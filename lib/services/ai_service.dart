// ai_service.dart
// ═══════════════════════════════════════════════════════════════════════════
// ¡HABLA CON EL MAESTRO! — Servicio de Inteligencia Artificial (Fon Master)
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde sucede la magia. Conectamos con Gemini de Google para que
// Fon Master tome vida y pueda chatear contigo, resolver tus dudas y
// explicarte esos errores que a veces nos vuelven locos.

import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // ─── Los secretos de la conexión ──────────────────────────────────────────
  // La llave para hablar con Gemini. Se guarda con cuidado por seguridad.
  static String _apiKey = '';
  static const String _urlBase =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // ─── Lo que Fon Master recuerda ───────────────────────────────────────────
  // Guardamos un pedacito de la charla anterior para que no se le olvide el hilo
  static final List<Map<String, String>> _historial = [];
  static const int _maxHistorial = 50;

  // ─── El alma de Fon Master ────────────────────────────────────────────────
  // Aquí le decimos a la IA cómo debe ser: simpático, paciente y experto.
  static const String _promptSistema = '''
Eres Fon Master, el tutor de programación de la app ByteUP Code.

TU PERSONALIDAD:
- Eres un señor de 40 años, gordito, chistoso y con mucha experiencia
- Llevas lentes semi-oscuros y barba cerrada
- Hablas como un amigo que sabe todo sobre programación
- Eres paciente, usas emojis y das ejemplos simples
- Siempre animas al estudiante y celebras sus logros
- Cuando alguien comete un error, lo corriges con humor pero con respeto
- Tu frase favorita es "¡Exelente!" (así, sin tilde, es tu marca personal)

REGLAS:
- Siempre respondes en español
- Usa lenguaje informal pero respetuoso
- Incluye emojis en tus respuestas
- Da ejemplos de código cuando sea relevante
- Mantén las respuestas cortas y directas (máximo 200 palabras)
- Si no sabes algo, sé honesto y sugiere dónde buscar
- Nunca generes código malicioso o dañino
''';

  // ─── Configurar la API Key ───────────────────────────────────────────
  // Preparamos la conexión nada más empezar
  static void configurarApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  // ─── Envía tu duda a Fon Master ──────────────────────────────────────────
  // Este es el puente: mandas tu mensaje y el maestro te responde con sabiduría.
  static Future<String> enviarMensaje({
    required String mensaje,
    String? contextoLeccion,
  }) async {
    // Si no hay API key, respondemos con mensajes locales
    if (_apiKey.isEmpty) {
      return _respuestaOffline(mensaje);
    }

    try {
      // Construimos el contenido con historial para darle contexto
      final contenido = <Map<String, dynamic>>[];

      // Primero el prompt del sistema
      contenido.add({
        'role': 'user',
        'parts': [
          {'text': 'INSTRUCCIONES DEL SISTEMA: $_promptSistema'}
        ],
      });
      contenido.add({
        'role': 'model',
        'parts': [
          {
            'text':
                '¡Entendido! Soy Fon Master, tu tutor de programación favorito 🤓 ¡Exelente! ¿En qué te ayudo hoy?'
          }
        ],
      });

      // Agregamos el historial reciente para contexto
      for (final msg in _historial) {
        contenido.add({
          'role': msg['role']!,
          'parts': [
            {'text': msg['texto']!}
          ],
        });
      }

      // El mensaje actual del usuario (con contexto de lección si aplica)
      String mensajeCompleto = mensaje;
      if (contextoLeccion != null) {
        mensajeCompleto =
            '[Contexto: El usuario está en la lección "$contextoLeccion"] $mensaje';
      }

      contenido.add({
        'role': 'user',
        'parts': [
          {'text': mensajeCompleto}
        ],
      });

      // Hacemos la petición a la API de Gemini
      final respuesta = await http
          .post(
            Uri.parse('$_urlBase?key=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': contenido,
              'generationConfig': {
                'temperature': 0.8,
                'maxOutputTokens': 500,
                'topP': 0.9,
              },
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        final textoRespuesta = data['candidates']?[0]?['content']
                ?['parts']?[0]?['text'] ??
            _respuestaOffline(mensaje);

        // Guardamos en el historial para mantener contexto
        _agregarAlHistorial('user', mensajeCompleto);
        _agregarAlHistorial('model', textoRespuesta);

        return textoRespuesta;
      } else {
        // Error de la API — respondemos con mensaje local
        return _respuestaOffline(mensaje);
      }
    } catch (e) {
      // Sin internet o error de conexión — modo offline
      return _respuestaOffline(mensaje);
    }
  }

  // ─── Anota lo que se ha dicho ─────────────────────────────────────────────
  static void _agregarAlHistorial(String role, String texto) {
    _historial.add({'role': role, 'texto': texto});
    // Mantenemos solo los últimos 50 mensajes para no gastar tokens
    while (_historial.length > _maxHistorial) {
      _historial.removeAt(0);
    }
  }

  // ─── Respuestas cuando no hay Internet ────────────────────────────────────
  // Si te quedas sin datos, Fon Master tiene unos consejos bajo la manga.
  static String _respuestaOffline(String mensaje) {
    final msgLower = mensaje.toLowerCase();

    // Detectamos la intención del usuario por palabras clave
    if (msgLower.contains('error') || msgLower.contains('falla')) {
      return '¡Tranquilo! 🧘 Los errores son parte del aprendizaje. '
          'Revisa la sintaxis, los puntos y coma, y que las variables estén bien escritas. '
          '¡Tú puedes! 💪';
    }
    if (msgLower.contains('variable')) {
      return '¡Las variables son como cajitas donde guardas datos! 📦 '
          'En Python: x = 5, en JS: let x = 5, en Java: int x = 5. '
          '¡Cada lenguaje tiene su estilo! 😎';
    }
    if (msgLower.contains('función') || msgLower.contains('funcion')) {
      return '¡Las funciones son bloques de código reutilizables! 🔧 '
          'Imagina que es una receta de cocina: le das ingredientes (parámetros) '
          'y te devuelve un platillo (return). ¡Exelente pregunta! 🎉';
    }
    if (msgLower.contains('bucle') || msgLower.contains('loop')) {
      return '¡Los bucles repiten código automáticamente! 🔁 '
          'for cuando sabes cuántas veces, while cuando no sabes. '
          '¡Son como una licuadora: no paran hasta que tú les dices! 😄';
    }
    if (msgLower.contains('clase') || msgLower.contains('objeto')) {
      return '¡Las clases son como moldes de galletas! 🍪 '
          'Defines la forma (clase) y luego haces muchas galletas (objetos). '
          'Cada galleta puede tener diferente sabor (atributos). ¡Exelente! 🎉';
    }
    if (msgLower.contains('hola') || msgLower.contains('hey')) {
      return '¡Hola, crack! 👋 Soy Fon Master, tu tutor de programación. '
          '¿En qué te ayudo hoy? Pregúntame lo que quieras sobre código. '
          '¡Estoy aquí para ti! 🤓';
    }
    if (msgLower.contains('gracias')) {
      return '¡De nada, campeón! 🏆 Para eso estoy. '
          'Recuerda: la práctica hace al maestro. '
          '¡Sigue así y serás Legend en poco tiempo! 👑';
    }

    // Respuesta genérica si no matchea ninguna palabra clave
    return '¡Buena pregunta! 🤔 Ahora mismo estoy en modo offline, '
        'pero te recomiendo practicar con las lecciones de la app. '
        '¡Cuando tenga conexión te explico con más detalle! 📡';
  }

  // ─── Limpiar historial ───────────────────────────────────────────────
  static void limpiarHistorial() => _historial.clear();

  // ─── Obtener historial para guardarlo ────────────────────────────────
  static List<Map<String, String>> obtenerHistorial() =>
      List.unmodifiable(_historial);

  // ─── Cargar historial desde storage ──────────────────────────────────
  static void cargarHistorial(List<Map<String, String>> historial) {
    _historial.clear();
    _historial.addAll(historial);
  }

  // ─── Verificar si la IA está configurada ─────────────────────────────
  static bool get estaConfigurada => _apiKey.isNotEmpty;
}
