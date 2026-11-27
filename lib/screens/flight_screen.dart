import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/path_bird.dart';

/// Ласточка делает петлю по экрану и садится в центр — переход в приложение.
class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );
  late final Animation<double> _curve =
      CurvedAnimation(parent: _c, curve: Curves.easeInOutSine);

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) context.read<AppState>().finishFlight();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Path _path(Size s) => Path()
    ..moveTo(s.width * 0.50, s.height * 0.19)
    ..cubicTo(
      s.width * 0.80, s.height * 0.19,
      s.width * 0.92, s.height * 0.50,
      s.width * 0.65, s.height * 0.55,
    )
    ..cubicTo(
      s.width * 0.60, s.height * 0.56,
      s.width * 0.55, s.height * 0.56,
      s.width * 0.50, s.height * 0.55,
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PathBird(progress: _curve, pathBuilder: _path),
    );
  }
}
