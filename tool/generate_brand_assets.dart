import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Not a real test — a reproducible generator for the brand PNGs, run with:
///
///   flutter test tool/generate_brand_assets.dart
///
/// It renders the Coinsight mark (a gold coin with a scan reticle on the dark
/// brand background) at the sizes the icon / splash tooling needs, then
/// `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`
/// fan them out to every platform.

const _bg = Color(0xFF0B0D12);
const _gold = Color(0xFFD4AF37);
const _goldLight = Color(0xFFE8C766);

Future<void> _save(String path, int size,
    void Function(Canvas c, double s) paint) async {
  await _saveRect(path, size, size, (c, w, h) => paint(c, w));
}

Future<void> _saveRect(String path, int w, int h,
    void Function(Canvas c, double w, double h) paint) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  paint(canvas, w.toDouble(), h.toDouble());
  final image = await recorder.endRecording().toImage(w, h);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
}

/// `flutter test` substitutes a box-glyph test font, so load a real sans-serif
/// for the wordmark. Only the rasterised PNG is committed — no font file is
/// embedded or redistributed. Drop `assets/brand/wordmark-font.ttf` (e.g. Inter
/// Bold, SIL OFL) to pin the exact face; otherwise a system font is used.
Future<bool> _loadFont() async {
  final candidates = [
    'assets/brand/wordmark-font.ttf',
    r'C:\Windows\Fonts\segoeuib.ttf',
    r'C:\Windows\Fonts\arialbd.ttf',
    '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
    '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
  ];
  for (final path in candidates) {
    final f = File(path);
    if (f.existsSync()) {
      final loader = FontLoader('BrandFont')
        ..addFont(Future.value(f.readAsBytesSync().buffer.asByteData()));
      await loader.load();
      return true;
    }
  }
  return false;
}

void _wordmark(Canvas c, double w, double h, {required Color textColor}) {
  final markSize = h * 0.86;
  c.save();
  c.translate(h * 0.07, h * 0.07);
  _mark(c, markSize, inset: 0.06);
  c.restore();

  final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
    fontSize: h * 0.40,
    fontFamily: 'BrandFont',
    fontWeight: FontWeight.w700,
  ))
    ..pushStyle(ui.TextStyle(
      color: textColor,
      letterSpacing: -h * 0.006,
      fontWeight: FontWeight.w700,
    ))
    ..addText('Coinsights');
  final para = pb.build()..layout(ui.ParagraphConstraints(width: w));
  c.drawParagraph(para, Offset(h * 1.02, (h - para.height) / 2));
}

/// The gold coin + reticle mark. [inset] is the fraction of margin around it.
void _mark(Canvas c, double s, {double inset = 0.14, bool disc = true}) {
  final center = Offset(s / 2, s / 2);
  final r = s * (0.5 - inset);

  if (disc) {
    // Coin body with a soft bevel.
    c.drawCircle(
      center,
      r,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(center.dx - r, center.dy - r),
          Offset(center.dx + r, center.dy + r),
          [_goldLight, _gold, const Color(0xFF9C7C1E)],
          [0.0, 0.5, 1.0],
        ),
    );
    c.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.012
        ..color = const Color(0xFF6E5514),
    );
    // Inner ring.
    c.drawCircle(
      center,
      r * 0.80,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.02
        ..color = const Color(0x33000000),
    );
  }

  // Scan reticle (four corner brackets), matching the app's brand glyph.
  final mark = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = s * 0.055
    ..strokeCap = StrokeCap.round
    ..color = disc ? const Color(0xFF1A1400) : _gold;
  final box = Rect.fromCenter(
      center: center, width: r * 1.02, height: r * 1.02);
  final len = r * 0.36;
  void corner(Offset o, double dx, double dy) {
    c.drawLine(o, o + Offset(dx, 0), mark);
    c.drawLine(o, o + Offset(0, dy), mark);
  }

  corner(box.topLeft, len, len);
  corner(box.topRight, -len, len);
  corner(box.bottomLeft, len, -len);
  corner(box.bottomRight, -len, -len);

  // Center dot.
  c.drawCircle(center, s * 0.055,
      Paint()..color = disc ? const Color(0xFF1A1400) : _gold);
}

void main() {
  test('generate brand PNGs', () async {
    final haveFont = await _loadFont();

    // Full app icon: mark on the brand background.
    await _save('assets/brand/icon.png', 1024, (c, s) {
      c.drawRect(Offset.zero & Size(s, s), Paint()..color = _bg);
      _mark(c, s, inset: 0.16);
    });

    // Android adaptive foreground: transparent, extra safe-zone padding.
    await _save('assets/brand/icon_foreground.png', 1024, (c, s) {
      _mark(c, s, inset: 0.28);
    });

    // Splash: just the reticle glyph (no disc) on transparent, centred small.
    await _save('assets/brand/splash.png', 768, (c, s) {
      const scale = 0.42;
      c.save();
      c.translate(s * (1 - scale) / 2, s * (1 - scale) / 2);
      c.scale(scale);
      _mark(c, s, inset: 0.05, disc: false);
      c.restore();
    });

    // Horizontal logo lockup (mark + wordmark) — for README, web, marketing.
    if (haveFont) {
      await _saveRect('assets/brand/logo_dark.png', 1700, 420, (c, w, h) {
        c.drawRect(Offset.zero & Size(w, h), Paint()..color = _bg);
        _wordmark(c, w, h, textColor: const Color(0xFFF4F5F7));
      });
      await _saveRect('assets/brand/logo_transparent.png', 1700, 420, (c, w, h) {
        _wordmark(c, w, h, textColor: _gold);
      });
    }

    expect(File('assets/brand/icon.png').existsSync(), isTrue);
    expect(File('assets/brand/icon_foreground.png').existsSync(), isTrue);
    expect(File('assets/brand/splash.png').existsSync(), isTrue);
  });
}
