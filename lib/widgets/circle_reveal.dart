import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../core/color_utils.dart';
import '../core/theme.dart';

/// Круг из места нажатия растёт на весь экран (как в дизайне), в этот момент
/// вызывается [onCovered] (смена экрана), затем круг растворяется.
void circleReveal(BuildContext context, {required VoidCallback onCovered}) {
  final box = context.findRenderObject() as RenderBox;
  final center = box.localToGlobal(box.size.center(Offset.zero));
  final size = MediaQuery.sizeOf(context);
  final corners = [
    Offset.zero,
    Offset(size.width, 0),
    Offset(0, size.height),
    Offset(size.width, size.height),
  ];
  final maxR = corners.map((c) => (c - center).distance).reduce(math.max);
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _CircleReveal(
      center: center,
      startR: box.size.width / 2,
      maxR: maxR + 8,
      onCovered: onCovered,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _CircleReveal extends StatefulWidget {
  final Offset center;
  final double startR, maxR;
  final VoidCallback onCovered, onDone;
  const _CircleReveal({
    required this.center,
    required this.startR,
    required this.maxR,
    required this.onCovered,
    required this.onDone,
  });

  @override
  State<_CircleReveal> createState() => _CircleRevealState();
}

class _CircleRevealState extends State<_CircleReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  bool _fired = false;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (!_fired && _c.value >= 0.5) {
        _fired = true;
        widget.onCovered();
      }
    });
    _c.forward().whenComplete(widget.onDone);
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
        builder: (context, _) {
          final grow =
              Curves.easeInOutCubic.transform(clamp01(_c.value / 0.5));
          final fade =
              Curves.easeOut.transform(clamp01((_c.value - 0.5) / 0.5));
          final r = lerpDouble(widget.startR, widget.maxR, grow)!;
          return Opacity(
            opacity: 1 - fade,
            child: CustomPaint(
              size: Size.infinite,
              painter: _CirclePainter(widget.center, r),
            ),
          );
        },
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Offset center;
  final double r;
  _CirclePainter(this.center, this.r);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(
      center,
      r,
      Paint()..shader = kSunsetGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.r != r || old.center != center;
}
