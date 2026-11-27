import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/color_utils.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../state/search_state.dart';
import '../widgets/blur_fade.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/gradient_slider.dart';
import '../widgets/screen_header.dart';

/// ГЛАВНАЯ ФУНКЦИЯ: выбор цвета.
/// 1) кольцо оттенков → отпустили палец → круг разворачивается
/// 2) тонкая настройка (квадрат, слайдеры, коды) → «Найти мебель» → каталог.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchState>();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: 'Поиск',
            leading: IconButton(
              tooltip: 'Фильтры',
              onPressed: () => showFilterSheet(context),
              icon: Badge(
                isLabelVisible: search.filtersActive,
                smallSize: 8,
                child: const Icon(Icons.tune_rounded, size: 28),
              ),
            ),
            trailing: search.stage == PickStage.tune
                ? IconButton(
                    tooltip: 'Вернуться к кольцу',
                    onPressed: search.backToWheel,
                    icon: const Icon(Icons.donut_large_rounded, size: 26),
                  )
                : null,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: search.stage == PickStage.wheel
                  ? const _WheelStage(key: ValueKey('wheel'))
                  : const _TuneStage(key: ValueKey('tune')),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── 1. КОЛЬЦО ─────────────────────────

class _WheelStage extends StatefulWidget {
  const _WheelStage({super.key});

  @override
  State<_WheelStage> createState() => _WheelStageState();
}

class _WheelStageState extends State<_WheelStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _grow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  bool _drag = false;

  @override
  void dispose() {
    _grow.dispose();
    super.dispose();
  }

  void _update(Offset p, double size) {
    final dx = p.dx - size / 2, dy = p.dy - size / 2;
    if (dx.abs() < 1 && dy.abs() < 1) return;
    var deg = math.atan2(dx, -dy) * 180 / math.pi; // по часовой от верха
    if (deg < 0) deg += 360;
    context.read<SearchState>().setWheelHue((360 - deg) % 360);
  }

  void _release() {
    if (!_drag || _grow.isAnimating) return;
    setState(() => _drag = false);
    _grow.forward().whenComplete(() {
      if (mounted) context.read<SearchState>().enterTune();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hue = context.select<SearchState, double>((s) => s.wheelHue);

    return LayoutBuilder(builder: (context, c) {
      final size = math.min(c.maxWidth - 48, 360.0);
      final theta = ((360 - hue) % 360) * math.pi / 180;
      final pure = HSVColor.fromAHSV(1, hue, 1, 1).toColor();

      return Column(
        children: [
          const SizedBox(height: 28),
          BlurFade(
            child: Text('Выберите цвет:',
                style: context.tt.titleMedium
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) {
                    if (_grow.value > 0) return;
                    setState(() => _drag = true);
                    _update(d.localPosition, size);
                  },
                  onPanUpdate: (d) => _update(d.localPosition, size),
                  onPanEnd: (_) => _release(),
                  onPanCancel: _release,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: _drag ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 180),
                    builder: (context, p, _) => AnimatedBuilder(
                      animation: _grow,
                      builder: (context, _) {
                        final g = Curves.easeInOutCubic.transform(_grow.value);
                        final mid = size / 2 * 0.75;
                        final cx = lerpDouble(
                            size / 2 + mid * math.sin(theta), size / 2, g)!;
                        final cy = lerpDouble(
                            size / 2 - mid * math.cos(theta), size / 2, g)!;
                        final r = lerpDouble(
                            lerpDouble(20, 32, p)!, size * 0.46, g)!;
                        return Stack(
                          children: [
                            const Positioned.fill(
                              child: RepaintBoundary(
                                child: CustomPaint(painter: _RingPainter()),
                              ),
                            ),
                            Positioned(
                              left: cx - r,
                              top: cy - r,
                              width: 2 * r,
                              height: 2 * r,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: pure,
                                  border: Border.all(
                                      color: Colors.white, width: 3 + 3 * g),
                                  boxShadow: [
                                    BoxShadow(
                                      color: pure.withValues(alpha: 0.5),
                                      blurRadius: 18 * p,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlurFade(
            delay: const Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                'Выберите оттенок и отпустите',
                style: TextStyle(fontSize: 12, color: context.muted),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.width / 2;
    final inner = outer * 0.5;
    final rect = Rect.fromCircle(center: center, radius: outer);
    // Красный сверху; дальше по часовой: пурпур → синий → голубой → зелёный → жёлтый → оранжевый.
    final colors = [
      for (var i = 0; i <= 12; i++)
        HSVColor.fromAHSV(1, ((360 - i * 30) % 360).toDouble(), 1, 1).toColor(),
    ];
    final shader = SweepGradient(
      colors: colors,
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);
    canvas.drawCircle(
      center,
      (outer + inner) / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = outer - inner
        ..shader = shader
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ───────────────────────── 2. НАСТРОЙКА ─────────────────────────

class _TuneStage extends StatefulWidget {
  const _TuneStage({super.key});

  @override
  State<_TuneStage> createState() => _TuneStageState();
}

class _TuneStageState extends State<_TuneStage> {
  bool _details = false;

  void _find() {
    context.read<SearchState>().applyTarget();
    context.read<AppState>().setTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SearchState>();
    final t = s.tuning;
    final color = t.result;
    final name = colorNameRu(color);
    Duration d(int ms) => Duration(milliseconds: ms);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            BlurFade(
              child: Center(
                child: AnimatedSwitcher(
                  duration: d(250),
                  child: Text(
                    name,
                    key: ValueKey(name),
                    style: context.tt.titleMedium
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlurFade(
              delay: d(80),
              child: AspectRatio(
                aspectRatio: 1,
                child: _SvSquare(
                  tuning: t,
                  onChanged: (sat, val) =>
                      s.setTuning(t.copyWith(sat: sat, val: val)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            BlurFade(delay: d(160), child: _TunePanel(state: s)),
            const SizedBox(height: 14),
            BlurFade(
              delay: d(240),
              child: _ColorCard(
                color: color,
                expanded: _details,
                onToggle: () => setState(() => _details = !_details),
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: BlurFade(
            delay: d(320),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                foregroundColor: context.cs.onSurface,
                backgroundColor: context.cs.surface,
                side: BorderSide(color: context.cs.onSurface, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _find,
              child: const Text('Найти мебель',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SvSquare extends StatelessWidget {
  final ColorTuning tuning;
  final void Function(double sat, double val) onChanged;
  const _SvSquare({required this.tuning, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final pure = HSVColor.fromAHSV(1, tuning.hue, 1, 1).toColor();
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth, h = c.maxHeight;
      void upd(Offset p) => onChanged(
            clamp01(p.dx / w),
            clamp01(1 - p.dy / h),
          );
      return GestureDetector(
        onPanDown: (d) => upd(d.localPosition),
        onPanUpdate: (d) => upd(d.localPosition),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
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
                left: tuning.sat * w - 13,
                top: (1 - tuning.val) * h - 13,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 4),
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

class _TunePanel extends StatelessWidget {
  final SearchState state;
  const _TunePanel({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = state.tuning;
    final base = t.base;
    final result = t.result;
    final lum = 0.299 * base.r + 0.587 * base.g + 0.114 * base.b;
    final gray = Color.from(alpha: 1, red: lum, green: lum, blue: lum);

    Widget row(String label, String value, Widget slider) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Text(label, style: const TextStyle(fontSize: 12.5)),
              ),
              Expanded(child: slider),
              SizedBox(
                width: 46,
                child: Text(value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );

    String pct(double v) => '${(v * 100).round()}%';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Настройка оттенка',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: state.resetTuning,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.hairline,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Сбросить', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          row(
            'Оттенок',
            '${t.hue.round()}°',
            GradientSlider(
              value: t.hue,
              min: 0,
              max: 360,
              thumbColor: result,
              colors: [
                for (var i = 0; i <= 6; i++)
                  HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor(),
              ],
              onChanged: (v) => state.setTuning(t.copyWith(hue: v)),
            ),
          ),
          row(
            'Насыщенность',
            pct(t.sat),
            GradientSlider(
              value: t.sat,
              min: 0,
              max: 1,
              thumbColor: result,
              colors: [
                HSVColor.fromAHSV(1, t.hue, 0, t.val).toColor(),
                HSVColor.fromAHSV(1, t.hue, 1, t.val).toColor(),
              ],
              onChanged: (v) => state.setTuning(t.copyWith(sat: v)),
            ),
          ),
          row(
            'Яркость',
            pct(t.val),
            GradientSlider(
              value: t.val,
              min: 0,
              max: 1,
              thumbColor: result,
              colors: [
                Colors.black,
                HSVColor.fromAHSV(1, t.hue, t.sat, 1).toColor(),
              ],
              onChanged: (v) => state.setTuning(t.copyWith(val: v)),
            ),
          ),
          row(
            'Монотонность',
            pct(t.mono),
            GradientSlider(
              value: t.mono,
              min: 0,
              max: 1,
              thumbColor: result,
              colors: [base, gray],
              onChanged: (v) => state.setTuning(t.copyWith(mono: v)),
            ),
          ),
          row(
            'Темнее / Светлее',
            pct(t.light),
            GradientSlider(
              value: t.light,
              min: -1,
              max: 1,
              thumbColor: result,
              colors: [Colors.black, base, Colors.white],
              onChanged: (v) => state.setTuning(t.copyWith(light: v)),
            ),
          ),
          row(
            'Тёплый / Холодный',
            pct(t.warm),
            GradientSlider(
              value: t.warm,
              min: -1,
              max: 1,
              thumbColor: result,
              colors: [const Color(0xFF1A8CFF), base, const Color(0xFFFF8C1A)],
              onChanged: (v) => state.setTuning(t.copyWith(warm: v)),
            ),
          ),
        ],
      ),
    );
  }
}

void _copy(BuildContext context, String value) {
  Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Скопировано: $value'),
      duration: const Duration(milliseconds: 1300),
    ));
}

class _ColorCard extends StatelessWidget {
  final Color color;
  final bool expanded;
  final VoidCallback onToggle;
  const _ColorCard({
    required this.color,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final hex = colorToHex(color);
    final details = [
      ('RGB', rgbString(color)),
      ('HSL', hslString(color)),
      ('HSV', hsvString(color)),
      ('CMYK', cmykString(color)),
      ('Яркость', brightnessString(color)),
      ('Цветовое пространство', 'sRGB'),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.hairline),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Выбранный цвет',
                        style: TextStyle(fontSize: 11, color: context.muted)),
                    const SizedBox(height: 2),
                    Text(hex,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _copy(context, hex),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Скопировать код',
                              style: TextStyle(
                                  fontSize: 11, color: context.muted)),
                          const SizedBox(width: 4),
                          Icon(Icons.copy_rounded,
                              size: 13, color: context.muted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggle,
                icon: AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 280),
                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        for (final (label, value) in details)
                          InkWell(
                            onTap: () => _copy(context, value),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                children: [
                                  Text(label,
                                      style: TextStyle(
                                          fontSize: 12, color: context.muted)),
                                  const Spacer(),
                                  Text(value,
                                      style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 10),
                                  Icon(Icons.copy_rounded,
                                      size: 14, color: context.muted),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
