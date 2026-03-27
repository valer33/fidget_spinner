import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/fidget_registry.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premiumFidgets = FidgetRegistry.premium;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        foregroundColor: Colors.white,
        title: const Text('Purchases'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: premiumFidgets.isEmpty
            ? _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: premiumFidgets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final fidget = premiumFidgets[index];
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
                    child: Row(
                      children: [
                        Icon(fidget.icon, color: fidget.accentColor, size: 28),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fidget.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${fidget.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: kTextMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        _PurchaseButton(fidget: fidget),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final dynamic fidget;

  const _PurchaseButton({required this.fidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('In-app purchases coming soon'),
            backgroundColor: kSurface,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kAccent.withValues(alpha: 0.4), width: 1),
        ),
        child: const Text(
          'Get',
          style: TextStyle(
            color: kAccent,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: kTextMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'More fidgets coming soon',
            style: TextStyle(
              color: kTextMuted.withValues(alpha: 0.6),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
