import 'package:flutter/material.dart';

class LandingBackground extends StatelessWidget {
  const LandingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: darkMode
              ? const [Color(0xFF07131A), Color(0xFF0F1D26), Color(0xFF12364B)]
              : const [Color(0xFFE6F6FF), Color(0xFFF2FBF8), Color(0xFFF8F2FF)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: _GlowOrb(
              size: 220,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.26),
            ),
          ),
          Positioned(
            right: -70,
            top: 80,
            child: _GlowOrb(
              size: 280,
              color: const Color(0xFF2DD4BF).withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            bottom: -100,
            right: 40,
            child: _GlowOrb(
              size: 240,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 20)],
      ),
    );
  }
}
