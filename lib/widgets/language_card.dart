// language_card.dart
// ═══════════════════════════════════════════════════════════════════════════
// TU TARJETA DE LENGUAJE — El resumen de tu progreso
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde ves lo bien que vas en Python, JavaScript o Java. Cada tarjeta
// tiene su propio color, su emoji y una barrita que muestra cuánto te falta.

import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String id;
  final String nombre;
  final String emoji;
  final Color colorPrimario;
  final Color colorSecundario;
  final double progreso; // 0.0 – 1.0
  final VoidCallback? onTap;

  const LanguageCard({
    super.key,
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.progreso,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorPrimario.withValues(alpha: 0.18),
              colorSecundario.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorPrimario.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorPrimario.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fila superior: emoji + badge de progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                _buildBadgePorcentaje(),
              ],
            ),

            // Nombre + barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                _buildBarraProgreso(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgePorcentaje() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorPrimario.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${(progreso * 100).round()}%',
        style: TextStyle(
          color: colorPrimario,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildBarraProgreso() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progreso.clamp(0.0, 1.0),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [colorPrimario, colorSecundario]),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: colorPrimario.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
