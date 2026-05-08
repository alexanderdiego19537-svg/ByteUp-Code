// background_particles.dart
// ═══════════════════════════════════════════════════════════════════════════
// ¡MIRA LAS PARTÍCULAS! — Fondo animado y relajante
// ═══════════════════════════════════════════════════════════════════════════
// Esas lucecitas verdes que flotan suavemente al fondo. Le dan a la app ese
// toque tecnológico y moderno sin distraerte de lo importante: aprender.

import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundParticles extends StatefulWidget {
  final Widget? child;
  const BackgroundParticles({super.key, this.child});

  @override
  State<BackgroundParticles> createState() => _BackgroundParticlesState();
}

class _BackgroundParticlesState extends State<BackgroundParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final int particleCount = 40;
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(particleCount, (i) {
      return _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        speed: rng.nextDouble() * 0.2 + 0.1,
        size: rng.nextDouble() * 3 + 1,
        angle: rng.nextDouble() * 2 * pi,
        opacity: rng.nextDouble() * 0.4 + 0.1,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            for (var p in _particles) {
              p.y -= (p.speed * 0.005);
              p.x += sin(p.angle) * 0.002;
              if (p.y < -0.1) {
                p.y = 1.1;
                p.x = rng.nextDouble();
              }
              p.angle += 0.01;
            }
            return CustomPaint(
              painter: _ParticlePainter(_particles),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) Positioned.fill(child: widget.child!),
      ],
    );
  }
}

class _Particle {
  double x, y, speed, size, angle, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.angle,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (var p in particles) {
      paint.color = const Color(0xFF00FF88).withValues(alpha: p.opacity);
      // Efecto glow en las partículas
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.5);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
