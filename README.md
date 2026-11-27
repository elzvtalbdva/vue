# vue — MVP (Flutter, Material 3)

## Запуск
1. Распакуйте архив, откройте терминал в папке `vue`.
2. Один раз создайте платформенные папки:
       flutter create . --org com.vue --project-name vue
   (файлы lib/, pubspec.yaml, assets/ не перезапишутся)
3. Зависимости:
       flutter pub get
4. Иконка приложения (из assets/icon):
       dart run flutter_launcher_icons
5. Запуск:
       flutter run -d chrome        # быстрее всего
       flutter run                  # телефон / симулятор (нужны Xcode+CocoaPods или Android SDK)

## Название под иконкой
- Android: android/app/src/main/AndroidManifest.xml → android:label="vue"
- iOS: ios/Runner/Info.plist → <key>CFBundleDisplayName</key><string>vue</string>
- iOS, доступ к галерее (выбор фото профиля), добавьте в Info.plist:
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Нужно, чтобы выбрать фото профиля</string>

## Где менять данные
- lib/data/products.dart — товары: описание, разделы, ссылки (url), цены (price)
- assets/products/ — фото. Имена: <id>_1.png, <id>_2.png ..., <id>_tex.png (материал).
  Заменяйте на оригиналы с прозрачным фоном — имена и код менять не нужно, если названия те же.
- lib/core/theme.dart — название (kAppName), цвета, градиент
- lib/state/app_state.dart — signInWithGoogle() и register(): место для Firebase
