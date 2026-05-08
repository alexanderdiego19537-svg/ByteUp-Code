// draggable_fon_master.dart
// ═══════════════════════════════════════════════════════════════════════════
// FON MASTER A TU LADO — El tutor que puedes mover a tu antojo
// ═══════════════════════════════════════════════════════════════════════════
// Fon Master te acompaña a todas partes. Puedes arrastrarlo por la pantalla y,
// si tocas dos veces sobre él, ¡se abrirá el chat para que le preguntes lo que quieras!

import 'dart:math';
import 'package:flutter/material.dart';
import 'fon_master_widget.dart'; // reutiliza el enum Expresion

class DraggableFonMaster extends StatefulWidget {
  final VoidCallback? onChatTap;
  final String mensaje;
  final Expresion expresion;

  const DraggableFonMaster({
    super.key,
    this.onChatTap,
    this.mensaje = '¡Toca 2 veces para hablar! 💬',
    this.expresion = Expresion.feliz,
  });

  @override
  State<DraggableFonMaster> createState() => _DraggableFonMasterState();
}

class _DraggableFonMasterState extends State<DraggableFonMaster>
    with TickerProviderStateMixin {
  // Posición — se inicializa en la primera build
  double _x = -1;
  double _y = -1;
  bool _initialized = false;

  // Detección de doble tap
  DateTime? _lastTap;

  // Animación de flotación suave
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  // Globo de diálogo
  late AnimationController _bubbleCtrl;
  late Animation<double> _bubbleOpacity;
  bool _mostrarGlobo = true;

  @override
  void initState() {
    super.initState();

    // Flotación continua: igual que el original
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // Globo con fade suave
    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bubbleOpacity =
        CurvedAnimation(parent: _bubbleCtrl, curve: Curves.easeIn);

    // Aparece el globo al inicio
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _bubbleCtrl.forward();
    });
    // Desaparece a los 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _bubbleCtrl.reverse();
        setState(() => _mostrarGlobo = false);
      }
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _bubbleCtrl.dispose();
    super.dispose();
  }

  void _init(BuildContext context) {
    if (_initialized) return;
    final size = MediaQuery.of(context).size;
    _x = size.width - 110;
    _y = size.height - 220;
    _initialized = true;
  }

  void _onTap() {
    final now = DateTime.now();
    if (_lastTap != null && now.difference(_lastTap!).inMilliseconds < 400) {
      // ─── Doble tap: abrir chat ───────────────────────────────────────
      _lastTap = null;
      if (widget.onChatTap != null) {
        widget.onChatTap!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '¡Hola! Soy Fon Master 🤓  El chat llega muy pronto 💬',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF111627),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      // ─── Primer tap: mostrar/ocultar globo ──────────────────────────
      _lastTap = now;
      if (!_mostrarGlobo) {
        setState(() => _mostrarGlobo = true);
        _bubbleCtrl.forward();
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _bubbleCtrl.reverse();
            setState(() => _mostrarGlobo = false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    if (!_initialized) return const SizedBox.shrink();

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onTap: _onTap,
        onPanUpdate: (details) {
          final size = MediaQuery.of(context).size;
          setState(() {
            _x = (_x + details.delta.dx).clamp(0.0, size.width - 100.0);
            _y = (_y + details.delta.dy).clamp(0.0, size.height - 140.0);
          });
        },
        child: AnimatedBuilder(
          animation: _floatAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: child,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Globo de diálogo — igual que el original
              if (_mostrarGlobo)
                FadeTransition(
                  opacity: _bubbleOpacity,
                  child: _BurbujaDialogo(mensaje: widget.mensaje),
                ),
              const SizedBox(height: 6),
              // El personaje — exactamente el mismo painter del original
              SizedBox(
                width: 80,
                height: 90,
                child: CustomPaint(
                  painter: _FonMasterPainterCompleto(
                      expresion: widget.expresion),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Globo de diálogo ────────────────────────────────────────────────────────
// Idéntico al de fon_master_widget.dart
class _BurbujaDialogo extends StatelessWidget {
  final String mensaje;
  const _BurbujaDialogo({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 190),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF88).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        mensaje,
        style: const TextStyle(
          color: Color(0xFF0A0E1A),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── CustomPainter completo — copia exacta del painter original ──────────────
// Se copia aquí porque _FonMasterPainter en fon_master_widget.dart es privado.
class _FonMasterPainterCompleto extends CustomPainter {
  final Expresion expresion;
  _FonMasterPainterCompleto({required this.expresion});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Cuerpo gordito ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 18), width: 52, height: 42),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFF00CC6A),
    );
    // Cuello de la camiseta
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 1), width: 22, height: 10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF00AA55),
    );

    // ── Cabeza ──
    canvas.drawCircle(Offset(cx, cy - 12), 22, Paint()..color = const Color(0xFFE8B87A));

    // ── Barba cerrada ──
    final barbaPath = Path()
      ..moveTo(cx - 16, cy - 6)
      ..quadraticBezierTo(cx - 18, cy + 6, cx - 10, cy + 8)
      ..quadraticBezierTo(cx, cy + 12, cx + 10, cy + 8)
      ..quadraticBezierTo(cx + 18, cy + 6, cx + 16, cy - 6)
      ..quadraticBezierTo(cx, cy + 2, cx - 16, cy - 6)
      ..close();
    canvas.drawPath(barbaPath, Paint()..color = const Color(0xFF4A3728));

    // ── Lentes semi-oscuros ──
    final lentesFill = Paint()
      ..color = const Color(0xFF2A2A3A).withValues(alpha: 0.7);
    final lentesMarco = Paint()
      ..color = const Color(0xFF1A1A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final lenteIzq = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx - 10, cy - 14), width: 16, height: 12),
      const Radius.circular(4),
    );
    canvas.drawRRect(lenteIzq, lentesFill);
    canvas.drawRRect(lenteIzq, lentesMarco);

    final lenteDer = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 10, cy - 14), width: 16, height: 12),
      const Radius.circular(4),
    );
    canvas.drawRRect(lenteDer, lentesFill);
    canvas.drawRRect(lenteDer, lentesMarco);

    // Puente y patillas
    canvas.drawLine(Offset(cx - 2, cy - 14), Offset(cx + 2, cy - 14), lentesMarco);
    canvas.drawLine(Offset(cx - 18, cy - 14), Offset(cx - 22, cy - 16), lentesMarco);
    canvas.drawLine(Offset(cx + 18, cy - 14), Offset(cx + 22, cy - 16), lentesMarco);

    // ── Ojos (cambian con la expresión) ──
    final ojoStroke = Paint()
      ..color = const Color(0xFF1A1A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    switch (expresion) {
      case Expresion.feliz:
        canvas.drawPath(
          Path()
            ..moveTo(cx - 14, cy - 14)
            ..quadraticBezierTo(cx - 10, cy - 18, cx - 6, cy - 14),
          ojoStroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(cx + 6, cy - 14)
            ..quadraticBezierTo(cx + 10, cy - 18, cx + 14, cy - 14),
          ojoStroke,
        );
      case Expresion.sorprendido:
        canvas.drawCircle(Offset(cx - 10, cy - 14), 5, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(cx - 10, cy - 14), 3, Paint()..color = const Color(0xFF1A1A2A));
        canvas.drawCircle(Offset(cx + 10, cy - 14), 5, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(cx + 10, cy - 14), 3, Paint()..color = const Color(0xFF1A1A2A));
      case Expresion.triste:
        canvas.drawPath(
          Path()
            ..moveTo(cx - 14, cy - 16)
            ..quadraticBezierTo(cx - 10, cy - 12, cx - 6, cy - 16),
          ojoStroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(cx + 6, cy - 16)
            ..quadraticBezierTo(cx + 10, cy - 12, cx + 14, cy - 16),
          ojoStroke,
        );
      case Expresion.celebrando:
        _estrella(canvas, Offset(cx - 10, cy - 14), 5, const Color(0xFFFFD700));
        _estrella(canvas, Offset(cx + 10, cy - 14), 5, const Color(0xFFFFD700));
    }

    // ── Boca ──
    final bocaStroke = Paint()
      ..color = const Color(0xFF1A1A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    switch (expresion) {
      case Expresion.feliz:
        canvas.drawPath(
          Path()
            ..moveTo(cx - 8, cy - 3)
            ..quadraticBezierTo(cx, cy + 4, cx + 8, cy - 3),
          bocaStroke,
        );
      case Expresion.sorprendido:
        canvas.drawCircle(Offset(cx, cy - 1), 4,
          Paint()..color = const Color(0xFF1A1A2A)..style = PaintingStyle.stroke..strokeWidth = 2);
      case Expresion.triste:
        canvas.drawPath(
          Path()
            ..moveTo(cx - 6, cy)
            ..quadraticBezierTo(cx, cy - 4, cx + 6, cy),
          bocaStroke,
        );
      case Expresion.celebrando:
        canvas.drawPath(
          Path()
            ..moveTo(cx - 10, cy - 4)
            ..quadraticBezierTo(cx, cy + 6, cx + 10, cy - 4),
          bocaStroke,
        );
        canvas.drawLine(
          Offset(cx - 4, cy - 1), Offset(cx + 4, cy - 1),
          Paint()..color = Colors.white..strokeWidth = 3..strokeCap = StrokeCap.round,
        );
    }

    // ── Cabello ──
    final cabeloPath = Path()
      ..moveTo(cx - 20, cy - 22)
      ..quadraticBezierTo(cx - 18, cy - 36, cx, cy - 34)
      ..quadraticBezierTo(cx + 18, cy - 36, cx + 20, cy - 22)
      ..quadraticBezierTo(cx + 14, cy - 30, cx, cy - 29)
      ..quadraticBezierTo(cx - 14, cy - 30, cx - 20, cy - 22)
      ..close();
    canvas.drawPath(cabeloPath, Paint()..color = const Color(0xFF2A1F14));

    // ── Brazos gorditos ──
    final brazoPaint = Paint()
      ..color = const Color(0xFF00CC6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final mano = Paint()..color = const Color(0xFFE8B87A);

    canvas.drawLine(Offset(cx - 24, cy + 12), Offset(cx - 32, cy + 22), brazoPaint);
    canvas.drawCircle(Offset(cx - 33, cy + 24), 5, mano);

    if (expresion == Expresion.celebrando) {
      canvas.drawLine(Offset(cx + 24, cy + 12), Offset(cx + 34, cy - 2), brazoPaint);
      canvas.drawCircle(Offset(cx + 35, cy - 4), 5, mano);
    } else {
      canvas.drawLine(Offset(cx + 24, cy + 12), Offset(cx + 32, cy + 22), brazoPaint);
      canvas.drawCircle(Offset(cx + 33, cy + 24), 5, mano);
    }

    // ── Brillo en lentes ──
    final brillo = Paint()
      ..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawCircle(Offset(cx - 13, cy - 17), 2, brillo);
    canvas.drawCircle(Offset(cx + 7, cy - 17), 2, brillo);

    // ── Mejillas sonrojadas ──
    if (expresion == Expresion.feliz || expresion == Expresion.celebrando) {
      final mejilla = Paint()
        ..color = const Color(0xFFFF8C8C).withValues(alpha: 0.4);
      canvas.drawCircle(Offset(cx - 16, cy - 5), 4, mejilla);
      canvas.drawCircle(Offset(cx + 16, cy - 5), 4, mejilla);
    }
  }

  void _estrella(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;
      final outer = Offset(
        center.dx + radius * cos(outerAngle),
        center.dy + radius * sin(outerAngle),
      );
      final inner = Offset(
        center.dx + (radius * 0.4) * cos(innerAngle),
        center.dy + (radius * 0.4) * sin(innerAngle),
      );
      if (i == 0) path.moveTo(outer.dx, outer.dy);
      else path.lineTo(outer.dx, outer.dy);
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FonMasterPainterCompleto old) => old.expresion != expresion;
}
