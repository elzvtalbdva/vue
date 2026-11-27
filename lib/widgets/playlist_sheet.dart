import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../state/app_state.dart';

/// Как в Pinterest: нажали сердечко → выбрали, в какие плейлисты сохранить.
Future<void> showPlaylistSheet(BuildContext context, Product product) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => _PlaylistSheet(product: product),
  );
}

Future<String?> askPlaylistName(BuildContext context, {String? initial}) {
  final ctl = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(initial == null ? 'Новый плейлист' : 'Название плейлиста'),
      content: TextField(
        controller: ctl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Например, «Гостиная»'),
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctl.text),
          child: const Text('Готово'),
        ),
      ],
    ),
  );
}

class _PlaylistSheet extends StatelessWidget {
  final Product product;
  const _PlaylistSheet({required this.product});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SafeArea(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Сохранить в плейлист',
                    style: context.tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final name in state.playlists.keys)
                    CheckboxListTile(
                      value: state.isInPlaylist(name, product.id),
                      title: Text(name),
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (_) => context
                          .read<AppState>()
                          .toggleInPlaylist(name, product.id),
                    ),
                  ListTile(
                    leading: const Icon(Icons.add_rounded),
                    title: const Text('Новый плейлист'),
                    onTap: () async {
                      final name = await askPlaylistName(context);
                      if (name != null && context.mounted) {
                        final s = context.read<AppState>();
                        final created = s.createPlaylist(name);
                        s.toggleInPlaylist(created, product.id);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
