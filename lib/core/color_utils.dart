import 'dart:math' as math;
import 'package:flutter/material.dart';

int _b(double v) => math.min(255, math.max(0, (v * 255).round()));

/// Ограничивает число отрезком 0..1 (возвращает именно double).
double clamp01(double v) => v < 0.0 ? 0.0 : (v > 1.0 ? 1.0 : v);

String colorToHex(Color c) =>
    '#${_b(c.r).toRadixString(16).padLeft(2, '0')}'
            '${_b(c.g).toRadixString(16).padLeft(2, '0')}'
            '${_b(c.b).toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();

/// Понимает "#D98F52", "D98F52", "#fa0", "217, 143, 82", "rgb(217,143,82)".
Color? parseColor(String input) {
  var s = input.trim();
  if (s.isEmpty) return null;
  if (!s.startsWith('#') && s.contains(RegExp(r'[,\s]'))) {
    final nums = RegExp(r'\d{1,3}')
        .allMatches(s)
        .map((m) => int.parse(m.group(0)!))
        .toList();
    if (nums.length == 3 && nums.every((n) => n <= 255)) {
      return Color.fromARGB(255, nums[0], nums[1], nums[2]);
    }
    return null;
  }
  s = s.replaceAll('#', '');
  if (s.length == 3) s = s.split('').map((c) => '$c$c').join();
  if (s.length != 6) return null;
  final v = int.tryParse(s, radix: 16);
  return v == null ? null : Color(0xFF000000 | v);
}

List<double> _lab(Color c) {
  double lin(double x) =>
      x <= 0.04045 ? x / 12.92 : math.pow((x + 0.055) / 1.055, 2.4).toDouble();
  final r = lin(c.r), g = lin(c.g), b = lin(c.b);
  final x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047;
  final y = r * 0.2126 + g * 0.7152 + b * 0.0722;
  final z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883;
  double f(double t) =>
      t > 0.008856 ? math.pow(t, 1 / 3).toDouble() : 7.787 * t + 16 / 116;
  final fx = f(x), fy = f(y), fz = f(z);
  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

/// ΔE в Lab: 0 — одинаковые, ~10 — почти не отличить, ~30 — «одно семейство».
double colorDistance(Color a, Color b) {
  final l1 = _lab(a), l2 = _lab(b);
  final dl = l1[0] - l2[0], da = l1[1] - l2[1], db = l1[2] - l2[2];
  return math.sqrt(dl * dl + da * da + db * db);
}

// ───────── форматы для панели «Выбранный цвет» ─────────

String rgbString(Color c) => '${_b(c.r)}, ${_b(c.g)}, ${_b(c.b)}';

String hslString(Color c) {
  final h = HSLColor.fromColor(c);
  return '${h.hue.round()}°, ${(h.saturation * 100).round()}%, '
      '${(h.lightness * 100).round()}%';
}

String hsvString(Color c) {
  final h = HSVColor.fromColor(c);
  return '${h.hue.round()}°, ${(h.saturation * 100).round()}%, '
      '${(h.value * 100).round()}%';
}

String cmykString(Color c) {
  final r = c.r, g = c.g, b = c.b;
  final k = 1 - math.max(r, math.max(g, b));
  if (k >= 1) return '0%, 0%, 0%, 100%';
  final cc = (1 - r - k) / (1 - k);
  final m = (1 - g - k) / (1 - k);
  final y = (1 - b - k) / (1 - k);
  String p(double v) => '${(v * 100).round()}%';
  return '${p(cc)}, ${p(m)}, ${p(y)}, ${p(k.toDouble())}';
}

String brightnessString(Color c) =>
    '${((0.299 * c.r + 0.587 * c.g + 0.114 * c.b) * 100).toStringAsFixed(1)}%';

// ───────── название цвета по-русски ─────────

String colorNameRu(Color c) {
  final hsv = HSVColor.fromColor(c);
  final h = hsv.hue, s = hsv.saturation, v = hsv.value;
  if (v < 0.12) return 'Чёрный';
  if (s < 0.09) {
    if (v > 0.93) return 'Белый';
    if (v > 0.72) return 'Светло-серый';
    if (v > 0.38) return 'Серый';
    return 'Тёмно-серый';
  }
  String base;
  if (h < 15 || h >= 345) {
    base = 'красный';
  } else if (h < 40) {
    base = 'оранжевый';
  } else if (h < 65) {
    base = 'жёлтый';
  } else if (h < 90) {
    base = 'лаймовый';
  } else if (h < 150) {
    base = 'зелёный';
  } else if (h < 190) {
    base = 'бирюзовый';
  } else if (h < 215) {
    base = 'голубой';
  } else if (h < 255) {
    base = 'синий';
  } else if (h < 285) {
    base = 'фиолетовый';
  } else if (h < 320) {
    base = 'пурпурный';
  } else {
    base = 'розовый';
  }
  if ((h < 45 || h >= 345) && v < 0.6 && s > 0.3) {
    base = (h >= 345 || h < 12) ? 'бордовый' : 'коричневый';
  }
  var prefix = '';
  if (s >= 0.9 && v >= 0.9) {
    prefix = 'Чистый ';
  } else if (v < 0.35) {
    prefix = 'Очень тёмный ';
  } else if (v < 0.5) {
    prefix = 'Тёмный ';
  } else if (s < 0.3) {
    prefix = 'Пыльный ';
  } else if (v > 0.85 && s < 0.55) {
    prefix = 'Светлый ';
  } else if (s >= 0.75) {
    prefix = 'Насыщенный ';
  }
  final name = '$prefix$base';
  return name[0].toUpperCase() + name.substring(1);
}

// ───────── тонкая настройка оттенка ─────────

/// База — HSV. Поверх неё: монотонность (к серому), светлее/темнее,
/// тёплый/холодный. [result] — итоговый цвет для поиска.
class ColorTuning {
  final double hue; // 0..360
  final double sat; // 0..1
  final double val; // 0..1
  final double mono; // 0..1
  final double light; // -1..1
  final double warm; // -1..1

  const ColorTuning({
    this.hue = 0,
    this.sat = 1,
    this.val = 1,
    this.mono = 0,
    this.light = 0,
    this.warm = 0,
  });

  ColorTuning copyWith({
    double? hue,
    double? sat,
    double? val,
    double? mono,
    double? light,
    double? warm,
  }) =>
      ColorTuning(
        hue: hue ?? this.hue,
        sat: sat ?? this.sat,
        val: val ?? this.val,
        mono: mono ?? this.mono,
        light: light ?? this.light,
        warm: warm ?? this.warm,
      );

  Color get base => HSVColor.fromAHSV(1, hue, sat, val).toColor();

  Color get result {
    var c = base;
    if (mono > 0) {
      final g = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
      c = Color.lerp(
        c,
        Color.from(alpha: 1, red: g, green: g, blue: g),
        mono,
      )!;
    }
    if (light > 0) {
      c = Color.lerp(c, Colors.white, light * 0.8)!;
    } else if (light < 0) {
      c = Color.lerp(c, Colors.black, -light * 0.8)!;
    }
    if (warm > 0) {
      c = Color.lerp(c, const Color(0xFFFF8C1A), warm * 0.4)!;
    } else if (warm < 0) {
      c = Color.lerp(c, const Color(0xFF1A8CFF), -warm * 0.4)!;
    }
    return c;
  }
}
