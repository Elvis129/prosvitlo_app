import 'package:flutter/material.dart';

/// Splash screen with animated pulsating logo
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(body: Center(child: _PulsatingLogo())),
    );
  }
}

class _PulsatingLogo extends StatefulWidget {
  @override
  State<_PulsatingLogo> createState() => _PulsatingLogoState();
}

class _PulsatingLogoState extends State<_PulsatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.2,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adaptive logo size based on screen width (20% of screen width)
    final logoSize = MediaQuery.of(context).size.width * 0.2;

    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/image/logo.png',
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
