import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkMode = false;
  String _currency = 'USD';
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildSectionHeader('General Preferences'),
                  _buildSwitchTile(
                    'Email Notifications',
                    'Receive daily reports and alerts via email',
                    _emailNotifications,
                    (val) => setState(() => _emailNotifications = val),
                  ),
                  const Divider(),
                  _buildSwitchTile(
                    'SMS Notifications',
                    'Receive urgent alerts via SMS',
                    _smsNotifications,
                    (val) => setState(() => _smsNotifications = val),
                  ),
                  const Divider(),
                  _buildSwitchTile(
                    'Dark Mode',
                    'Enable dark theme for the admin dashboard',
                    _darkMode,
                    (val) => setState(() => _darkMode = val),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Localization Configuration'),
                  _buildDropdownTile('System Currency', _currency,
                      ['USD', 'EUR', 'GBP', 'LKR'], (val) {
                    if (val != null) setState(() => _currency = val);
                  }),
                  const Divider(),
                  _buildDropdownTile('System Language', _language,
                      ['English', 'Spanish', 'French'], (val) {
                    if (val != null) setState(() => _language = val);
                  }),
                  const SizedBox(height: 48),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Settings saved successfully')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Save Changes',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: GoogleFonts.montserrat(
              color: Colors.grey.shade600, fontSize: 13)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1565C0),
    );
  }

  Widget _buildDropdownTile(String title, String currentValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
      trailing: DropdownButton<String>(
        value: currentValue,
        underline: const SizedBox(),
        items: options
            .map((e) => DropdownMenuItem(
                value: e, child: Text(e, style: GoogleFonts.montserrat())))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
