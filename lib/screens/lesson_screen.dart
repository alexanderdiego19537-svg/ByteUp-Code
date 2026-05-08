// lesson_screen.dart — ¡La Arena de Entrenamiento!
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde ocurre el aprendizaje real. Usamos el sistema "Master Elite"
// de 6 pasos: Fon te explica, vemos la teoría, analizamos un ejemplo, practicamos
// juntos, te enfrentas a un reto solo y finalmente celebramos tu victoria.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/game_service.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/fon_master_widget.dart'; 
import '../services/audio_service.dart';

class LessonScreen extends StatefulWidget {
  final NivelContenido nivel;

  const LessonScreen({super.key, required this.nivel});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // ─── Estilos ─────────────────────────────────────────────────────────────
  static const Color _fondoBase = Color(0xFF0D1117);
  static const Color _verdeColor = Color(0xFF00FF7F);
  static const Color _cianColor = Color(0xFF00E5FF);
  static const Color _cardColor = Color(0xFF161B22);
  static const Color _errorColor = Color(0xFFFF4C4C);

  // ─── Estado del nivel ───────────────────────────────────────────────────
  int _pasoActual = 0; // 0 = Fon Explica, 1 = Teoría, 2 = Ejemplo, 3 = Guiado, 4 = Reto, 5 = Resumen

  // Estado Paso 1 (Teoría)
  int _parrafoTeoriaActual = 0;

  // Estado Paso 2 (Ejemplo)
  int _lineaEjemploPaso = 0;

  // Estado Paso 3 (Guiado)
  int _erroresGuiado = 0;
  bool _mostrarPistaGuiado = false;
  int? _seleccionGuiado;
  bool _animandoGuiado = false;

  // Variables paso 4
  int? _seleccionReto;
  int _erroresReto = 0;
  bool _animandoReto = false;

  void _verificarRespuesta(int index) async {
    if (_animandoReto) return;
    final pregunta = widget.nivel.retoSolo;
    final bool correcta = index == pregunta.respuestaCorrecta;
    setState(() {
      _seleccionReto = index;
      _animandoReto = true;
    });

    if (correcta) {
      AudioService.playCorrecto();
    } else {
      AudioService.playError();
    }

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    if (correcta) {
      _siguientePaso();
    } else {
      setState(() {
        _erroresReto++;
        _animandoReto = false;
        _seleccionReto = null;
      });
      if (_erroresReto >= 3) {
        if (_usuario.corazones > 0) {
          _usuario.corazones--;
          StorageService.guardarUsuario(_usuario);
        }
        _mostrarPerdidaCorazon();
      }
    }
  }

  // Resultado
  Map<String, dynamic>? _resultadoFinal;

  late UserModel _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = StorageService.cargarUsuario() ?? UserModel(nombre: 'Dev');
  }

  void _siguientePaso() {
    setState(() {
      if (_pasoActual < 5) {
        _pasoActual++;
      }
    });
    if (_pasoActual == 5) {
      _finalizarNivel();
    }
  }

  void _responderOpcion(int indice) {
    if (_animandoReto) return;
    setState(() {
      _seleccionReto = indice;
    });
  }

  void _finalizarNivel() async {
    // Calculamos errores totales para las estrellas
    int erroresTotales = _erroresGuiado + _erroresReto;
    bool usoPistas = _mostrarPistaGuiado;
    int estrellas = GameService.calcularEstrellas(errores: erroresTotales, usoPistas: usoPistas);

    final result = await GameService.completarNivel(
      usuario: _usuario,
      nivel: widget.nivel,
      estrellas: estrellas,
      erroresCometidos: erroresTotales,
    );

    AudioService.playNivelCompletado();
    
    await StorageService.guardarProgreso(_usuario);

    setState(() {
      _resultadoFinal = result;
    });
  }

  // ─── CONSTRUCCIÓN PRINCIPAL ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildProgressBar(),
        actions: [
          Row(
            children: [
              const Icon(Icons.favorite, color: _errorColor, size: 20),
              const SizedBox(width: 4),
              Text(
                '${_usuario.corazones}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOutCubic,
                child: _buildPasoActual(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final double progreso = (_pasoActual) / 5.0; // 0 a 1
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progreso,
        backgroundColor: Colors.white10,
        valueColor: AlwaysStoppedAnimation<Color>(_verdeColor),
        minHeight: 8,
      ),
    );
  }

  Widget _buildPasoActual() {
    switch (_pasoActual) {
      case 0: return _buildPaso0FonExplica(key: const ValueKey(0));
      case 1: return _buildPaso1Teoria(key: const ValueKey(1));
      case 2: return _buildPaso2Ejemplo(key: const ValueKey(2));
      case 3: return _buildPaso3Guiado(key: const ValueKey(3));
      case 4: return _buildPaso4RetoSolo(key: const ValueKey(4));
      case 5: return _buildPaso5Resumen(key: const ValueKey(5));
      default: return const SizedBox.shrink();
    }
  }

  // ─── PASO 0: FON MASTER EXPLICA ──────────────────────────────────────────

  Widget _buildPaso0FonExplica({required Key key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _cardColor.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: _verdeColor.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: 1.2,
                      child: const FonMasterWidget(
                        mensaje: '¡Presta mucha atención!',
                        expresion: Expresion.feliz,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  widget.nivel.titulo,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _cianColor.withOpacity(0.3)),
                  ),
                  child: TypewriterText(
                    text: widget.nivel.explicacionFon,
                    style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.5),
                    duration: const Duration(milliseconds: 3000),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBoton(
            texto: 'Entendido',
            onTap: _siguientePaso,
            color: _verdeColor,
          ),
        ),
      ],
    );
  }

  // ─── PASO 1: TEORÍA INTERACTIVA ──────────────────────────────────────────

  Widget _buildPaso1Teoria({required Key key}) {
    final parrafos = widget.nivel.teoriaParrafos;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('📚 Teoría', style: TextStyle(color: _cianColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ...List.generate(_parrafoTeoriaActual + 1, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        parrafos[index],
                        style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBoton(
            texto: _parrafoTeoriaActual < parrafos.length - 1 ? 'Siguiente línea' : 'Continuar',
            onTap: () {
              if (_parrafoTeoriaActual < parrafos.length - 1) {
                setState(() => _parrafoTeoriaActual++);
              } else {
                _siguientePaso();
              }
            },
            color: _parrafoTeoriaActual < parrafos.length - 1 ? const Color(0xFF4A7DFF) : _verdeColor,
          ),
        ),
      ],
    );
  }

  // ─── PASO 2: EJEMPLO RESUELTO ──────────────────────────────────────────────

  Widget _buildPaso2Ejemplo({required Key key}) {
    final lineasInfo = widget.nivel.ejemploLineas;
    final lineasCodigo = widget.nivel.ejemploContenido.split('\n');

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('💡 Analicemos este ejemplo', style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.nivel.esEjemploCodigo ? Colors.black : _cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(lineasCodigo.length, (index) {
                      bool esActiva = index == _lineaEjemploPaso;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        color: esActiva ? _verdeColor.withOpacity(0.2) : Colors.transparent,
                        width: double.infinity,
                        child: Text(
                          lineasCodigo[index],
                          style: TextStyle(
                            color: esActiva ? _verdeColor : Colors.white60,
                            fontFamily: widget.nivel.esEjemploCodigo ? 'monospace' : null,
                            fontSize: 16,
                            fontWeight: esActiva ? FontWeight.bold : FontWeight.normal
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                if (_lineaEjemploPaso < lineasInfo.length)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cianColor.withOpacity(0.1),
                      border: Border(left: BorderSide(color: _cianColor, width: 4)),
                    ),
                    child: Text(
                      lineasInfo[_lineaEjemploPaso],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBoton(
            texto: _lineaEjemploPaso < lineasCodigo.length - 1 ? 'Explicar línea ${_lineaEjemploPaso + 2}' : '¡Lo entiendo!',
            onTap: () {
              if (_lineaEjemploPaso < lineasCodigo.length - 1) {
                setState(() => _lineaEjemploPaso++);
              } else {
                _siguientePaso();
              }
            },
            color: _lineaEjemploPaso < lineasCodigo.length - 1 ? const Color(0xFF4A7DFF) : _verdeColor,
          ),
        ),
      ],
    );
  }

  // ─── PASO 3: EJERCICIO GUIADO ──────────────────────────────────────────────

  Widget _buildPaso3Guiado({required Key key}) {
    final pregunta = widget.nivel.ejercicioGuiado;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('👟 Práctica Guiada', style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(pregunta.texto, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                if (_mostrarPistaGuiado && pregunta.pista != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(child: Text(pregunta.pista!, style: const TextStyle(color: Colors.amber, fontSize: 16))),
                      ],
                    ),
                  ),
                ...List.generate(pregunta.opciones.length, (index) {
                  bool seleccionado = _seleccionGuiado == index;
                  bool esCorrecta = pregunta.respuestaCorrecta == index;
                  Color btnColor = _cardColor;
                  
                  if (_animandoGuiado && seleccionado) {
                    btnColor = esCorrecta ? _verdeColor : _errorColor;
                  } else if (seleccionado) {
                    btnColor = Colors.white24;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: _animandoGuiado ? null : () {
                        setState(() => _seleccionGuiado = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: seleccionado ? (esCorrecta && _animandoGuiado ? _verdeColor : Colors.white54) : Colors.transparent),
                        ),
                        child: Text(
                          pregunta.opciones[index],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        if (_seleccionGuiado != null && !_animandoGuiado)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildBoton(
              texto: 'Comprobar',
              onTap: () async {
                setState(() => _animandoGuiado = true);
                bool correcta = _seleccionGuiado == pregunta.respuestaCorrecta;
                if (correcta) AudioService.playCorrecto(); else AudioService.playError();
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                if (correcta) {
                  if (pregunta.explicacion != null) {
                    _mostrarDialogExplicacion(pregunta.explicacion!);
                  } else {
                    _siguientePaso();
                  }
                } else {
                  setState(() {
                    _erroresGuiado++;
                    _animandoGuiado = false;
                    _seleccionGuiado = null;
                    if (_erroresGuiado >= 2) _mostrarPistaGuiado = true;
                  });
                }
              },
              color: _verdeColor,
            ),
          ),
      ],
    );
  }

  // ─── PASO 4: RETO SOLO ─────────────────────────────────────────────────────

  Widget _buildPaso4RetoSolo({required Key key}) {
    final pregunta = widget.nivel.retoSolo;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('🔥 Reto Solo', style: TextStyle(color: _errorColor, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Sin pistas. Si fallas 3 veces pierdes un corazón.', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 16),
                Text(pregunta.texto, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ...List.generate(pregunta.opciones.length, (index) {
                  bool seleccionado = _seleccionReto == index;
                  bool esCorrecta = pregunta.respuestaCorrecta == index;
                  Color btnColor = _cardColor;
                  Color borderColor = Colors.transparent;

                  if (_animandoReto && seleccionado) {
                    btnColor = esCorrecta ? _verdeColor.withOpacity(0.3) : _errorColor.withOpacity(0.3);
                    borderColor = esCorrecta ? _verdeColor : _errorColor;
                  } else if (seleccionado) {
                    btnColor = Colors.white.withOpacity(0.15);
                    borderColor = _cianColor;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: _animandoReto ? null : () => _verificarRespuesta(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          pregunta.opciones[index],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── PASO 5: RESUMEN Y RECOMPENSAS ─────────────────────────────────────────

  Widget _buildPaso5Resumen({required Key key}) {
    if (_resultadoFinal == null) return const Center(child: CircularProgressIndicator());

    final xp = _resultadoFinal!['xpGanado'] as int;
    final estrellas = _resultadoFinal!['estrellas'] as int;
    final mensaje = _resultadoFinal!['mensajeFon'] as String;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < estrellas ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 60,
                    );
                  }),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Nivel Completado!',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '+$xp XP',
                  style: const TextStyle(color: _verdeColor, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Text(mensaje, style: const TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 24),
                const Text('Lo que aprendiste:', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...widget.nivel.aprendiste.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    const Icon(Icons.check_circle_outline, color: _verdeColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t, style: const TextStyle(color: Colors.white70, fontSize: 16))),
                  ]),
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBoton(
            texto: 'Continuar',
            onTap: () {
              Navigator.pop(context); // Volver al mapa
            },
            color: _cianColor,
          ),
        ),
      ],
    );
  }

  // ─── UTILIDADES PANTALLA ───────────────────────────────────────────────────

  void _mostrarDialogExplicacion(String teexto) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Acierto!', style: TextStyle(color: _verdeColor)),
        content: Text(teexto, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _siguientePaso();
            },
            child: const Text('Continuar', style: TextStyle(color: _cianColor, fontSize: 16)),
          )
        ],
      ),
    );
  }

  void _mostrarPerdidaCorazon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Cuidado!', style: TextStyle(color: _errorColor)),
        content: const Text('Has agotado tus intentos y perdiste 1 corazón. ¡Piensa bien la próxima vez!', style: TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _erroresReto = 0); // reinicia los errores del reto actual para darle otra chance
            },
            child: const Text('Intentar de nuevo', style: TextStyle(color: _errorColor, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildBoton({required String texto, required VoidCallback onTap, required Color color}) {
    // El botón "principal" (verde/cian) tiene fondo tenue + borde fuerte
    // El botón "secundario" (azul) tiene fondo un poco más opaco para no verse deshabilitado
    final bool esPrincipal = color == _verdeColor || color == _cianColor;
    return GestureDetector(
      onTap: () {
        AudioService.playClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(esPrincipal ? 0.15 : 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: esPrincipal ? 1.5 : 1.5),
          boxShadow: esPrincipal
              ? []
              : [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!esPrincipal) ...[
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 15),
              const SizedBox(width: 8),
            ],
            Text(
              texto,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}