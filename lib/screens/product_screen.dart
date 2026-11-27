import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/color_utils.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../widgets/blur_fade.dart';
import '../widgets/heart_button.dart';
import '../widgets/mini_color_picker.dart';
import '../widgets/product_image.dart';
import '../widgets/screen_header.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scroll = ScrollController();
  final _pages = PageController();
  int _index = 0;
  double _btnOpacity = 1;

  @override
  void initState() {
    super.initState();
    // Кнопка «Перейти на сайт» становится прозрачной, когда листаем вниз.
    _scroll.addListener(() {
      final dir = _scroll.position.userScrollDirection;
      if (dir == ScrollDirection.idle) return;
      final target = dir == ScrollDirection.reverse ? 0.2 : 1.0;
      if (target != _btnOpacity) setState(() => _btnOpacity = target);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _openSite() async {
    final ok = await launchUrl(
      Uri.parse(widget.product.url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final n = p.photos.length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _Header(product: p),
                Expanded(
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.only(top: 10, bottom: 130),
                    children: [
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          controller: _pages,
                          physics: const BouncingScrollPhysics(),
                          itemCount: n,
                          onPageChanged: (i) => setState(() => _index = i),
                          itemBuilder: (context, i) => _Page(
                            controller: _pages,
                            index: i,
                            product: p,
                            photo: p.photos[i],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 6, 12, 0),
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Row(
                                key: ValueKey(_index),
                                children: [
                                  for (int i = 0; i < n; i++)
                                    Padding(
                                      padding: EdgeInsets.only(right: i == n - 1 ? 0 : 6),
                                      child: PhotoViewIcon(
                                        view: p.photos[i].view,
                                        size: 16,
                                        color: _index == i
                                            ? context.cs.primary
                                            : context.muted,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            HeartButton(product: p, size: 26),
                          ],
                        ),
                      ),
                      BlurFade(
                        delay: const Duration(milliseconds: 250),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: context.tt.titleLarge?.copyWith(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(p.spec,
                                  style: TextStyle(
                                      fontSize: 11.5, color: context.muted)),
                              if (p.price != null) ...[
                                const SizedBox(height: 8),
                                Text(formatPrice(p.price!),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      for (final (i, s) in p.sections.indexed)
                        BlurFade(
                          delay: Duration(milliseconds: 350 + 80 * i),
                          child: _Section(section: s),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: MediaQuery.paddingOf(context).bottom + 14,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _btnOpacity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    foregroundColor: context.cs.onSurface,
                    backgroundColor: context.cs.surface,
                    side: BorderSide(color: context.cs.onSurface, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _openSite,
                  child: const Text('Перейти на сайт',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: «<», мини-пипетка с цветом товара, круг поиска, образец и HEX.
class _Header extends StatelessWidget {
  final Product product;
  const _Header({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.chevron_left_rounded, size: 38),
          ),
          Expanded(
            child: Center(
              child: MiniColorPicker(color: product.color, width: 138),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SearchOrb(size: 34),
              const SizedBox(height: 16),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: product.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.hairline),
                ),
              ),
              const SizedBox(height: 6),
              Text(colorToHex(product.color),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Одна страница карусели: фото товара или «материал вблизи».
/// При пролистывании слегка уменьшается и бледнеет.
class _Page extends StatelessWidget {
  final PageController controller;
  final int index;
  final Product product;
  final ProductPhoto photo;
  const _Page({
    required this.controller,
    required this.index,
    required this.product,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final isCloseup = photo.view == ProductView.closeup;
    final child = isCloseup
        ? Center(
            child: Image.asset(
              photo.asset,
              width: double.infinity,
              height: 215,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 215,
                width: double.infinity,
                color: product.color,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 6),
            child: ProductImage(product: product, photo: photo),
          );

    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        var dist = 0.0;
        if (controller.hasClients &&
            controller.position.hasPixels &&
            controller.position.hasContentDimensions) {
          dist = ((controller.page ?? index.toDouble()) - index).abs();
          if (dist > 1) dist = 1;
        }
        return Opacity(
          opacity: 1 - 0.55 * dist,
          child: Transform.scale(scale: 1 - 0.12 * dist, child: child),
        );
      },
    );
  }
}

/// «— Размеры и спальное место» → раскрывается списком.
class _Section extends StatefulWidget {
  final ProductSection section;
  const _Section({required this.section});

  @override
  State<_Section> createState() => _SectionState();
}

class _SectionState extends State<_Section> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _open
                          ? const Icon(Icons.keyboard_arrow_down_rounded,
                              key: ValueKey('o'), size: 22)
                          : const Text('—',
                              key: ValueKey('c'), style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Expanded(
                    child: Text(s.title,
                        style: const TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _open
                ? Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final b in s.bullets)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('•  ',
                                    style: TextStyle(fontSize: 12.5)),
                                Expanded(
                                  child: Text(b,
                                      style: const TextStyle(
                                          fontSize: 12.5, height: 1.35)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

String formatPrice(int n) =>
    '${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ' ')} ₽';
