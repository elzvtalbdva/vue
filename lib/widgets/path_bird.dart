import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import '../core/color_utils.dart';

/// Ласточка (белый спрайт assets/swallow.png). Цвет подстраивается под тему.
class Swallow extends StatelessWidget {
  final double width;
  const Swallow({super.key, this.width = 80});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/swallow.png',
      width: width,
      color: Theme.of(context).colorScheme.onSurface,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Ласточка летит по кривой: поворачивается по направлению полёта,
/// слегка «машет» (сжатие по вертикали) и разворачивается, если летит влево.
class PathBird extends StatelessWidget {
  final Animation<double> progress; // 0..1
  final Path Function(Size size) pathBuilder;
  final double birdWidth;

  const PathBird({
    super.key,
    required this.progress,
    required this.pathBuilder,
    this.birdWidth = 76,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final size = c.biggest;
      final metric = pathBuilder(size).computeMetrics().first;
      return AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          final t = clamp01(progress.value);
          final tan = metric.getTangentForOffset(metric.length * t)!;
          final a = math.atan2(tan.vector.dy, tan.vector.dx);
          final left = tan.vector.dx < 0;
          final flap = 1 + 0.07 * math.sin(t * math.pi * 14);
          final m = Matrix4.identity()
            ..rotateZ(left ? a - math.pi : a)
            ..scaleByVector3(Vector3(left ? -1.0 : 1.0, flap, 1.0));
          return Stack(
            children: [
              Positioned(
                left: tan.position.dx,
                top: tan.position.dy,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.5),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: m,
                    child: Swallow(width: birdWidth),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
