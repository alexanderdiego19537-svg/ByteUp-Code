// racha_animacion.dart
// ═══════════════════════════════════════════════════════════════════════════
// ¡ESTÁS EN LLAMAS! — Animación de racha de días
// ═══════════════════════════════════════════════════════════════════════════
// ¡BOOM! Esta es la fiesta visual que aparece cuando logras un día más de estudio.
// ¡Que el fuego de la programación nunca se apague!

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RachaAnimacion extends StatefulWidget {
  final int rachaInfo;
  const RachaAnimacion({super.key, required this.rachaInfo});

  @override
  State<RachaAnimacion> createState() => _RachaAnimacionState();
}

class _RachaAnimacionState extends State<RachaAnimacion>
    with TickerProviderStateMixin {
  // Escala del número central (elástica, entra con rebote)
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  // Llamas 🔥 — pulsan repitiendo
  late AnimationController _fireController;
  late Animation<double> _fireAnim;

  // Shake del texto
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  // Fade del fondo
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // 1. Vibración al aparecer
    HapticFeedback.heavyImpact();

    // 2. Fade de fondo — aparece rápido
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    // 3. Escala del número — entra con elasticOut
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _scaleController.forward();
    });

    // 4. Llamas — pulsan repitiendo (escala pequeña)
    _fireController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _fireAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _fireController, curve: Curves.easeInOut),
    );

    // 5. Shake del texto — trembling rápido
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _shakeAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
    // Shake por 1.2 segundos total (rebota 7 veces)
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      for (int i = 0; i < 7; i++) {
        if (!mounted) break;
        await _shakeController.forward();
        if (!mounted) break;
        await _shakeController.reverse();
      }
    });

    // 6. Segunda vibración a los 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) HapticFeedback.heavyImpact();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fireController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              const Color(0xFFFF4500).withOpacity(0.15),
              Colors.black.withOpacity(0.88),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Llamas superiores pulsantes
              AnimatedBuilder(
                animation: _fireAnim,
                builder: (_, __) => Transform.scale(
                  scale: _fireAnim.value,
                  child: const Text('🔥', style: TextStyle(fontSize: 72)),
                ),
              ),

              const SizedBox(height: 12),

              // Número grande animado
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFB347), Color(0xFFFF4500)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF4500).withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${widget.rachaInfo}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Texto con shake animation
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(_shakeAnim.value, 0),
                  child: child,
                ),
                child: Text(
                  '¡RACHA DE ${widget.rachaInfo} DÍAS!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Color(0xFFFF6B35),
                        blurRadius: 20,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Color(0xFFFF4500),
                        blurRadius: 40,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              // Subtítulo motivacional
              const Text(
                '¡Sigue programando sin parar! 🚀',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Llamas inferiores con desfase de fase
              AnimatedBuilder(
                animation: _fireAnim,
                builder: (_, __) => Transform.scale(
                  scale: 1.15 - (_fireAnim.value - 0.85), // fase opuesta
                  child: const Text('🔥🔥🔥', style: TextStyle(fontSize: 40)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
