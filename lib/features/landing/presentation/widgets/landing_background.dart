import 'dart:ui';

import 'package:flutter/material.dart';

class LandingBackground extends StatelessWidget {
  const LandingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    if (darkMode) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF101114),
              Color(0xFF171A23),
              Color(0xFF0E1721),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final shortSide = width < height ? width : height;
        final isCompact = width < 700;

        final topBubbleWidth = isCompact ? width * 1.08 : shortSide * 0.9;
        final topBubbleHeight = isCompact ? topBubbleWidth * 0.88 : shortSide * 0.7;
        final mintBubbleSize = isCompact ? width * 1.05 : shortSide * 1.02;
        final yellowBubbleWidth = isCompact ? width * 0.78 : shortSide * 0.7;
        final yellowBubbleHeight = isCompact ? yellowBubbleWidth * 0.82 : shortSide * 0.54;

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8FCFF), Color(0xFFFDFDF8)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: isCompact ? -height * 0.02 : -120,
                left: isCompact ? -width * 0.34 : -140,
                child: _BlurBubble(
                  width: topBubbleWidth,
                  height: topBubbleHeight,
                  color: const Color(0xFFA8DFFF),
                  radius: topBubbleHeight / 2,
                  blur: isCompact ? 16 : 18,
                  opacity: 0.72,
                ),
              ),
              Positioned(
                top: isCompact ? height * 0.17 : 180,
                right: isCompact ? -width * 0.34 : -180,
                child: _BlurBubble(
                  width: mintBubbleSize,
                  height: mintBubbleSize,
                  color: const Color(0xFFBDF4EA),
                  radius: mintBubbleSize / 2,
                  blur: isCompact ? 18 : 22,
                  opacity: 0.7,
                ),
              ),
              Positioned(
                bottom: isCompact ? -height * 0.08 : -120,
                left: isCompact ? width * 0.17 : 140,
                child: _BlurBubble(
                  width: yellowBubbleWidth,
                  height: yellowBubbleHeight,
                  color: const Color(0xFFFFE7A8),
                  radius: yellowBubbleHeight / 2,
                  blur: isCompact ? 16 : 18,
                  opacity: 0.62,
                ),
              ),
              Positioned(
                top: isCompact ? height * 0.07 : 80,
                left: isCompact ? width * 0.08 : 80,
                child: _FadedGlow(
                  size: isCompact ? width * 0.2 : 140,
                  color: const Color(0xFF5DB3E6),
                  opacity: 0.18,
                ),
              ),
              Positioned(
                top: isCompact ? height * 0.12 : 120,
                right: isCompact ? width * 0.18 : 240,
                child: _FadedGlow(
                  size: isCompact ? width * 0.16 : 120,
                  color: const Color(0xFFDBF7F0),
                  opacity: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BlurBubble extends StatelessWidget {
  const _BlurBubble({
    required this.width,
    required this.height,
    required this.color,
    required this.radius,
    required this.blur,
    required this.opacity,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ),
    );
  }
}

class _FadedGlow extends StatelessWidget {
  const _FadedGlow({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
