import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const FormFreshFidgetApp());
}

class FormFreshFidgetApp extends StatelessWidget {
  const FormFreshFidgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormFresh Fidgets',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const FidgetHomeScreen(),
    );
  }
}

// Base class for all fidget types
abstract class FidgetType {
  String get name;
  String get description;
  Widget buildFidget(VoidCallback onInteract);
  Future<void> onInteract();
}

class FidgetHomeScreen extends StatefulWidget {
  const FidgetHomeScreen({Key? key}) : super(key: key);

  @override
  State<FidgetHomeScreen> createState() => _FidgetHomeScreenState();
}

class _FidgetHomeScreenState extends State<FidgetHomeScreen> {
  int _spinTime = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer will be updated when actively spinning
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormFresh Fidgets'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fidget display area
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SpinnerFidget(
                  onSpinStart: () {
                    setState(() => _spinTime = 0);
                  },
                  onSpinEnd: (duration) {
                    setState(() => _spinTime = duration);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Last Spin', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        '$_spinTime s',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Total Spins', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const Text(
                        '0',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Placeholder for future fidget types
            Text(
              'More fidgets coming soon',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class SpinnerFidget extends StatefulWidget {
  final VoidCallback onSpinStart;
  final Function(int) onSpinEnd;

  const SpinnerFidget({
    Key? key,
    required this.onSpinStart,
    required this.onSpinEnd,
  }) : super(key: key);

  @override
  State<SpinnerFidget> createState() => _SpinnerFidgetState();
}

class _SpinnerFidgetState extends State<SpinnerFidget> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  double _currentVelocity = 0;
  double _totalRotation = 0;
  int _spinStartTime = 0;
  Timer? _decayTimer;

  static const double _friction = 0.95; // Deceleration factor
  static const double _velocityThreshold = 0.01; // Minimum velocity to continue spinning
  static const Duration _decayInterval = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this);
  }

  void _startSpin(double velocity) {
    widget.onSpinStart();
    _spinStartTime = DateTime.now().millisecondsSinceEpoch;
    _currentVelocity = velocity;
    _decayTimer?.cancel();

    // Initial haptic feedback
    HapticFeedback.heavyImpact();

    _decayTimer = Timer.periodic(_decayInterval, (_) {
      if (_currentVelocity.abs() < _velocityThreshold) {
        _decayTimer?.cancel();
        int spinDuration = (DateTime.now().millisecondsSinceEpoch - _spinStartTime) ~/ 1000;
        widget.onSpinEnd(spinDuration);
        _stopSpin();
        return;
      }

      setState(() {
        // Apply friction/deceleration
        _currentVelocity *= _friction;
        _totalRotation += _currentVelocity * 0.01;

        // Haptic feedback pulses during spin (every 0.2 rotations)
        if ((_totalRotation * 5).toInt() % 1 == 0) {
          HapticFeedback.lightImpact();
        }
      });
    });
  }

  void _stopSpin() {
    _decayTimer?.cancel();
    _currentVelocity = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startSpin(8.0); // Initial spin velocity
      },
      child: Transform.rotate(
        angle: _totalRotation * 2 * 3.14159, // Convert to radians
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }
}
