// ranking_screen.dart — ¡El Salón de la Fama!
// ═══════════════════════════════════════════════════════════════════════════
// ¿Quién es el mejor programador de la academia? Aquí puedes ver a los
// cracks que lideran el ranking. ¡Sigue aprendiendo para ver tu nombre en el TOP!
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/background_particles.dart';

const _fondo = Color(0xFF0A0E1A);
const _verde = Color(0xFF00FF88);
const _cian = Color(0xFF22D3EE);

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados (Mock) para mostrar el potencial de la UI
    final List<Map<String, dynamic>> usuariosData = [
      {'nombre': 'Carlos Hacker', 'xp': 15000, 'rango': Rango.legend},
      {'nombre': 'Ana Coder', 'xp': 12500, 'rango': Rango.diamante},
      {'nombre': 'María Dev', 'xp': 8000, 'rango': Rango.oro},
      {'nombre': 'Tú', 'xp': 3500, 'rango': Rango.plata}, // mock de usuario
      {'nombre': 'LuisJS', 'xp': 3000, 'rango': Rango.plata},
      {'nombre': 'Juana Py', 'xp': 1200, 'rango': Rango.bronce},
      {'nombre': 'Pedro HTML', 'xp': 900, 'rango': Rango.bronce},
      {'nombre': 'Gaby CSS', 'xp': 400, 'rango': Rango.bronce},
    ];

    return Scaffold(
      backgroundColor: _fondo,
      body: BackgroundParticles(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 110,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: FlexibleSpaceBar(
                    title: const Text(
                      '🏆 Top Programadores',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        shadows: [Shadow(color: _verde, blurRadius: 10)],
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 55, bottom: 16),
                    background: Container(
                      color: _fondo.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final isTop3 = index < 3;
                    final isMe = usuariosData[index]['nombre'] == 'Tú';
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isMe 
                            ? _verde.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isMe 
                              ? _verde.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.1),
                          width: isMe ? 2 : 1,
                        ),
                        boxShadow: isTop3 || isMe ? [
                          BoxShadow(
                            color: (isMe ? _verde : _cian).withValues(alpha: isMe ? 0.3 : 0.1),
                            blurRadius: isMe ? 25 : 15,
                          )
                        ] : [],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: isTop3
                                      ? [_cian, _verde]
                                      : [Colors.white24, Colors.white10],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: isTop3 || isMe ? Colors.white : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          usuariosData[index]['nombre'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isMe ? FontWeight.w900 : FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '${usuariosData[index]['xp']} XP',
                          style: TextStyle(
                            color: _verde.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Text(
                          (usuariosData[index]['rango'] as Rango).emoji,
                          style: TextStyle(
                            fontSize: 34,
                            shadows: [
                              Shadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: usuariosData.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
