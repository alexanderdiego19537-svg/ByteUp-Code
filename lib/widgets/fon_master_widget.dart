// fon_master_widget.dart
// ═══════════════════════════════════════════════════════════════════════════
// EL ALMA DE ByteUP — Tu tutor personal, Fon Master
// ═══════════════════════════════════════════════════════════════════════════
// Conoce a Fon Master: un experto en código, paciente y divertido. Aquí es
// donde dibujamos su rostro, sus expresiones y sus globos de texto motivadores.

import 'dart:math';
import 'package:flutter/material.dart';

// ─── Expresiones que puede tener Fon Master ─────────────────────────────────
enum Expresion { feliz, sorprendido, triste, celebrando }

// ─── Widget principal de Fon Master ─────────────────────────────────────────
// Uso: FonMasterWidget(mensaje: "¡Vamos!", expresion: Expresion.feliz)
class FonMasterWidget extends StatefulWidget {
  final String mensaje;
  final Expresion expresion;
  final VoidCallback? onTap;

  const FonMasterWidget({
    super.key,
    this.mensaje = '¿Listo para aprender? 🚀',
    this.expresion = Expresion.feliz,
    this.onTap,
  });

  @override
  State<FonMasterWidget> createState() => _FonMasterWidgetState();
}

class _FonMasterWidgetState extends State<FonMasterWidget>
    with TickerProviderStateMixin {
  // Animación de flotación — sube y baja suavemente
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Animación del globo de diálogo — aparece con fade
  late AnimationController _bubbleController;
  late Animation<double> _bubbleOpacity;

  // Controla si el globo está visible o no
  bool _mostrarGlobo = true;

  @override
  void initState() {
    super.initState();

    // Flotación continua: 2 segundos arriba, 2 abajo, para siempre
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // El globo aparece con un fade suave
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bubbleOpacity = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.easeIn,
    );

    // Mostramos el globo al arrancar después de un ratito
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _bubbleController.forward();
    });

    // Después de 6 segundos ocultamos el globo para que no estorbe
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        _bubbleController.reverse();
        setState(() => _mostrarGlobo = false);
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  // Cuando el usuario toca a Fon Master
  void _alTocar() {
    // Si hay callback personalizado, lo ejecutamos
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    // Si no, mostramos el SnackBar clásico de Fon Master
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '¡Hola! Soy Fon Master, tu tutor 🤓',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1A1F35),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    // Mostramos de nuevo el globo si estaba oculto
    if (!_mostrarGlobo) {
      setState(() => _mostrarGlobo = true);
      _bubbleController.forward();
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          _bubbleController.reverse();
          setState(() => _mostrarGlobo = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retorna el contenido directamente (sin Positioned)
    // El widget puede usarse en Stack, Column, Center, etc.
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Globo de diálogo
          if (_mostrarGlobo)
            FadeTransition(
              opacity: _bubbleOpacity,
              child: _GloboDialogo(mensaje: widget.mensaje),
            ),
          const SizedBox(height: 6),
          // El personaje
          GestureDetector(
            onTap: _alTocar,
            child: SizedBox(
              width: 80,
              height: 90,
              child: CustomPaint(
                painter: FonMasterPainter(expresion: widget.expresion),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Globo de diálogo ───────────────────────────────────────────────────────
// Burbuja blanca arriba de Fon Master con su mensaje
class _GloboDialogo extends StatelessWidget {
  final String mensaje;

  const _GloboDialogo({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF88).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        mensaje,
        style: const TextStyle(
          color: Color(0xFF0A0E1A),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── CustomPainter de Fon Master ────────────────────────────────────────────
// Aquí es donde dibujamos al personaje pixel por pixel:
// Gordito, lentes semi-oscuros, barba cerrada, ropa colorida
class FonMasterPainter extends CustomPainter {
  final Expresion expresion;

  FonMasterPainter({required this.expresion});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // ── Cuerpo (gordito con ropa colorida) ──
    final cuerpoPaint = Paint()..color = const Color(0xFF00CC6A);
    // Torso gordito — rectángulo redondeado grande
    final cuerpoRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY + 18),
        width: 52,
        height: 42,
      ),
      const Radius.circular(16),
    );
    canvas.drawRRect(cuerpoRect, cuerpoPaint);

    // Detalle del cuello de la camiseta
    final cuelloPaint = Paint()..color = const Color(0xFF00AA55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 1),
          width: 22,
          height: 10,
        ),
        const Radius.circular(5),
      ),
      cuelloPaint,
    );

    // ── Cabeza (cara redonda, gordita) ──
    final pielPaint = Paint()..color = const Color(0xFFE8B87A);
    // Cara redonda del gordito
    canvas.drawCircle(Offset(centerX, centerY - 12), 22, pielPaint);

    // ── Barba cerrada (sombra oscura en la parte baja de la cara) ──
    final barbaPaint = Paint()..color = const Color(0xFF4A3728);
    // Arco de barba en la mandíbula
    final barbaPath = Path()
      ..moveTo(centerX - 16, centerY - 6)
      ..quadraticBezierTo(centerX - 18, centerY + 6, centerX - 10, centerY + 8)
      ..quadraticBezierTo(centerX, centerY + 12, centerX + 10, centerY + 8)
      ..quadraticBezierTo(centerX + 18, centerY + 6, centerX + 16, centerY - 6)
      ..quadraticBezierTo(centerX, centerY + 2, centerX - 16, centerY - 6)
      ..close();
    canvas.drawPath(barbaPath, barbaPaint);

    // ── Lentes semi-oscuros ──
    final lentesPaint = Paint()
      ..color = const Color(0xFF2A2A3A).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    final lentesMarco = Paint()
      ..color = const Color(0xFF1A1A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Lente izquierdo
    final lenteIzq = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX - 10, centerY - 14),
        width: 16,
        height: 12,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(lenteIzq, lentesPaint);
    canvas.drawRRect(lenteIzq, lentesMarco);

    // Lente derecho
    final lenteDer = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX + 10, centerY - 14),
        width: 16,
        height: 12,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(lenteDer, lentesPaint);
    canvas.drawRRect(lenteDer, lentesMarco);

    // Puente entre los lentes
    canvas.drawLine(
      Offset(centerX - 2, centerY - 14),
      Offset(centerX + 2, centerY - 14),
      lentesMarco,
    );

    // Patillas de los lentes
    canvas.drawLine(
      Offset(centerX - 18, centerY - 14),
      Offset(centerX - 22, centerY - 16),
      lentesMarco,
    );
    canvas.drawLine(
      Offset(centerX + 18, centerY - 14),
      Offset(centerX + 22, centerY - 16),
      lentesMarco,
    );

    // ── Ojitos detrás de los lentes (cambian con la expresión) ──
    final ojoPaint = Paint()..color = Colors.white;
    final pupilaPaint = Paint()..color = const Color(0xFF1A1A2A);

    // Los ojos cambian según la expresión
    switch (expresion) {
      case Expresion.feliz:
        // Ojitos felices — arcos curvos hacia arriba (sonriendo)
        final ojoFeliz = Paint()
          ..color = const Color(0xFF1A1A2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
        // Ojo izquierdo — arquito feliz
        final arcoIzq = Path()
          ..moveTo(centerX - 14, centerY - 14)
          ..quadraticBezierTo(centerX - 10, centerY - 18, centerX - 6, centerY - 14);
        canvas.drawPath(arcoIzq, ojoFeliz);
        // Ojo derecho — arquito feliz
        final arcoDer = Path()
          ..moveTo(centerX + 6, centerY - 14)
          ..quadraticBezierTo(centerX + 10, centerY - 18, centerX + 14, centerY - 14);
        canvas.drawPath(arcoDer, ojoFeliz);

      case Expresion.sorprendido:
        // Ojos bien abiertos — círculos grandes
        canvas.drawCircle(Offset(centerX - 10, centerY - 14), 5, ojoPaint);
        canvas.drawCircle(Offset(centerX - 10, centerY - 14), 3, pupilaPaint);
        canvas.drawCircle(Offset(centerX + 10, centerY - 14), 5, ojoPaint);
        canvas.drawCircle(Offset(centerX + 10, centerY - 14), 3, pupilaPaint);

      case Expresion.triste:
        // Ojitos tristes — arcos curvos hacia abajo
        final ojoTriste = Paint()
          ..color = const Color(0xFF1A1A2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
        final arcoTristeIzq = Path()
          ..moveTo(centerX - 14, centerY - 16)
          ..quadraticBezierTo(centerX - 10, centerY - 12, centerX - 6, centerY - 16);
        canvas.drawPath(arcoTristeIzq, ojoTriste);
        final arcoTristeDer = Path()
          ..moveTo(centerX + 6, centerY - 16)
          ..quadraticBezierTo(centerX + 10, centerY - 12, centerX + 14, centerY - 16);
        canvas.drawPath(arcoTristeDer, ojoTriste);

      case Expresion.celebrando:
        // Ojos de estrella — celebrando a lo grande
        _dibujarEstrella(canvas, Offset(centerX - 10, centerY - 14), 5,
            const Color(0xFFFFD700));
        _dibujarEstrella(canvas, Offset(centerX + 10, centerY - 14), 5,
            const Color(0xFFFFD700));
    }

    // ── Boca (también cambia con la expresión) ──
    final bocaPaint = Paint()
      ..color = const Color(0xFF1A1A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    switch (expresion) {
      case Expresion.feliz:
        // Sonrisa grande y amigable
        final sonrisa = Path()
          ..moveTo(centerX - 8, centerY - 3)
          ..quadraticBezierTo(centerX, centerY + 4, centerX + 8, centerY - 3);
        canvas.drawPath(sonrisa, bocaPaint);

      case Expresion.sorprendido:
        // Boca en "O" de sorpresa
        canvas.drawCircle(
          Offset(centerX, centerY - 1),
          4,
          Paint()
            ..color = const Color(0xFF1A1A2A)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

      case Expresion.triste:
        // Mueca triste hacia abajo
        final triste = Path()
          ..moveTo(centerX - 6, centerY)
          ..quadraticBezierTo(centerX, centerY - 4, centerX + 6, centerY);
        canvas.drawPath(triste, bocaPaint);

      case Expresion.celebrando:
        // Sonrisota de oreja a oreja — ¡Exelente!
        final mega = Path()
          ..moveTo(centerX - 10, centerY - 4)
          ..quadraticBezierTo(centerX, centerY + 6, centerX + 10, centerY - 4);
        canvas.drawPath(mega, bocaPaint);
        // Dientes de la sonrisa
        canvas.drawLine(
          Offset(centerX - 4, centerY - 1),
          Offset(centerX + 4, centerY - 1),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round,
        );
    }

    // ── Cabello corto arriba ──
    final cabelloPaint = Paint()..color = const Color(0xFF2A1F14);
    final cabeloPath = Path()
      ..moveTo(centerX - 20, centerY - 22)
      ..quadraticBezierTo(centerX - 18, centerY - 36, centerX, centerY - 34)
      ..quadraticBezierTo(centerX + 18, centerY - 36, centerX + 20, centerY - 22)
      ..quadraticBezierTo(centerX + 14, centerY - 30, centerX, centerY - 29)
      ..quadraticBezierTo(centerX - 14, centerY - 30, centerX - 20, centerY - 22)
      ..close();
    canvas.drawPath(cabeloPath, cabelloPaint);

    // ── Bracitos gorditos a los lados ──
    final brazoPaint = Paint()
      ..color = const Color(0xFF00CC6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Brazo izquierdo
    canvas.drawLine(
      Offset(centerX - 24, centerY + 12),
      Offset(centerX - 32, centerY + 22),
      brazoPaint,
    );
    // Manita izquierda
    canvas.drawCircle(
      Offset(centerX - 33, centerY + 24),
      5,
      Paint()..color = const Color(0xFFE8B87A),
    );

    // Brazo derecho
    if (expresion == Expresion.celebrando) {
      // Cuando celebra, levanta el brazo derecho — ¡Exelente!
      canvas.drawLine(
        Offset(centerX + 24, centerY + 12),
        Offset(centerX + 34, centerY - 2),
        brazoPaint,
      );
      canvas.drawCircle(
        Offset(centerX + 35, centerY - 4),
        5,
        Paint()..color = const Color(0xFFE8B87A),
      );
    } else {
      // Brazo normal relajado
      canvas.drawLine(
        Offset(centerX + 24, centerY + 12),
        Offset(centerX + 32, centerY + 22),
        brazoPaint,
      );
      canvas.drawCircle(
        Offset(centerX + 33, centerY + 24),
        5,
        Paint()..color = const Color(0xFFE8B87A),
      );
    }

    // ── Brillo en los lentes (detalle de estilo) ──
    final brilloPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX - 13, centerY - 17), 2, brilloPaint);
    canvas.drawCircle(Offset(centerX + 7, centerY - 17), 2, brilloPaint);

    // ── Mejillas sonrojadas cuando está feliz o celebrando ──
    if (expresion == Expresion.feliz || expresion == Expresion.celebrando) {
      final mejillaPaint = Paint()
        ..color = const Color(0xFFFF8C8C).withValues(alpha: 0.4);
      canvas.drawCircle(Offset(centerX - 16, centerY - 5), 4, mejillaPaint);
      canvas.drawCircle(Offset(centerX + 16, centerY - 5), 4, mejillaPaint);
    }
  }

  // Dibuja una estrellita en los ojos cuando celebra
  void _dibujarEstrella(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;
      final outerPoint = Offset(
        center.dx + radius * cos(outerAngle),
        center.dy + radius * sin(outerAngle),
      );
      final innerPoint = Offset(
        center.dx + (radius * 0.4) * cos(innerAngle),
        center.dy + (radius * 0.4) * sin(innerAngle),
      );
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FonMasterPainter oldDelegate) {
    return oldDelegate.expresion != expresion;
  }
}

// ─── Mensajes predeterminados de Fon Master ─────────────────────────────────
// Se usan cuando no se pasa un mensaje específico al widget
class FonMasterMensajes {
  static const bienvenida = '¿Listo para aprender? 🚀';
  static const animo = '¡Vamos que puedes! 💪';
  static const exelente = '¡Exelente! 🎉';  // Su frase insignia (así, sin tilde)
  static const error = 'No te preocupes, ¡intentalo de nuevo! 💡';
  static const racha = '¡Tu racha está increíble! 🔥';
  static const despedida = '¡Nos vemos mañana, Dev! 👋';

  // Devuelve un mensaje aleatorio de ánimo
  static String aleatorio() {
    final mensajes = [bienvenida, animo, exelente, racha];
    return mensajes[Random().nextInt(mensajes.length)];
  }
  
}
