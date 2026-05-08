// game_service.dart
// ═══════════════════════════════════════════════════════════════════════════
// EL MOTOR DEL JUEGO — Lógica de XP, Estrellas y Rachas
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde calculamos tus puntos de experiencia, cuántas estrellas
// te mereces por tu esfuerzo y cuidamos que tu racha de días no se pierda.

import '../models/user_model.dart';
import '../models/lesson_model.dart';
import 'storage_service.dart';

class GameService {
  // ─── La tabla de recompensas ──────────────────────────────────────────────
  static const int xpRespuestaCorrecta  = 10;
  static const int xpNivel1Estrella     = 30;
  static const int xpNivel2Estrellas    = 50;
  static const int xpNivel3Estrellas    = 75;
  static const int xpProyectoFinal      = 200;
  static const int xpExamenFinal        = 500;
  static const int xpRacha7Dias         = 100;
  static const int xpRacha30Dias        = 500;

  static const int maxCorazones         = 5;
  static const int horasParaRegenerarUno = 4;

  // ─── ¿Cuántas estrellas te has ganado? ──────────────────────────────────
  /// errores: total de respuestas incorrectas en el nivel
  /// usoPistas: si el usuario necesitó pistas en el ejercicio guiado
  static int calcularEstrellas({
    required int errores,
    required bool usoPistas,
  }) {
    if (errores == 0 && !usoPistas) return 3; // ⭐⭐⭐ Perfecto
    if (errores <= 2 && !usoPistas) return 2; // ⭐⭐ Bien
    return 1;                                  // ⭐ ¡Sigue intentándolo!
  }

  /// XP que se gana según las estrellas obtenidas
  static int xpPorEstrellas(int estrellas, {
    bool esProyecto = false,
    bool esExamen = false,
  }) {
    if (esExamen)  return xpExamenFinal;
    if (esProyecto) return xpProyectoFinal;
    switch (estrellas) {
      case 3: return xpNivel3Estrellas;
      case 2: return xpNivel2Estrellas;
      default: return xpNivel1Estrella;
    }
  }

  // ─── ¡Nivel Superado! (Procesar el éxito) ───────────────────────────────
  /// Llama esto al finalizar el paso 6 (ResumenXP) de un nivel.
  /// Retorna mapa con resultado completo para mostrar en la pantalla.
  static Future<Map<String, dynamic>> completarNivel({
    required UserModel usuario,
    required NivelContenido nivel,
    required int estrellas,        // 1, 2 o 3
    required int erroresCometidos,
  }) async {
    final xpGanado = xpPorEstrellas(
      estrellas,
      esProyecto: nivel.esProyectoFinal,
      esExamen: nivel.esExamenFinal,
    );

    // Guardar solo si mejora las estrellas del nivel
    final estrellasAnteriores = usuario.estrellasNivel[nivel.id] ?? 0;
    final mejoroEstrellas = estrellas > estrellasAnteriores;
    if (mejoroEstrellas) {
      usuario.estrellasNivel[nivel.id] = estrellas;
    }

    // XP siempre se gana (aunque repitas el nivel)
    usuario.xpTotal += xpGanado;

    // Registrar como completado si es la primera vez
    if (!usuario.leccionesCompletadas.contains(nivel.id)) {
      usuario.leccionesCompletadas.add(nivel.id);
    }

    // Actualizar progreso del lenguaje
    _actualizarProgresoLenguaje(usuario, _lenguajeDelId(nivel.id));

    // Verificar insignias
    final nuevasInsignias = _verificarInsignias(usuario);

    // Actualizar rango
    _actualizarRango(usuario);

    // Persistir todo
    await StorageService.guardarUsuario(usuario);

    String mensajeFon;
    if (estrellas == 3) {
      mensajeFon = '¡PERFECTO! ¡Eres increíble! 🌟 +$xpGanado XP';
    } else if (estrellas == 2) {
      mensajeFon = '¡Muy bien! Casi perfecto 💪 +$xpGanado XP';
    } else {
      mensajeFon = '¡Lo lograste! Sigue practicando 🎯 +$xpGanado XP';
    }

    return {
      'xpGanado': xpGanado,
      'estrellas': estrellas,
      'mejoroEstrellas': mejoroEstrellas,
      'nuevasInsignias': nuevasInsignias,
      'nuevoRango': usuario.rango,
      'mensajeFon': mensajeFon,
    };
  }

  // ─── Revisar si tu respuesta fue buena ──────────────────────────────────
  static Map<String, dynamic> procesarRespuesta({
    required UserModel usuario,
    required Pregunta pregunta,
    required int respuestaUsuario,
  }) {
    final esCorrecta = pregunta.esCorrecta(respuestaUsuario);
    int xpGanado = 0;
    bool perdioCorazon = false;

    if (esCorrecta) {
      xpGanado = xpRespuestaCorrecta;
      usuario.xpTotal += xpGanado;
    } else {
      if (usuario.corazones > 0) {
        usuario.corazones--;
        perdioCorazon = true;
      }
    }

    _actualizarRango(usuario);

    return {
      'esCorrecta': esCorrecta,
      'xpGanado': xpGanado,
      'perdioCorazon': perdioCorazon,
      'corazonesRestantes': usuario.corazones,
      'mensajeFonMaster': esCorrecta
          ? '¡Exelente! 🎉 +$xpGanado XP'
          : (pregunta.explicacion ?? '¡Tú puedes! 💪'),
      'nuevoRango': usuario.rango,
    };
  }

  // ─── Terminar la lección con estilo ─────────────────────────────────────
  static Map<String, dynamic> completarLeccion({
    required UserModel usuario,
    required LessonModel leccion,
    required int respuestasCorrectas,
  }) {
    final precision = leccion.totalPreguntas > 0
        ? (respuestasCorrectas / leccion.totalPreguntas * 100).round()
        : 0;

    // Calcular estrellas basadas en precisión
    int estrellas;
    if (precision == 100) {
      estrellas = 3;
    } else if (precision >= 70) {
      estrellas = 2;
    } else {
      estrellas = 1;
    }

    final xpGanado = xpPorEstrellas(estrellas);
    usuario.xpTotal += xpGanado;

    if (!usuario.leccionesCompletadas.contains(leccion.id)) {
      usuario.leccionesCompletadas.add(leccion.id);
    }

    _actualizarProgresoLenguaje(usuario, leccion.lenguaje);
    final nuevasInsignias = _verificarInsignias(usuario);
    _actualizarRango(usuario);

    String mensajeFonMaster;
    if (estrellas == 3)      mensajeFonMaster = '¡PERFECTO! 🌟 +$xpGanado XP';
    else if (precision >= 80) mensajeFonMaster = '¡Exelente! 💪 +$xpGanado XP';
    else if (precision >= 50) mensajeFonMaster = '¡Bien hecho! 👍 +$xpGanado XP';
    else                      mensajeFonMaster = '¡Sigue así! 🧠 +$xpGanado XP';

    return {
      'xpGanado': xpGanado,
      'estrellas': estrellas,
      'precision': precision,
      'nuevasInsignias': nuevasInsignias,
      'nuevoRango': usuario.rango,
      'mensajeFonMaster': mensajeFonMaster,
    };
  }

  // ─── La Racha: ¡Que no se apague el fuego! ───────────────────────────────
  static Map<String, dynamic> verificarStreak(UserModel usuario) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final ultimo = DateTime(usuario.ultimoAcceso.year, usuario.ultimoAcceso.month, usuario.ultimoAcceso.day);
    final diferenciaDias = hoy.difference(ultimo).inDays;
    
    bool rachaActualizada = false;
    bool rachaPerdida = false;
    int xpBonus = 0;

    if (diferenciaDias == 1) {
      // Día siguiente exacto — incrementar racha
      usuario.streakActual++;
      rachaActualizada = true;

      if (usuario.streakActual == 7) {
        xpBonus = xpRacha7Dias;
        usuario.xpTotal += xpBonus;
      } else if (usuario.streakActual == 30) {
        xpBonus = xpRacha30Dias;
        usuario.xpTotal += xpBonus;
      }

      if (usuario.streakActual > usuario.mejorStreak) {
        usuario.mejorStreak = usuario.streakActual;
      }
    } else if (diferenciaDias > 2) {
      // Pasaron más de 2 días — resetear a 1 (no a 0, sigue vivo)
      usuario.streakActual = 1;
      rachaPerdida = true;
    }
    // diferenciaDias == 0: mismo día, no cambiar nada
    // diferenciaDias == 2: faltó un día, mantener racha (gracia de 1 día)

    // Actualizar ultimoAcceso siempre que cambie el día
    if (diferenciaDias > 0) {
      usuario.ultimoAcceso = ahora;
    }
    
    _verificarInsignias(usuario);
    _actualizarRango(usuario);

    return {
      'streakActual': usuario.streakActual,
      'mejorStreak': usuario.mejorStreak,
      'rachaActualizada': rachaActualizada,
      'rachaPerdida': rachaPerdida,
      'xpBonus': xpBonus,
    };
  }

  // ─── Los Corazones: Tu energía vital ─────────────────────────────────────
  static int regenerarCorazones(UserModel usuario) {
    if (usuario.corazones >= maxCorazones) return 0;
    final ahora = DateTime.now();
    final diferencia = ahora.difference(usuario.ultimaRegeneracionCorazones);
    final aRegenerar = diferencia.inHours ~/ horasParaRegenerarUno;
    if (aRegenerar > 0) {
      final antes = usuario.corazones;
      usuario.corazones = (usuario.corazones + aRegenerar).clamp(0, maxCorazones);
      usuario.ultimaRegeneracionCorazones = ahora;
      return usuario.corazones - antes;
    }
    return 0;
  }

  static Duration tiempoParaSiguienteCorazon(UserModel usuario) {
    if (usuario.corazones >= maxCorazones) return Duration.zero;
    final ahora = DateTime.now();
    final diferencia = ahora.difference(usuario.ultimaRegeneracionCorazones);
    final minutosDesdeUltima = diferencia.inMinutes;
    final minutosParaSiguiente =
        (horasParaRegenerarUno * 60) - (minutosDesdeUltima % (horasParaRegenerarUno * 60));
    return Duration(minutes: minutosParaSiguiente);
  }

  static bool puedeJugar(UserModel usuario) => usuario.corazones > 0;

  // ─── Privados ─────────────────────────────────────────────────────────────

  static void _actualizarRango(UserModel usuario) {
    usuario.rango = Rango.desdeXP(usuario.xpTotal);
  }

  static String _lenguajeDelId(String nivelId) {
    if (nivelId.startsWith('logica_'))     return 'logica';
    if (nivelId.startsWith('python_'))     return 'python';
    if (nivelId.startsWith('js_'))         return 'javascript';
    if (nivelId.startsWith('java_'))       return 'java';
    if (nivelId.startsWith('cpp_'))        return 'cpp';
    if (nivelId.startsWith('html_'))       return 'html';
    return '';
  }

  static void _actualizarProgresoLenguaje(UserModel usuario, String lenguaje) {
    if (lenguaje.isEmpty) return;
    final totalPorLenguaje = {
      'logica': 42,      // 6 módulos × 6 niveles + 6 proyectos
      'python': 42,
      'javascript': 42,
      'java': 42,
      'cpp': 42,
      'html': 42,
    };
    final total = totalPorLenguaje[lenguaje] ?? 0;
    if (total == 0) return;
    final completadas = usuario.leccionesCompletadas
        .where((id) => id.startsWith('${lenguaje}_') || id.startsWith('${_prefijoCorto(lenguaje)}_'))
        .length;
    usuario.progresoLenguajes[lenguaje] = (completadas / total).clamp(0.0, 1.0);
  }

  static String _prefijoCorto(String lenguaje) {
    switch (lenguaje) {
      case 'javascript': return 'js';
      default: return lenguaje;
    }
  }

  static List<Insignia> _verificarInsignias(UserModel usuario) {
    final nuevas = <Insignia>[];
    final condiciones = <Insignia, bool>{
      Insignia.primeraLeccion:      usuario.leccionesCompletadas.isNotEmpty,
      Insignia.racha7dias:          usuario.streakActual >= 7,
      Insignia.racha30dias:         usuario.streakActual >= 30,
      Insignia.completarPython:     (usuario.progresoLenguajes['python'] ?? 0) >= 1.0,
      Insignia.completarJavaScript: (usuario.progresoLenguajes['javascript'] ?? 0) >= 1.0,
      Insignia.completarJava:       (usuario.progresoLenguajes['java'] ?? 0) >= 1.0,
      Insignia.completarCpp:        (usuario.progresoLenguajes['cpp'] ?? 0) >= 1.0,
      Insignia.completarHtml:       (usuario.progresoLenguajes['html'] ?? 0) >= 1.0,
      Insignia.completarLogica:     (usuario.progresoLenguajes['logica'] ?? 0) >= 1.0,
      Insignia.llegarAPlata:        usuario.rango.index >= Rango.plata.index,
      Insignia.llegarAOro:          usuario.rango.index >= Rango.oro.index,
      Insignia.legend:              usuario.rango == Rango.legend,
    };
    condiciones.forEach((insignia, cumple) {
      if (cumple && !usuario.insigniasGanadas.contains(insignia)) {
        usuario.insigniasGanadas.add(insignia);
        nuevas.add(insignia);
      }
    });
    return nuevas;
  }
}

// Extensión para guardar estrellas desde GameService
extension StorageEstrellas on StorageService {
  static void guardarEstrellas(Map<String, int> estrellas) {
    // Delegamos a StorageService estático
    for (final entry in estrellas.entries) {
      StorageService.guardarEstrellasNivel(entry.key, entry.value);
    }
  }
}
