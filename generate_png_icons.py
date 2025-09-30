#!/usr/bin/env python3
"""
Generate PNG app icons from SVG design for iOS app
Creates standard, dark, and tinted variations
"""

import os
import subprocess
import sys

def create_svg_variations():
    """Create SVG variations for different appearances"""
    
    # Base SVG content (standard version)
    base_svg = '''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <!-- Serenity Gradient -->
    <radialGradient id="serenityGradient" cx="50%" cy="50%" r="50%">
      <stop offset="0%" style="stop-color:#87CEEB;stop-opacity:1" />
      <stop offset="30%" style="stop-color:#A7C7E7;stop-opacity:1" />
      <stop offset="70%" style="stop-color:#B2D8B2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#D7BDE2;stop-opacity:1" />
    </radialGradient>
    
    <!-- Breathing Orb Gradient -->
    <radialGradient id="orbGradient" cx="50%" cy="50%" r="40%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.9" />
      <stop offset="50%" style="stop-color:#A7C7E7;stop-opacity:0.7" />
      <stop offset="100%" style="stop-color:#87CEEB;stop-opacity:0.5" />
    </radialGradient>
    
    <!-- Lotus Petal Gradient -->
    <linearGradient id="petalGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#D7BDE2;stop-opacity:0.8" />
      <stop offset="100%" style="stop-color:#B2D8B2;stop-opacity:0.6" />
    </linearGradient>
  </defs>

  <!-- Background -->
  <circle cx="512" cy="512" r="512" fill="url(#serenityGradient)" />

  <!-- Lotus Petals (8 petals for spiritual symbolism) -->
  <g transform="translate(512,512)">
    <!-- Petal 1 (0°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(0)" />
    <!-- Petal 2 (45°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(45)" />
    <!-- Petal 3 (90°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(90)" />
    <!-- Petal 4 (135°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(135)" />
    <!-- Petal 5 (180°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(180)" />
    <!-- Petal 6 (225°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(225)" />
    <!-- Petal 7 (270°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(270)" />
    <!-- Petal 8 (315°) -->
    <ellipse cx="0" cy="-180" rx="40" ry="80" fill="url(#petalGradient)" opacity="0.7" transform="rotate(315)" />
  </g>

  <!-- Breathing Rings -->
  <circle cx="512" cy="512" r="120" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.4" />
  <circle cx="512" cy="512" r="150" fill="none" stroke="#A7C7E7" stroke-width="2" opacity="0.3" />
  <circle cx="512" cy="512" r="180" fill="none" stroke="#B2D8B2" stroke-width="2" opacity="0.2" />

  <!-- Central Breathing Orb -->
  <circle cx="512" cy="512" r="80" fill="url(#orbGradient)" />

  <!-- Zen Particles -->
  <circle cx="350" cy="280" r="4" fill="#ffffff" opacity="0.6" />
  <circle cx="680" cy="320" r="3" fill="#A7C7E7" opacity="0.5" />
  <circle cx="400" cy="750" r="5" fill="#B2D8B2" opacity="0.4" />
  <circle cx="720" cy="680" r="3" fill="#D7BDE2" opacity="0.5" />
  <circle cx="280" cy="600" r="4" fill="#87CEEB" opacity="0.6" />
  <circle cx="780" cy="450" r="3" fill="#ffffff" opacity="0.4" />
</svg>'''

    # Dark version - adjust colors for dark appearance
    dark_svg = base_svg.replace(
        'stop-color:#87CEEB', 'stop-color:#1e3a5f'
    ).replace(
        'stop-color:#A7C7E7', 'stop-color:#2d4f73'
    ).replace(
        'stop-color:#B2D8B2', 'stop-color:#2d4a2d'
    ).replace(
        'stop-color:#D7BDE2', 'stop-color:#4a2d4a'
    ).replace(
        'stroke="#ffffff"', 'stroke="#cccccc"'
    ).replace(
        'fill="#ffffff"', 'fill="#cccccc"'
    )

    # Tinted version - more monochrome for tinted appearance
    tinted_svg = base_svg.replace(
        'stop-color:#87CEEB', 'stop-color:#888888'
    ).replace(
        'stop-color:#A7C7E7', 'stop-color:#999999'
    ).replace(
        'stop-color:#B2D8B2', 'stop-color:#aaaaaa'
    ).replace(
        'stop-color:#D7BDE2', 'stop-color:#bbbbbb'
    ).replace(
        'stroke="#A7C7E7"', 'stroke="#999999"'
    ).replace(
        'stroke="#B2D8B2"', 'stroke="#aaaaaa"'
    ).replace(
        'fill="#A7C7E7"', 'fill="#999999"'
    ).replace(
        'fill="#B2D8B2"', 'fill="#aaaaaa"'
    ).replace(
        'fill="#D7BDE2"', 'fill="#bbbbbb"'
    ).replace(
        'fill="#87CEEB"', 'fill="#888888"'
    )

    return base_svg, dark_svg, tinted_svg

def save_svg_files():
    """Save SVG variations to files"""
    base_svg, dark_svg, tinted_svg = create_svg_variations()
    
    # Save SVG files
    with open('app-icon-standard.svg', 'w') as f:
        f.write(base_svg)
    
    with open('app-icon-dark.svg', 'w') as f:
        f.write(dark_svg)
    
    with open('app-icon-tinted.svg', 'w') as f:
        f.write(tinted_svg)
    
    print("✅ SVG variations created: app-icon-standard.svg, app-icon-dark.svg, app-icon-tinted.svg")

def convert_with_imagemagick():
    """Try to convert using ImageMagick"""
    svg_files = [
        ('app-icon-standard.svg', 'app-icon-1024.png'),
        ('app-icon-dark.svg', 'app-icon-1024-dark.png'),
        ('app-icon-tinted.svg', 'app-icon-1024-tinted.png')
    ]
    
    success = False
    for svg_file, png_file in svg_files:
        try:
            # Try ImageMagick convert command
            result = subprocess.run([
                'convert', svg_file, '-resize', '1024x1024', png_file
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✅ Converted {svg_file} → {png_file}")
                success = True
            else:
                print(f"❌ ImageMagick failed for {svg_file}")
                break
        except FileNotFoundError:
            print("❌ ImageMagick not found")
            break
    
    return success

def convert_with_rsvg():
    """Try to convert using rsvg-convert"""
    svg_files = [
        ('app-icon-standard.svg', 'app-icon-1024.png'),
        ('app-icon-dark.svg', 'app-icon-1024-dark.png'),
        ('app-icon-tinted.svg', 'app-icon-1024-tinted.png')
    ]
    
    success = False
    for svg_file, png_file in svg_files:
        try:
            # Try rsvg-convert command
            result = subprocess.run([
                'rsvg-convert', '-w', '1024', '-h', '1024', svg_file, '-o', png_file
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✅ Converted {svg_file} → {png_file}")
                success = True
            else:
                print(f"❌ rsvg-convert failed for {svg_file}")
                break
        except FileNotFoundError:
            print("❌ rsvg-convert not found")
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

def create_manual_instructions():
    """Create instructions for manual conversion"""
    instructions = """
🎨 Manual PNG Generation Instructions

Since automatic conversion tools aren't available, please use one of these methods:

METHOD 1: Online SVG to PNG Converter
1. Go to: https://convertio.co/svg-png/ or https://cloudconvert.com/svg-to-png
2. Upload: app-icon-standard.svg → Convert to PNG (1024×1024)
3. Upload: app-icon-dark.svg → Convert to PNG (1024×1024) 
4. Upload: app-icon-tinted.svg → Convert to PNG (1024×1024)
5. Rename files to:
   - app-icon-1024.png
   - app-icon-1024-dark.png
   - app-icon-1024-tinted.png

METHOD 2: Preview App (macOS)
1. Open each SVG file in Preview
2. File → Export → Format: PNG → Resolution: 1024×1024
3. Save with correct filenames

METHOD 3: Install ImageMagick
1. brew install imagemagick
2. Run this script again

📁 Final Step:
Copy all three PNG files to: BreathEasy/Assets.xcassets/AppIcon.appiconset/

🎯 The Contents.json file is already configured correctly!
"""
    
    with open('manual-conversion-instructions.txt', 'w') as f:
        f.write(instructions)
    
    print("📝 Created manual-conversion-instructions.txt")

def main():
    print("🎨 Generating BreathEasy App Icons...")
    
    # Step 1: Create SVG variations
    save_svg_files()
    
    # Step 2: Try automatic conversion
    converted = False
    
    print("\n🔄 Attempting automatic PNG conversion...")
    
    if convert_with_imagemagick():
        converted = True
    elif convert_with_rsvg():
        converted = True
    
    if converted:
        print("\n📱 PNG files generated successfully!")
        
        # Step 3: Copy to AppIcon folder
        if copy_to_appicon_folder():
            print("\n✅ App icons installed successfully!")
            print("🚀 You can now build your app in Xcode to see the new icon")
        else:
            print("\n⚠️  Please manually copy PNG files to AppIcon.appiconset folder")
    else:
        print("\n⚠️  Automatic conversion failed")
        create_manual_instructions()
        print("\n📋 Please follow the manual conversion instructions")

if __name__ == "__main__":
    main()
