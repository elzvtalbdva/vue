import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import 'circle_reveal.dart';

/// Шапка экрана: слева иконка, по центру заголовок, справа — свой виджет.
class ScreenHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  const ScreenHeader({super.key, required this.title, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 16, 6),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Align(alignment: Alignment.centerLeft, child: leading),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: context.tt.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 52,
              child: Align(alignment: Alignment.centerRight, child: trailing),
            ),
          ],
        ),
      ),
    );
  }
}

/// Круглая кнопка с градиентом заката → открывает «Поиск» (круг заливает экран).
class SearchOrb extends StatelessWidget {
  final double size;
  const SearchOrb({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final app = context.read<AppState>();
        final nav = Navigator.of(context, rootNavigator: true);
        circleReveal(
          context,
          onCovered: () {
            nav.popUntil((r) => r.isFirst);
            app.setTab(0);
          },
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: kSunsetGradient,
        ),
      ),
    );
  }
}
