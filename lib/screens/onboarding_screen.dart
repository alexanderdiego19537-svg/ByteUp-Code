// onboarding_screen.dart — ¡Conociendo a tu nuevo Mentor!
// ═══════════════════════════════════════════════════════════════════════════
// ¿Eres un ninja del código o apenas estás descubriendo el teclado?
// Esta pantalla nos ayuda a saber quién eres para que Fon Master pueda
// guiarte de la mejor manera posible. ¡Es tu carta de presentación!
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/fon_master_widget.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color _fondoBase = Color(0xFF0D1117);
  static const Color _verdeColor = Color(0xFF00FF7F);
  static const Color _cianColor = Color(0xFF00E5FF);
  static const Color _cardColor = Color(0xFF161B22);

  int _paso = 0; // 0 = intro fon, 1-5 = preguntas, 6 = resultado
  int _puntaje = 0;
  int? _seleccionActual;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'texto': '¿Sabes qué es una variable en programación?',
      'opciones': ['Ni idea', 'Creo que es una caja para guardar datos', 'Sí, con tipado fuerte y débil'],
      'puntos': [0, 1, 2],
    },
    {
      'texto': '¿Qué hace un bucle (loop)?',
      'opciones': ['Pausa el programa', 'Repite código varias veces', 'Conecta con la base de datos'],
      'puntos': [0, 2, 0],
    },
    {
      'texto': '¿Has escrito código antes?',
      'opciones': ['Nunca', 'Solo un poco en la escuela', 'Sí, conozco al menos un lenguaje'],
      'puntos': [0, 1, 2],
    },
    {
      'texto': '¿Qué pasa si te olvidas de un punto y coma? (en C++ o Java)',
      'opciones': ['Nada', 'El programa tira error', 'La PC explota'],
      'puntos': [0, 2, 0],
    },
    {
      'texto': '¿Te gusta resolver problemas lógicos o rompecabezas?',
      'opciones': ['No mucho', 'Sí, son divertidos', 'Me encantan, es mi pasión'],
      'puntos': [0, 1, 2],
    },
  ];

  void _siguientePaso() {
    if (_paso > 0 && _paso <= _preguntas.length) {
      if (_seleccionActual != null) {
        _puntaje += _preguntas[_paso - 1]['puntos'][_seleccionActual!] as int;
        _seleccionActual = null;
      } else {
        return; // Debe seleccionar algo
      }
    }
    setState(() {
      _paso++;
    });
  }

  void _finalizar() async {
    final usuario = StorageService.cargarUsuario();
    if (usuario != null) {
      usuario.onboardingCompleto = true;
      if (_puntaje >= 8) {
        usuario.nivelDetectado = 2; // Avanzado
      } else if (_puntaje >= 4) {
        usuario.nivelDetectado = 1; // Intermedio
      } else {
        usuario.nivelDetectado = 0; // Principiante
      }
      await StorageService.guardarProgreso(usuario);
    }
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoBase,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildContenido(),
        ),
      ),
    );
  }

  Widget _buildContenido() {
    if (_paso == 0) {
      return _buildIntro();
    } else if (_paso <= _preguntas.length) {
      return _buildPregunta();
    } else {
      return _buildResultado();
    }
  }

  Widget _buildIntro() {
    return Padding(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200, width: 200,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _cardColor),
            child: CustomPaint(painter: FonMasterPainter()),
          ),
          const SizedBox(height: 40),
          const Text('¡Hola, soy Fon Master!', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20)),
            child: const TypewriterText(
              text: 'Seré tu tutor personal en este viaje. Antes de empezar, hagamos un pequeño test para ver por dónde debemos comenzar tu entrenamiento. ¿Listo?',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          const Spacer(),
          _buildBoton('¡Empezar!', _siguientePaso, _verdeColor),
        ],
      ),
    );
  }

  Widget _buildPregunta() {
    final pregunta = _preguntas[_paso - 1];
    final opciones = pregunta['opciones'] as List<String>;

    return Padding(
      key: ValueKey('pregunta_$_paso'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pregunta $_paso de ${_preguntas.length}', style: const TextStyle(color: _cianColor, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(pregunta['texto'] as String, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ...List.generate(opciones.length, (index) {
            bool seleccionado = _seleccionActual == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() => _seleccionActual = index);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: seleccionado ? Colors.white24 : _cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: seleccionado ? _verdeColor : Colors.transparent),
                  ),
                  child: Text(opciones[index], style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            );
          }),
          const Spacer(),
          if (_seleccionActual != null)
            _buildBoton('Siguiente', _siguientePaso, _verdeColor),
        ],
      ),
    );
  }

  Widget _buildResultado() {
    String nivelStr = 'Principiante';
    String mensaje = 'No te preocupes, ¡empezaremos desde cero! El Módulo 1 está hecho a tu medida.';
    if (_puntaje >= 8) {
      nivelStr = 'Avanzado';
      mensaje = '¡Vaya, ya sabes lo que haces! Podrás avanzar más rápido por la Etapa de Lógica y saltar a los Lenguajes.';
    } else if (_puntaje >= 4) {
      nivelStr = 'Intermedio';
      mensaje = 'Tienes una buena idea de cómo funciona esto. Haremos un repaso rápido de Lógica y estaremos listos.';
    }

    return Padding(
      key: const ValueKey('resultado'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.rocket_launch, color: _cianColor, size: 80),
          const SizedBox(height: 24),
          const Text('¡Evaluación Completa!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text('Tu nivel es:', style: const TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
          Text(nivelStr, style: const TextStyle(color: _verdeColor, fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
            child: Text(mensaje, style: const TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
          ),
          const Spacer(),
          _buildBoton('Ir a la academia', _finalizar, _cianColor),
        ],
      ),
    );
  }

  Widget _buildBoton(String texto, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        alignment: Alignment.center,
        child: Text(texto, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
