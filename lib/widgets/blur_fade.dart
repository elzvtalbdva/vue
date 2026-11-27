import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Плавное появление: прозрачность + размытие → резкость + лёгкий сдвиг.
/// show=false — так же плавно исчезает. delay — для каскада элементов.
class BlurFade extends StatefulWidget {
  final Widget child;
  final bool show;
  final Duration delay;
  final Duration duration;
  final double blur;
  final double dy;

  const BlurFade({
    super.key,
    required this.child,
    this.show = true,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.blur = 10,
    this.dy = 16,
  });

  @override
  State<BlurFade> createState() => _BlurFadeState();
}

class _BlurFadeState extends State<BlurFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(BlurFade old) {
    super.didUpdateWidget(old);
    if (old.show != widget.show) _sync();
  }

  void _sync() {
    _timer?.cancel();
    if (widget.show) {
      _timer = Timer(widget.delay, () {
        if (mounted) _c.forward();
      });
    } else {
      _c.reverse();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        if (t == 0) {
          // Невидим и не ловит нажатия, но занимает своё место в раскладке.
          return IgnorePointer(child: Opacity(opacity: 0, child: child));
        }
        final sigma = (1 - t) * widget.blur;
        Widget w = Opacity(opacity: t, child: child);
        if (sigma > 0.05) {
          w = ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: sigma,
              sigmaY: sigma,
              tileMode: TileMode.decal,
            ),
            child: w,
          );
        }
        return IgnorePointer(
          ignoring: t < 0.6,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.dy),
            child: w,
          ),
        );
      },
    );
  }
}
