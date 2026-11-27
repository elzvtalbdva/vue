import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import 'catalog_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.select<AppState, int>((s) => s.tab);
    const screens = [SearchScreen(), CatalogScreen(), ProfileScreen()];

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation, secondary) =>
            FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondary,
          fillColor: context.cs.surface,
          child: child,
        ),
        child: KeyedSubtree(key: ValueKey(tab), child: screens[tab]),
      ),
      bottomNavigationBar: _VueBar(
        index: tab,
        onTap: (i) => context.read<AppState>().setTab(i),
      ),
    );
  }
}

class _VueBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _VueBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = Color.alphaBlend(
      context.cs.onSurface.withValues(alpha: 0.07),
      context.cs.surface,
    );
    return Container(
      color: bg,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      height: 64 + MediaQuery.paddingOf(context).bottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 3; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Center(child: _BarIcon(slot: i, selected: i == index)),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  final int slot; // 0 — поиск (круг), 1 — каталог (домик), 2 — профиль (меню)
  final bool selected;
  const _BarIcon({required this.slot, required this.selected});

  @override
  Widget build(BuildContext context) {
    final Widget icon;
    if (slot == 0) {
      icon = selected
          ? Container(
              key: const ValueKey('s'),
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: kSunsetGradient,
              ),
            )
          : Icon(Icons.circle_outlined,
              key: const ValueKey('u'), size: 28, color: context.cs.onSurface);
    } else {
      final data = slot == 1
          ? (selected ? Icons.home_rounded : Icons.home_outlined)
          : Icons.menu_rounded;
      icon = selected
          ? ShaderMask(
              key: const ValueKey('s'),
              blendMode: BlendMode.srcIn,
              shaderCallback: (r) => kSunsetGradient.createShader(r),
              child: Icon(data, size: 30, color: Colors.white),
            )
          : Icon(data,
              key: const ValueKey('u'), size: 30, color: context.cs.onSurface);
    }
    return AnimatedScale(
      scale: selected ? 1.12 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: icon,
      ),
    );
  }
}
