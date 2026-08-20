const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const SVG_PATH = path.join(__dirname, 'documind_icon.svg');

async function generateForeground() {
  console.log('🎨 Generating Android adaptive icon foreground...\n');

  const svgBuffer = fs.readFileSync(SVG_PATH);

  // Android adaptive icon: 108dp at each density
  // The foreground layer is 108dp, with the icon content in the inner 66dp (safe zone)
  const sizes = [
    { size: 108, path: 'android/app/src/main/res/drawable/ic_launcher_foreground.png' },
  ];

  for (const { size, path: outputPath } of sizes) {
    const fullPath = path.join(__dirname, '..', outputPath);
    const dir = path.dirname(fullPath);
    fs.mkdirSync(dir, { recursive: true });

    // Create a 108x108 canvas with the icon centered (72% of canvas = safe zone)
    const canvasSize = size * 3; // 324px for xxxhdpi
    const iconSize = (canvasSize * 72) / 108; // 72dp safe zone
    const offset = (canvasSize - iconSize) / 2;

    // Create transparent canvas
    const canvas = Buffer.from(
      `<svg xmlns="http://www.w3.org/2000/svg" width="${canvasSize}" height="${canvasSize}">
        <rect width="${canvasSize}" height="${canvasSize}" fill="none"/>
      </svg>`
    );

    // Resize icon to fit safe zone
    const resizedIcon = await sharp(svgBuffer)
      .resize(Math.round(iconSize), Math.round(iconSize), {
        fit: 'contain',
        background: { r: 0, g: 0, b: 0, alpha: 0 },
      })
      .toBuffer();

    // Composite icon onto canvas
    await sharp(canvas)
      .composite([{
        input: resizedIcon,
        left: Math.round(offset),
        top: Math.round(offset),
      }])
      .png()
      .toFile(fullPath);

    console.log(`   ✅ ${outputPath} (${canvasSize}x${canvasSize})`);
  }

  console.log('\n✅ Android adaptive icon foreground generated!');
}

generateForeground().catch((err) => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
