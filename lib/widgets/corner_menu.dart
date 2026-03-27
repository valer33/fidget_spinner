import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/about_screen.dart';
import '../screens/purchases_screen.dart';
import '../screens/statistics_screen.dart';

/// Slide-out side menu triggered by the corner icon in the top-left.
class CornerMenu extends StatefulWidget {
  final VoidCallback onDismiss;

  const CornerMenu({super.key, required this.onDismiss});

  @override
  State<CornerMenu> createState() => _CornerMenuState();
}

class _CornerMenuState extends State<CornerMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  Future<void> _navigateTo(Widget screen) async {
    await _dismiss();
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
        ),

        // Menu panel
        Align(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: _slideAnimation,
            child: _MenuPanel(
              onNavigate: _navigateTo,
              onDismiss: _dismiss,
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuPanel extends StatelessWidget {
  final Function(Widget) onNavigate;
  final VoidCallback onDismiss;

  const _MenuPanel({required this.onNavigate, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.72,
      height: double.infinity,
      decoration: BoxDecoration(
        color: kSurface,
        border: Border(
          right: BorderSide(color: kAccent.withValues(alpha: 0.15), width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FormFresh',
                    style: TextStyle(
                      color: kAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Fidgets',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: kAccent.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 8),

            // Menu items
            _MenuItem(
              icon: Icons.bar_chart_rounded,
              label: 'Statistics',
              onTap: () => onNavigate(const StatisticsScreen()),
            ),
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'Purchases',
              onTap: () => onNavigate(const PurchasesScreen()),
            ),
            _MenuItem(
              icon: Icons.person_outline,
              label: 'Account',
              onTap: () {}, // placeholder — no screen yet
              muted: true,
            ),
            _MenuItem(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () {}, // placeholder — no screen yet
              muted: true,
            ),
            _MenuItem(
              icon: Icons.info_outline,
              label: 'About',
              onTap: () => onNavigate(const AboutScreen()),
            ),

            const Spacer(),

            // Version tag
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: kTextMuted.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool muted;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = muted ? kTextMuted.withValues(alpha: 0.4) : Colors.white;

    return InkWell(
      onTap: muted ? null : onTap,
      splashColor: kAccent.withValues(alpha: 0.08),
      highlightColor: kAccent.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (muted) ...[
              const Spacer(),
              Text(
                'Soon',
                style: TextStyle(
                  color: kTextMuted.withValues(alpha: 0.35),
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
