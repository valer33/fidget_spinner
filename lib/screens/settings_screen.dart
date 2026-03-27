import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _hapticIntensity;
  late double _sensitivity;

  @override
  void initState() {
    super.initState();
    _hapticIntensity = StorageService.getHapticIntensity();
    _sensitivity = StorageService.getSensitivity();
  }

  Future<void> _saveSettings() async {
    await StorageService.setHapticIntensity(_hapticIntensity);
    await StorageService.setSensitivity(_sensitivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        foregroundColor: Colors.white,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Haptic Intensity
            _SettingCard(
              title: 'Haptic Intensity',
              subtitle: 'Strength of vibration feedback',
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Off')),
                  ButtonSegment(value: 1, label: Text('Light')),
                  ButtonSegment(value: 2, label: Text('Medium')),
                  ButtonSegment(value: 3, label: Text('Heavy')),
                ],
                selected: {_hapticIntensity},
                onSelectionChanged: (Set<int> selection) {
                  setState(() => _hapticIntensity = selection.first);
                  _saveSettings();
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return kAccent;
                    return Colors.white;
                  }),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return kSurface;
                    return Colors.transparent;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sensitivity
            _SettingCard(
              title: 'Spin Sensitivity',
              subtitle: 'How fast the spinner responds to swipe',
              child: Column(
                children: [
                  Slider(
                    value: _sensitivity,
                    min: 0.5,
                    max: 2.0,
                    activeColor: kAccent,
                    inactiveColor: kBorder,
                    onChanged: (value) {
                      setState(() => _sensitivity = value);
                    },
                    onChangeEnd: (value) => _saveSettings(),
                  ),
                  Text(
                    _sensitivity < 1.0 ? 'Light' : (_sensitivity > 1.0 ? 'Strong' : 'Normal'),
                    style: const TextStyle(color: kAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reset Stats button
            Center(
              child: TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await StorageService.setTotalSpins(0);
                  await StorageService.setTotalHapticPulses(0);
                  await StorageService.setLongestSpin(0);
                  if (mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Statistics reset'),
                        backgroundColor: Color(0xFF1A1A1A),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Reset Statistics',
                  style: TextStyle(color: kDanger),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kAccent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: kTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
