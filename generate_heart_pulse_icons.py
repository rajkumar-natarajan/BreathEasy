#!/usr/bin/env python3
"""
Generate BreathEasy App Icons with Heart + Pulse Design
Creates standard, dark, and tinted variations for iOS
"""

import os
import subprocess
import sys

def create_heart_pulse_svg_variations():
    """Create SVG variations for different appearances with heart + pulse design"""
    
    # Base SVG content (standard version) - Heart + Pulse design
    base_svg = '''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <!-- Background Gradient - Calming blue to soft green -->
    <radialGradient id="backgroundGradient" cx="50%" cy="50%" r="70%">
      <stop offset="0%" style="stop-color:#E3F2FD;stop-opacity:1" />
      <stop offset="40%" style="stop-color:#A7C7E7;stop-opacity:1" />
      <stop offset="80%" style="stop-color:#B2D8B2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#87CEEB;stop-opacity:1" />
    </radialGradient>
    
    <!-- Heart Gradient - Warm life colors -->
    <linearGradient id="heartGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#FF6B8A;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#FF8FA3;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#FFB3C1;stop-opacity:1" />
    </linearGradient>
    
    <!-- Pulse Wave Gradient -->
    <linearGradient id="pulseGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#4CAF50;stop-opacity:0.8" />
      <stop offset="50%" style="stop-color:#66BB6A;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#81C784;stop-opacity:0.6" />
    </linearGradient>
    
    <!-- Breathing Ripple Gradient -->
    <radialGradient id="rippleGradient" cx="50%" cy="50%" r="50%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.3" />
      <stop offset="70%" style="stop-color:#A7C7E7;stop-opacity:0.2" />
      <stop offset="100%" style="stop-color:#87CEEB;stop-opacity:0.1" />
    </radialGradient>
    
    <!-- Glow Effect -->
    <filter id="glow">
      <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
      <feMerge> 
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    
    <!-- Drop Shadow -->
    <filter id="dropshadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="2" dy="4" stdDeviation="3" flood-color="#000000" flood-opacity="0.2"/>
    </filter>
  </defs>

  <!-- Background Circle -->
  <circle cx="512" cy="512" r="512" fill="url(#backgroundGradient)" />
  
  <!-- Breathing Ripples -->
  <circle cx="512" cy="512" r="350" fill="none" stroke="url(#rippleGradient)" stroke-width="2" opacity="0.3" />
  <circle cx="512" cy="512" r="300" fill="none" stroke="url(#rippleGradient)" stroke-width="2" opacity="0.4" />
  <circle cx="512" cy="512" r="250" fill="none" stroke="url(#rippleGradient)" stroke-width="2" opacity="0.5" />
  
  <!-- Heart Shape -->
  <g transform="translate(512,400)" filter="url(#dropshadow)">
    <path d="M 0,40 
             C -40,0 -80,0 -80,40 
             C -80,80 -40,120 0,160 
             C 40,120 80,80 80,40 
             C 80,0 40,0 0,40 Z" 
          fill="url(#heartGradient)" 
          filter="url(#glow)" />
  </g>
  
  <!-- Pulse Wave Line -->
  <g transform="translate(512,600)" opacity="0.9">
    <path d="M -200,0 
             L -150,0 
             L -130,-30 
             L -110,60 
             L -90,-80 
             L -70,40 
             L -50,0
             L 0,0
             L 20,-20
             L 40,40
             L 60,-60
             L 80,30
             L 100,0
             L 200,0" 
          fill="none" 
          stroke="url(#pulseGradient)" 
          stroke-width="4" 
          stroke-linecap="round" 
          stroke-linejoin="round" 
          filter="url(#glow)" />
  </g>
  
  <!-- Breathing Indicators -->
  <g opacity="0.7">
    <circle cx="300" cy="300" r="6" fill="#4CAF50" opacity="0.8" />
    <circle cx="724" cy="300" r="6" fill="#4CAF50" opacity="0.6" />
    <circle cx="300" cy="724" r="6" fill="#66BB6A" opacity="0.7" />
    <circle cx="724" cy="724" r="6" fill="#66BB6A" opacity="0.5" />
    
    <circle cx="250" cy="400" r="4" fill="#81C784" opacity="0.6" />
    <circle cx="774" cy="400" r="4" fill="#81C784" opacity="0.4" />
    <circle cx="400" cy="250" r="4" fill="#A5D6A7" opacity="0.5" />
    <circle cx="624" cy="774" r="4" fill="#A5D6A7" opacity="0.4" />
  </g>
  
  <!-- Central Breathing Focus Point -->
  <circle cx="512" cy="512" r="25" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.6" />
  <circle cx="512" cy="512" r="15" fill="#ffffff" opacity="0.4" />
  
  <!-- Air Flow Curves -->
  <g opacity="0.3">
    <path d="M 350,200 Q 400,150 450,200 Q 500,250 550,200 Q 600,150 650,200" 
          fill="none" 
          stroke="#ffffff" 
          stroke-width="2" 
          stroke-linecap="round" />
    
    <path d="M 350,824 Q 400,874 450,824 Q 500,774 550,824 Q 600,874 650,824" 
          fill="none" 
          stroke="#ffffff" 
          stroke-width="2" 
          stroke-linecap="round" />
  </g>
</svg>'''

    # Dark version - adjust colors for dark appearance
    dark_svg = base_svg.replace(
        'stop-color:#E3F2FD', 'stop-color:#1A1A2E'
    ).replace(
        'stop-color:#A7C7E7', 'stop-color:#16213E'
    ).replace(
        'stop-color:#B2D8B2', 'stop-color:#1B2F1B'
    ).replace(
        'stop-color:#87CEEB', 'stop-color:#0E3A5F'
    ).replace(
        'stop-color:#FF6B8A', 'stop-color:#8B2635'
    ).replace(
        'stop-color:#FF8FA3', 'stop-color:#A53448'
    ).replace(
        'stop-color:#FFB3C1', 'stop-color:#B8485B'
    ).replace(
        'stop-color:#4CAF50', 'stop-color:#2E7D32'
    ).replace(
        'stop-color:#66BB6A', 'stop-color:#388E3C'
    ).replace(
        'stop-color:#81C784', 'stop-color:#43A047'
    ).replace(
        'fill="#4CAF50"', 'fill="#2E7D32"'
    ).replace(
        'fill="#66BB6A"', 'fill="#388E3C"'
    ).replace(
        'fill="#81C784"', 'fill="#43A047"'
    ).replace(
        'fill="#A5D6A7"', 'fill="#4CAF50"'
    ).replace(
        'stroke="#ffffff"', 'stroke="#CCCCCC"'
    ).replace(
        'fill="#ffffff"', 'fill="#CCCCCC"'
    )

    # Tinted version - more monochrome for tinted appearance
    tinted_svg = base_svg.replace(
        'stop-color:#E3F2FD', 'stop-color:#F5F5F5'
    ).replace(
        'stop-color:#A7C7E7', 'stop-color:#E0E0E0'
    ).replace(
        'stop-color:#B2D8B2', 'stop-color:#EEEEEE'
    ).replace(
        'stop-color:#87CEEB', 'stop-color:#BDBDBD'
    ).replace(
        'stop-color:#FF6B8A', 'stop-color:#757575'
    ).replace(
        'stop-color:#FF8FA3', 'stop-color:#8E8E8E'
    ).replace(
        'stop-color:#FFB3C1', 'stop-color:#A7A7A7'
    ).replace(
        'stop-color:#4CAF50', 'stop-color:#666666'
    ).replace(
        'stop-color:#66BB6A', 'stop-color:#777777'
    ).replace(
        'stop-color:#81C784', 'stop-color:#888888'
    ).replace(
        'fill="#4CAF50"', 'fill="#666666"'
    ).replace(
        'fill="#66BB6A"', 'fill="#777777"'
    ).replace(
        'fill="#81C784"', 'fill="#888888"'
    ).replace(
        'fill="#A5D6A7"', 'fill="#999999"'
    )

    return base_svg, dark_svg, tinted_svg

def save_heart_pulse_svg_files():
    """Save heart + pulse SVG variations to files"""
    base_svg, dark_svg, tinted_svg = create_heart_pulse_svg_variations()
    
    # Save SVG files
    with open('app-icon-heart-standard.svg', 'w') as f:
        f.write(base_svg)
    
    with open('app-icon-heart-dark.svg', 'w') as f:
        f.write(dark_svg)
    
    with open('app-icon-heart-tinted.svg', 'w') as f:
        f.write(tinted_svg)
    
    print("✅ Heart + Pulse SVG variations created:")
    print("   🫀 app-icon-heart-standard.svg")
    print("   🌙 app-icon-heart-dark.svg") 
    print("   🎨 app-icon-heart-tinted.svg")

def convert_with_imagemagick():
    """Try to convert using ImageMagick"""
    svg_files = [
        ('app-icon-heart-standard.svg', 'app-icon-1024.png'),
        ('app-icon-heart-dark.svg', 'app-icon-1024-dark.png'),
        ('app-icon-heart-tinted.svg', 'app-icon-1024-tinted.png')
    ]
    
    success = True
    for svg_file, png_file in svg_files:
        try:
            # Try ImageMagick convert command
            result = subprocess.run([
                'convert', svg_file, '-resize', '1024x1024', png_file
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✅ Converted {svg_file} → {png_file}")
            else:
                print(f"❌ ImageMagick failed for {svg_file}")
                success = False
                break
        except FileNotFoundError:
            print("❌ ImageMagick not found")
            success = False
            break
    
    return success

def copy_to_appicon_folder():
    """Copy PNG files to the AppIcon.appiconset folder"""
    appicon_path = "BreathEasy/Assets.xcassets/AppIcon.appiconset"
    
    if not os.path.exists(appicon_path):
        print(f"❌ AppIcon folder not found: {appicon_path}")
        return False
    
    png_files = [
        'app-icon-1024.png',
        'app-icon-1024-dark.png', 
        'app-icon-1024-tinted.png'
    ]
    
    success = True
    for png_file in png_files:
        if os.path.exists(png_file):
            try:
                subprocess.run(['cp', png_file, f"{appicon_path}/{png_file}"], check=True)
                print(f"✅ Copied {png_file} to AppIcon.appiconset")
            except subprocess.CalledProcessError:
                print(f"❌ Failed to copy {png_file}")
                success = False
        else:
            print(f"❌ PNG file not found: {png_file}")
            success = False
    
    return success

def create_preview_html():
    """Create an HTML preview of the new heart + pulse icon"""
    html_content = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BreathEasy Heart + Pulse App Icon Preview</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 800px;
        }
        
        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        
        .icon-showcase {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 40px 0;
            flex-wrap: wrap;
        }
        
        .icon-item {
            text-align: center;
        }
        
        .icon-container {
            width: 180px;
            height: 180px;
            border-radius: 40px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            margin-bottom: 15px;
            transition: transform 0.3s ease;
        }
        
        .icon-container:hover {
            transform: scale(1.05);
        }
        
        .icon-container.dark {
            background: #2c3e50;
        }
        
        .icon-container.tinted {
            background: #95a5a6;
        }
        
        .icon-container svg {
            width: 100%;
            height: 100%;
        }
        
        .icon-label {
            font-weight: 600;
            color: #34495e;
            font-size: 1.1em;
        }
        
        .features {
            text-align: left;
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
        }
        
        .features h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.5em;
        }
        
        .features ul {
            list-style: none;
            padding: 0;
        }
        
        .features li {
            padding: 8px 0;
            display: flex;
            align-items: center;
        }
        
        .features li::before {
            content: "🫀";
            margin-right: 10px;
            font-size: 1.2em;
        }
        
        .color-palette {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        
        .color-swatch {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .pulse-demo {
            background: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🫀 BreathEasy Heart + Pulse Icon</h1>
        
        <div class="icon-showcase">
            <div class="icon-item">
                <div class="icon-container">
                    <!-- Standard Icon will be loaded here -->
                </div>
                <div class="icon-label">Standard</div>
            </div>
            
            <div class="icon-item">
                <div class="icon-container dark">
                    <!-- Dark Icon will be loaded here -->
                </div>
                <div class="icon-label">Dark Mode</div>
            </div>
            
            <div class="icon-item">
                <div class="icon-container tinted">
                    <!-- Tinted Icon will be loaded here -->
                </div>
                <div class="icon-label">Tinted</div>
            </div>
        </div>
        
        <div class="features">
            <h3>🎯 Design Features</h3>
            <ul>
                <li>Heart symbol representing life and wellness</li>
                <li>Pulse wave showing heart rate monitoring</li>
                <li>Breathing ripples for meditation guidance</li>
                <li>Calming color palette for relaxation</li>
                <li>Central focus point for breathing exercises</li>
                <li>Air flow curves suggesting natural breathing</li>
                <li>Glow effects for premium feel</li>
                <li>Perfect for health and wellness apps</li>
            </ul>
        </div>
        
        <div class="pulse-demo">
            <h3>💗 Heart + Breathing Integration</h3>
            <p>This icon perfectly represents the BreathEasy app's core functionality:</p>
            <p><strong>❤️ Heart Health:</strong> Central heart symbol for cardiovascular wellness</p>
            <p><strong>📊 Pulse Monitoring:</strong> EKG-style wave for heart rate tracking</p>
            <p><strong>🫁 Breathing Focus:</strong> Ripples and flow lines for breath awareness</p>
        </div>
        
        <div>
            <h3>🎨 Color Palette</h3>
            <div class="color-palette">
                <div class="color-swatch" style="background: #FF6B8A;" title="Heart Pink"></div>
                <div class="color-swatch" style="background: #4CAF50;" title="Health Green"></div>
                <div class="color-swatch" style="background: #A7C7E7;" title="Calm Blue"></div>
                <div class="color-swatch" style="background: #B2D8B2;" title="Serenity Green"></div>
                <div class="color-swatch" style="background: #87CEEB;" title="Sky Blue"></div>
            </div>
        </div>
    </div>
</body>
</html>'''
    
    with open('heart-pulse-icon-preview.html', 'w') as f:
        f.write(html_content)
    
    print("✅ Created heart-pulse-icon-preview.html")

def main():
    print("🫀 Generating BreathEasy Heart + Pulse App Icons...")
    
    # Step 1: Create SVG variations
    save_heart_pulse_svg_files()
    
    # Step 2: Create preview
    create_preview_html()
    
    # Step 3: Try automatic conversion
    print("\n🔄 Converting SVG to PNG...")
    
    if convert_with_imagemagick():
        print("\n📱 PNG files generated successfully!")
        
        # Step 4: Copy to AppIcon folder
        if copy_to_appicon_folder():
            print("\n✅ Heart + Pulse icons installed successfully!")
            print("🚀 You can now build your app in Xcode to see the new heart + pulse icon")
        else:
            print("\n⚠️  Please manually copy PNG files to AppIcon.appiconset folder")
    else:
        print("\n⚠️  PNG conversion failed - please use manual conversion")
        print("📝 Check heart-pulse-icon-preview.html for design preview")

if __name__ == "__main__":
    main()
