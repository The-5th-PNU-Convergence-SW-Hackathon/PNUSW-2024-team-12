import 'package:flutter/material.dart';

class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key});

  @override
  _BouncingDotsState createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );

    _animation2 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.7, curve: Curves.easeInOut)),
    );

    _animation3 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedDot(_animation1),
        const SizedBox(width: 8),
        _buildAnimatedDot(_animation2),
        const SizedBox(width: 8),
        _buildAnimatedDot(_animation3),
      ],
    );
  }

  Widget _buildAnimatedDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
