#!/usr/bin/env python3
import click
import logging
import sys
from datetime import datetime, timedelta
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.exporter import XatuExporter


def setup_logging(verbose: bool):
    """Configure logging based on verbosity"""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )


@click.command()
@click.option('--environment', '-e', required=True,
              type=click.Choice(['staging', 'production']),
              help='Environment to export from/to')
@click.option('--table-group', '-g', 
              type=click.Choice(['daily', 'hourly', 'chunked', 'all']),
              default='all',
              help='Table group to export')
@click.option('--date', '-d', type=click.DateTime(['%Y-%m-%d']),
              help='Date to export (defaults to yesterday for daily, last hour for hourly)')
@click.option('--parallel', '-p', default=4, 
              help='Number of parallel exports')
@click.option('--dry-run', is_flag=True,
              help='Show what would be done without doing it')
@click.option('--verbose', '-v', is_flag=True,
              help='Enable verbose logging')
@click.option('--continue-on-error', is_flag=True,
              help='Continue exporting even if some tables fail')
def export_all(environment, table_group, date, parallel, dry_run, verbose, continue_on_error):
    """Export all tables for a given date/group
    
    Examples:
        # Export all daily tables for yesterday
        export_all.py -e production -g daily
        
        # Export all hourly tables for specific date
        export_all.py -e production -g hourly -d 2024-05-30
        
        # Export all table groups with high parallelism
        export_all.py -e production -g all -p 10
        
        # Dry run to see what would be exported
        export_all.py -e staging -g daily --dry-run
    """
    setup_logging(verbose)
    
    try:
        if dry_run:
            click.echo("🔍 Running in DRY RUN mode - no files will be uploaded")
        
        click.echo(f"📊 Exporting {table_group} tables from {environment}")
        
        exporter = XatuExporter(environment, dry_run=dry_run)
        
        # Determine which groups to export
        if table_group == 'all':
            groups = ['daily', 'hourly', 'chunked']
        else:
            groups = [table_group]
        
        total_exports = 0
        successful_exports = 0
        failed_exports = 0
        
        with ThreadPoolExecutor(max_workers=parallel) as executor:
            # Submit export jobs
            futures = []
            
            for group in groups:
                if group == 'daily':
                    export_date = date or (datetime.now() - timedelta(days=1))
                    futures.extend(exporter.submit_daily_exports(executor, export_date))
                    click.echo(f"📅 Submitted daily exports for {export_date.strftime('%Y-%m-%d')}")
                    
                elif group == 'hourly':
                    export_date = date or (datetime.now() - timedelta(hours=1))
                    futures.extend(exporter.submit_hourly_exports(executor, export_date))
                    click.echo(f"🕐 Submitted hourly exports for {export_date.strftime('%Y-%m-%d %H:00')}")
                    
                elif group == 'chunked':
                    futures.extend(exporter.submit_chunked_exports(executor))
                    click.echo("📦 Submitted chunked exports")
            
            total_exports = len(futures)
            click.echo(f"🚀 Running {total_exports} export jobs with {parallel} workers")
            
            # Wait for completion and report results
            with click.progressbar(
                as_completed(futures),
                length=total_exports,
                label='Exporting tables'
            ) as bar:
                for future in bar:
                    try:
                        result = future.result()
                        if result:
                            successful_exports += 1
                        else:
                            failed_exports += 1
                    except Exception as e:
                        failed_exports += 1
                        if verbose:
                            click.echo(f"\n❌ Export failed: {e}", err=True)
                        if not continue_on_error:
                            raise
        
        # Report final results
        click.echo(f"\n📈 Export Summary:")
        click.echo(f"   Total: {total_exports}")
        click.echo(f"   ✅ Success: {successful_exports}")
        click.echo(f"   ❌ Failed: {failed_exports}")
        
        if failed_exports > 0:
            if continue_on_error:
                click.echo(f"\n⚠️  {failed_exports} exports failed but continued due to --continue-on-error")
                sys.exit(2)  # Exit with warning code
            else:
                click.echo(f"\n❌ {failed_exports} exports failed", err=True)
                sys.exit(1)
        else:
            click.echo("\n✅ All exports completed successfully!")
            sys.exit(0)
            
    except Exception as e:
        click.echo(f"❌ Error: {e}", err=True)
        if verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    export_all()