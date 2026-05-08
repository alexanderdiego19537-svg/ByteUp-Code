// storage_service.dart
// ═══════════════════════════════════════════════════════════════════════════
// EL COFRE DE LOS RECUERDOS — Servicio de Guardado Local
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde guardamos todo tu progreso para que, cuando vuelvas a abrir
// la app, todo esté exactamente donde lo dejaste. ¡Tu esfuerzo está seguro aquí!

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  // ─── Las llaves del cofre ───────────────────────────────────────────────
  static const String _claveUsuario         = 'byteup_usuario';
  static const String _claveHistorialChat   = 'byteup_historial_chat';
  static const String _claveConfiguracion   = 'byteup_config';
  static const String _clavePrimeraVez      = 'byteup_primera_vez';
  static const String _claveApiKey          = 'byteup_api_key';
  // Nuevas:
  static const String _claveEstrellas       = 'byteup_estrellas';
  static const String _claveEtapa           = 'byteup_etapa';
  static const String _claveModulo          = 'byteup_modulo';
  static const String _claveOnboarding      = 'byteup_onboarding';
  static const String _claveCuentas         = 'byteup_cuentas'; // lista de cuentas

  static SharedPreferences? _prefs;

  // ─── Abrir el cofre (Inicializar) ───────────────────────────────────────
  static Future<void> inicializar() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── TUS DATOS PERSONALES ───────────────────────────────────────────────

  static Future<bool> guardarUsuario(UserModel usuario) async =>
      await _prefs?.setString(_claveUsuario, usuario.toJsonString()) ?? false;

  static UserModel? cargarUsuario() {
    final jsonString = _prefs?.getString(_claveUsuario);
    if (jsonString == null) return null;
    try {
      return UserModel.fromJsonString(jsonString);
    } catch (e) {
      return null;
    }
  }

  static bool existeUsuario() => _prefs?.containsKey(_claveUsuario) ?? false;

  // ─── TU COLECCIÓN DE ESTRELLAS ──────────────────────────────────────────

  /// Guarda las estrellas (1-3) que obtuvo el usuario en un nivel
  static Future<void> guardarEstrellasNivel(
      String nivelId, int estrellas) async {
    final mapa = _cargarMapaEstrellas();
    mapa[nivelId] = estrellas;
    await _prefs?.setString(_claveEstrellas, jsonEncode(mapa));
  }

  /// Carga el mapa completo de {nivelId: estrellas}
  static Map<String, int> cargarTodasLasEstrellas() => _cargarMapaEstrellas();

  /// Estrellas de un nivel específico (0 si no completado)
  static int estrellasDeNivel(String nivelId) =>
      _cargarMapaEstrellas()[nivelId] ?? 0;

  static Map<String, int> _cargarMapaEstrellas() {
    final jsonStr = _prefs?.getString(_claveEstrellas);
    if (jsonStr == null) return {};
    try {
      return Map<String, int>.from(jsonDecode(jsonStr));
    } catch (_) {
      return {};
    }
  }

  // ─── ¿DÓNDE TE QUEDASTE? (ETAPA Y MÓDULO) ───────────────────────────────

  static Future<void> guardarEtapa(int etapa) async =>
      await _prefs?.setInt(_claveEtapa, etapa);

  static int cargarEtapa() => _prefs?.getInt(_claveEtapa) ?? 1;

  static Future<void> guardarModulo(String moduloId) async =>
      await _prefs?.setString(_claveModulo, moduloId);

  static String cargarModulo() =>
      _prefs?.getString(_claveModulo) ?? 'logica_m1';

  // ─── TU BIENVENIDA (ONBOARDING) ──────────────────────────────────────────

  static Future<void> marcarOnboardingCompleto() async =>
      await _prefs?.setBool(_claveOnboarding, true);

  static bool onboardingCompleto() =>
      _prefs?.getBool(_claveOnboarding) ?? false;

  // ─── TUS LLAVES DE ENTRADA (AUTENTICACIÓN) ──────────────────────────────
  // Lista de cuentas: [{email, passwordHash, nombre}]

  static Future<void> registrarCuenta({
    required String email,
    required String passwordHash,
    required String nombre,
  }) async {
    final cuentas = _cargarCuentas();
    // Actualiza si ya existe, inserta si no
    cuentas.removeWhere((c) => c['email'] == email);
    cuentas.add({
      'email': email.toLowerCase().trim(),
      'passwordHash': passwordHash,
      'nombre': nombre,
    });
    await _prefs?.setString(_claveCuentas, jsonEncode(cuentas));
  }

  /// ¿Quién eres? Comprobamos que tu contraseña coincida
  static String? verificarLogin(String email, String passwordHash) {
    final cuentas = _cargarCuentas();
    final cuenta = cuentas.firstWhere(
      (c) =>
          c['email'] == email.toLowerCase().trim() &&
          c['passwordHash'] == passwordHash,
      orElse: () => {},
    );
    return cuenta.isNotEmpty ? cuenta['nombre'] as String : null;
  }

  static bool emailRegistrado(String email) {
    final cuentas = _cargarCuentas();
    return cuentas.any((c) => c['email'] == email.toLowerCase().trim());
  }

  static List<Map<String, dynamic>> _cargarCuentas() {
    final jsonStr = _prefs?.getString(_claveCuentas);
    if (jsonStr == null) return [];
    try {
      return (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ─── TUS CHARLAS CON FON MASTER ──────────────────────────────────────────

  static Future<bool> guardarHistorialChat(
      List<Map<String, String>> historial) async {
    return await _prefs?.setString(_claveHistorialChat, jsonEncode(historial)) ??
        false;
  }

  static List<Map<String, String>> cargarHistorialChat() {
    final jsonString = _prefs?.getString(_claveHistorialChat);
    if (jsonString == null) return [];
    try {
      final lista = jsonDecode(jsonString) as List;
      return lista.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // ─── TUS PREFERENCIAS ────────────────────────────────────────────────────

  static Future<bool> guardarConfiguracion(
      Map<String, dynamic> config) async =>
      await _prefs?.setString(_claveConfiguracion, jsonEncode(config)) ?? false;

  static Map<String, dynamic> cargarConfiguracion() {
    final jsonString = _prefs?.getString(_claveConfiguracion);
    if (jsonString == null) {
      return {
        'notificaciones': true,
        'sonido': true,
        'vibracion': true,
        'temaOscuro': true,
        'idioma': 'es',
      };
    }
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return {'notificaciones': true, 'sonido': true, 'temaOscuro': true};
    }
  }

  // ─── ¿ES TU PRIMER DÍA AQUÍ? ────────────────────────────────────────────

  static bool esPrimeraVez() =>
      !(_prefs?.containsKey(_clavePrimeraVez) ?? false);

  static Future<bool> marcarNoEsPrimeraVez() async =>
      await _prefs?.setBool(_clavePrimeraVez, true) ?? false;

  // ─── API KEY ─────────────────────────────────────────────────────────────

  static Future<bool> guardarApiKey(String apiKey) async =>
      await _prefs?.setString(_claveApiKey, apiKey) ?? false;

  static String? cargarApiKey() => _prefs?.getString(_claveApiKey);

  // ─── HERRAMIENTAS ÚTILES ────────────────────────────────────────────────

  static Future<void> guardarProgreso(UserModel usuario) async {
    usuario.ultimoAcceso = DateTime.now();
    // Sincronizar estrellas del usuario al storage dedicado
    for (final entry in usuario.estrellasNivel.entries) {
      await guardarEstrellasNivel(entry.key, entry.value);
    }
    await guardarUsuario(usuario);
  }

  static Future<bool> resetearTodo() async => await _prefs?.clear() ?? false;

  static Future<void> borrarTodoElProgreso() async => resetearTodo();

  static bool leccionCompletada(String leccionId) {
    final usuario = cargarUsuario();
    if (usuario == null) return false;
    return usuario.leccionesCompletadas.contains(leccionId);
  }
}
