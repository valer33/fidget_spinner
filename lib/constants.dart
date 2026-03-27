import 'package:flutter/material.dart';

// Colors
const Color kBackground = Color(0xFF0A0A0A);
const Color kSurface = Color(0xFF1A1A1A);
const Color kAccent = Color(0xFF00D4FF);
const Color kAccentMuted = Color(0xFF0099CC);
const Color kTextMuted = Color(0xFF888888);
const Color kDanger = Color(0xFFFF4444);
const Color kBorder = Color(0xFF333333);

// Spinner physics
const double kFriction = 0.95;
const double kVelocityThreshold = 0.01;
const Duration kDecayInterval = Duration(milliseconds: 50);
const double kSwipeMultiplier = 0.01;
const double kHapticTriggerThreshold = 0.05;
const double kMinVelocity = 0.5;
const double kMaxVelocity = 15.0;

// Spinner dimensions
const double kSpinnerSize = 180.0;
const double kBallRadius = 12.0;
const double kCenterBearingRadius = 15.0;
