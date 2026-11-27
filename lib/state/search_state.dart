import 'package:flutter/material.dart';
import '../core/color_utils.dart';
import '../data/products.dart';
import '../models/product.dart';

enum PickStage { wheel, tune }

class SearchState extends ChangeNotifier {
  // ───── выбор цвета ─────
  PickStage stage = PickStage.wheel;
  double wheelHue = 240;
  ColorTuning tuning = const ColorTuning(hue: 240);

  // ───── применённый фильтр каталога ─────
  Color? target;
  String sort = 'color'; // color | asc | desc
  final Set<String> categories = {};

  Color get tunedColor => tuning.result;

  void setWheelHue(double h) {
    wheelHue = h;
    tuning = ColorTuning(hue: h);
    notifyListeners();
  }

  void enterTune() {
    stage = PickStage.tune;
    notifyListeners();
  }

  void backToWheel() {
    stage = PickStage.wheel;
    notifyListeners();
  }

  void setTuning(ColorTuning t) {
    tuning = t;
    notifyListeners();
  }

  void resetTuning() {
    tuning = ColorTuning(hue: wheelHue);
    notifyListeners();
  }

  void applyTarget() {
    target = tuning.result;
    if (sort != 'asc' && sort != 'desc') sort = 'color';
    notifyListeners();
  }

  void clearTarget() {
    target = null;
    notifyListeners();
  }

  void setFilters({required String sort, required Set<String> categories}) {
    this.sort = sort;
    this.categories
      ..clear()
      ..addAll(categories);
    notifyListeners();
  }

  bool get hasPrices => products.any((p) => p.price != null);
  bool get filtersActive => categories.isNotEmpty || sort != 'color';

  /// (список, точное ли совпадение по цвету)
  (List<Product>, bool) results() {
    var list = products
        .where((p) => categories.isEmpty || categories.contains(p.category))
        .toList();
    var exact = true;

    final t = target;
    if (t != null) {
      final d = {for (final p in list) p.id: colorDistance(t, p.color)};
      list.sort((a, b) => d[a.id]!.compareTo(d[b.id]!));
      final close = list.where((p) => d[p.id]! <= 40).toList();
      if (close.isEmpty && list.isNotEmpty) {
        exact = false;
        list = list.take(4).toList();
      } else {
        list = close;
      }
    }

    int price(Product p) => p.price ?? 1 << 30;
    if (sort == 'asc') list.sort((a, b) => price(a).compareTo(price(b)));
    if (sort == 'desc') {
      list.sort((a, b) => (b.price ?? -1).compareTo(a.price ?? -1));
    }
    return (list, exact);
  }
}
