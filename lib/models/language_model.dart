// language_model.dart
// ═══════════════════════════════════════════════════════════════════════════
// ¡CONOCE TUS LENGUAJES! — Estructura de cada lenguaje de programación
// ═══════════════════════════════════════════════════════════════════════════
// Aquí definimos qué hace a un lenguaje en nuestra app: su nombre, su emoji,
// su color y, lo más importante, ¡cuánto has avanzado en él!

import 'package:flutter/material.dart';

// ─── Lo que define a un Lenguaje ─────────────────────────────────────────────
class LanguageModel {
  final String id; // "python", "javascript", "java", "cpp"
  final String nombre;
  final String emoji;
  final Color color;
  final Color colorSecundario;
  double progreso; // 0.0 a 1.0
  int leccionesCompletadas;
  final int leccionesTotales;
  int nivelActual;
  bool desbloqueado;

  LanguageModel({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.color,
    required this.colorSecundario,
    this.progreso = 0.0,
    this.leccionesCompletadas = 0,
    required this.leccionesTotales,
    this.nivelActual = 1,
    this.desbloqueado = true,
  });

  // Hace las cuentas para ver qué porcentaje del lenguaje has dominado
  void actualizarProgreso() {
    if (leccionesTotales > 0) {
      progreso = leccionesCompletadas / leccionesTotales;
    }
  }

  // ¿Ya te volviste un experto y terminaste todo?
  bool get completado => leccionesCompletadas >= leccionesTotales;

  // El mensajito que verás en pantalla sobre tu avance
  String get textoProgreso =>
      '$leccionesCompletadas/$leccionesTotales lecciones';

  // Para guardar tus datos y que no se pierdan
  Map<String, dynamic> toJson() => {
        'id': id,
        'progreso': progreso,
        'leccionesCompletadas': leccionesCompletadas,
        'nivelActual': nivelActual,
        'desbloqueado': desbloqueado,
      };

  // Los lenguajes que vienen de fábrica en ByteUP
  static List<LanguageModel> lenguajesPredeterminados() {
    return [
      LanguageModel(
        id: 'python',
        nombre: 'Python',
        emoji: '🐍',
        color: const Color(0xFF3776AB),
        colorSecundario: const Color(0xFF4A9FD9),
        leccionesTotales: 10,
        desbloqueado: true,
      ),
      LanguageModel(
        id: 'javascript',
        nombre: 'JavaScript',
        emoji: '⚡',
        color: const Color(0xFFF7DF1E),
        colorSecundario: const Color(0xFFFFE75E),
        leccionesTotales: 10,
        desbloqueado: true,
      ),
      LanguageModel(
        id: 'java',
        nombre: 'Java',
        emoji: '☕',
        color: const Color(0xFFED8B00),
        colorSecundario: const Color(0xFFFFAD33),
        leccionesTotales: 8,
        desbloqueado: false, // Se desbloquea después de Python nivel 3
      ),
      LanguageModel(
        id: 'cpp',
        nombre: 'C++',
        emoji: '⚙️',
        color: const Color(0xFF00599C),
        colorSecundario: const Color(0xFF2980B9),
        leccionesTotales: 8,
        desbloqueado: false, // Se desbloquea después de Java nivel 2
      ),
    ];
  }
}
