import 'package:flutter/material.dart';
import '../models/product.dart';
import '../core/theme.dart';

/// PNG без фона: сам подстраивается под светлую/тёмную тему.
/// Если файла нет — рисуется иконка цвета товара.
class ProductImage extends StatelessWidget {
  final Product product;
  final ProductPhoto? photo;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ProductImage({
    super.key,
    required this.product,
    this.photo,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final p = photo ?? product.cover;
    return Image.asset(
      p.asset,
      fit: fit,
      width: width,
      height: height,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => Center(
        child: Icon(product.icon, size: 72, color: product.color),
      ),
    );
  }
}

/// Виджет для отображения иконки вида фото (для карусели)
class PhotoViewIcon extends StatelessWidget {
  final ProductView view;
  final double size;
  final Color? color;

  const PhotoViewIcon({
    super.key,
    required this.view,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (view) {
      case ProductView.front:
        icon = Icons.remove_red_eye_rounded;
        break;
      case ProductView.side:
        icon = Icons.rotate_right_rounded;
        break;
      case ProductView.back:
        icon = Icons.rotate_left_rounded;
        break;
      case ProductView.closeup:
        icon = Icons.zoom_in_rounded;
        break;
    }
    return Icon(icon, size: size, color: color ?? context.muted);
  }
}
