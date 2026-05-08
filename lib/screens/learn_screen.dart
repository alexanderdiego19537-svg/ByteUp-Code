// learn_screen.dart — ¡Tu Mapa del Tesoro (del Conocimiento)!
// ═══════════════════════════════════════════════════════════════════════════
// Esta es la pantalla de la ruta de aprendizaje. Aquí visualizas tu camino
// como si fuera un mapa de aventura. Cada nodo es un nuevo reto por conquistar.
// Desde la lógica pura hasta los lenguajes más avanzados, tú controlas el viaje.
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../data/lessons_data.dart';
import 'lesson_screen.dart';
import '../widgets/fon_master_widget.dart';
import 'ai_tutor_screen.dart';

class LearnScreen extends StatefulWidget {
  final String? startLang;

  const LearnScreen({super.key, this.startLang});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with TickerProviderStateMixin {
  static const Color _fondoBase = Color(0xFF0D1117);
  static const Color _cardColor = Color(0xFF161B22);

  UserModel _usuario = UserModel(nombre: 'Dev');
  String _cursoSeleccionado = 'logica'; // 'logica', 'python', 'javascript', etc
  
  late AnimationController _pulseController;

  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _cursos = [
    {'id': 'logica', 'nombre': 'Lógica Pura', 'emoji': '🧠', 'color': Color(0xFF8B5CF6)},
    {'id': 'python', 'nombre': 'Python', 'emoji': '🐍', 'color': Color(0xFF3B82F6)},
    {'id': 'javascript', 'nombre': 'JavaScript', 'emoji': '⚡', 'color': Color(0xFFF59E0B)},
    {'id': 'java', 'nombre': 'Java', 'emoji': '☕', 'color': Color(0xFFEF4444)},
    {'id': 'cpp', 'nombre': 'C++', 'emoji': '⚙️', 'color': Color(0xFF10B981)},
    {'id': 'html', 'nombre': 'HTML', 'emoji': '🌐', 'color': Color(0xFFEC4899)},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.startLang != null) {
      _cursoSeleccionado = widget.startLang!;
    }
    
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
      
    _cargarDatos();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _cargarDatos() {
    setState(() {
      _usuario = StorageService.cargarUsuario() ?? UserModel(nombre: 'Dev');
      if (widget.startLang == null) {
        _cursoSeleccionado = _usuario.etapaActual == 1 ? 'logica' : 'python';
      }
    });

    // Auto-scroll logic if needed, simplificado para ahora.
    Future.delayed(const Duration(milliseconds: 500), () {
        // En un proyecto real, se scrolea hasta el nodo activo.
    });
  }

  List<ModuloModel> get _modulosActuales {
    if (_cursoSeleccionado == 'logica') {
      return LessonsData.modulosLogica;
    } else {
      return LessonsData.obtenerModulos(EtapaAprendizaje.lenguajes, _cursoSeleccionado);
    }
  }

  double _getOffsetCircular(int index) {
    if (index % 4 == 0) return 0.0;
    if (index % 4 == 1) return 50.0;
    if (index % 4 == 2) return 0.0;
    if (index % 4 == 3) return -50.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoBase,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildSelectorHorizontal(),
                Expanded(
                  child: _buildRutaDelMapa(),
                ),
              ],
            ),

            // Fon Master — 1 tap globo, 2 taps abre chat
            _FonMasterLearnWidget(
              onAbrirChat: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AITutorScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Ruta de Aprendizaje',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          // Bloque estadisticas rapido
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xFFFF4B8C), size: 20),
              const SizedBox(width: 4),
              Text('${_usuario.corazones}', style: const TextStyle(color: Color(0xFFFF4B8C), fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelectorHorizontal() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cursos.length,
        itemBuilder: (context, index) {
          final curso = _cursos[index];
          final bool activo = _cursoSeleccionado == curso['id'];
          final Color cColor = curso['color'];

          return GestureDetector(
            onTap: () {
              setState(() => _cursoSeleccionado = curso['id']);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12, bottom: 10, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: activo ? LinearGradient(colors: [cColor.withOpacity(0.8), cColor]) : null,
                color: activo ? null : _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: activo ? [
                  BoxShadow(color: cColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))
                ] : [],
                border: Border.all(color: activo ? Colors.transparent : Colors.white10),
              ),
              child: Row(
                children: [
                  Text(curso['emoji'], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    curso['nombre'],
                    style: TextStyle(
                      color: activo ? Colors.white : Colors.white54,
                      fontWeight: activo ? FontWeight.w900 : FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRutaDelMapa() {
    final modulos = _modulosActuales;
    
    // Convertir todo en una lista lineal de Elementos (Headers de Modulo + Nodos de Nivel)
    List<Map<String, dynamic>> rutaVisual = [];
    
    for (int m = 0; m < modulos.length; m++) {
      final modulo = modulos[m];
      rutaVisual.add({'tipo': 'header', 'modulo': modulo});
      
      final totalNodos = modulo.totalUnidades;
      
      for (int n = 0; n < totalNodos; n++) {
        NivelContenido nivel;
        if (n < modulo.niveles.length) {
          nivel = modulo.niveles[n];
        } else {
          nivel = modulo.proyectoFinal!;
        }
        
        bool completado = _usuario.leccionesCompletadas.contains(nivel.id);
        
        // Bloqueado si no es el primer nivel de logica y el anterior no está en leccionesCompletadas.
        bool bloqueado = true;
        if (nivel.id == 'logica_m1_n1' || nivel.id == '${_cursoSeleccionado}_m1_n1') {
           bloqueado = false; // El primer nivel o modulo abierto siempre disponible
        } else {
           // Para simplificar: buscar el índice global del nivel actual y ver si el anterior está
           // Buscamos nivel anterior
           if (n > 0) {
              if (_usuario.leccionesCompletadas.contains(modulo.niveles[n-1].id)) bloqueado = false;
           } else if (m > 0) {
              final moduloAnterior = modulos[m-1];
              if (moduloAnterior.proyectoFinal != null && _usuario.leccionesCompletadas.contains(moduloAnterior.proyectoFinal!.id)) bloqueado = false;
           }
        }
        
        if (completado) bloqueado = false; // por seguridad
        
        bool actual = !bloqueado && !completado; 
        
        rutaVisual.add({
          'tipo': 'nodo',
          'nivel': nivel,
          'completado': completado,
          'bloqueado': bloqueado,
          'actual': actual,
          'zigzagIndex': n,
        });
      }
    }

    final Color colorActual = _cursos.firstWhere((c) => c['id'] == _cursoSeleccionado)['color'];

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      physics: const BouncingScrollPhysics(),
      itemCount: rutaVisual.length,
      itemBuilder: (context, index) {
        final item = rutaVisual[index];
        if (item['tipo'] == 'header') {
          return _buildModuloBanner(item['modulo'], colorActual);
        } else {
          // Encontrar si el proximo es tambien nodo
          bool hasNextNode = false;
          double nextOffset = 0.0;
          if (index + 1 < rutaVisual.length && rutaVisual[index+1]['tipo'] == 'nodo') {
              hasNextNode = true;
              nextOffset = _getOffsetCircular(rutaVisual[index+1]['zigzagIndex']);
          }

          return _buildNodoNivel(item, colorActual, hasNextNode, nextOffset);
        }
      },
    );
  }

  Widget _buildModuloBanner(ModuloModel modulo, Color baseColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: baseColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(color: baseColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)
        ]
      ),
      child: Column(
        children: [
          Text(modulo.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text('Módulo ${modulo.numero}', style: TextStyle(color: baseColor, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(modulo.titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, height: 1.2), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(modulo.descripcion, style: const TextStyle(color: Colors.white60, fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNodoNivel(Map<String, dynamic> item, Color colorActual, bool hasNextNode, double nextOffset) {
    final NivelContenido nivel = item['nivel'];
    final bool completado = item['completado'];
    final bool bloqueado = item['bloqueado'];
    final bool actual = item['actual'];
    final int zigzagIndex = item['zigzagIndex'];
    final int estrellas = _usuario.estrellasNivel[nivel.id] ?? 0;

    final double offset = _getOffsetCircular(zigzagIndex);

    Color nodoColor = completado ? const Color(0xFF00FF7F) : (bloqueado ? const Color(0xFF2D333B) : colorActual);
    Color borderColor = completado ? Colors.greenAccent : (bloqueado ? const Color(0xFF444C56) : colorActual.withOpacity(0.8));
    Color shadowColor = completado ? const Color(0xFF008945) : (bloqueado ? const Color(0xFF1E2328) : colorActual.withAlpha(200).withBlue(50)); // Oscurecemos un poco para el 3D
    
    IconData icono;
    if (nivel.esProyectoFinal) {
      icono = bloqueado ? Icons.lock_rounded : Icons.emoji_events_rounded;
    } else {
      if (completado) {
        icono = Icons.check_rounded;
      } else if (actual) {
        icono = Icons.play_arrow_rounded;
      } else {
        icono = Icons.lock_rounded;
      }
    }

    final nodoWidget = GestureDetector(
       onTap: bloqueado ? null : () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(nivel: nivel)))
              .then((_) => _cargarDatos());
       },
       child: Column(
          children: [
            // El círculo 3D real
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nodoColor,
                border: Border.all(color: borderColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 8), // Profundidad 3D (Borde inferior grueso)
                  ),
                  if (actual) BoxShadow(
                      color: colorActual.withOpacity(0.6), blurRadius: 20
                  )
                ],
              ),
              child: Center(
                child: Icon(icono, color: bloqueado ? Colors.white30 : (actual ? Colors.white : Colors.black), size: 40),
              ),
            ),
            const SizedBox(height: 12),
            // Las estrellas debajo del nivel
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (idx) => Icon(
                idx < estrellas ? Icons.star_rounded : Icons.star_border_rounded,
                color: bloqueado ? Colors.transparent : Colors.amber, 
                size: 20,
              )),
            )
          ]
       )
    );

    return SizedBox(
      height: 140, // Espacio fijo por fila 
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conector (Dibuja línea hacia el nodo siguiente si existe)
          if (hasNextNode)
             CustomPaint(
               size: const Size(double.infinity, 140),
               painter: _CaminoPainter(
                  offsetInicio: offset, 
                  offsetFin: nextOffset, 
                  color: completado ? const Color(0xFF00FF7F) : const Color(0xFF2D333B)
               ),
             ),
             
          // Transformación horizontal (zigzag)
          Transform.translate(
            offset: Offset(offset, 0),
            child: actual ? ScaleTransition(
               scale: Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine)),
               child: nodoWidget
            ) : nodoWidget,
          ),
        ],
      )
    );
  }
}

// Pintor de curvas/líneas gruesas simulando caminos
class _CaminoPainter extends CustomPainter {
  final double offsetInicio;
  final double offsetFin;
  final Color color;

  _CaminoPainter({required this.offsetInicio, required this.offsetFin, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    
    final paintObj = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Punto donde está este nodo (el centro aprox del círculo de 80)
    final pStart = Offset(centerX + offsetInicio, 40); 
    // Punto donde está el centro del PRÓXIMO nodo
    final pEnd = Offset(centerX + offsetFin, 140 + 40); 

    path.moveTo(pStart.dx, pStart.dy);
    // Draw smooth bezier curve instead of straight line
    path.cubicTo(
        pStart.dx, pStart.dy + 50, 
        pEnd.dx, pEnd.dy - 50, 
        pEnd.dx, pEnd.dy
    );

    canvas.drawPath(path, paintObj);
  }

  @override
  bool shouldRepaint(covariant _CaminoPainter oldDelegate) {
    return oldDelegate.offsetInicio != offsetInicio || 
           oldDelegate.offsetFin != offsetFin ||
           oldDelegate.color != color;
  }
}

// ─── Fon Master para LearnScreen — 1 tap globo, 2 taps chat ──────────────────
class _FonMasterLearnWidget extends StatefulWidget {
  final VoidCallback onAbrirChat;
  const _FonMasterLearnWidget({required this.onAbrirChat});

  @override
  State<_FonMasterLearnWidget> createState() => _FonMasterLearnWidgetState();
}

class _FonMasterLearnWidgetState extends State<_FonMasterLearnWidget>
    with TickerProviderStateMixin {
  int _tapCount = 0;
  bool _mostrarGlobo = false;

  late AnimationController _floatController;
  late Animation<double> _floatAnim;
  late AnimationController _bubbleController;
  late Animation<double> _bubbleOpacity;

  static const _mensajes = [
    'Sigue el camino. ¡Un paso a la vez! 🗺️',
    '¡Completa los nodos en orden! 🎯',
    'Tócame dos veces para ayuda 💬',
    '¡Vamos programador! 🚀',
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bubbleOpacity = CurvedAnimation(parent: _bubbleController, curve: Curves.easeIn);

    // Mostrar globo al iniciar
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _mostrarGlobo = true);
        _bubbleController.forward();
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _bubbleController.reverse();
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) setState(() => _mostrarGlobo = false);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapCount++;

    if (_tapCount >= 2) {
      _tapCount = 0;
      widget.onAbrirChat();
      return;
    }

    // 1 tap — mostrar globo
    setState(() => _mostrarGlobo = true);
    _bubbleController.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _tapCount = 0;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _bubbleController.reverse();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _mostrarGlobo = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mensaje = _mensajes[DateTime.now().second % _mensajes.length];
    return Positioned(
      right: 16,
      bottom: 24,
      child: AnimatedBuilder(
        animation: _floatAnim,
        builder: (ctx, child) => Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_mostrarGlobo)
              FadeTransition(
                opacity: _bubbleOpacity,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 190),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF88).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    mensaje,
                    style: const TextStyle(
                      color: Color(0xFF0A0E1A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleTap,
              child: SizedBox(
                width: 80,
                height: 90,
                child: CustomPaint(
                  painter: FonMasterPainter(expresion: Expresion.feliz),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
