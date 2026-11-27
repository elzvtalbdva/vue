import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import 'playlist_sheet.dart';

class HeartButton extends StatelessWidget {
  final Product product;
  final double size;
  const HeartButton({super.key, required this.product, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final fav = context.select<AppState, bool>((s) => s.isFavorite(product.id));
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: () => showPlaylistSheet(context, product),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
        child: Icon(
          fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(fav),
          size: size,
          color: fav ? context.cs.primary : context.cs.onSurface,
        ),
      ),
    );
  }
}
