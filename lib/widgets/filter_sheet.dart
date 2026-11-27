import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/products.dart';
import '../state/search_state.dart';

/// Фильтры каталога (иконка слева вверху): тип мебели и сортировка.
Future<void> showFilterSheet(BuildContext context) {
  final search = context.read<SearchState>();
  var sort = search.sort;
  final cats = {...search.categories};

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Что ищем',
                  style: ctx.tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in productCategories)
                    FilterChip(
                      label: Text(c),
                      selected: cats.contains(c),
                      onSelected: (v) =>
                          setSheet(() => v ? cats.add(c) : cats.remove(c)),
                    ),
                ],
              ),
              if (search.hasPrices) ...[
                const SizedBox(height: 20),
                Text('Сортировка',
                    style: ctx.tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: 'color', label: Text('По цвету')),
                      ButtonSegment(value: 'asc', label: Text('Дешевле')),
                      ButtonSegment(value: 'desc', label: Text('Дороже')),
                    ],
                    selected: {sort},
                    onSelectionChanged: (s) => setSheet(() => sort = s.first),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setSheet(() {
                      cats.clear();
                      sort = 'color';
                    }),
                    child: const Text('Сбросить'),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      search.setFilters(sort: sort, categories: cats);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Применить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
