// ai_tutor_screen.dart — ¡Tu rincón de consulta con Fon Master!
// ═══════════════════════════════════════════════════════════════════════════
// Esta pantalla es donde sucede la magia de la IA. Aquí puedes charlar con
// Fon Master sobre cualquier duda de programación. Es como tener a tu mentor
// disponible 24/7 para explicarte desde un "Hola Mundo" hasta algoritmos locos.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../widgets/typewriter_text.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  // Controladores para manejar el texto que escribes y el scroll del chat
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Lista de mensajes: aquí guardamos la conversación entre tú y yo
  final List<Map<String, String>> _mensajes = [
    {
      'emisor': 'fon_master',
      'texto': '¡Hola! Soy Fon Master, tu tutor personal de programación. Pregúntame sobre cualquier concepto, error de código o simplemente charlemos sobre tecnología. ¿En qué te ayudo hoy?'
    }
  ];

  // Función para enviar tu mensaje al chat
  void _enviarMensaje() {
    if (_controller.text.trim().isEmpty) return;

    final textoUsuario = _controller.text;
    setState(() {
      _mensajes.add({'emisor': 'usuario', 'texto': textoUsuario});
      _mensajes.add({'emisor': 'fon_master', 'texto': '...'}); // Animación de "estoy pensando"
    });
    
    _controller.clear();
    _scrollToBottom();

    // Simulamos la respuesta de la IA (¡Pronto será real con Gemini!)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _mensajes.last = {
            'emisor': 'fon_master',
            'texto': '¡Esa es una excelente pregunta! Para resolverlo debes pensar en la estructura de control correcta. Sigue practicando y pronto lo dominarás al 100%.'
          };
        });
        _scrollToBottom();
      }
    });
  }

  // Mueve la vista al final del chat para que siempre veas lo último que dijimos
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // El círculo del perfil de Fon Master en el chat
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00FF88), width: 2),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF1A2744),
                child: Icon(Icons.psychology_rounded, color: Color(0xFF00FF88)),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fon Master', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('En línea', style: TextStyle(color: Color(0xFF00FF88), fontSize: 12)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // Área de los globos de texto
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msj = _mensajes[index];
                final esUsuario = msj['emisor'] == 'usuario';
                
                return Align(
                  alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: esUsuario ? const Color(0xFF00FF88) : const Color(0xFF1A2744),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(esUsuario ? 20 : 0),
                        bottomRight: Radius.circular(esUsuario ? 0 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: esUsuario ? const Color(0xFF00FF88).withOpacity(0.2) : Colors.black26,
                          blurRadius: 10, offset: const Offset(0, 4)
                        )
                      ],
                    ),
                    child: msj['texto'] == '...'
                      ? const SizedBox(
                          width: 40, height: 20, 
                          child: Center(child: LinearProgressIndicator(color: Color(0xFF00FF88), backgroundColor: Colors.white24))
                        )
                      : Text(
                          msj['texto']!,
                          style: TextStyle(
                            color: esUsuario ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                );
              },
            ),
          ),
          // El campo donde escribes tus dudas
          Container(
             padding: const EdgeInsets.all(20),
             decoration: const BoxDecoration(
               color: Color(0xFF0A0E1A),
               border: Border(top: BorderSide(color: Colors.white10)),
             ),
             child: Row(
               children: [
                 Expanded(
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     decoration: BoxDecoration(
                       color: const Color(0xFF1A2744),
                       borderRadius: BorderRadius.circular(30),
                       border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.5)),
                     ),
                     child: TextField(
                       controller: _controller,
                       style: const TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         hintText: 'Escribe tu duda...',
                         hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                         border: InputBorder.none,
                       ),
                       onSubmitted: (_) => _enviarMensaje(),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 // El botón de enviar con un toque de color ByteUP
                 GestureDetector(
                   onTap: _enviarMensaje,
                   child: Container(
                     padding: const EdgeInsets.all(14),
                     decoration: const BoxDecoration(
                       color: Color(0xFF00FF88),
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(Icons.send_rounded, color: Colors.black),
                   ),
                 )
               ],
             ),
          )
        ],
      ),
    );
  }
}

