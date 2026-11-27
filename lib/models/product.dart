import 'package:flutter/material.dart';

/// Вид фотографии товара (PNG на прозрачном фоне).
enum ProductView {
  front,     // Впереди
  side,      // Сбоку
  back,      // Сзади
  closeup,   // Материал вблизи (текстура)
}

class ProductPhoto {
  /// Путь к файлу в assets/products/
  final String asset;

  /// Вид фото
  final ProductView view;
  const ProductPhoto(this.asset, {required this.view});
}

class ProductSection {
  final String title;
  final List<String> bullets;
  const ProductSection(this.title, this.bullets);
}

class Product {
  final String id;
  final String name;
  final String category;
  final Color color;

  /// Короткая строка под названием (артикул, размеры, цвет).
  final String spec;
  final List<ProductPhoto> photos;
  final List<ProductSection> sections;

  /// Ссылка на страницу товара у поставщика.
  final String url;
  final String? shop;

  /// Цена в рублях. null — не показываем и не учитываем в сортировке.
  final int? price;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.spec,
    required this.photos,
    required this.sections,
    required this.url,
    this.shop,
    this.price,
  });

  /// Картинка для превью (вид спереди, иначе первое).
  ProductPhoto get cover =>
      photos.firstWhere((p) => p.view == ProductView.front, orElse: () => photos.first);

  /// Фото по виду
  ProductPhoto? photoByView(ProductView view) {
    try {
      return photos.firstWhere((p) => p.view == view);
    } catch (_) {
      return null;
    }
  }

  IconData get icon {
    switch (category) {
      case 'Диван':
        return Icons.weekend_rounded;
      case 'Кресло':
        return Icons.chair_rounded;
      case 'Стул':
        return Icons.chair_alt_rounded;
      case 'Стол':
        return Icons.table_restaurant_rounded;
      case 'Комод':
      case 'Кухня':
        return Icons.inventory_2_rounded;
      default:
        return Icons.local_florist_rounded;
    }
  }
}
