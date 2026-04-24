import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/services/auth_service.dart';
import 'package:lutheran/core/services/db_service.dart';
import 'package:lutheran/core/services/notification_service.dart';
import 'package:lutheran/features/auth/presentation/pages/login_page.dart';
import 'package:lutheran/features/settings/presentation/pages/settings_page.dart';
import 'package:lutheran/features/settings/presentation/providers/settings_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  List<Map<String, dynamic>> _verses = [];
  List<Map<String, dynamic>> _notes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      DbService.instance.getAllSavedVerses(),
      DbService.instance.getAllNotes(),
    ]);
    if (mounted) setState(() {
      _verses = results[0];
      _notes  = results[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final bg = dark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F8F8);
    final cardBg = dark ? const Color(0xFF1A1A1A) : Colors.white;
    final div = dark ? Colors.white10 : Colors.grey.shade200;
    final sp = Get.find<SettingsProvider>();
    final isEn = sp.language.value == 'en';

    final name = user?.displayName ?? (isEn ? 'Guest' : 'Nta konti');
    final email = user?.email ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: bg,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dark ? Colors.white12 : Colors.grey.shade200,
                          border: Border.all(
                            color: dark ? Colors.white24 : Colors.grey.shade300),
                        ),
                        child: ClipOval(
                          child: user?.photoURL != null
                              ? Image.network(user!.photoURL!, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(initial, style: GoogleFonts.cinzel(
                                      fontSize: 24, fontWeight: FontWeight.w800,
                                      color: dark ? Colors.white : Colors.black))))
                              : Center(child: Text(initial, style: GoogleFonts.cinzel(
                                  fontSize: 24, fontWeight: FontWeight.w800,
                                  color: dark ? Colors.white : Colors.black))),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(name, style: GoogleFonts.cinzel(
                            fontSize: 18, fontWeight: FontWeight.w800,
                            color: dark ? Colors.white : Colors.black)),
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(email, style: GoogleFonts.lato(
                              fontSize: 12, color: dark ? Colors.white38 : Colors.grey.shade500),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                          const SizedBox(height: 10),
                          // Quick stats
                          Row(children: [
                            _StatPill('${_verses.length}',
                              isEn ? 'Saved' : 'Byabitswe', dark),
                            const SizedBox(width: 8),
                            _StatPill('${_notes.length}',
                              isEn ? 'Notes' : 'Inyandiko', dark),
                          ]),
                        ],
                      )),
                      // Edit button
                      if (user != null)
                        IconButton(
                          icon: Icon(Icons.edit_rounded, size: 20,
                            color: dark ? Colors.white54 : Colors.grey.shade600),
                          onPressed: () => _showEditSheet(context, user, dark),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabs,
              labelColor: dark ? Colors.white : Colors.black,
              unselectedLabelColor: dark ? Colors.white38 : Colors.grey.shade400,
              indicatorColor: dark ? Colors.white : Colors.black,
              indicatorWeight: 2,
              labelStyle: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: GoogleFonts.lato(fontSize: 13),
              tabs: [
                Tab(text: isEn ? 'Saved Verses' : 'Inzandiko Zabitswe'),
                Tab(text: isEn ? 'My Notes' : 'Inyandiko Zanjye'),
              ],
            ),
          ),
        ],
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabs,
                children: [
                  // ── Saved Verses ────────────────────────────────────────
                  _verses.isEmpty
                      ? _EmptySection(
                          icon: Icons.bookmark_outline_rounded,
                          label: isEn
                              ? 'No saved verses yet.\nTap a verse while reading to save it.'
                              : 'Nta nzandiko zabitswe.\nKanda inzandiko mu gusoma uyibike.',
                          dark: dark)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _verses.length,
                            itemBuilder: (context, i) {
                              final v = _verses[i];
                              return _SavedVerseTile(
                                data: v, dark: dark, cardBg: cardBg, div: div,
                                onDelete: () async {
                                  await DbService.instance.unsaveVerse(
                                    bookId: v['book_id'] as String,
                                    chapter: v['chapter'] as int,
                                    verse: v['verse'] as int,
                                  );
                                  _load();
                                },
                              );
                            },
                          ),
                        ),

                  // ── Notes ───────────────────────────────────────────────
                  _notes.isEmpty
                      ? _EmptySection(
                          icon: Icons.edit_note_rounded,
                          label: isEn
                              ? 'No notes yet.\nTap a verse while reading to add a note.'
                              : 'Nta nyandiko ziriho.\nKanda inzandiko mu gusoma wongere inyandiko.',
                          dark: dark)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _notes.length,
                            itemBuilder: (context, i) {
                              final n = _notes[i];
                              return _NoteTile(
                                data: n, dark: dark, cardBg: cardBg, div: div,
                                onDelete: () async {
                                  await DbService.instance.deleteNote(n['id'] as int);
                                  _load();
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
      ),
      // Bottom actions: Settings · Share · Sign out
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardBg,
          border: Border(top: BorderSide(color: div, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BottomAction(
                  icon: Icons.settings_rounded,
                  label: isEn ? 'Settings' : 'Igenamiterere',
                  dark: dark,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsPage())),
                ),
                _BottomAction(
                  icon: Icons.language_rounded,
                  label: isEn ? 'RW' : 'EN',
                  dark: dark,
                  onTap: () => sp.setLanguage(isEn ? 'rw' : 'en'),
                ),
                _BottomAction(
                  icon: Icons.share_rounded,
                  label: isEn ? 'Share App' : 'Sangira',
                  dark: dark,
                  onTap: () => Share.share(
                    isEn
                        ? 'Download the LCR App for daily Bible readings and prayers!'
                        : 'Pakurura porogaramu ya LCR y\'Itorero kugirango usomere Bibiliya buri munsi!'),
                ),
                if (FirebaseAuth.instance.currentUser != null)
                  _BottomAction(
                    icon: Icons.logout_rounded,
                    label: isEn ? 'Sign Out' : 'Sohoka',
                    dark: dark,
                    isDestructive: true,
                    onTap: () => _confirmSignOut(context, isEn),
                  )
                else
                  _BottomAction(
                    icon: Icons.login_rounded,
                    label: isEn ? 'Sign In' : 'Injira',
                    dark: dark,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginPage())),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, bool isEn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEn ? 'Sign Out' : 'Sohoka',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w700)),
        content: Text(isEn ? 'Are you sure you want to sign out?' : 'Urifuza gusohoka?',
          style: GoogleFonts.lato(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : 'Oya',
              style: GoogleFonts.lato(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
            child: Text(isEn ? 'Sign Out' : 'Yego, Sohoka',
              style: GoogleFonts.lato(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, User user, bool dark) {
    final nameCtrl = TextEditingController(text: user.displayName ?? '');
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hindura Amazina', style: GoogleFonts.cinzel(
              fontSize: 16, fontWeight: FontWeight.w700,
              color: dark ? Colors.white : Colors.black)),
            const SizedBox(height: 14),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Amazina',
                prefixIcon: const Icon(Icons.person_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    await user.updateDisplayName(nameCtrl.text.trim());
                    if (context.mounted) { Navigator.pop(context); setState(() {}); }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark ? Colors.white : Colors.black,
                  foregroundColor: dark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Bika', style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
              )),
          ]),
      ),
    );
  }
}

// ─── Saved Verse Tile ─────────────────────────────────────────────────────────
class _SavedVerseTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool dark;
  final Color cardBg;
  final Color div;
  final VoidCallback onDelete;
  const _SavedVerseTile({
    required this.data, required this.dark, required this.cardBg,
    required this.div, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ref = '${data['book_name']} ${data['chapter']}:${data['verse']}';
    final text = data['text'] as String? ?? '';

    return Dismissible(
      key: Key('verse_${data['book_id']}_${data['chapter']}_${data['verse']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white)),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: div)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.bookmark_rounded, size: 14,
              color: dark ? Colors.white54 : Colors.grey.shade500),
            const SizedBox(width: 6),
            Text(ref, style: GoogleFonts.lato(
              fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5,
              color: dark ? Colors.white54 : Colors.grey.shade600)),
            const Spacer(),
            GestureDetector(
              onTap: () => NotificationService.showInstant(
                title: ref, body: text),
              child: Icon(Icons.notifications_none_rounded, size: 16,
                color: dark ? Colors.white24 : Colors.grey.shade400)),
          ]),
          const SizedBox(height: 8),
          Text(text, style: GoogleFonts.notoSerif(
            fontSize: 14, height: 1.65,
            color: dark ? const Color(0xFFE8E6DE) : const Color(0xFF1A1A1A))),
        ]),
      ),
    );
  }
}

// ─── Note Tile ────────────────────────────────────────────────────────────────
class _NoteTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool dark;
  final Color cardBg;
  final Color div;
  final VoidCallback onDelete;
  const _NoteTile({
    required this.data, required this.dark, required this.cardBg,
    required this.div, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? '';
    final content = data['content'] as String? ?? '';
    final ts = data['created_at'] as int? ?? 0;
    final date = ts > 0
        ? DateTime.fromMillisecondsSinceEpoch(ts)
        : DateTime.now();
    final dateStr =
        '${date.day}/${date.month}/${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Dismissible(
      key: Key('note_${data['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white)),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: div)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (title.isNotEmpty) ...[
            Text(title, style: GoogleFonts.lato(
              fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5,
              color: dark ? Colors.white54 : Colors.grey.shade600)),
            const SizedBox(height: 6),
          ],
          Text(content, style: GoogleFonts.lato(
            fontSize: 14, height: 1.6,
            color: dark ? const Color(0xFFE8E6DE) : const Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          Text(dateStr, style: GoogleFonts.lato(
            fontSize: 10, color: dark ? Colors.white24 : Colors.grey.shade400)),
        ]),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  const _EmptySection({required this.icon, required this.label, required this.dark});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: dark ? Colors.white12 : Colors.grey.shade300),
      const SizedBox(height: 16),
      Text(label, textAlign: TextAlign.center,
        style: GoogleFonts.lato(fontSize: 13, height: 1.6,
          color: dark ? Colors.white38 : Colors.grey.shade500)),
    ]),
  );
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final bool dark;
  const _StatPill(this.value, this.label, this.dark);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: dark ? Colors.white10 : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: GoogleFonts.lato(
        fontSize: 12, fontWeight: FontWeight.w800,
        color: dark ? Colors.white : Colors.black)),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.lato(
        fontSize: 11, color: dark ? Colors.white54 : Colors.grey.shade600)),
    ]),
  );
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  final bool isDestructive;
  final VoidCallback onTap;
  const _BottomAction({
    required this.icon, required this.label, required this.dark,
    required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red.shade400
        : (dark ? Colors.white70 : Colors.grey.shade700);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.lato(
            fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}
