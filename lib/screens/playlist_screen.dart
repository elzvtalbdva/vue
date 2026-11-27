import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/playlist_sheet.dart';
import '../widgets/product_card.dart';

/// Страница плейлиста — на тон светлее фона, как в дизайне.
class PlaylistScreen extends StatefulWidget {
  final String name;
  const PlaylistScreen({super.key, required this.name});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late String _name = widget.name;

  Future<void> _rename() async {
    final n = await askPlaylistName(context, initial: _name);
    if (n == null || !mounted) return;
    final app = context.read<AppState>();
    app.renamePlaylist(_name, n);
    if (app.playlists.containsKey(n.trim())) setState(() => _name = n.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bg = context.cs.surfaceContainerHigh;
    final items = context.watch<AppState>().productsIn(_name);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left_rounded, size: 38),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _rename,
                      child: Text(
                        _name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.tt.titleLarge
                            ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Добавить мебель',
                    onPressed: () {
                      final app = context.read<AppState>();
                      Navigator.of(context, rootNavigator: true)
                          .popUntil((r) => r.isFirst);
                      app.setTab(1);
                    },
                    icon: const Icon(Icons.add_rounded, size: 32),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
                        child: Text(
                          'Тут пока ничего нет :(',
                          style: TextStyle(
                            fontSize: 18,
                            color: context.cs.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    )
                  : GridView.builder(
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
                        background: bg,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
