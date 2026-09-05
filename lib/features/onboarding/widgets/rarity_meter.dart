import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// The arc gauge from the onboarding "1% rarest" slide — a needle sweeping a
/// warm gradient track from "very common" to "ultra rare".
class RarityMeter extends StatelessWidget {
  const RarityMeter({
    super.key,
    required this.label,
    required this.lowLabel,
    required this.highLabel,
    this.fill = 0.92,
  });

  final String label;
  final String lowLabel;
  final String highLabel;

  /// 0..1 position of the needle.
  final double fill;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: CustomPaint(
            size: const Size(double.infinity, 60),
            painter: _MeterPainter(fill.clamp(0, 1)),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(lowLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(highLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }
}

class _MeterPainter extends CustomPainter {
  _MeterPainter(this.fill);
  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(6, 8, size.width - 12, 90);
    const startAngle = math.pi * 0.85;
    const sweep = math.pi * 1.3;

    // Track.
    canvas.drawArc(
      rect,
      startAngle,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8
        ..shader = const LinearGradient(
          colors: [Color(0xFF3A3F47), AppColors.gold],
        ).createShader(rect),
    );

    // Needle.
    final angle = startAngle + sweep * fill;
    final cx = rect.center.dx;
    final cy = rect.top + rect.height / 2;
    final r = rect.width / 2;
    final tip = Offset(cx + r * math.cos(angle), cy + r * math.sin(angle));
    canvas.drawCircle(tip, 9, Paint()..color = AppColors.gold);
    canvas.drawCircle(
        tip, 9, Paint()..color = AppColors.onGold..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _MeterPainter old) => old.fill != fill;
}
