import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/services/auth_service.dart';
import 'package:lutheran/features/auth/presentation/pages/login_page.dart';
import 'package:share_plus/share_plus.dart';

// ─── Community Page ───────────────────────────────────────────────────────────
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0E17) : const Color(0xFFF5F3EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1C1B22) : const Color(0xFF0D1B3E),
        title: Text('Ubucuti / Community',
            style: GoogleFonts.cinzel(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        actions: [
          if (AuthService.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
              onPressed: () => _showNewPost(context, isDark),
            ),
          if (!AuthService.isLoggedIn)
            TextButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
              child: Text('Injira', style: GoogleFonts.lato(
                  color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Inkuru / Feed'),
            Tab(text: 'Amasengesho / Prayers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _FeedTab(isDark: isDark),
          _PrayerWallTab(isDark: isDark),
        ],
      ),
      floatingActionButton: AuthService.isLoggedIn
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF0D1B3E),
              onPressed: () => _showNewPost(context, isDark),
              child: const Icon(Icons.edit_rounded, color: Colors.white),
            )
          : null,
    );
  }

  void _showNewPost(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewPostSheet(isDark: isDark),
    );
  }
}

// ─── Feed Tab ─────────────────────────────────────────────────────────────────
class _FeedTab extends StatelessWidget {
  final bool isDark;
  const _FeedTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('type', whereIn: ['verse_share', 'reflection'])
          .orderBy('createdAt', descending: true)
          .limit(40)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return _EmptyState(
            icon: Icons.people_outline_rounded,
            title: 'Nta nkuru zihari / No posts yet',
            sub: 'Banza wowe woherereze / Be the first to share a verse or reflection',
            isDark: isDark,
          );
        }
        final docs = snap.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return _PostCard(data: data, docId: docs[i].id, isDark: isDark);
          },
        );
      },
    );
  }
}

// ─── Prayer Wall Tab ──────────────────────────────────────────────────────────
class _PrayerWallTab extends StatelessWidget {
  final bool isDark;
  const _PrayerWallTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('type', isEqualTo: 'prayer_request')
          .orderBy('createdAt', descending: true)
          .limit(40)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return _EmptyState(
            icon: Icons.volunteer_activism_rounded,
            title: 'Nta bisabwa bihari / No prayer requests yet',
            sub: 'Saba dusengerere / Share a prayer request with the community',
            isDark: isDark,
          );
        }
        final docs = snap.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return _PrayerCard(data: data, docId: docs[i].id, isDark: isDark);
          },
        );
      },
    );
  }
}

// ─── Post Card ────────────────────────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isDark;
  const _PostCard({required this.data, required this.docId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final name = data['displayName'] as String? ?? 'User';
    final content = data['content'] as String? ?? '';
    final verseRef = data['verseRef'] as String? ?? '';
    final verseText = data['verseText'] as String? ?? '';
    final likes = data['likesCount'] as int? ?? 0;
    final ts = data['createdAt'] as Timestamp?;
    final timeStr = ts != null ? _timeAgo(ts.toDate()) : '';
    final uid = AuthService.currentUser?.uid;
    final likedBy = List<String>.from(data['likedBy'] ?? []);
    final isLiked = uid != null && likedBy.contains(uid);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1C2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF5C6BC0),
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
                  if (timeStr.isNotEmpty)
                    Text(timeStr, style: GoogleFonts.lato(
                        fontSize: 11, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                ],
              )),
            ]),
            // Verse quote (if any)
            if (verseRef.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B3E).withValues(alpha: isDark ? 0.4 : 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (verseText.isNotEmpty)
                    Text('"$verseText"', style: GoogleFonts.notoSerif(
                        fontSize: 13, height: 1.65, fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF1A1A1A))),
                  if (verseRef.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('— $verseRef', style: GoogleFonts.lato(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: const Color(0xFFD4AF37))),
                  ],
                ]),
              ),
            ],
            // Content / reflection
            if (content.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(content, style: GoogleFonts.lato(
                  fontSize: 13, height: 1.6,
                  color: isDark ? Colors.white70 : const Color(0xFF3A3A3A))),
            ],
            const SizedBox(height: 12),
            // Actions
            Row(children: [
              _ActionBtn(
                icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                label: '$likes',
                color: isLiked ? Colors.red : (isDark ? Colors.white38 : Colors.grey.shade500),
                onTap: () => _toggleLike(docId, uid, likedBy, likes),
              ),
              const SizedBox(width: 16),
              _ActionBtn(
                icon: Icons.share_rounded,
                label: 'Sangiza',
                color: isDark ? Colors.white38 : Colors.grey.shade500,
                onTap: () {
                  final text = verseText.isNotEmpty
                      ? '"$verseText"\n— $verseRef\n\n$content\n\nLCR App'
                      : '$content\n\nLCR App';
                  Share.share(text);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLike(
      String docId, String? uid, List<String> likedBy, int current) async {
    if (uid == null) return;
    final ref = FirebaseFirestore.instance.collection('posts').doc(docId);
    if (likedBy.contains(uid)) {
      await ref.update({
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([uid]),
      });
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ubu / just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// ─── Prayer Card ──────────────────────────────────────────────────────────────
class _PrayerCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isDark;
  const _PrayerCard({required this.data, required this.docId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final name = data['displayName'] as String? ?? 'User';
    final content = data['content'] as String? ?? '';
    final prayingCount = data['prayingCount'] as int? ?? 0;
    final uid = AuthService.currentUser?.uid;
    final prayedBy = List<String>.from(data['prayedBy'] ?? []);
    final hasPrayed = uid != null && prayedBy.contains(uid);
    final ts = data['createdAt'] as Timestamp?;
    final timeStr = ts != null ? _timeAgo(ts.toDate()) : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1C2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE57373).withValues(alpha: isDark ? 0.2 : 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE57373).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.volunteer_activism_rounded,
                    size: 14, color: Color(0xFFE57373)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
                  if (timeStr.isNotEmpty)
                    Text(timeStr, style: GoogleFonts.lato(
                        fontSize: 11, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                ],
              )),
            ]),
            const SizedBox(height: 12),
            Text(content, style: GoogleFonts.lato(
                fontSize: 13, height: 1.65,
                color: isDark ? Colors.white70 : const Color(0xFF3A3A3A))),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => _togglePray(docId, uid, prayedBy),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: hasPrayed
                      ? const Color(0xFFE57373).withValues(alpha: 0.15)
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasPrayed
                        ? const Color(0xFFE57373).withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(hasPrayed ? '🙏' : '🤲', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      hasPrayed
                          ? 'Turasengera ($prayingCount)'
                          : 'Sengera / Pray ($prayingCount)',
                      style: GoogleFonts.lato(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: hasPrayed ? const Color(0xFFE57373)
                            : (isDark ? Colors.white54 : Colors.grey.shade600),
                      ),
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

  Future<void> _togglePray(String docId, String? uid, List<String> prayedBy) async {
    if (uid == null) return;
    final ref = FirebaseFirestore.instance.collection('posts').doc(docId);
    if (prayedBy.contains(uid)) {
      await ref.update({
        'prayingCount': FieldValue.increment(-1),
        'prayedBy': FieldValue.arrayRemove([uid]),
      });
    } else {
      await ref.update({
        'prayingCount': FieldValue.increment(1),
        'prayedBy': FieldValue.arrayUnion([uid]),
      });
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ubu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// ─── New Post Sheet ───────────────────────────────────────────────────────────
class _NewPostSheet extends StatefulWidget {
  final bool isDark;
  const _NewPostSheet({required this.isDark});

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  String _type = 'verse_share'; // verse_share | prayer_request | reflection
  final _contentCtrl = TextEditingController();
  final _verseRefCtrl = TextEditingController();
  final _verseTextCtrl = TextEditingController();
  bool _posting = false;

  @override
  void dispose() {
    _contentCtrl.dispose();
    _verseRefCtrl.dispose();
    _verseTextCtrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final user = AuthService.currentUser;
    if (user == null || _contentCtrl.text.trim().isEmpty) return;
    setState(() => _posting = true);
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'uid': user.uid,
        'displayName': user.displayName ?? 'User',
        'photoUrl': user.photoURL ?? '',
        'type': _type,
        'content': _contentCtrl.text.trim(),
        'verseRef': _verseRefCtrl.text.trim(),
        'verseText': _verseTextCtrl.text.trim(),
        'likesCount': 0,
        'likedBy': [],
        'prayingCount': 0,
        'prayedBy': [],
        'commentsCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'language': 'rw',
      });
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1C2A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(height: 16),
              Text('Sangiza / Share', style: GoogleFonts.lato(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
              const SizedBox(height: 14),
              // Type selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _TypeChip(label: '📖 Ijambo', value: 'verse_share',
                      selected: _type == 'verse_share', isDark: isDark,
                      onTap: () => setState(() => _type = 'verse_share')),
                  const SizedBox(width: 8),
                  _TypeChip(label: '💭 Ibitekerezo', value: 'reflection',
                      selected: _type == 'reflection', isDark: isDark,
                      onTap: () => setState(() => _type = 'reflection')),
                  const SizedBox(width: 8),
                  _TypeChip(label: '🙏 Isengesho', value: 'prayer_request',
                      selected: _type == 'prayer_request', isDark: isDark,
                      onTap: () => setState(() => _type = 'prayer_request')),
                ]),
              ),
              const SizedBox(height: 14),
              if (_type == 'verse_share') ...[
                _SheetField(ctrl: _verseRefCtrl, hint: 'Inomero (e.g. Yoh.3:16)', isDark: isDark),
                const SizedBox(height: 8),
                _SheetField(ctrl: _verseTextCtrl, hint: 'Ijambo ry\'iringiro...', isDark: isDark, maxLines: 2),
                const SizedBox(height: 8),
              ],
              _SheetField(
                ctrl: _contentCtrl,
                hint: _type == 'prayer_request'
                    ? 'Ibyo usaba gusenga...'
                    : 'Ibitekerezo byawe...',
                isDark: isDark, maxLines: 3,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: _posting ? null : _post,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B3E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _posting
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Ohereza / Post',
                          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label, value;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _TypeChip({required this.label, required this.value,
      required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D1B3E)
              : (isDark ? const Color(0xFF2A2840) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: GoogleFonts.lato(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: selected ? Colors.white
              : (isDark ? Colors.white60 : const Color(0xFF1A1A1A)),
        )),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final bool isDark;
  final int maxLines;
  const _SheetField({required this.ctrl, required this.hint,
      required this.isDark, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.lato(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.lato(color: isDark ? Colors.white38 : Colors.grey.shade400),
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2840) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.lato(fontSize: 12, color: color,
              fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final bool isDark;
  const _EmptyState({required this.icon, required this.title,
      required this.sub, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60,
                color: isDark ? Colors.white24 : Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white54 : Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(sub, textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 13,
                    color: isDark ? Colors.white38 : Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}
