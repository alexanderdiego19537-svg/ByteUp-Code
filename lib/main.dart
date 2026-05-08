// main.dart
// ═══════════════════════════════════════════════════════════════════════════
// ¡BIENVENIDO A ByteUP Code! — El corazón de nuestra app
// ═══════════════════════════════════════════════════════════════════════════
// Este es el punto de inicio de toda la experiencia. Aquí preparamos el terreno,
// configuramos el estilo visual y lanzamos la pantalla de bienvenida.
// Si buscas las pantallas de la interfaz, date una vuelta por lib/screens/.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StorageService.inicializar();
  runApp(const ByteUpCodeApp());
}

// ─── Los Colores de nuestra Marca ───────────────────────────────────────────
class AppColors {
  static const fondo          = Color(0xFF0A0E1A);
  static const fondoCard      = Color(0xFF111627);
  static const verde          = Color(0xFF00FF88);
  static const verdeOscuro    = Color(0xFF00CC6A);
  static const cian           = Color(0xFF22D3EE);
  static const azulElectrico  = Color(0xFF4A7DFF);
  static const morado         = Color(0xFF8B5CF6);
  static const rosa           = Color(0xFFFF6B9D);
  static const amarillo       = Color(0xFFFFD93D);
  static const naranja        = Color(0xFFFF8C42);
}

// ─── La Raíz de la Aplicación ───────────────────────────────────────────────
class ByteUpCodeApp extends StatelessWidget {
  const ByteUpCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteUP Code',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.fondo,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.verde,
          secondary: AppColors.azulElectrico,
          surface: AppColors.fondoCard,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── Pantalla de Bienvenida (Splash) ─────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scaleAnim = CurvedAnimation(
        parent: _scaleController, curve: Curves.elasticOut);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
      // Saludamos al usuario con un sonido de bienvenida
      AudioService.playBienvenida();
    });

    // Esperamos 3 segundos para que el usuario disfrute la animación
    // y luego decidimos si mandarlo al inicio o a que se registre.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final destino = StorageService.existeUsuario()
          ? const HomeScreen()
          : const AuthScreen();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => destino,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: Stack(
        children: [
          const _ParticulasFondo(),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // El logo central con ese brillo que "late"
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: AnimatedBuilder(
                      animation: _glowAnim,
                      builder: (context, child) {
                        return Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0x4000FF88),
                                Color(0x1500FF88),
                                Colors.transparent,
                              ],
                              stops: [0.3, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.verde
                                    .withValues(alpha: 0.4 * _glowAnim.value),
                                blurRadius: 40 * _glowAnim.value,
                                spreadRadius: 8 * _glowAnim.value,
                              ),
                              BoxShadow(
                                color: AppColors.azulElectrico
                                    .withValues(alpha: 0.15 * _glowAnim.value),
                                blurRadius: 60 * _glowAnim.value,
                                spreadRadius: 15 * _glowAnim.value,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1A2340), Color(0xFF0F1628)],
                              ),
                              border: Border.all(
                                color: AppColors.verde.withValues(alpha: 0.5),
                                width: 2.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '</>',
                                style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.verde,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                        color: AppColors.verde,
                                        blurRadius: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 36),

                  // El nombre de la app con un degradado moderno
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.verde, AppColors.cian],
                    ).createShader(bounds),
                    child: const Text(
                      'ByteUP Code',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Aprende a programar jugando',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.45),
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Una barrita de carga para que no parezca que se trabó
                  SizedBox(
                    width: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: Color(0xFF1A2040),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.verde),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Esas Partículas Mágicas que flotan al fondo ───────────────────────────
class _ParticulasFondo extends StatefulWidget {
  const _ParticulasFondo();

  @override
  State<_ParticulasFondo> createState() => _ParticulasFondoState();
}

class _ParticulasFondoState extends State<_ParticulasFondo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particula> _particulas;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particulas = List.generate(25, (_) => _Particula(rng));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticulasPainter(_particulas, _controller.value),
        );
      },
    );
  }
}

class _Particula {
  final double x, y, radio, velocidad, opacidad;

  _Particula(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        radio = rng.nextDouble() * 3 + 1,
        velocidad = rng.nextDouble() * 0.3 + 0.1,
        opacidad = rng.nextDouble() * 0.3 + 0.05;
}

class _ParticulasPainter extends CustomPainter {
  final List<_Particula> particulas;
  final double progreso;

  _ParticulasPainter(this.particulas, this.progreso);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particulas) {
      final y = (p.y + progreso * p.velocidad) % 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.radio,
        Paint()
          ..color = AppColors.verde.withValues(alpha: p.opacidad)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticulasPainter old) => true;
}
