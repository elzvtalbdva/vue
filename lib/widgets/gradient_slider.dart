import 'package:flutter/material.dart';
import '../core/color_utils.dart';

/// Тонкий слайдер с градиентной дорожкой и кружком-ползунком.
class GradientSlider extends StatelessWidget {
  final double value, min, max;
  final List<Color> colors;
  final Color thumbColor;
  final double trackHeight;
  final double thumbSize;
  final ValueChanged<double> onChanged;

  const GradientSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.colors,
    required this.thumbColor,
    required this.onChanged,
    this.trackHeight = 4,
    this.thumbSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final frac = clamp01((value - min) / (max - min));

      void update(double dx) {
        final f = clamp01(dx / w);
        onChanged(min + f * (max - min));
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (d) => update(d.localPosition.dx),
        onPanUpdate: (d) => update(d.localPosition.dx),
        child: SizedBox(
          height: thumbSize + 8,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: trackHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(trackHeight),
                  gradient: LinearGradient(colors: colors),
                ),
              ),
              Positioned(
                left: frac * w - thumbSize / 2,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
