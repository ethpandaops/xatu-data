import dotenv
import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def load_env():
    """Load environment variables from .env file."""
    dotenv.load_dotenv()
    return {
        'username': os.getenv('XATU_CLICKHOUSE_USERNAME'),
        'password': os.getenv('XATU_CLICKHOUSE_PASSWORD'),
        'host': os.getenv('XATU_CLICKHOUSE_HOST')
    }

def create_db_url(credentials):
    """Create database URL from credentials."""
    return f"clickhouse+http://{credentials['username']}:{credentials['password']}@{credentials['host']}:443/default?protocol=https"

def add_branding(fig, title=None, subtitle=None):
    """Add ethPandaOps branding to a figure."""
    # Get dimensions of input figure
    fig_width = fig.get_size_inches()[0]
    
    # Create header figure with fixed height
    header_height = 1
    header_fig = plt.figure(figsize=(fig_width, header_height))
    
    # Add logos with increased size
    left_logo_ax = header_fig.add_axes([0.02, 0.2, 0.18, 0.7])
    right_logo_ax = header_fig.add_axes([0.82, 0.2, 0.16, 0.7])
    
    try:
        ethpandaops = plt.imread('../../assets/content/ethpandaops.png')
        xatu = plt.imread('../../assets/content/xatu.png')
        
        left_logo_ax.imshow(ethpandaops)
        right_logo_ax.imshow(xatu)
    except:
        # If the images aren't found, just leave the areas blank
        pass
    
    left_logo_ax.axis('off')
    right_logo_ax.axis('off')
    
    # Add title and subtitle if provided
    if title:
        header_fig.text(0.5, 0.7, title, fontsize=20, fontweight='bold', ha='center')
    if subtitle:
        header_fig.text(0.5, 0.4, subtitle, fontsize=12, ha='center')
        
    # Stack figures
    combined_height = header_height + fig.get_size_inches()[1]
    combined_fig = plt.figure(figsize=(fig_width, combined_height))
    
    # Draw figures before accessing canvas
    header_fig.canvas.draw()
    fig.canvas.draw()
    
    # Copy contents using buffer_rgba
    header_img = np.frombuffer(header_fig.canvas.buffer_rgba(), dtype=np.uint8)
    header_img = header_img.reshape(header_fig.canvas.get_width_height()[::-1] + (4,))[:,:,:3]
    
    fig_img = np.frombuffer(fig.canvas.buffer_rgba(), dtype=np.uint8)
    fig_img = fig_img.reshape(fig.canvas.get_width_height()[::-1] + (4,))[:,:,:3]
    
    # Add to combined figure
    header_ax = combined_fig.add_axes([0, fig.get_size_inches()[1]/combined_height + 0.02, 1, (header_height-0.2)/combined_height])
    content_ax = combined_fig.add_axes([0, 0.02, 1, (fig.get_size_inches()[1]-0.2)/combined_height])
    
    header_ax.imshow(header_img)
    content_ax.imshow(fig_img)
    
    header_ax.axis('off')
    content_ax.axis('off')
    
    plt.close(header_fig)
    plt.close(fig)
    
    return combined_fig

def process_config(config):
    """Process the config dictionary to ensure all necessary keys are present."""
    # Check for either before/after structure or networks structure
    if 'before' in config and 'after' in config:
        # Before/after structure (original)
        for key in ['before', 'after']:
            # Verify sub-keys
            for subkey in ['network', 'start_at_slot', 'finish_at_slot']:
                if subkey not in config[key]:
                    raise ValueError(f"Missing required key '{subkey}' in config['{key}']")
        
        # Ensure slot ranges are valid
        for period in ['before', 'after']:
            if config[period]['start_at_slot'] >= config[period]['finish_at_slot']:
                raise ValueError(f"start_at_slot must be less than finish_at_slot in config['{period}']")
            
            # Add display label if not present
            if 'label' not in config[period]:
                config[period]['label'] = config[period]['network']
    
    elif 'networks' in config:
        # Multi-network structure
        # Verify each network has required fields
        for network_key, network_config in config['networks'].items():
            for subkey in ['network', 'start_at_slot', 'finish_at_slot']:
                if subkey not in network_config:
                    raise ValueError(f"Missing required key '{subkey}' in config['networks']['{network_key}']")
            
            # Ensure slot ranges are valid
            if network_config['start_at_slot'] >= network_config['finish_at_slot']:
                raise ValueError(f"start_at_slot must be less than finish_at_slot in config['networks']['{network_key}']")
            
            # Add display label if not present
            if 'label' not in network_config:
                network_config['label'] = network_key
    
    else:
        raise ValueError("Config must contain either 'before'/'after' keys or a 'networks' key")
    
    return config