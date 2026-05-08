// rank_card.dart
// ═══════════════════════════════════════════════════════════════════════════
// TU ESTATUS DE LEYENDA — Tu rango actual
// ═══════════════════════════════════════════════════════════════════════════
// ¿Eres Bronce o ya llegaste a Diamante? Esta tarjeta te muestra tu nivel de
// gloria y cuántos puntos te faltan para subir al siguiente escalón.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

// ─── Paleta ──────────────────────────────────────────────────────────────────
const _verde = Color(0xFF00FF88);
const _cian  = Color(0xFF22D3EE);
const _fondo = Color(0xFF0A0E1A);

class RankCard extends StatelessWidget {
  final UserModel usuario;
  /// Si es `true` muestra la versión compacta (solo barra + texto)
  final bool compacto;

  const RankCard({
    super.key,
    required this.usuario,
    this.compacto = false,
  });

  @override
  Widget build(BuildContext context) {
    final progreso    = usuario.progresoRango;
    final siguiente   = usuario.siguienteRango;
    final xpEnRango   = usuario.xpTotal - usuario.rango.xpMinimo;
    final xpNecesario = usuario.rango.xpMaximo - usuario.rango.xpMinimo;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _verde.withValues(alpha: 0.12),
                _cian.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _verde.withValues(alpha: 0.2)),
          ),
          child: compacto ? _buildCompacto(progreso, siguiente) :
              _buildCompleto(progreso, siguiente, xpEnRango, xpNecesario),
        ),
      ),
    );
  }

  // ─── Versión completa ─────────────────────────────────────────────────────
  Widget _buildCompleto(
    double progreso,
    Rango? siguiente,
    int xpEnRango,
    int xpNecesario,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Emoji del rango
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _verde.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: _verde.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(
                  usuario.rango.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Nombre del rango
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [_verde, _cian],
                    ).createShader(bounds),
                    child: Text(
                      'Rango ${usuario.rango.nombre}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    siguiente != null
                        ? 'Siguiente: ${siguiente.emoji} ${siguiente.nombre}'
                        : '¡Eres una leyenda! 👑',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // XP total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [_verde, _cian],
                  ).createShader(bounds),
                  child: Text(
                    '${usuario.xpTotal}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'XP total',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),
        _buildBarra(progreso, siguiente, xpEnRango, xpNecesario),
      ],
    );
  }

  // ─── Versión compacta (solo barra) ───────────────────────────────────────
  Widget _buildCompacto(double progreso, Rango? siguiente) {
    return Row(
      children: [
        Text(usuario.rango.emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario.rango.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progreso.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_verde, _cian]),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        if (siguiente != null)
          Text(
            siguiente.emoji,
            style: const TextStyle(fontSize: 22),
          ),
      ],
    );
  }

  // ─── Barra de progreso del rango ──────────────────────────────────────────
  Widget _buildBarra(
    double progreso,
    Rango? siguiente,
    int xpEnRango,
    int xpNecesario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '+$xpEnRango XP en este rango',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 12,
              ),
            ),
            Text(
              siguiente != null
                  ? '${(progreso * 100).round()}% → ${siguiente.nombre}'
                  : '¡Nivel máximo!',
              style: const TextStyle(
                color: _verde,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progreso.clamp(0.0, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_verde, _cian]),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: _verde.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (siguiente != null) ...[
          const SizedBox(height: 4),
          Text(
            '${xpNecesario - xpEnRango} XP para ${siguiente.nombre}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
