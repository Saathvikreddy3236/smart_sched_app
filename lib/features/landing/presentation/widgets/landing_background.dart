import 'package:flutter/material.dart';

class LandingBackground extends StatefulWidget {
  const LandingBackground({super.key});

  @override
  State<LandingBackground> createState() => _LandingBackgroundState();
}

class _LandingBackgroundState extends State<LandingBackground> {
  Offset _pointer = const Offset(0.5, 0.35);

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    void updatePointer(Offset localPosition) {
      if (size.width == 0 || size.height == 0) return;
      setState(() {
        _pointer = Offset(
          (localPosition.dx / size.width).clamp(0, 1),
          (localPosition.dy / size.height).clamp(0, 1),
        );
      });
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      color: darkMode ? const Color(0xFF101114) : const Color(0xFFFFFBF4),
      child: MouseRegion(
        onHover: (event) => updatePointer(event.localPosition),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanDown: (details) => updatePointer(details.localPosition),
          onPanUpdate: (details) => updatePointer(details.localPosition),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: darkMode
                    ? const [
                        Color(0xFF101114),
                        Color(0xFF171820),
                        Color(0xFF241C24),
                      ]
                    : const [
                        Color(0xFFFFFBF4),
                        Color(0xFFF5F7FF),
                        Color(0xFFFFF1E8),
                      ],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _BackgroundTexturePainter(darkMode: darkMode),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 520),
                  curve: Curves.easeOutCubic,
                  right: -160 + ((1 - _pointer.dx) * 84),
                  top: 42 + (_pointer.dy * 70),
                  child: _SoftShape(
                    size: 420,
                    color: const Color(0xFF3657FF).withValues(alpha: 0.14),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  bottom: -170 + ((1 - _pointer.dy) * 82),
                  left: -110 + (_pointer.dx * 92),
                  child: _SoftShape(
                    size: 360,
                    color: const Color(0xFFFF6B4A).withValues(alpha: 0.13),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                  left: (_pointer.dx * size.width) - 120,
                  top: (_pointer.dy * size.height) - 120,
                  child: IgnorePointer(
                    child: _SoftShape(
                      size: 240,
                      color: const Color(0xFF00A88F).withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftShape extends StatelessWidget {
  const _SoftShape({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.34),
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 20)],
      ),
    );
  }
}

class _BackgroundTexturePainter extends CustomPainter {
  const _BackgroundTexturePainter({required this.darkMode});

  final bool darkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = (darkMode ? Colors.white : const Color(0xFF111827)).withValues(
        alpha: darkMode ? 0.035 : 0.045,
      )
      ..strokeWidth = 1;
    const step = 42.0;
    for (var x = -size.height; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundTexturePainter oldDelegate) {
    return oldDelegate.darkMode != darkMode;
  }
}
