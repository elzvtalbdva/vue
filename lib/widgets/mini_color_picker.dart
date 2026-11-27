import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Маленький «пипеткообразный» индикатор цвета товара (как в шапке карточки):
/// квадрат насыщенность/яркость + полоска оттенка. Только показывает цвет.
class MiniColorPicker extends StatelessWidget {
  final Color color;
  final double width;
  const MiniColorPicker({super.key, required this.color, this.width = 150});

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromColor(color);
    final pure = HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor();
    final h = width * 0.9;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        final sx = lerpDouble(0.5, hsv.saturation, t)! * width;
        final sy = lerpDouble(0.5, 1 - hsv.value, t)! * h;
        final hx = lerpDouble(0.5, hsv.hue / 360, t)! * width;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width,
              height: h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white, pure]),
                        ),
                      ),
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: sx - 9,
                      top: sy - 9,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: width,
              height: 16,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(colors: [
                        for (var i = 0; i <= 6; i++)
                          HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor(),
                      ]),
                    ),
                  ),
                  Positioned(
                    left: hx - 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: pure,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
