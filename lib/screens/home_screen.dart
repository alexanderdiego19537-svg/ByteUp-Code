import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/game_service.dart';

import '../widgets/background_particles.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/fon_master_widget.dart';

import 'learn_screen.dart';
import 'profile_screen.dart';
import 'ranking_screen.dart';
import 'ai_tutor_screen.dart';
import 'dev_studio_screen.dart';
import '../widgets/racha_animacion.dart';

// home_screen.dart — ¡Tu Centro de Comando!
// ═══════════════════════════════════════════════════════════════════════════
// ¡Bienvenido a casa, programador! Esta es la pantalla principal donde puedes
// ver tu rango, los lenguajes que estás dominando y los retos diarios.
// Es tu punto de partida para convertirte en un Master Elite.
// ═══════════════════════════════════════════════════════════════════════════

const _fondo = Color(0xFF0A0E1A);
const _fondoCard = Color(0xFF111627);
const _verde = Color(0xFF00FF88);
const _cian = Color(0xFF22D3EE);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  UserModel? _usuario;
  bool _cargando = true;

  late AnimationController _entradaController;
  late List<Animation<double>> _fadeAnimaciones;
  late AnimationController _neonController;
  late Animation<double> _neonAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  int _tabActivo = 0;
  bool _mostrarAnimacionRacha = false;

  // Posición inicial de Fon Master
  double _fonX = 280;
  double _fonY = 500;

  // Mapa de escalas para cada tarjeta de lenguaje
  final Map<String, double> _escalas = {};

  static const _lenguajes = [
    {
      'id': 'python',
      'nombre': 'Python',
      'sub': 'Domina el código más popular',
      'emoji': '🐍',
      'color1': Color(0xFF3B82F6),
      'color2': Color(0xFF1D4ED8),
    },
    {
      'id': 'javascript',
      'nombre': 'JavaScript',
      'sub': 'Crea interactividad web',
      'emoji': '⚡',
      'color1': Color(0xFFF59E0B),
      'color2': Color(0xFFD97706),
    },
    {
      'id': 'java',
      'nombre': 'Java',
      'sub': 'Desarrollo corporativo y móvil',
      'emoji': '☕',
      'color1': Color(0xFFEF4444),
      'color2': Color(0xFFB91C1C),
    },
    {
      'id': 'cpp',
      'nombre': 'C++',
      'sub': 'Máximo rendimiento',
      'emoji': '⚙️',
      'color1': Color(0xFF8B5CF6),
      'color2': Color(0xFF6D28D9),
    },
  ];

  static const _desafios = [
    {'titulo': '¿Qué imprime?', 'codigo': 'print([x*2 for x in range(3)])', 'respuesta': '[0, 2, 4]', 'lenguaje': '🐍 Python'},
    {'titulo': '¿Resultado?', 'codigo': 'console.log(typeof null)', 'respuesta': '"object"', 'lenguaje': '⚡ JavaScript'},
    {'titulo': '¿Método?', 'codigo': '"Hello".charAt(1)', 'respuesta': '"e"', 'lenguaje': '⚡ JavaScript'},
    {'titulo': '¿Valor de i?', 'codigo': 'int i = 10;\ni += i--;', 'respuesta': '20', 'lenguaje': '☕ Java'},
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAnimaciones();
    _cargarDatos();
  }

  void _inicializarAnimaciones() {
    _entradaController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeAnimaciones = List.generate(5, (i) {
      final inicio = i * 0.12;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entradaController, curve: Interval(inicio, (inicio + 0.4).clamp(0, 1), curve: Curves.easeOut)),
      );
    });

    _neonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _neonAnim = Tween<double>(begin: 4, end: 18).animate(CurvedAnimation(parent: _neonController, curve: Curves.easeInOut));

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.03).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  Future<void> _cargarDatos() async {
    var usuario = StorageService.cargarUsuario() ?? UserModel(nombre: 'Dev');
    GameService.regenerarCorazones(usuario);
    final rachaInfo = GameService.verificarStreak(usuario);
    await StorageService.guardarUsuario(usuario);

    if (mounted) {
      setState(() {
        _usuario = usuario;
        _cargando = false;
        if (rachaInfo['rachaActualizada'] == true) {
          _mostrarAnimacionRacha = true;
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              setState(() => _mostrarAnimacionRacha = false);
            }
          });
        }
      });
      _entradaController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _neonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _desafioDeHoy {
    final dif = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1));
    return _desafios[dif.inDays % _desafios.length];
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const Scaffold(backgroundColor: _fondo, body: Center(child: CircularProgressIndicator(color: _verde)));

    final usuario = _usuario!;

    return Scaffold(
      backgroundColor: _fondo,
      body: Stack(
        children: [
          const BackgroundParticles(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(usuario),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimaciones[0],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _verde.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _verde.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 6, height: 6, decoration: BoxDecoration(color: _verde, shape: BoxShape.circle, boxShadow: [BoxShadow(color: _verde.withOpacity(0.8), blurRadius: 6)])),
                                  const SizedBox(width: 6),
                                  const Text('SESIÓN ACTIVA', style: TextStyle(color: _verde, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TypewriterText(
                              text: '¡Hola, ${usuario.nombre}!',
                              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                              duration: const Duration(milliseconds: 1200),
                            ),
                            const SizedBox(height: 4),
                            Text('¿Qué vas a programar hoy? 🚀', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.55))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _fadeAnimaciones[1],
                        child: _buildCardNeon(usuario),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimaciones[2],
                        child: Row(
                          children: [
                            Container(width: 4, height: 22, decoration: BoxDecoration(gradient: const LinearGradient(colors: [_verde, _cian], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(4))),
                            const SizedBox(width: 10),
                            const Text('Elige tu tecnología', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                            const Spacer(),
                            Text('4 cursos', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _fadeAnimaciones[2],
                        child: _buildListaLenguajes(usuario),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimaciones[3],
                        child: _buildDesafioDia(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 20, right: 20, bottom: 30,
            child: _buildNavbar(),
          ),

          Positioned(
            left: _fonX,
            top: _fonY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _fonX += details.delta.dx;
                  _fonY += details.delta.dy;
                });
              },
              onTap: () {},
              onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AITutorScreen())),
              child: const FonMasterWidget(expresion: Expresion.feliz, mensaje: '¡Doble tap para chatear!'),
            ),
          ),

          if (_mostrarAnimacionRacha)
            RachaAnimacion(rachaInfo: _usuario!.streakActual),
        ],
      ),
    );
  }

  Widget _buildHeader(UserModel usuario) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0E1A).withOpacity(0.85),
                const Color(0xFF0D1F2D).withOpacity(0.75),
              ],
            ),
            border: Border(
              bottom: BorderSide(color: _verde.withOpacity(0.12), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))
                      .then((_) => _cargarDatos());
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: _verde.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [_verde, _cian])),
                        child: Center(child: Text(usuario.iniciales, style: const TextStyle(fontWeight: FontWeight.w900, color: _fondo, fontSize: 16))),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(usuario.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(usuario.rango.nombre, style: const TextStyle(color: _verde, fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _mostrarDialogRacha(context, usuario),
                      child: _chipTop('🔥', '${usuario.streakActual}', const Color(0xFFFF6B6B)),
                    ),
                    const SizedBox(width: 6),
                    _chipTop('❤️', '${usuario.corazones}', const Color(0xFFFF4B8C)),
                    const SizedBox(width: 6),
                    _chipTop('⚡', '${usuario.xpTotal}', _verde),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipTop(String emoji, String text, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: _fondoCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 48),
            child: Text(
              text,
              style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNeon(UserModel usuario) {
    return AnimatedBuilder(
      animation: _neonAnim,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF111D35), Color(0xFF0D1F2D), Color(0xFF111627)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _verde.withOpacity(0.35 + (_neonAnim.value - 4) / 50),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(color: _verde.withOpacity(0.18), blurRadius: _neonAnim.value * 2, spreadRadius: _neonAnim.value * 0.2),
              BoxShadow(color: _cian.withOpacity(0.06), blurRadius: _neonAnim.value * 3, spreadRadius: 0),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [_verde.withOpacity(0.25), _verde.withOpacity(0.05)]),
                  border: Border.all(color: _verde.withOpacity(0.7), width: 2.5),
                  boxShadow: [BoxShadow(color: _verde.withOpacity(0.3), blurRadius: 16, spreadRadius: 2)],
                ),
                child: Center(child: Text(usuario.rango.emoji, style: const TextStyle(fontSize: 36))),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('RANGO ACTUAL', style: TextStyle(color: _verde.withOpacity(0.7), fontWeight: FontWeight.w900, letterSpacing: 2.5, fontSize: 10)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _verde.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _verde.withOpacity(0.3)),
                          ),
                          child: Text('${usuario.xpTotal} XP', style: const TextStyle(color: _verde, fontSize: 11, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      usuario.rango.nombre.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: -0.5,
                        shadows: [Shadow(color: Color(0xFF00FF88), blurRadius: 12)],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(height: 10, decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(10))),
                        FractionallySizedBox(
                          widthFactor: usuario.progresoRango,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [_verde, _cian]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: _verde.withOpacity(0.5), blurRadius: 8)],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Faltan ${(usuario.rango.xpMaximo + 1) - usuario.xpTotal} XP para subir',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListaLenguajes(UserModel usuario) {
    return Column(
      children: _lenguajes.map((lang) {
        final progreso = usuario.progresoLenguajes[lang['id']] ?? 0.0;
        final color1 = lang['color1'] as Color;
        final color2 = lang['color2'] as Color;
        final langId = lang['id'] as String;
        final escala = _escalas[langId] ?? 1.0;

        return GestureDetector(
          onTapDown: (_) => setState(() => _escalas[langId] = 0.95),
          onTapUp: (_) {
            setState(() => _escalas[langId] = 1.0);
            Navigator.push(context, MaterialPageRoute(builder: (_) => LearnScreen(startLang: langId))).then((_) => _cargarDatos());
          },
          onTapCancel: () => setState(() => _escalas[langId] = 1.0),
          child: AnimatedScale(
            scale: escala,
            duration: const Duration(milliseconds: 100),
            child: Container(
              height: 88,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color1.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8, bottom: -16,
                    child: Opacity(
                      opacity: 0.25,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Text(lang['emoji'] as String, style: const TextStyle(fontSize: 72)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                          child: Text(lang['emoji'] as String, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lang['nombre'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              Text(lang['sub'] as String, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: progreso,
                                        backgroundColor: Colors.black.withOpacity(0.2),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                        minHeight: 5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text('${(progreso * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList().cast<Widget>(),
    );
  }

  Widget _buildDesafioDia() {
    final desafio = _desafioDeHoy;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF111D35), _fondoCard],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _verde.withOpacity(0.35), width: 1.5),
          boxShadow: [BoxShadow(color: _verde.withOpacity(0.08), blurRadius: 24, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_verde.withOpacity(0.15), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _verde.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.flash_on_rounded, color: _verde, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Desafío del Día', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                      Text('RETO DIARIO', style: TextStyle(color: _verde, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_verde, _cian]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: _verde.withOpacity(0.35), blurRadius: 10)],
                    ),
                    child: const Text('+50 XP', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desafio['titulo'] as String, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 15)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cian.withOpacity(0.2)),
                      boxShadow: [BoxShadow(color: _cian.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Text(desafio['codigo'] as String, style: const TextStyle(fontFamily: 'monospace', color: _cian, fontSize: 15, height: 1.5)),
                  ),
                  const SizedBox(height: 16),
                  if (_desafioCompletadoHoy)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _verde.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _verde.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: _verde, size: 18),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Desafío completado — vuelve mañana',
                              style: TextStyle(color: _verde, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _mostrarDesafioDiaDialog(context, desafio),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: _verde,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: _verde),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow_rounded, size: 20),
                            SizedBox(width: 6),
                            Text('Atacar Desafío', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    final tabs = [
      {'i': Icons.home_rounded, 'l': 'Inicio'},
      {'i': Icons.school_rounded, 'l': 'Aprender'},
      {'i': Icons.code_rounded, 'l': 'Studio'},
      {'i': Icons.leaderboard_rounded, 'l': 'Ranking'},
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1420).withOpacity(0.92),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 10)),
              BoxShadow(color: _verde.withOpacity(0.06), blurRadius: 20),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final activo = _tabActivo == i;
              final esStudio = i == 2;
              final colorActivo = esStudio ? _cian : _verde;
              return GestureDetector(
                onTap: () {
                  setState(() => _tabActivo = i);
                  if (i == 1) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnScreen())).then((_) { _cargarDatos(); setState(() => _tabActivo = 0); });
                  } else if (i == 2) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DevStudioScreen())).then((_) { setState(() => _tabActivo = 0); });
                  } else if (i == 3) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RankingScreen())).then((_) { _cargarDatos(); setState(() => _tabActivo = 0); });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: activo
                        ? LinearGradient(
                            colors: [colorActivo.withOpacity(0.25), colorActivo.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(22),
                    border: activo ? Border.all(color: colorActivo.withOpacity(0.4), width: 1) : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i]['i'] as IconData, color: activo ? colorActivo : Colors.white30, size: 20),
                      const SizedBox(height: 3),
                      Text(
                        tabs[i]['l'] as String,
                        style: TextStyle(
                          color: activo ? _verde : Colors.white30,
                          fontSize: 10,
                          fontWeight: activo ? FontWeight.w900 : FontWeight.w500,
                          letterSpacing: activo ? 0.5 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogRacha(BuildContext context, UserModel usuario) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: _fondoCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: const Color(0xFFFF6B6B).withOpacity(0.5))),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF6B6B), size: 60),
                const SizedBox(height: 16),
                Text('Racha Actual: ${usuario.streakActual} días 🔥', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Mejor Racha Histórica: ${usuario.mejorStreak} días', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (i) {
                    final dia = DateTime.now().subtract(Duration(days: 6 - i));
                    bool activo = i >= (7 - usuario.streakActual);
                    return Column(
                      children: [
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: activo ? const Color(0xFFFF6B6B) : Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(activo ? Icons.check_rounded : Icons.close_rounded, size: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dia.weekday == 1 ? 'L' : (dia.weekday == 2 ? 'M' : (dia.weekday == 3 ? 'X' : (dia.weekday == 4 ? 'J' : (dia.weekday == 5 ? 'V' : (dia.weekday == 6 ? 'S' : 'D'))))),
                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                  child: const Text('¡Sigue así programador! La consistencia es la clave del Master Elite.', textAlign: TextAlign.center, style: TextStyle(color: _verde, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: _verde, foregroundColor: Colors.black),
                  child: const Text('¡A programar!'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _desafioCompletadoHoy = false;

  void _mostrarDesafioDiaDialog(BuildContext context, Map<String, dynamic> desafio) {
    if (_desafioCompletadoHoy) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Ya completaste el desafío de hoy! Vuelve mañana.', style: TextStyle(color: Colors.white))));
      return;
    }

    List<String> opciones = [desafio['respuesta'] as String];
    if (desafio['respuesta'] == '"object"') {
      opciones.addAll(['"null"', '"undefined"', 'Error']);
    } else if (desafio['respuesta'] == '[0, 2, 4]') {
      opciones.addAll(['[0, 1, 2]', '[2, 4, 6]', 'Error']);
    } else if (desafio['respuesta'] == '"e"') {
      opciones.addAll(['"H"', '"l"', 'null']);
    } else if (desafio['respuesta'] == '20') {
      opciones.addAll(['10', '19', '21']);
    } else {
      opciones.addAll(['Opción B', 'Opción C', 'Opción D']);
    }
    opciones.shuffle();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return _DesafioDialog(
          desafio: desafio,
          opciones: opciones,
          onSuccess: () async {
            Navigator.pop(ctx);
            _desafioCompletadoHoy = true;
            _usuario!.xpTotal += 50;
            _usuario!.rango = Rango.desdeXP(_usuario!.xpTotal);
            await StorageService.guardarUsuario(_usuario!);
            if (mounted) setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: _verde, content: const Text('¡Excelente! +50 XP 🚀', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            );
          },
        );
      },
    );
  }
}

class _DesafioDialog extends StatefulWidget {
  final Map<String, dynamic> desafio;
  final List<String> opciones;
  final VoidCallback onSuccess;

  const _DesafioDialog({required this.desafio, required this.opciones, required this.onSuccess});

  @override
  State<_DesafioDialog> createState() => _DesafioDialogState();
}

class _DesafioDialogState extends State<_DesafioDialog> {
  int? _seleccion;
  bool _animando = false;
  String? _errorMsj;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _fondoCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: _verde.withOpacity(0.5))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.flash_on_rounded, color: _verde),
                SizedBox(width: 8),
                Text('Desafío Especial', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.desafio['titulo'] as String, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
              child: Text(widget.desafio['codigo'] as String, style: const TextStyle(fontFamily: 'monospace', color: _cian, fontSize: 16)),
            ),
            const SizedBox(height: 24),
            ...List.generate(widget.opciones.length, (idx) {
              bool seleccionado = _seleccion == idx;
              bool correcta = widget.opciones[idx] == widget.desafio['respuesta'];
              Color btnColor = Colors.white10;

              if (_animando && seleccionado) {
                btnColor = correcta ? _verde : const Color(0xFFFF4C4C);
              } else if (seleccionado) {
                btnColor = Colors.white24;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: _animando ? null : () => setState(() { _seleccion = idx; _errorMsj = null; }),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.circular(12)),
                    child: Text(widget.opciones[idx], style: const TextStyle(color: Colors.white)),
                  ),
                ),
              );
            }),
            if (_errorMsj != null) ...[
              const SizedBox(height: 8),
              Text(_errorMsj!, style: const TextStyle(color: Color(0xFFFF4C4C), fontSize: 14), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: _animando ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: (_seleccion == null || _animando) ? null : () async {
                    setState(() => _animando = true);
                    bool correcta = widget.opciones[_seleccion!] == widget.desafio['respuesta'];
                    await Future.delayed(const Duration(seconds: 1));
                    if (correcta) {
                      widget.onSuccess();
                    } else {
                      setState(() {
                        _animando = false;
                        _errorMsj = '¡Respuesta incorrecta!\nLa respuesta era: ${widget.desafio["respuesta"]}';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: _verde, foregroundColor: Colors.black),
                  child: const Text('Responder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}