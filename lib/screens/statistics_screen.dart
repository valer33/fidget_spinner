import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/storage_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSpins = StorageService.getTotalSpins();
    final hapticPulses = StorageService.getTotalHapticPulses();
    final longestSpin = StorageService.getLongestSpin();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        foregroundColor: Colors.white,
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _StatRow(
              icon: Icons.rotate_right,
              label: 'Total Spins',
              value: '$totalSpins',
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.vibration,
              label: 'Haptic Pulses',
              value: '$hapticPulses',
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.emoji_events,
              label: 'Longest Spin',
              value: '${longestSpin}s',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccent.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: kAccent, size: 22),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: kAccent,
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
