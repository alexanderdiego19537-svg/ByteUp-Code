// lesson_model.dart
// ═══════════════════════════════════════════════════════════════════════════
// EL MAPA DEL APRENDIZAJE — Modelo de lecciones y retos
// ═══════════════════════════════════════════════════════════════════════════
// Este archivo es el corazón pedagógico de la app. Aquí organizamos desde simples
// preguntas de opción múltiple hasta retos de lógica pura que pondrán a
// prueba tu mente de programador.

import 'dart:convert';

// ─── Las diferentes formas de aprender ──────────────────────────────────────
enum TipoEjercicio {
  opcionMultiple,
  completarCodigo,
  ordenarCodigo,
  escribirCodigo;

  String get nombre {
    switch (this) {
      case TipoEjercicio.opcionMultiple:   return 'Opción múltiple';
      case TipoEjercicio.completarCodigo:  return 'Completar código';
      case TipoEjercicio.ordenarCodigo:    return 'Ordenar código';
      case TipoEjercicio.escribirCodigo:   return 'Escribir código';
    }
  }

  String get emoji {
    switch (this) {
      case TipoEjercicio.opcionMultiple:   return '🔘';
      case TipoEjercicio.completarCodigo:  return '✏️';
      case TipoEjercicio.ordenarCodigo:    return '🧩';
      case TipoEjercicio.escribirCodigo:   return '⌨️';
    }
  }
}

// ─── Una pregunta clásica ───────────────────────────────────────────────────
class Pregunta {
  final String texto;
  final List<String> opciones;
  final int respuestaCorrecta;
  final String? explicacion;

  const Pregunta({
    required this.texto,
    required this.opciones,
    required this.respuestaCorrecta,
    this.explicacion,
  });

  bool esCorrecta(int respuestaUsuario) => respuestaUsuario == respuestaCorrecta;

  Map<String, dynamic> toJson() => {
    'texto': texto,
    'opciones': opciones,
    'respuestaCorrecta': respuestaCorrecta,
    'explicacion': explicacion,
  };

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
    texto: json['texto'],
    opciones: List<String>.from(json['opciones']),
    respuestaCorrecta: json['respuestaCorrecta'],
    explicacion: json['explicacion'],
  );
}

// ─── El contenedor de toda una lección ───────────────────────────────────────
class LessonModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String lenguaje;
  final TipoEjercicio tipo;
  final int dificultad;
  final int xpRecompensa;
  final List<Pregunta> preguntas;
  final int orden;

  const LessonModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.lenguaje,
    this.tipo = TipoEjercicio.opcionMultiple,
    this.dificultad = 1,
    this.xpRecompensa = 50,
    required this.preguntas,
    this.orden = 0,
  });

  int get totalPreguntas => preguntas.length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'lenguaje': lenguaje,
    'tipo': tipo.index,
    'dificultad': dificultad,
    'xpRecompensa': xpRecompensa,
    'preguntas': preguntas.map((p) => p.toJson()).toList(),
    'orden': orden,
  };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'],
    lenguaje: json['lenguaje'],
    tipo: TipoEjercicio.values[json['tipo'] ?? 0],
    dificultad: json['dificultad'] ?? 1,
    xpRecompensa: json['xpRecompensa'] ?? 50,
    preguntas: (json['preguntas'] as List).map((p) => Pregunta.fromJson(p)).toList(),
    orden: json['orden'] ?? 0,
  );

  String toJsonString() => jsonEncode(toJson());
}

// ════════════════════════════════════════════════════════════════════════════
// ¡BIENVENIDO AL NIVEL ELITE! — Nuevas formas de aprender
// ════════════════════════════════════════════════════════════════════════════

// ─── El camino del estudiante ───────────────────────────────────────────────
enum EtapaAprendizaje {
  logicaPura,
  lenguajes;

  String get nombre {
    switch (this) {
      case EtapaAprendizaje.logicaPura: return 'Lógica Pura';
      case EtapaAprendizaje.lenguajes:  return 'Lenguajes';
    }
  }

  String get emoji {
    switch (this) {
      case EtapaAprendizaje.logicaPura: return '🧠';
      case EtapaAprendizaje.lenguajes:  return '💻';
    }
  }

  String get descripcion {
    switch (this) {
      case EtapaAprendizaje.logicaPura:
        return 'Aprende a pensar como programador antes de escribir código';
      case EtapaAprendizaje.lenguajes:
        return 'Aprende lenguajes reales: Python, JS, Java, C++ y más';
    }
  }
}

// ─── Preguntas con las que puedes interactuar ───────────────────────────────
class PreguntaInteractiva {
  final String texto;
  final List<String> opciones;
  final int respuestaCorrecta; // índice 0-3
  final String? pista;          // Una ayudita si te equivocas un par de veces
  final String? explicacion;    // Para que entiendas el "por qué" de la respuesta

  const PreguntaInteractiva({
    required this.texto,
    required this.opciones,
    required this.respuestaCorrecta,
    this.pista,
    this.explicacion,
  });

  bool esCorrecta(int idx) => idx == respuestaCorrecta;
}

// ─── Todo lo que incluye un nivel (sus 6 pasos mágicos) ─────────────────────
class NivelContenido {
  final String id;          // e.g. "logica_m1_n1", "python_m1_n1"
  final int numero;         // 1-6
  final String titulo;
  final String subtitulo;

  // Paso 1: Fon Master explica (no se puede saltar)
  final String explicacionFon;

  // Paso 2: Teoría interactiva (párrafo por párrafo)
  final List<String> teoriaParrafos;

  // Paso 3: Ejemplo resuelto con explicación línea a línea
  final String ejemploContenido;        // código o texto del ejemplo
  final List<String> ejemploLineas;     // explicaciones por línea
  final bool esEjemploCodigo;           // ¿Queremos que se vea como un editor de código?

  // Paso 4: Ejercicio guiado (con pistas automáticas)
  final PreguntaInteractiva ejercicioGuiado;

  // Paso 5: El Reto Solitario (aquí demuestras lo que sabes, ¡sin ayudas!)
  final PreguntaInteractiva retoSolo;

  // Paso 6: Resumen + XP
  final String resumenTexto;
  final List<String> aprendiste;

  final int xpBase;            // Los puntos que ganas por completar este nivel
  final bool esProyectoFinal;  // 🏆 Proyecto especial → +200 XP
  final bool esExamenFinal;    // 🎓 Examen → +500 XP

  const NivelContenido({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.subtitulo,
    required this.explicacionFon,
    required this.teoriaParrafos,
    required this.ejemploContenido,
    required this.ejemploLineas,
    this.esEjemploCodigo = false,
    required this.ejercicioGuiado,
    required this.retoSolo,
    required this.resumenTexto,
    required this.aprendiste,
    this.xpBase = 50,
    this.esProyectoFinal = false,
    this.esExamenFinal = false,
  });
}

// ─── Módulo: Un paquete de niveles sobre un mismo tema ──────────────────────
class ModuloModel {
  final String id;         // e.g. "logica_m1", "python_m2"
  final int numero;        // 1-6
  final String titulo;
  final String emoji;
  final String descripcion;
  final String lenguaje;   // "logica", "python", "javascript", "java", "cpp", "html"
  final EtapaAprendizaje etapa;
  final List<NivelContenido> niveles;
  final NivelContenido? proyectoFinal; // 🏆

  const ModuloModel({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.emoji,
    required this.descripcion,
    required this.lenguaje,
    required this.etapa,
    required this.niveles,
    this.proyectoFinal,
  });

  int get totalUnidades => niveles.length + (proyectoFinal != null ? 1 : 0);

  // ¿Cuánto has avanzado en este módulo en total?
  double progresoDesde(List<String> leccionesCompletadas) {
    int completados = 0;
    for (final n in niveles) {
      if (leccionesCompletadas.contains(n.id)) completados++;
    }
    if (proyectoFinal != null &&
        leccionesCompletadas.contains(proyectoFinal!.id)) {
      completados++;
    }
    return completados / totalUnidades;
  }

  // ¿Ya puedes entrar a este nivel o te falta completar el anterior?
  bool nivelDesbloqueado(int indiceNivel, List<String> leccionesCompletadas) {
    if (indiceNivel == 0) return true; // el primero siempre abierto
    // El nivel N se desbloquea si el nivel N-1 está completado
    return leccionesCompletadas.contains(niveles[indiceNivel - 1].id);
  }

  // El Gran Final: solo para los que completaron todo el módulo
  bool proyectoDesbloqueado(List<String> leccionesCompletadas) {
    return niveles.every((n) => leccionesCompletadas.contains(n.id));
  }
}
