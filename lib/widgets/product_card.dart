import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../core/color_utils.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../screens/product_screen.dart';
import 'blur_fade.dart';
import 'heart_button.dart';
import 'product_image.dart';

/// Карточка каталога. Открывается «как на айфоне»: разворачивается из места
/// нажатия на весь экран (container transform).
class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  /// Цвет фона, на котором лежит карточка (для плавного разворота).
  final Color? background;
  const ProductCard({
    super.key,
    required this.product,
    this.index = 0,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return BlurFade(
      delay: Duration(milliseconds: 70 * (index > 8 ? 8 : index)),
      blur: 6,
      dy: 20,
      child: OpenContainer<void>(
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 550),
        useRootNavigator: true,
        closedElevation: 0,
        openElevation: 0,
        closedColor: background ?? context.cs.surface,
        openColor: context.cs.surface,
        middleColor: context.cs.surface,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        openBuilder: (_, __) => ProductScreen(product: product),
        closedBuilder: (_, __) => _CardBody(product: product),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final Product product;
  const _CardBody({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            colorToHex(product.color),
            style: context.tt.titleMedium
                ?.copyWith(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(child: Center(child: ProductImage(product: product))),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.tt.bodyMedium?.copyWith(fontSize: 13.5),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: HeartButton(product: product, size: 22),
          ),
        ],
      ),
    );
  }
}
