const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const SVG_PATH = path.join(__dirname, 'documind_icon.svg');

// Platform-specific icon sizes
const ICONS = {
  // Android adaptive icon (used as base layer)
  android: [
    { size: 48,  path: 'android/app/src/main/res/mipmap-mdpi/ic_launcher.png' },
    { size: 72,  path: 'android/app/src/main/res/mipmap-hdpi/ic_launcher.png' },
    { size: 96,  path: 'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png' },
    { size: 144, path: 'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png' },
    { size: 192, path: 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png' },
    // Round icons
    { size: 48,  path: 'android/app/src/main/res/mipmap-mdpi/ic_launcher_round.png' },
    { size: 72,  path: 'android/app/src/main/res/mipmap-hdpi/ic_launcher_round.png' },
    { size: 96,  path: 'android/app/src/main/res/mipmap-xhdpi/ic_launcher_round.png' },
    { size: 144, path: 'android/app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png' },
    { size: 192, path: 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png' },
  ],

  // iOS
  ios: [
    { size: 20,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png' },
    { size: 40,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png' },
    { size: 60,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png' },
    { size: 29,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png' },
    { size: 58,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png' },
    { size: 87,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png' },
    { size: 40,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png' },
    { size: 80,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png' },
    { size: 120,  path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png' },
    { size: 120,  path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png' },
    { size: 180,  path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png' },
    { size: 76,   path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png' },
    { size: 152,  path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png' },
    { size: 167,  path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png' },
    { size: 1024, path: 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png' },
  ],

  // macOS
  macos: [
    { size: 16,   path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png' },
    { size: 32,   path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png' },
    { size: 64,   path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png' },
    { size: 128,  path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png' },
    { size: 256,  path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png' },
    { size: 512,  path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png' },
    { size: 1024, path: 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png' },
  ],

  // Web
  web: [
    { size: 192,  path: 'web/icons/Icon-192.png' },
    { size: 512,  path: 'web/icons/Icon-512.png' },
    { size: 192,  path: 'web/icons/Icon-maskable-192.png' },
    { size: 512,  path: 'web/icons/Icon-maskable-512.png' },
    { size: 48,   path: 'web/favicon.png' },
  ],
};

async function generateIcons() {
  console.log('🎨 Generating DocuMind app icons...\n');

  const svgBuffer = fs.readFileSync(SVG_PATH);
  let count = 0;

  for (const [platform, sizes] of Object.entries(ICONS)) {
    console.log(`📱 ${platform.toUpperCase()}`);
    for (const { size, path: outputPath } of sizes) {
      const fullPath = path.join(__dirname, '..', outputPath);
      const dir = path.dirname(fullPath);

      // Ensure directory exists
      fs.mkdirSync(dir, { recursive: true });

      // Generate PNG
      await sharp(svgBuffer)
        .resize(size, size, {
          fit: 'cover',
          position: 'centre',
        })
        .png()
        .toFile(fullPath);

      count++;
      console.log(`   ✅ ${outputPath} (${size}x${size})`);
    }
    console.log('');
  }

  console.log(`🎉 Generated ${count} icon files across all platforms!`);
}

generateIcons().catch((err) => {
  console.error('❌ Error generating icons:', err.message);
  process.exit(1);
});
