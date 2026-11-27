import 'dart:typed_data';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/blur_fade.dart';
import '../widgets/path_bird.dart';

/// Приветствие → ласточка прилетает → «Как Вас зовут?» (регистрация).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final Animation<double> _flight =
      CurvedAnimation(parent: _intro, curve: Curves.easeInOutCubic);

  late final AnimationController _up = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _upCurve =
      CurvedAnimation(parent: _up, curve: Curves.easeInOutCubic);

  bool _showText = false;
  bool _showForm = false;

  final _login = TextEditingController();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _pass = TextEditingController();
  Uint8List? _photo;

  bool get _valid =>
      _login.text.trim().length >= 3 && _pass.text.length >= 4;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _showText = true);
    _intro.forward();
    await Future.delayed(const Duration(milliseconds: 3600));
    if (!mounted) return;
    setState(() => _showText = false);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _showForm = true);
    _up.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    _up.dispose();
    _login.dispose();
    _name.dispose();
    _surname.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final x = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    if (mounted) setState(() => _photo = bytes);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AppState>().register(
          nickname: _login.text.trim(),
          firstName: _name.text.trim(),
          lastName: _surname.text.trim(),
          avatar: _photo,
        );
  }

  void _google() {
    FocusScope.of(context).unfocus();
    // ЗАГЛУШКА: сюда подключается google_sign_in.
    context.read<AppState>().signInWithGoogle();
  }

  void _phone() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вход по номеру телефона скоро появится')),
    );
  }

  Path _introPath(Size s) => Path()
    ..moveTo(-s.width * 0.15, s.height * 0.80)
    ..cubicTo(
      s.width * 0.32, s.height * 0.80,
      s.width * 0.18, s.height * 0.42,
      s.width * 0.50, s.height * 0.42,
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth, h = c.maxHeight;
        return Stack(
          children: [
            // «Добро пожаловать в vue!»
            Positioned(
              left: 24,
              right: 24,
              top: h * 0.47,
              child: BlurFade(
                show: _showText,
                duration: const Duration(milliseconds: 900),
                blur: 14,
                child: Text(
                  'Добро пожаловать в $kAppName!',
                  textAlign: TextAlign.center,
                  style: context.tt.titleLarge
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Ласточка: сначала летит по кривой, потом поднимается наверх.
            if (!_showForm)
              Positioned.fill(
                child: PathBird(progress: _flight, pathBuilder: _introPath),
              )
            else
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _upCurve,
                  builder: (context, _) {
                    final y = lerpDouble(h * 0.42, h * 0.19, _upCurve.value)!;
                    return Stack(children: [
                      Positioned(
                        left: w / 2,
                        top: y,
                        child: const FractionalTranslation(
                          translation: Offset(-0.5, -0.5),
                          child: Swallow(width: 76),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
            // Форма регистрации
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_showForm,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(28, h * 0.27, 28, 32),
                  child: _form(context),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _form(BuildContext context) {
    Duration d(int ms) => Duration(milliseconds: ms);
    return Column(
      children: [
        BlurFade(
          show: _showForm,
          delay: d(300),
          child: Text('Как Вас зовут?',
              style: context.tt.titleLarge
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 26),
        BlurFade(
          show: _showForm,
          delay: d(450),
          child: _Avatar(photo: _photo, onTap: _pickPhoto),
        ),
        const SizedBox(height: 26),
        for (final (i, f) in [
          ('Логин', _login, false),
          ('Имя', _name, false),
          ('Фамилия', _surname, false),
          ('Пароль', _pass, true),
        ].indexed)
          BlurFade(
            show: _showForm,
            delay: d(600 + i * 100),
            child: _FieldRow(
              label: f.$1,
              controller: f.$2,
              obscure: f.$3,
              onChanged: () => setState(() {}),
            ),
          ),
        const SizedBox(height: 20),
        SizedBox(
          height: 56,
          child: BlurFade(
            show: _showForm && _valid,
            blur: 6,
            dy: 8,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: context.cs.onSurface,
                side: BorderSide(color: context.cs.onSurface, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submit,
              child: const Text('Продолжить', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlurFade(
          show: _showForm,
          delay: d(1000),
          child: Column(
            children: [
              Text('или', style: TextStyle(fontSize: 12, color: context.muted)),
              TextButton(
                onPressed: _google,
                child: const Text('войти по Google',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: _phone,
                child: const Text('войти по номеру телефона',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final Uint8List? photo;
  final VoidCallback onTap;
  const _Avatar({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: photo == null ? kAvatarGradient : null,
                image: photo == null
                    ? null
                    : DecorationImage(image: MemoryImage(photo!), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.black, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onChanged;
  const _FieldRow({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: context.tt.titleMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 2,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: kSunsetMid.withValues(alpha: 0.5),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              autocorrect: false,
              onChanged: (_) => onChanged(),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: context.cs.surfaceContainerHighest,
                hintText: 'введите…',
                hintStyle: TextStyle(fontSize: 13, color: context.muted),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
