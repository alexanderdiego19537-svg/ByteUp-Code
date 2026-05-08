// lesson_card.dart
// ═══════════════════════════════════════════════════════════════════════════
// TU SIGUIENTE PASO — Tarjeta de lección en el mapa
// ═══════════════════════════════════════════════════════════════════════════
// El mapa del tesoro: aquí ves qué lecciones ya ganaste, cuáles están
// listas para jugar y cuáles todavía están bajo llave esperando por ti.

import 'package:flutter/material.dart';
import '../models/lesson_model.dart';

// ─── Estados de una lección ───────────────────────────────────────────────────
enum EstadoLeccion { completada, disponible, bloqueada }

// ─── Paleta ──────────────────────────────────────────────────────────────────
const _verde = Color(0xFF00FF88);
const _cian  = Color(0xFF22D3EE);

class LessonCard extends StatelessWidget {
  final LessonModel leccion;
  final EstadoLeccion estado;
  final Color colorPrimario;
  final Color colorSecundario;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.leccion,
    required this.estado,
    this.colorPrimario = _verde,
    this.colorSecundario = _cian,
    this.onTap,
  });

  bool get _completada => estado == EstadoLeccion.completada;
  bool get _disponible => estado == EstadoLeccion.disponible;
  bool get _bloqueada  => estado == EstadoLeccion.bloqueada;

  @override
  Widget build(BuildContext context) {
    final colorNodo = _completada
        ? _verde
        : _disponible
            ? colorPrimario
            : Colors.white.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: _bloqueada ? 0.45 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: _bloqueada
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _completada
                        ? [
                            _verde.withValues(alpha: 0.15),
                            _cian.withValues(alpha: 0.07),
                          ]
                        : [
                            colorPrimario.withValues(alpha: 0.15),
                            colorSecundario.withValues(alpha: 0.07),
                          ],
                  ),
            color: _bloqueada ? Colors.white.withValues(alpha: 0.04) : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorNodo.withValues(alpha: _bloqueada ? 0.12 : 0.3),
              width: 1.5,
            ),
            boxShadow: !_bloqueada
                ? [
                    BoxShadow(
                      color: colorNodo.withValues(alpha: 0.15),
                      blurRadius: 12,
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Ícono del estado
              _buildIcono(colorNodo),
              const SizedBox(width: 12),

              // Información de la lección
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lección ${leccion.orden}',
                      style: TextStyle(
                        color: colorNodo.withValues(alpha: 0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      leccion.titulo,
                      style: TextStyle(
                        color: _bloqueada
                            ? Colors.white.withValues(alpha: 0.25)
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildEstrellas(),
                  ],
                ),
              ),

              // Badge de XP (solo en disponibles)
              if (_disponible)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+${leccion.xpRecompensa}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ),

              // Ícono de candado en bloqueadas
              if (_bloqueada)
                Icon(
                  Icons.lock_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcono(Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: !_bloqueada
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _completada
                    ? [_verde, _cian]
                    : [colorPrimario, colorSecundario],
              )
            : null,
        color: _bloqueada ? Colors.white.withValues(alpha: 0.05) : null,
        border: Border.all(
          color: color.withValues(alpha: _bloqueada ? 0.12 : 0.4),
          width: 1.5,
        ),
      ),
      child: Center(
        child: _completada
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
            : _bloqueada
                ? Icon(Icons.lock_rounded,
                    color: Colors.white.withValues(alpha: 0.2), size: 18)
                : Icon(
                    _iconPorDificultad(leccion.dificultad),
                    color: Colors.white,
                    size: 20,
                  ),
      ),
    );
  }

  Widget _buildEstrellas() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < leccion.dificultad
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          size: 10,
          color: _bloqueada
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFFFD700).withValues(alpha: 0.8),
        );
      }),
    );
  }

  IconData _iconPorDificultad(int dificultad) {
    switch (dificultad) {
      case 1: return Icons.star_border_rounded;
      case 2: return Icons.star_half_rounded;
      case 3: return Icons.star_rounded;
      case 4: return Icons.flash_on_rounded;
      case 5: return Icons.whatshot_rounded;
      default: return Icons.book_rounded;
    }
  }
}
