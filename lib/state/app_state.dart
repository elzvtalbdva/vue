import 'package:flutter/foundation.dart';
import '../data/products.dart';
import '../models/product.dart';

enum AppStage { onboarding, flying, home }

class AppState extends ChangeNotifier {
  AppStage stage = AppStage.onboarding;

  /// 0 — поиск, 1 — каталог, 2 — профиль
  int tab = 1;

  String nickname = '';
  String firstName = '';
  String lastName = '';
  Uint8List? avatar;

  /// Плейлисты: название -> id товаров (порядок сохраняется).
  final Map<String, List<String>> playlists = {
    'Кухня': [],
    'Гостиная': [],
    'Спальня': [],
  };

  String get displayName {
    final n = '$firstName $lastName'.trim();
    return n.isEmpty ? nickname : n;
  }

  void setTab(int i) {
    if (tab == i) return;
    tab = i;
    notifyListeners();
  }

  // ───────── вход ─────────

  /// ЗАГЛУШКА: реальная регистрация (Firebase Auth) подключается здесь.
  void register({
    required String nickname,
    String firstName = '',
    String lastName = '',
    Uint8List? avatar,
  }) {
    this.nickname = nickname;
    this.firstName = firstName;
    this.lastName = lastName;
    this.avatar = avatar;
    stage = AppStage.flying;
    notifyListeners();
  }

  /// ЗАГЛУШКА: подключите google_sign_in + firebase_auth.
  void signInWithGoogle() {
    nickname = 'designer';
    firstName = 'Гость';
    lastName = '';
    stage = AppStage.flying;
    notifyListeners();
  }

  void finishFlight() {
    stage = AppStage.home;
    tab = 1;
    notifyListeners();
  }

  void logout() {
    stage = AppStage.onboarding;
    notifyListeners();
  }

  void updateProfile({
    required String nickname,
    required String firstName,
    required String lastName,
    Uint8List? avatar,
  }) {
    this.nickname = nickname;
    this.firstName = firstName;
    this.lastName = lastName;
    if (avatar != null) this.avatar = avatar;
    notifyListeners();
  }

  // ───────── избранное / плейлисты ─────────

  bool isFavorite(String productId) =>
      playlists.values.any((l) => l.contains(productId));

  bool isInPlaylist(String playlist, String productId) =>
      playlists[playlist]?.contains(productId) ?? false;

  void toggleInPlaylist(String playlist, String productId) {
    final list = playlists[playlist];
    if (list == null) return;
    list.contains(productId) ? list.remove(productId) : list.add(productId);
    notifyListeners();
  }

  /// Создаёт плейлист «Новый плейлист», «Новый плейлист 2», … и возвращает имя.
  String createPlaylist([String? name]) {
    var n = (name ?? '').trim();
    if (n.isEmpty) n = 'Новый плейлист';
    var candidate = n;
    var i = 2;
    while (playlists.containsKey(candidate)) {
      candidate = '$n $i';
      i++;
    }
    playlists[candidate] = [];
    notifyListeners();
    return candidate;
  }

  void renamePlaylist(String oldName, String newName) {
    final n = newName.trim();
    if (n.isEmpty || n == oldName || playlists.containsKey(n)) return;
    final entries = playlists.entries.toList();
    playlists.clear();
    for (final e in entries) {
      playlists[e.key == oldName ? n : e.key] = e.value;
    }
    notifyListeners();
  }

  List<Product> productsIn(String playlist) => (playlists[playlist] ?? [])
      .map(productById)
      .whereType<Product>()
      .toList();
}
