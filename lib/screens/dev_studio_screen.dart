// dev_studio_screen.dart — ¡Tu Laboratorio de Código!
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde la teoría se vuelve realidad. DevStudio es un IDE real dentro
// de tu app. Puedes escribir código, verlo correr en vivo (en HTML) o enviarlo
// a nuestra consola "Piston" para ver qué sucede. ¡Eres un arquitecto digital!
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

// ─── Paleta VS Code Dark+ ─────────────────────────────────────────────────────
const _bg        = Color(0xFF1E1E1E);
const _bgPanel   = Color(0xFF252526);
const _bgTab     = Color(0xFF2D2D30);
const _bgInput   = Color(0xFF3C3C3C);
const _border    = Color(0xFF474747);
const _verde     = Color(0xFF00FF88);
const _cian      = Color(0xFF4EC9B0);
const _azul      = Color(0xFF569CD6);
const _amarillo  = Color(0xFFDCDCAA);
const _rojo      = Color(0xFFF44747);
const _textoP    = Color(0xFFD4D4D4);
const _textoS    = Color(0xFF858585);
const _acento    = Color(0xFF007ACC);
const _linea     = Color(0xFF3E3E3E);

// ─── Lenguajes ────────────────────────────────────────────────────────────────
class LenguajeStudio {
  final String id, nombre, emoji, extension, lenguajePiston, plantilla;
  final Color color;
  final bool tienePreview;
  const LenguajeStudio({
    required this.id, required this.nombre, required this.emoji,
    required this.color, required this.extension, required this.lenguajePiston,
    required this.plantilla, this.tienePreview = false,
  });
}

const _langs = [
  LenguajeStudio(
    id: 'html', nombre: 'HTML', emoji: '🌐', color: Color(0xFFE34C26),
    extension: '.html', lenguajePiston: 'html', tienePreview: true,
    plantilla: '''<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mi Proyecto</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #0d1117, #161b22);
      color: #e6edf3;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 20px;
    }
    h1 { color: #00ff88; font-size: 2em; text-shadow: 0 0 20px #00ff8866; }
    p { color: #8b949e; }
    button {
      background: #00ff88;
      color: #0d1117;
      border: none;
      padding: 14px 28px;
      border-radius: 10px;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      box-shadow: 0 0 20px #00ff8844;
    }
    #resultado { color: #22d3ee; font-size: 1.2em; min-height: 30px; }
  </style>
</head>
<body>
  <h1>Hola Dev!</h1>
  <p>Tu primer proyecto en ByteUP DevStudio</p>
  <button onclick="saludar()">Hazme click!</button>
  <p id="resultado"></p>
  <script>
    function saludar() {
      document.getElementById("resultado").textContent = "Lo lograste! Eres un crack!";
    }
  </script>
</body>
</html>''',
  ),
  LenguajeStudio(
    id: 'python', nombre: 'Python', emoji: '🐍', color: Color(0xFF3776AB),
    extension: '.py', lenguajePiston: 'python',
    plantilla: '# Mi programa en Python\n\nprint("Hola Mundo!")\n',
  ),
  LenguajeStudio(
    id: 'javascript', nombre: 'JavaScript', emoji: '⚡', color: Color(0xFFF7DF1E),
    extension: '.js', lenguajePiston: 'javascript',
    plantilla: '// Mi programa en JavaScript\n\nconsole.log("Hola Mundo!");\n',
  ),
  LenguajeStudio(
    id: 'java', nombre: 'Java', emoji: '☕', color: Color(0xFFED8B00),
    extension: '.java', lenguajePiston: 'java',
    plantilla: 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hola Mundo!");\n    }\n}\n',
  ),
  LenguajeStudio(
    id: 'cpp', nombre: 'C++', emoji: '⚙️', color: Color(0xFF00599C),
    extension: '.cpp', lenguajePiston: 'cpp',
    plantilla: '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hola Mundo!" << endl;\n    return 0;\n}\n',
  ),
];

// ─── Modelo Proyecto ──────────────────────────────────────────────────────────
class Proyecto {
  final String id;
  String nombre, codigo, lenguajeId;
  Proyecto({required this.id, required this.nombre, required this.codigo, required this.lenguajeId});
}

// ═══════════════════════════════════════════════════════════════════════════
class DevStudioScreen extends StatefulWidget {
  const DevStudioScreen({super.key});
  @override
  State<DevStudioScreen> createState() => _DevStudioScreenState();
}

class _DevStudioScreenState extends State<DevStudioScreen> with TickerProviderStateMixin {

  LenguajeStudio _lang = _langs[0];
  late TextEditingController _codeCtrl;
  final ScrollController _editorScroll = ScrollController();
  final ScrollController _lineScroll   = ScrollController();

  // 0=Editor 1=Preview 2=Consola
  int _tab = 0;

  final List<Proyecto> _proyectos = [];
  Proyecto? _proyecto;

  bool _corriendo   = false;
  String _consola   = '';
  bool _hayError    = false;

  // WebView
  late WebViewController _webCtrl;

  // Fon Master
  String _fonMsg   = 'Bienvenido a DevStudio! Escribe tu codigo y presiona para ejecutar. Estoy aqui para ayudarte!';
  bool _fonPensando = false;
  Timer? _debounce;

  // Animaciones
  late AnimationController _fonBounce;
  late Animation<double>   _fonFloat;
  late AnimationController _pulseCtrl;
  late Animation<double>   _pulseAnim;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: _lang.plantilla);
    _codeCtrl.addListener(_onCodigo);

    final p = Proyecto(id: '1', nombre: 'Mi Proyecto', codigo: _lang.plantilla, lenguajeId: _lang.id);
    _proyectos.add(p);
    _proyecto = p;

    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate());
    _refreshWebView();

    _fonBounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _fonFloat  = Tween<double>(begin: 0, end: -5).animate(CurvedAnimation(parent: _fonBounce, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.07).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  void _refreshWebView() {
    _webCtrl.loadHtmlString(_codeCtrl.text);
  }

  void _onCodigo() {
    _proyecto?.codigo = _codeCtrl.text;
    if (_lang.tienePreview && _tab == 1) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 700), _refreshWebView);
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 4), _llamarIA);
    if (mounted) setState(() {});
  }

  Future<void> _llamarIA({String? promptExtra}) async {
    if (_fonPensando) return;
    final codigo = _codeCtrl.text.trim();
    if (codigo.isEmpty && promptExtra == null) return;

    setState(() => _fonPensando = true);

    final prompt = promptExtra ??
        'El estudiante escribio este codigo en ${_lang.nombre}:\n\n$codigo\n\nDa un comentario MUY breve (maximo 2 oraciones), positivo y con emojis. Si hay un error menciónalo con humor.';

    try {
      final res = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {'Content-Type': 'application/json', 'anthropic-version': '2023-06-01'},
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 100,
          'system': 'Eres Fon Master, tutor de programacion divertido y motivador. Hablas informal, usas emojis. Maximo 2 oraciones. Tu frase favorita: Exelente! Nunca expliques largo.',
          'messages': [{'role': 'user', 'content': prompt}],
        }),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data  = jsonDecode(res.body);
        final texto = (data['content'] as List?)?.firstOrNull?['text'] ?? '';
        if (mounted && texto.isNotEmpty) {
          setState(() { _fonMsg = texto; _fonPensando = false; });
          return;
        }
      }
    } catch (_) {}
    _fonOffline();
  }

  void _fonOffline() {
    final msgs = [
      'Sigue asi! Cada linea que escribes te acerca mas al exito',
      'Exelente! Me gusta como piensas el problema',
      'Los errores son parte del aprendizaje, no te rajes!',
      'Buen trabajo! Eres mas dev de lo que crees',
    ];
    if (mounted) setState(() { _fonMsg = msgs[DateTime.now().second % msgs.length]; _fonPensando = false; });
  }

  void _setFon(String msg) => setState(() => _fonMsg = msg);

  Future<void> _ejecutar() async {
    if (_corriendo) return;

    if (_lang.tienePreview) {
      setState(() { _tab = 1; });
      _refreshWebView();
      _llamarIA(promptExtra: 'El estudiante presiono Preview en su proyecto HTML. Dile algo motivador sobre ver su pagina en vivo en 1 oracion.');
      return;
    }

    setState(() { _corriendo = true; _consola = ''; _hayError = false; _tab = 2; });
    HapticFeedback.lightImpact();
    _setFon('Ejecutando tu codigo... A ver que pasa!');

    try {
      final res = await http.post(
        Uri.parse('https://emkc.org/api/v2/piston/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': _lang.lenguajePiston,
          'version': '*',
          'files': [{'name': 'main${_lang.extension}', 'content': _codeCtrl.text}],
        }),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data    = jsonDecode(res.body);
        final stdout  = data['run']?['stdout'] ?? '';
        final stderr  = data['run']?['stderr'] ?? '';
        final compile = data['compile']?['stderr'] ?? '';
        final error   = compile.isNotEmpty ? compile : stderr;

        setState(() {
          _corriendo = false;
          _hayError  = error.isNotEmpty;
          _consola   = error.isNotEmpty ? 'ERROR:\n$error' : (stdout.isEmpty ? '(Sin salida)' : stdout);
        });

        _llamarIA(promptExtra: error.isNotEmpty
          ? 'El estudiante tiene este error en ${_lang.nombre}:\n$error\nDale animo y un hint breve con humor en 2 oraciones.'
          : 'El codigo del estudiante en ${_lang.nombre} corrio perfectamente. Salida: $stdout\nFelicitalo de forma epica en 2 oraciones.');
        if (error.isEmpty) HapticFeedback.heavyImpact();
      } else {
        setState(() { _corriendo = false; _consola = 'Error de conexion.'; _hayError = true; });
        _fonOffline();
      }
    } catch (_) {
      setState(() { _corriendo = false; _consola = 'Sin conexion al servidor.'; _hayError = true; });
      _fonOffline();
    }
  }

  void _cambiarLang(LenguajeStudio lang) {
    setState(() { _lang = lang; _codeCtrl.text = lang.plantilla; _consola = ''; _tab = 0; });
    _llamarIA(promptExtra: 'El estudiante cambio a ${lang.nombre} ${lang.emoji}. Dile algo motivador sobre este lenguaje en 1 oracion.');
  }

  void _nuevoProyecto() {
    final ctrl = TextEditingController(text: 'Proyecto ${_proyectos.length + 1}');
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgPanel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nuevo Proyecto', style: TextStyle(color: _textoP, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              style: const TextStyle(color: _textoP),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: const TextStyle(color: _textoS),
                filled: true, fillColor: _bg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _verde)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Lenguaje:', style: TextStyle(color: _textoS, fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _langs.map((l) => GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  final p = Proyecto(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nombre: ctrl.text.trim().isEmpty ? 'Proyecto' : ctrl.text.trim(),
                    codigo: l.plantilla, lenguajeId: l.id,
                  );
                  setState(() { _proyectos.add(p); _proyecto = p; _lang = l; _codeCtrl.text = l.plantilla; _consola = ''; _tab = 0; });
                  _llamarIA(promptExtra: 'El estudiante creo un proyecto "${p.nombre}" en ${l.nombre}. Saluda con emocion en 1 oracion.');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: l.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: l.color.withOpacity(0.5)),
                  ),
                  child: Text('${l.emoji} ${l.nombre}', style: TextStyle(color: l.color, fontWeight: FontWeight.bold)),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _verProyectos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgPanel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SizedBox(
        height: 380,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Text('Mis Proyectos', style: TextStyle(color: _textoP, fontSize: 17, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${_proyectos.length} total', style: const TextStyle(color: _textoS, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _proyectos.length,
                itemBuilder: (_, i) {
                  final p    = _proyectos[_proyectos.length - 1 - i];
                  final l    = _langs.firstWhere((x) => x.id == p.lenguajeId, orElse: () => _langs[0]);
                  final curr = p.id == _proyecto?.id;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() { _proyecto = p; _lang = l; _codeCtrl.text = p.codigo; _consola = ''; _tab = 0; });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: curr ? l.color.withOpacity(0.12) : _bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: curr ? l.color.withOpacity(0.5) : _border),
                      ),
                      child: Row(
                        children: [
                          Text(l.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.nombre, style: const TextStyle(color: _textoP, fontWeight: FontWeight.bold)),
                              Text(l.nombre, style: const TextStyle(color: _textoS, fontSize: 12)),
                            ],
                          )),
                          if (curr) Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: _verde.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                            child: const Text('Activo', style: TextStyle(color: _verde, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _editorScroll.dispose();
    _lineScroll.dispose();
    _fonBounce.dispose();
    _pulseCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _langBar(),
            _tabBar(),
            Expanded(child: _contenido()),
            _fonMaster(),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: _bgPanel,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: _bgInput, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.chevron_left_rounded, color: _textoP, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 8, height: 8, decoration: BoxDecoration(
            color: _verde, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: _verde.withOpacity(0.6), blurRadius: 8)],
          )),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_proyecto?.nombre ?? 'DevStudio',
                  style: const TextStyle(color: _textoP, fontSize: 14, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
                Text('${_lang.emoji} ${_lang.nombre}  |  ${_codeCtrl.text.split('\n').length} lineas',
                  style: const TextStyle(color: _textoS, fontSize: 10)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00FF88), Color(0xFF4EC9B0)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('DevStudio',
              style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _langBar() {
    return Container(
      height: 46,
      color: _bgPanel,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        itemCount: _langs.length,
        itemBuilder: (_, i) {
          final l      = _langs[i];
          final activo = l.id == _lang.id;
          return GestureDetector(
            onTap: () => _cambiarLang(l),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: activo ? l.color.withOpacity(0.18) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: activo ? l.color : _border, width: activo ? 1.5 : 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.emoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(l.nombre, style: TextStyle(
                    color: activo ? l.color : _textoS,
                    fontSize: 12,
                    fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabBar() {
    final tabs = [
      {'i': Icons.code_rounded, 'l': 'Codigo', 't': 0},
      if (_lang.tienePreview) {'i': Icons.language_rounded, 'l': 'Navegador', 't': 1},
      {'i': Icons.terminal_rounded, 'l': 'Consola', 't': 2},
    ];
    return Container(
      color: _bgTab,
      child: Row(
        children: tabs.map((t) {
          final idx    = t['t'] as int;
          final activo = _tab == idx;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _tab = idx);
                if (idx == 1 && _lang.tienePreview) _refreshWebView();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: activo ? _acento : Colors.transparent, width: 2)),
                  color: activo ? _bg : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(t['i'] as IconData, size: 14, color: activo ? _textoP : _textoS),
                    const SizedBox(width: 5),
                    Text(t['l'] as String, style: TextStyle(
                      color: activo ? _textoP : _textoS,
                      fontSize: 11,
                      fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
                    )),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _contenido() {
    switch (_tab) {
      case 0: return _editor();
      case 1: return _preview();
      case 2: return _consolaView();
      default: return _editor();
    }
  }

  Widget _editor() {
    final numLineas = _codeCtrl.text.split('\n').length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          color: const Color(0xFF1E1E1E),
          child: SingleChildScrollView(
            controller: _lineScroll,
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 8),
              child: Column(
                children: List.generate(numLineas, (i) => SizedBox(
                  height: 22.1,
                  child: Text('${i + 1}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: _textoS, fontFamily: 'monospace', fontSize: 12)),
                )),
              ),
            ),
          ),
        ),
        Container(width: 1, color: _linea),
        Expanded(
          child: Container(
            color: _bg,
            child: SingleChildScrollView(
              controller: _editorScroll,
              child: TextField(
                controller: _codeCtrl,
                maxLines: null,
                style: const TextStyle(
                  fontFamily: 'monospace', fontSize: 13.5,
                  color: _textoP, height: 1.62, letterSpacing: 0.3,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 40),
                  border: InputBorder.none, isDense: true,
                ),
                onChanged: (_) => setState(() {}),
                cursorColor: _acento,
                cursorWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _preview() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: const Color(0xFF323233),
          child: Row(
            children: [
              _dot(const Color(0xFFFF5F57)),
              const SizedBox(width: 5),
              _dot(const Color(0xFFFFBD2E)),
              const SizedBox(width: 5),
              _dot(const Color(0xFF28C840)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 10, color: _textoS),
                      SizedBox(width: 5),
                      Text('localhost - ByteUP DevStudio',
                        style: TextStyle(color: _textoS, fontSize: 11, fontFamily: 'monospace')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () { _refreshWebView(); _setFon('Recargando tu pagina! Vamos a ver como quedo!'); },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: _bgInput, borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.refresh_rounded, color: _textoS, size: 15),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: WebViewWidget(controller: _webCtrl)),
      ],
    );
  }

  Widget _dot(Color c) => Container(width: 11, height: 11, decoration: BoxDecoration(color: c, shape: BoxShape.circle));

  Widget _consolaView() {
    return Container(
      color: _bg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF2D2D30),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: _corriendo ? _amarillo : (_hayError ? _rojo : _verde),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: (_corriendo ? _amarillo : (_hayError ? _rojo : _verde)).withOpacity(0.5), blurRadius: 6)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _corriendo ? 'Ejecutando...' : (_hayError ? 'Error' : 'Salida del programa'),
                  style: const TextStyle(color: _textoS, fontSize: 12, fontFamily: 'monospace'),
                ),
                const Spacer(),
                if (_consola.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _consola = ''),
                    child: const Icon(Icons.delete_outline_rounded, color: _textoS, size: 16),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _corriendo
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: _verde, strokeWidth: 2)),
                      SizedBox(height: 14),
                      Text('Compilando y ejecutando...', style: TextStyle(color: _textoS, fontSize: 13)),
                    ],
                  ),
                )
              : _consola.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.terminal_rounded, size: 52, color: _textoS.withOpacity(0.25)),
                        const SizedBox(height: 12),
                        const Text('Presiona Ejecutar para ver la salida',
                          style: TextStyle(color: _textoS, fontSize: 13)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      _consola,
                      style: TextStyle(
                        fontFamily: 'monospace', fontSize: 13, height: 1.6,
                        color: _hayError ? const Color(0xFFFF7B72) : const Color(0xFF7EE787),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _fonMaster() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        border: Border(
          top: BorderSide(color: _verde.withOpacity(0.3), width: 1),
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _fonFloat,
            builder: (_, child) => Transform.translate(offset: Offset(0, _fonFloat.value), child: child),
            child: GestureDetector(
              onTap: () => _llamarIA(),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00FF88), Color(0xFF4EC9B0)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: _verde.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)],
                ),
                child: const Center(child: Text('🧑‍💻', style: TextStyle(fontSize: 20))),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2433),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border.all(color: _verde.withOpacity(0.25)),
              ),
              child: _fonPensando
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12, height: 12,
                        child: CircularProgressIndicator(color: _verde.withOpacity(0.8), strokeWidth: 2)),
                      const SizedBox(width: 8),
                      const Text('Fon Master pensando...', style: TextStyle(color: _textoS, fontSize: 12, fontStyle: FontStyle.italic)),
                    ],
                  )
                : Text(_fonMsg, style: const TextStyle(color: _textoP, fontSize: 12, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      color: _bgPanel,
      child: Row(
        children: [
          _btn(icon: Icons.add_rounded, label: 'Nuevo', onTap: _nuevoProyecto),
          const SizedBox(width: 8),
          _btn(
            icon: Icons.folder_open_rounded,
            label: 'Proyectos',
            onTap: _verProyectos,
            badge: _proyectos.length > 1 ? '${_proyectos.length}' : null,
          ),
          const Spacer(),
          GestureDetector(
            onTap: _corriendo ? null : _ejecutar,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) => Transform.scale(scale: _corriendo ? 1.0 : _pulseAnim.value, child: child),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: BoxDecoration(
                  gradient: _corriendo ? null : const LinearGradient(
                    colors: [Color(0xFF00FF88), Color(0xFF4EC9B0)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  color: _corriendo ? _border : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _corriendo ? [] : [
                    BoxShadow(color: _verde.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _corriendo
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: _textoS))
                      : const Icon(Icons.play_arrow_rounded, color: Color(0xFF1E1E1E), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _corriendo ? 'Corriendo...' : (_lang.tienePreview ? 'Preview' : 'Ejecutar'),
                      style: TextStyle(
                        color: _corriendo ? _textoS : const Color(0xFF1E1E1E),
                        fontWeight: FontWeight.w800, fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn({required IconData icon, required String label, required VoidCallback onTap, String? badge}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _bgInput, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _textoS, size: 15),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: _textoS, fontSize: 12)),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: _verde.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(badge, style: const TextStyle(color: _verde, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}