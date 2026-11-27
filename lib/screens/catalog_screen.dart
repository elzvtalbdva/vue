import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/color_utils.dart';
import '../core/theme.dart';
import '../state/search_state.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/product_card.dart';
import '../widgets/screen_header.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchState>();
    final (items, exact) = search.results();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: 'Каталог',
            leading: IconButton(
              tooltip: 'Фильтры',
              onPressed: () => showFilterSheet(context),
              icon: Badge(
                isLabelVisible: search.filtersActive,
                smallSize: 8,
                child: const Icon(Icons.tune_rounded, size: 28),
              ),
            ),
            trailing: const SearchOrb(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: search.target == null
                ? const SizedBox(width: double.infinity)
                : _TargetChip(
                    color: search.target!,
                    exact: exact,
                    onClear: search.clearTarget,
                  ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('Ничего не найдено',
                        style: TextStyle(color: context.muted)),
                  )
                : GridView.builder(
                    key: ValueKey(
                      '${search.target}-${search.sort}-${search.categories.join(',')}',
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ProductCard(
                      key: ValueKey(items[i].id),
                      product: items[i],
                      index: i,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TargetChip extends StatelessWidget {
  final Color color;
  final bool exact;
  final VoidCallback onClear;
  const _TargetChip({
    required this.color,
    required this.exact,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: context.hairline),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${colorToHex(color)} · ${colorNameRu(color)}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  if (!exact)
                    Text('Точных совпадений нет — показаны самые близкие',
                        style: TextStyle(fontSize: 11, color: context.muted)),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
