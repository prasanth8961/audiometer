import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audiometer/constant/color.dart';
import 'package:audiometer/provider/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isTestInstructionsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkModeEnabled = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
        ),
        backgroundColor: kSecondaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Volume Control
            ListTile(
              leading: const Icon(Icons.volume_up, color: Color(0xFF89A8B2)),
              title: const Text('Volume Control',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Adjust the app’s volume'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showVolumeControlDialog();
              },
            ),
            const Divider(),

            // Frequency Range
            ListTile(
              leading: const Icon(Icons.tune, color: Color(0xFF89A8B2)),
              title: const Text('Frequency Range',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Set custom frequency range'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showFrequencyRangeDialog();
              },
            ),
            const Divider(),

            // Tone Duration
            ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF89A8B2)),
              title: const Text('Tone Duration',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Set the tone duration for each frequency'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showToneDurationDialog();
              },
            ),
            const Divider(),

            // Audio Output
            ListTile(
              leading: const Icon(Icons.headset, color: Color(0xFF89A8B2)),
              title: const Text('Audio Output',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Select audio output device'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showAudioOutputDialog();
              },
            ),
            const Divider(),

            // Calibration
            ListTile(
              leading: const Icon(Icons.adjust, color: Color(0xFF89A8B2)),
              title: const Text('Calibration',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Calibrate your audio meter'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showCalibrationDialog();
              },
            ),
            const Divider(),

            // Test Instructions
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF89A8B2)),
              title: const Text('Test Instructions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Toggle instructions during tests'),
              trailing: Switch(
                value: isTestInstructionsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    isTestInstructionsEnabled = value;
                  });
                },
              ),
              onTap: () {
                // Test Instructions logic handled by Switch
              },
            ),
            const Divider(),

            // Theme
            ListTile(
                leading:
                    const Icon(Icons.brightness_6, color: Color(0xFF89A8B2)),
                title: const Text('Theme',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Choose between light and dark mode'),
                trailing: Switch(
                  value: isDarkModeEnabled,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(); // Toggle the theme
                  },
                )),
            const Divider(),

            // Language
            ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF89A8B2)),
              title: const Text('Language',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Select language preferences'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showLanguageSelectionDialog();
              },
            ),
            const Divider(),

            // Reset Settings
            ListTile(
              leading: const Icon(Icons.restore, color: Color(0xFF89A8B2)),
              title: const Text('Reset Settings',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Reset to default settings'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showResetSettingsDialog();
              },
            ),
            const Divider(),

            // Help & Tutorials
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF89A8B2)),
              title: const Text('Help & Tutorials',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Learn how to use the app'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            const Divider(),

            // About App
            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF89A8B2)),
              title: const Text('About App',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('App version and developer info'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF89A8B2)),
              onTap: () {
                _showAboutAppDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Functions for dialog or page navigation
  void _showVolumeControlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Volume Control'),
          content: const Text('Adjust the app’s volume here'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFrequencyRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Frequency Range'),
          content: const Text('Set your desired frequency range here'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showToneDurationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tone Duration'),
          content: const Text('Set the duration of the tone here'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAudioOutputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Audio Output'),
          content: const Text('Choose your preferred audio output device'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCalibrationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Calibration'),
          content: const Text('Calibrate your audio meter here'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: const Text('Choose your preferred language for the app'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
              'Are you sure you want to reset all settings to default?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                // Add reset logic here
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutAppDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About the App'),
          content: const Text('Version: 1.0.0\nDeveloped by: Prasanth'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
