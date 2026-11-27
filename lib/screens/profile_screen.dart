import 'dart:typed_data';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../widgets/blur_fade.dart';
import '../widgets/product_image.dart';
import '../widgets/screen_header.dart';
import 'playlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final names = app.playlists.keys.toList();
    final cardW = (MediaQuery.sizeOf(context).width - 16 * 2 - 12) / 2;
    final hasBoth = app.firstName.isNotEmpty && app.lastName.isNotEmpty;
    final title = hasBoth ? '${app.firstName}\n${app.lastName}' : app.displayName;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: 'Профиль',
            leading: IconButton(
              tooltip: 'Редактировать',
              onPressed: () => _showEditSheet(context),
              icon: const Icon(Icons.edit_outlined, size: 26),
            ),
            trailing: const SearchOrb(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 10),
                BlurFade(
                  child: Center(
                    child: Text('@${app.nickname}',
                        style: TextStyle(fontSize: 16, color: context.muted)),
                  ),
                ),
                const SizedBox(height: 12),
                BlurFade(
                  delay: const Duration(milliseconds: 100),
                  child: Center(child: _BigAvatar(app: app)),
                ),
                const SizedBox(height: 12),
                BlurFade(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.tt.titleMedium
                        ?.copyWith(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 270,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final (i, n) in names.indexed)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: BlurFade(
                            delay: Duration(milliseconds: 300 + 90 * i),
                            child: SizedBox(
                              width: cardW,
                              child: _PlaylistCard(name: n),
                            ),
                          ),
                        ),
                      BlurFade(
                        delay: Duration(milliseconds: 300 + 90 * names.length),
                        child: SizedBox(
                          width: cardW,
                          child: const _NewPlaylistCard(key: ValueKey('new')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigAvatar extends StatelessWidget {
  final AppState app;
  const _BigAvatar({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: app.avatar == null ? kAvatarGradient : null,
        image: app.avatar == null
            ? null
            : DecorationImage(image: MemoryImage(app.avatar!), fit: BoxFit.cover),
      ),
    );
  }
}

OpenContainer<void> _container({
  required BuildContext context,
  required Widget Function(BuildContext, VoidCallback) closed,
  required WidgetBuilder open,
  bool tappable = true,
}) {
  final card = context.cs.surfaceContainerHigh;
  return OpenContainer<void>(
    tappable: tappable,
    transitionType: ContainerTransitionType.fade,
    transitionDuration: const Duration(milliseconds: 550),
    useRootNavigator: true,
    closedElevation: 0,
    openElevation: 0,
    closedColor: card,
    openColor: card,
    middleColor: card,
    closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    openBuilder: (ctx, _) => open(ctx),
    closedBuilder: closed,
  );
}

class _PlaylistCard extends StatelessWidget {
  final String name;
  const _PlaylistCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<AppState>().productsIn(name);
    return _container(
      context: context,
      open: (_) => PlaylistScreen(name: name),
      closed: (ctx, _) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // «+» ведёт в каталог — выбирать, что добавить.
                  onTap: () => ctx.read<AppState>().setTab(1),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.add_rounded, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: items.isEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text('Пока пусто',
                          style: TextStyle(fontSize: 12, color: ctx.muted)),
                    )
                  : ClipRect(
                      child: Stack(
                        children: [
                          for (var i = 0; i < items.length && i < 2; i++)
                            Positioned(
                              top: i * 64.0,
                              left: 0,
                              right: 4,
                              height: 200,
                              child: _MiniTile(product: items[i], depth: i),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  final Product product;
  final int depth;
  const _MiniTile({required this.product, required this.depth});

  @override
  Widget build(BuildContext context) {
    final shade = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.26 + 0.16 * depth),
      context.cs.surfaceContainerHigh,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      decoration: BoxDecoration(
        color: shade,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Expanded(child: ProductImage(product: product)),
        ],
      ),
    );
  }
}

/// «Новый плейлист +»: создаёт плейлист и сразу разворачивается на весь экран.
class _NewPlaylistCard extends StatefulWidget {
  const _NewPlaylistCard({super.key});

  @override
  State<_NewPlaylistCard> createState() => _NewPlaylistCardState();
}

class _NewPlaylistCardState extends State<_NewPlaylistCard> {
  String _created = 'Новый плейлист';

  @override
  Widget build(BuildContext context) {
    return _container(
      context: context,
      tappable: false,
      open: (_) => PlaylistScreen(name: _created),
      closed: (ctx, open) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _created = ctx.read<AppState>().createPlaylist();
          open();
        },
        child: const Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 10, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Новый\nплейлист',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.add_rounded, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showEditSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => const _EditSheet(),
  );
}

class _EditSheet extends StatefulWidget {
  const _EditSheet();

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late final _nick = TextEditingController(text: context.read<AppState>().nickname);
  late final _first = TextEditingController(text: context.read<AppState>().firstName);
  late final _last = TextEditingController(text: context.read<AppState>().lastName);
  Uint8List? _photo;

  @override
  void dispose() {
    _nick.dispose();
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final x = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (x == null) return;
    final b = await x.readAsBytes();
    if (mounted) setState(() => _photo = b);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _nick,
                decoration: const InputDecoration(labelText: 'Логин')),
            const SizedBox(height: 10),
            TextField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'Имя')),
            const SizedBox(height: 10),
            TextField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Фамилия')),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pick,
                icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                label: Text(_photo == null ? 'Изменить фото' : 'Фото выбрано'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    context.read<AppState>().logout();
                  },
                  child: const Text('Выйти'),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    context.read<AppState>().updateProfile(
                          nickname: _nick.text.trim(),
                          firstName: _first.text.trim(),
                          lastName: _last.text.trim(),
                          avatar: _photo,
                        );
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
