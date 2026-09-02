import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Dims the frame outside a centred circle and draws an animated positioning
/// ring — the "place the coin here" guide used over the live camera preview
/// (product spec §6).
class CoinFrameOverlay extends StatefulWidget {
  const CoinFrameOverlay({super.key, this.active = true});

  /// When false the ring stops pulsing (e.g. while a capture is processing).
  final bool active;

  @override
  State<CoinFrameOverlay> createState() => _CoinFrameOverlayState();
}

class _CoinFrameOverlayState extends State<CoinFrameOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(CoinFrameOverlay old) {
    super.didUpdateWidget(old);
    if (widget.active && !_c.isAnimating) {
      _c.repeat(reverse: true);
    } else if (!widget.active && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _OverlayPainter(pulse: _c.value, active: widget.active),
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({required this.pulse, required this.active});

  final double pulse;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2.15);
    final radius = size.shortestSide * 0.40;

    // Scrim with a circular cut-out.
    final scrim = Path()..addRect(Offset.zero & size);
    final hole = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(
      Path.combine(PathOperation.difference, scrim, hole),
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    // Positioning ring.
    final ringRadius = radius + (active ? pulse * 6 : 0);
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.gold.withValues(alpha: active ? 0.5 + pulse * 0.5 : 0.6),
    );

    // Corner brackets around the ring's bounding box.
    final box = Rect.fromCircle(center: center, radius: radius + 18);
    const len = 22.0;
    final bracket = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gold;
    void corner(Offset o, Offset h, Offset v) {
      canvas.drawLine(o, o + h, bracket);
      canvas.drawLine(o, o + v, bracket);
    }

    corner(box.topLeft, const Offset(len, 0), const Offset(0, len));
    corner(box.topRight, const Offset(-len, 0), const Offset(0, len));
    corner(box.bottomLeft, const Offset(len, 0), const Offset(0, -len));
    corner(box.bottomRight, const Offset(-len, 0), const Offset(0, -len));
  }

  @override
  bool shouldRepaint(_OverlayPainter old) =>
      old.pulse != pulse || old.active != active;
}
