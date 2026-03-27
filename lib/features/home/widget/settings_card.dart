import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SettingsCard extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  final String languageText;
  final VoidCallback onLanguageTap;

  final VoidCallback onWalletTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSubscribeTap;
  final VoidCallback onSecurityTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onLogoutTap;

  const SettingsCard({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.languageText,
    required this.onLanguageTap,
    required this.onWalletTap,
    required this.onNotificationTap,
    required this.onSubscribeTap,
    required this.onSecurityTap,
    required this.onPrivacyTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    const card = Colors.transparent;
    const divider = Color(0xFF232A36);
    // const text = Color(0xFFE9EEF7);
    // const sub = Color(0xFFAAB3C2);

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(
            icon: Icons.account_balance_wallet_outlined,
            title: "Wallet",
            onTap: onWalletTap,
          ),

          _item(
            icon: Icons.notifications_none_rounded,
            title: "Notification",
            onTap: onNotificationTap,
          ),

          _item(
            icon: Icons.subscriptions_outlined,
            title: "Subscribe Plan",
            onTap: onSubscribeTap,
          ),

          _languageRow(
            divider: divider,
            icon: Icons.language_outlined,
            title: "Language",
            value: languageText,
            onTap: onLanguageTap,
          ),

          _item(
            icon: Icons.security_outlined,
            title: "Security",
            onTap: onSecurityTap,
          ),

          _switchRow(
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            value: darkMode,
            onChanged: onDarkModeChanged,
          ),

          _item(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: onPrivacyTap,
          ),

          _item(
            icon: Icons.logout_rounded,
            title: "Log Out",
            titleColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            showArrow: false,
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }

  // Widget _div(Color c) => Divider(height: 1, thickness: 1, color: c);

  Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 6.h,
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? const Color(0xFFE9EEF7), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? const Color(0xFFE9EEF7),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFAAB3C2),
                size: 26,
              ),
          ],
        ),
      ),
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 6.h,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE9EEF7), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: const Text(
              "Dark Mode",
              style: TextStyle(
                color: Color(0xFFE9EEF7),
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF59D184),
            inactiveThumbColor: const Color(0xFF7C8799),
            inactiveTrackColor: const Color(0xFF2A3240),
          ),
        ],
      ),
    );
  }

  Widget _languageRow({
    required Color divider,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 6.h,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE9EEF7), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFE9EEF7),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1115),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF232A36)),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFFAAB3C2),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFAAB3C2),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}