const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const SVG_PATH = path.join(__dirname, 'documind_icon.svg');

async function generateSplashAssets() {
  console.log('🎨 Generating DocuMind splash screen assets...\n');

  const svgBuffer = fs.readFileSync(SVG_PATH);
  const assetsDir = path.join(__dirname, '..', 'assets', 'images');
  fs.mkdirSync(assetsDir, { recursive: true });

  // Splash screen icon (centered, with transparent background)
  const splashIcon = await sharp(svgBuffer)
    .resize(320, 320, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toFile(path.join(assetsDir, 'splash_icon.png'));

  console.log('   ✅ assets/images/splash_icon.png (320x320)');

  // Dark mode splash icon (slightly brighter)
  const splashIconDark = await sharp(svgBuffer)
    .resize(320, 320, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toFile(path.join(assetsDir, 'splash_icon_dark.png'));

  console.log('   ✅ assets/images/splash_icon_dark.png (320x320)');

  // App icon for splash (smaller, used in loading indicator area)
  const appIcon = await sharp(svgBuffer)
    .resize(80, 80, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toFile(path.join(assetsDir, 'app_icon.png'));

  console.log('   ✅ assets/images/app_icon.png (80x80)');

  console.log('\n✅ Splash assets generated!');
}

generateSplashAssets().catch((err) => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
