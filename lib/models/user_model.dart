// user_model.dart
// ═══════════════════════════════════════════════════════════════════════════
// TU PERFIL DE LEYENDA — Modelo del usuario y sus logros
// ═══════════════════════════════════════════════════════════════════════════
// Aquí guardamos todo lo que te hace único en ByteUP: tu XP, tus rachas,
// tus corazones y esas medallas que tanto te ha costado ganar.

import 'dart:convert';

// ─── Tus Rangos de Gloria ───────────────────────────────────────────────────
enum Rango {
  bronce, plata, oro, diamante, legend;

  String get nombre {
    switch (this) {
      case Rango.bronce:   return 'Bronce';
      case Rango.plata:    return 'Plata';
      case Rango.oro:      return 'Oro';
      case Rango.diamante: return 'Diamante';
      case Rango.legend:   return 'Legend';
    }
  }

  String get emoji {
    switch (this) {
      case Rango.bronce:   return '🥉';
      case Rango.plata:    return '🥈';
      case Rango.oro:      return '🥇';
      case Rango.diamante: return '💎';
      case Rango.legend:   return '👑';
    }
  }

  int get xpMinimo {
    switch (this) {
      case Rango.bronce:   return 0;
      case Rango.plata:    return 501;
      case Rango.oro:      return 1501;
      case Rango.diamante: return 3001;
      case Rango.legend:   return 6001;
    }
  }

  int get xpMaximo {
    switch (this) {
      case Rango.bronce:   return 500;
      case Rango.plata:    return 1500;
      case Rango.oro:      return 3000;
      case Rango.diamante: return 6000;
      case Rango.legend:   return 99999;
    }
  }

  static Rango desdeXP(int xp) {
    if (xp >= 6001) return Rango.legend;
    if (xp >= 3001) return Rango.diamante;
    if (xp >= 1501) return Rango.oro;
    if (xp >= 501)  return Rango.plata;
    return Rango.bronce;
  }
}

// ─── Tus Medallas de Honor (Insignias) ──────────────────────────────────────
enum Insignia {
  primeraLeccion, racha7dias, racha30dias,
  completarPython, completarJavaScript, completarJava, completarCpp, completarHtml,
  llegarAPlata, llegarAOro, completarLogica, legend;

  String get nombre {
    switch (this) {
      case Insignia.primeraLeccion:      return 'Primera Lección';
      case Insignia.racha7dias:          return 'Racha 7 días';
      case Insignia.racha30dias:         return 'Racha 30 días';
      case Insignia.completarPython:     return 'Python Master';
      case Insignia.completarJavaScript: return 'JS Ninja';
      case Insignia.completarJava:       return 'Java Dev';
      case Insignia.completarCpp:        return 'C++ Wizard';
      case Insignia.completarHtml:       return 'Web Designer';
      case Insignia.llegarAPlata:        return 'Rango Plata';
      case Insignia.llegarAOro:          return 'Rango Oro';
      case Insignia.completarLogica:     return 'Maestro Lógico';
      case Insignia.legend:              return 'Legend';
    }
  }

  String get emoji {
    switch (this) {
      case Insignia.primeraLeccion:      return '🎓';
      case Insignia.racha7dias:          return '🔥';
      case Insignia.racha30dias:         return '🌟';
      case Insignia.completarPython:     return '🐍';
      case Insignia.completarJavaScript: return '⚡';
      case Insignia.completarJava:       return '☕';
      case Insignia.completarCpp:        return '⚙️';
      case Insignia.completarHtml:       return '🌐';
      case Insignia.llegarAPlata:        return '🥈';
      case Insignia.llegarAOro:          return '🥇';
      case Insignia.completarLogica:     return '🧠';
      case Insignia.legend:              return '👑';
    }
  }

  String get descripcion {
    switch (this) {
      case Insignia.primeraLeccion:      return 'Completaste tu primera lección';
      case Insignia.racha7dias:          return 'Mantuviste 7 días seguidos';
      case Insignia.racha30dias:         return '¡30 días sin parar!';
      case Insignia.completarPython:     return 'Completaste todo Python';
      case Insignia.completarJavaScript: return 'Completaste todo JavaScript';
      case Insignia.completarJava:       return 'Completaste todo Java';
      case Insignia.completarCpp:        return 'Completaste todo C++';
      case Insignia.completarHtml:       return 'Completaste HTML + CSS';
      case Insignia.llegarAPlata:        return 'Alcanzaste el rango Plata';
      case Insignia.llegarAOro:          return 'Alcanzaste el rango Oro';
      case Insignia.completarLogica:     return 'Dominaste la Lógica Pura';
      case Insignia.legend:              return '¡Eres una leyenda!';
    }
  }

  String get id {
    switch (this) {
      case Insignia.primeraLeccion:      return 'primeros_pasos';
      case Insignia.racha7dias:          return 'racha_7';
      case Insignia.racha30dias:         return 'racha_30';
      case Insignia.completarPython:     return 'python_master';
      case Insignia.completarJavaScript: return 'js_master';
      case Insignia.completarJava:       return 'java_master';
      case Insignia.completarCpp:        return 'cpp_master';
      case Insignia.completarHtml:       return 'html_master';
      case Insignia.llegarAPlata:        return 'velocista';
      case Insignia.llegarAOro:          return 'perfeccionista';
      case Insignia.completarLogica:     return 'logica_master';
      case Insignia.legend:              return 'leyenda';
    }
  }
}

// ─── Tu Identidad en ByteUP ──────────────────────────────────────────────────
class UserModel {
  final String nombre;
  final String email;
  final String? fotoUrl;
  String? passwordHash; // Tu contraseña protegida (¡nunca la guardamos tal cual!)

  bool get isInvitado => email.isEmpty;

  int xpTotal;
  Rango rango;
  int streakActual;
  int mejorStreak;
  int corazones;
  DateTime ultimaRegeneracionCorazones;
  Map<String, double> progresoLenguajes;
  List<String> leccionesCompletadas;
  List<Insignia> insigniasGanadas;
  DateTime ultimoAcceso;

  // ── NUEVOS CAMPOS (Nivel Master Elite) ──────────────────────────────────
  int etapaActual;          // 1 = Lógica Pura, 2 = Lenguajes
  String moduloActualId;    // id del módulo en progreso
  Map<String, int> estrellasNivel;  // {"logica_m1_n1": 3, "python_m1_n1": 2}
  bool onboardingCompleto;  // pasó el quiz inicial de detección de nivel
  bool musicaActiva;        // Para que decidas si quieres música de fondo
  int nivelDetectado;       // 0=principiante, 1=intermedio, 2=avanzado (del quiz)

  static const int maxCorazones = 5;
  static const int horasRegeneracion = 4;

  UserModel({
    required this.nombre,
    this.email = '',
    this.fotoUrl,
    this.passwordHash,
    this.xpTotal = 0,
    this.rango = Rango.bronce,
    this.streakActual = 0,
    this.mejorStreak = 0,
    this.corazones = 5,
    DateTime? ultimaRegeneracionCorazones,
    Map<String, double>? progresoLenguajes,
    List<String>? leccionesCompletadas,
    List<Insignia>? insigniasGanadas,
    DateTime? ultimoAcceso,
    // Nuevos:
    this.etapaActual = 1,
    this.moduloActualId = 'logica_m1',
    Map<String, int>? estrellasNivel,
    this.onboardingCompleto = false,
    this.musicaActiva = true,
    this.nivelDetectado = 0,
  })  : ultimaRegeneracionCorazones =
            ultimaRegeneracionCorazones ?? DateTime.now(),
        progresoLenguajes = progresoLenguajes ??
            {
              'logica': 0.0,
              'python': 0.0,
              'javascript': 0.0,
              'java': 0.0,
              'cpp': 0.0,
              'html': 0.0,
            },
        leccionesCompletadas = leccionesCompletadas ?? [],
        insigniasGanadas = insigniasGanadas ?? [],
        ultimoAcceso = ultimoAcceso ?? DateTime.now(),
        estrellasNivel = estrellasNivel ?? {};

  // ── Atajos útiles ───────────────────────────────────────────────────────

  double get progresoRango {
    if (rango == Rango.legend) return 1.0;
    final xpEnRango = xpTotal - rango.xpMinimo;
    final xpParaSiguiente = rango.xpMaximo - rango.xpMinimo;
    return (xpEnRango / xpParaSiguiente).clamp(0.0, 1.0);
  }

  Rango? get siguienteRango {
    switch (rango) {
      case Rango.bronce:   return Rango.plata;
      case Rango.plata:    return Rango.oro;
      case Rango.oro:      return Rango.diamante;
      case Rango.diamante: return Rango.legend;
      case Rango.legend:   return null;
    }
  }

  String get iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';
  }

  // Estrellas de un nivel específico (0 si no completado)
  int estrellasDeNivel(String nivelId) => estrellasNivel[nivelId] ?? 0;

  // IDs de insignias para compatibilidad con ProfileScreen
  List<String> get insignias => insigniasGanadas.map((i) => i.id).toList();

  // ── Guardado de datos ───────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'email': email,
    'fotoUrl': fotoUrl,
    'passwordHash': passwordHash,
    'xpTotal': xpTotal,
    'rango': rango.index,
    'streakActual': streakActual,
    'mejorStreak': mejorStreak,
    'corazones': corazones,
    'ultimaRegeneracionCorazones': ultimaRegeneracionCorazones.toIso8601String(),
    'progresoLenguajes': progresoLenguajes,
    'leccionesCompletadas': leccionesCompletadas,
    'insigniasGanadas': insigniasGanadas.map((i) => i.index).toList(),
    'ultimoAcceso': ultimoAcceso.toIso8601String(),
    // Nuevos:
    'etapaActual': etapaActual,
    'moduloActualId': moduloActualId,
    'estrellasNivel': estrellasNivel,
    'onboardingCompleto': onboardingCompleto,
    'musicaActiva': musicaActiva,
    'nivelDetectado': nivelDetectado,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    nombre: json['nombre'] ?? 'Dev',
    email: json['email'] ?? '',
    fotoUrl: json['fotoUrl'],
    passwordHash: json['passwordHash'],
    xpTotal: json['xpTotal'] ?? 0,
    rango: Rango.values[json['rango'] ?? 0],
    streakActual: json['streakActual'] ?? 0,
    mejorStreak: json['mejorStreak'] ?? 0,
    corazones: json['corazones'] ?? 5,
    ultimaRegeneracionCorazones: json['ultimaRegeneracionCorazones'] != null
        ? DateTime.parse(json['ultimaRegeneracionCorazones'])
        : null,
    progresoLenguajes: json['progresoLenguajes'] != null
        ? Map<String, double>.from(json['progresoLenguajes'])
        : null,
    leccionesCompletadas: json['leccionesCompletadas'] != null
        ? List<String>.from(json['leccionesCompletadas'])
        : null,
    insigniasGanadas: json['insigniasGanadas'] != null
        ? (json['insigniasGanadas'] as List)
            .where((i) => i is int && i < Insignia.values.length)
            .map((i) => Insignia.values[i as int])
            .toList()
        : null,
    ultimoAcceso: json['ultimoAcceso'] != null
        ? DateTime.parse(json['ultimoAcceso'])
        : null,
    // Nuevos:
    etapaActual: json['etapaActual'] ?? 1,
    moduloActualId: json['moduloActualId'] ?? 'logica_m1',
    estrellasNivel: json['estrellasNivel'] != null
        ? Map<String, int>.from(json['estrellasNivel'])
        : null,
    onboardingCompleto: json['onboardingCompleto'] ?? false,
    musicaActiva: json['musicaActiva'] ?? true,
    nivelDetectado: json['nivelDetectado'] ?? 0,
  );

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String jsonString) =>
      UserModel.fromJson(jsonDecode(jsonString));
}
