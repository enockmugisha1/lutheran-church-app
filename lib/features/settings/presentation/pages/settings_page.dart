import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lutheran/core/services/auth_service.dart';
import 'package:lutheran/features/settings/presentation/providers/settings_provider.dart';
import 'package:lutheran/core/services/notification_service.dart';
import 'package:lutheran/core/services/cloud_messaging_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Get.find<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Igenamiterere'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Imyifatire (General)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsListTile(
                  icon: Icons.language_rounded,
                  title: 'Ururimi (Language)',
                  subtitle: _getLanguageName(settingsProvider.language.value),
                  onTap: () => _showLanguageDialog(context, settingsProvider),
                  isDark: isDark,
                  primary: primary,
                ),
                _SettingsListTile(
                  icon: Icons.format_size_rounded,
                  title: 'Ingano y\'Inyuguti (Text Size)',
                  subtitle:
                      '${(settingsProvider.textSize.value * 100).toInt()}%',
                  onTap: () => _showTextSizeDialog(context, settingsProvider),
                  isDark: isDark,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 24),
            _SectionHeader(title: 'Amatangazo (Notifications)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                Obx(
                  () => _SettingsSwitchTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Amatangazo Yose',
                    subtitle: 'Gufungura / Gufunga amatangazo yose',
                    value: settingsProvider.notificationsEnabled.value,
                    onChanged: (v) => settingsProvider.toggleNotifications(v),
                    isDark: isDark,
                    primary: primary,
                  ),
                ),
                _NotificationSubToggle(
                  icon: Icons.wb_sunny_rounded,
                  title: 'Isengesho ryo mu Gitondo',
                  subtitle: '6:30 AM — Morning prayer reminder',
                  color: const Color(0xFFFF9800),
                  enabled: NotificationService.isMorningEnabled(),
                  onChanged: (v) => NotificationService.setMorningEnabled(v),
                  isDark: isDark,
                ),
                _NotificationSubToggle(
                  icon: Icons.auto_stories_rounded,
                  title: 'Ijambo ry\'Uyu Munsi',
                  subtitle: '7:00 AM — Daily Bible verse',
                  color: const Color(0xFFD4AF37),
                  enabled: NotificationService.isVotdEnabled(),
                  onChanged: (v) => NotificationService.setVotdEnabled(v),
                  isDark: isDark,
                ),
                _NotificationSubToggle(
                  icon: Icons.nightlight_round,
                  title: 'Isengesho ryo mu Mugoroba',
                  subtitle: '8:00 PM — Evening prayer reminder',
                  color: const Color(0xFF5C6BC0),
                  enabled: NotificationService.isEveningEnabled(),
                  onChanged: (v) => NotificationService.setEveningEnabled(v),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 24),
            _SectionHeader(title: 'Push Notifications (Cloud)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _NotificationSubToggle(
                  icon: Icons.campaign_rounded,
                  title: 'Amatangazo y\'Itorero',
                  subtitle: 'Church announcements & news',
                  color: const Color(0xFF5C2E8A),
                  enabled: CloudMessagingService.isTopicEnabled(
                      CloudMessagingService.topicAnnouncements),
                  onChanged: (v) => CloudMessagingService.setTopicEnabled(
                      CloudMessagingService.topicAnnouncements, v),
                  isDark: isDark,
                ),
                _NotificationSubToggle(
                  icon: Icons.menu_book_rounded,
                  title: 'Amasomo ya buri Munsi',
                  subtitle: 'Daily devotions & spiritual readings',
                  color: const Color(0xFFD4AF37),
                  enabled: CloudMessagingService.isTopicEnabled(
                      CloudMessagingService.topicDevotions),
                  onChanged: (v) => CloudMessagingService.setTopicEnabled(
                      CloudMessagingService.topicDevotions, v),
                  isDark: isDark,
                ),
                _NotificationSubToggle(
                  icon: Icons.event_rounded,
                  title: 'Ibikorwa by\'Itorero',
                  subtitle: 'Church events & calendar updates',
                  color: const Color(0xFF26A69A),
                  enabled: CloudMessagingService.isTopicEnabled(
                      CloudMessagingService.topicEvents),
                  onChanged: (v) => CloudMessagingService.setTopicEnabled(
                      CloudMessagingService.topicEvents, v),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 24),
            _SectionHeader(title: 'Ibitekerezo (Feedback)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsListTile(
                  icon: Icons.feedback_rounded,
                  title: 'Tanga Ibitekerezo',
                  subtitle: 'Twandikire ibyo washaka ko twongerera',
                  onTap: () => _showFeedbackDialog(context),
                  isDark: isDark,
                  primary: primary,
                ),
                _SettingsListTile(
                  icon: Icons.bug_report_rounded,
                  title: 'Raporo y\'Ikibazo',
                  subtitle: 'Bivuge ikintu kitakora neza mu app',
                  onTap: () => _showFeedbackDialog(context, category: 'Ikibazo (Bug)'),
                  isDark: isDark,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 24),
            _SectionHeader(title: 'Konti (Account)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                if (FirebaseAuth.instance.currentUser != null)
                  _SettingsListTile(
                    icon: Icons.delete_forever_rounded,
                    title: 'Siba Konti Yanjye',
                    subtitle: 'Siba burundu konti na makuru yose',
                    onTap: () => _showDeleteAccountDialog(context),
                    isDark: isDark,
                    primary: Colors.red.shade600,
                  ),
              ],
            ),

            const SizedBox(height: 24),
            _SectionHeader(title: 'Andi Makuru (About)'),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SettingsListTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Ibyerekeranye n\'App',
                  subtitle: 'Lutheran Church of Rwanda v1.0.0',
                  onTap: () => _showAboutDialog(context),
                  isDark: isDark,
                  primary: primary,
                ),
                _SettingsListTile(
                  icon: Icons.share_rounded,
                  title: 'Sangira iyi App',
                  subtitle: 'Bwira abandi bantu iby\'iyi app',
                  onTap: () => Share.share(
                    'Koresha LCR App - Itorero rya Luteri mu Rwanda!\n\nIyi app irimo Bibiliya, Indirimbo, Amasengesho, Kalendari y\'Itorero, Liturgiya, na Catechism Ntoya ya Luteri. Yifashishe mu gukomeza ukwizera kwawe buri munsi.\n\nYikurire kuri Play Store.',
                  ),
                  isDark: isDark,
                  primary: primary,
                ),
              ],
            ),

            const SizedBox(height: 40),
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  children: [
                    Text(
                      'LCR · Itorero rya Luteri mu Rwanda',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('© 2026', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'rw':
        return 'Kinyarwanda';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return code;
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hitamo Ururimi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RadioTile(
              label: 'Kinyarwanda',
              value: 'rw',
              groupValue: provider.language.value,
              onChanged: (v) {
                provider.setLanguage(v!);
                Navigator.pop(ctx);
              },
            ),
            _RadioTile(
              label: 'English',
              value: 'en',
              groupValue: provider.language.value,
              onChanged: (v) {
                provider.setLanguage(v!);
                Navigator.pop(ctx);
              },
            ),
            _RadioTile(
              label: 'Français',
              value: 'fr',
              groupValue: provider.language.value,
              onChanged: (v) {
                provider.setLanguage(v!);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSizeDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ingano y\'Inyuguti'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: provider.textSize.value,
                onChanged: (v) => provider.setTextSize(v),
                min: 0.8,
                max: 1.5,
                divisions: 7,
              ),
              Text(
                '${(provider.textSize.value * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Funga'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, {String category = 'Ibitekerezo (General)'}) {
    final messageCtrl = TextEditingController();
    String selectedCategory = category;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Tanga Ibitekerezo',
              style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ubwoko bw\'Ibitekerezo',
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: [
                      'Ibitekerezo (General)',
                      'Ikibazo (Bug)',
                      'Icyifuzo (Feature Request)',
                      'Bibiliya',
                      'Indirimbo',
                      'Amasengesho',
                      'Ibindi',
                    ].map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.lato(fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => selectedCategory = v!),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Ubutumwa bwawe',
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                TextField(
                  controller: messageCtrl,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Andika hano ibyo wishakira...',
                    hintStyle: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
              child: const Text('Hagarika'),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final msg = messageCtrl.text.trim();
                      if (msg.isEmpty) return;
                      setState(() => isSubmitting = true);
                      try {
                        await FirebaseFirestore.instance.collection('feedback').add({
                          'category': selectedCategory,
                          'message': msg,
                          'createdAt': FieldValue.serverTimestamp(),
                          'platform': 'android',
                        });
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Murakoze! Ibitekerezo byanyu byakiriwe.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (_) {
                        setState(() => isSubmitting = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Habaye ikibazo. Gerageza nanone.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              child: isSubmitting
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Ohereza'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Siba Konti',
            style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w700, color: Colors.red.shade700)),
        content: Text(
          'Urifuza gusiba konti yawe burundu?\n\nBikurikira bizasibwa:\n• Amakuru yawe (izina, imeyili)\n• Amasengesho wakoze\n• Amashusho y\'umwirondoro\n\nIbi ntibishobora gusubirwaho.',
          style: GoogleFonts.lato(fontSize: 14, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hagarika', style: GoogleFonts.lato(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await AuthService.deleteAccount();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'requires-recent-login' && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Sohoka hanyuma winjire nanone mbere yo gusiba konti.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Habaye ikibazo. Gerageza nanone.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Yego, Siba',
                style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Lutheran Church of Rwanda',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.church_rounded,
        size: 40,
        color: Colors.green,
      ),
      children: [
        const Text(
          'Iyi app yakozwe kugira ngo ifashe abakiristu b\'Itorero rya Luteri mu Rwanda kugera ku bikoresho by\'idini byihuse.',
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252430) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3847) : Colors.grey.shade100,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final Color primary;

  const _SettingsListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Colors.grey,
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  final Color primary;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: primary,
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  const _RadioTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// ─── Notification Sub-Toggle ─────────────────────────────────────────────────
class _NotificationSubToggle extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool enabled;
  final Future<void> Function(bool) onChanged;
  final bool isDark;

  const _NotificationSubToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.enabled,
    required this.onChanged,
    required this.isDark,
  });

  @override
  State<_NotificationSubToggle> createState() => _NotificationSubToggleState();
}

class _NotificationSubToggleState extends State<_NotificationSubToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, size: 16, color: widget.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.lato(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: widget.isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
              widget.onChanged(v);
            },
            activeColor: widget.color,
          ),
        ],
      ),
    );
  }
}

