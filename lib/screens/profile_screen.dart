// profile_screen.dart — ¡Tu Identidad Digital!
// ═══════════════════════════════════════════════════════════════════════════
// En esta sección puedes ver todo lo que has logrado: tus medallas, tu racha,
// tu nivel actual y hasta un gráfico de tu actividad semanal. Es como tu
// currículum de ByteUP Code, ¡llénalo de éxitos!
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/game_service.dart';
import '../widgets/background_particles.dart';
import 'auth_screen.dart';

// ─── Paleta ──────────────────────────────────────────────────────────────────
const _fondo     = Color(0xFF0A0E1A);
const _verde     = Color(0xFF00FF88);
const _cian      = Color(0xFF22D3EE);
const _amarillo  = Color(0xFFFFD700);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {

  UserModel? _usuario;
  bool _cargando = true;

  late AnimationController _entradaController;
  late List<Animation<double>> _fadeAnims;

  @override
  void initState() {
    super.initState();
    _entradaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnims = List.generate(6, (i) {
      final ini = i * 0.10;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entradaController,
          curve: Interval(ini, (ini + 0.4).clamp(0, 1), curve: Curves.easeOut),
        ),
      );
    });
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuario = StorageService.cargarUsuario() ?? UserModel(nombre: 'Dev');
    GameService.verificarStreak(usuario);
    if (mounted) {
      setState(() {
        _usuario = usuario;
        _cargando = false;
      });
      _entradaController.forward();
    }
  }

  @override
  void dispose() {
    _entradaController.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: _fondo,
        body: Center(child: CircularProgressIndicator(color: _verde)),
      );
    }

    final usuario = _usuario!;

    return Scaffold(
      backgroundColor: _fondo,
      body: BackgroundParticles(
        child: CustomScrollView(
        slivers: [
          // ── AppBar con hero del avatar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _fondo,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white.withValues(alpha: 0.7), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_rounded,
                    color: Colors.white.withValues(alpha: 0.7), size: 22),
                onPressed: () => _mostrarAjustes(usuario),
              ),
            ],
            flexibleSpace: _buildAppBarHero(usuario),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats rápidas ─────────────────────────────────────
                _buildStatsRapidas(usuario),
                const SizedBox(height: 24),

                // ── Progreso de rango ─────────────────────────────────
                _buildCardRango(usuario),
                const SizedBox(height: 24),

                // ── Actividad de 7 días ───────────────────────────────
                _buildActividad(usuario),
                const SizedBox(height: 24),

                // ── Insignias ─────────────────────────────────────────
                _buildInsignias(usuario),
                const SizedBox(height: 24),
                
                // ── Modo Invitado (si aplica) ─────────────────────────
                if (usuario.isInvitado) _buildBotonRegistro(context),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildBotonRegistro(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnims[5],
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF111627), Color(0xFF1E284A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _cian.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _cian.withValues(alpha: 0.15),
              blurRadius: 20,
            )
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.person_outline_rounded, color: _cian, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Estás en modo Invitado',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea una cuenta para guardar tu progreso, competir en el Ranking y hablar con Fon Master.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const AuthScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cian,
                  foregroundColor: _fondo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Crear Cuenta', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Hero del AppBar: avatar + nombre ────────────────────────────────────
  Widget _buildAppBarHero(UserModel usuario) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _verde.withValues(alpha: 0.08),
              _fondo,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Avatar grande con gradiente
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_verde, _cian],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _verde.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    usuario.iniciales,
                    style: const TextStyle(
                      color: _fondo,
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nombre
              Text(
                usuario.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),

              // Rango con emoji
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _verde.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _verde.withValues(alpha: 0.25)),
                ),
                child: Text(
                  '${usuario.rango.emoji} ${usuario.rango.nombre}',
                  style: const TextStyle(
                    color: _verde,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 4 stats rápidas en una fila ──────────────────────────────────────────
  Widget _buildStatsRapidas(UserModel usuario) {
    return FadeTransition(
      opacity: _fadeAnims[0],
      child: Row(
        children: [
          _buildStatCard('⚡', '${usuario.xpTotal}', 'XP Total',
              const Color(0xFFFFD700)),
          const SizedBox(width: 10),
          _buildStatCard('🔥', '${usuario.streakActual}', 'Racha días',
              const Color(0xFFFF6B35)),
          const SizedBox(width: 10),
          _buildStatCard('❤️', '${usuario.corazones}', 'Corazones',
              const Color(0xFFFF6B9D)),
          const SizedBox(width: 10),
          _buildStatCard('🏅', '${usuario.insignias.length}', 'Insignias',
              const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String emoji, String valor, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Card de progreso de rango ────────────────────────────────────────────
  Widget _buildCardRango(UserModel usuario) {
    final progreso   = usuario.progresoRango;
    final siguiente  = usuario.siguienteRango;
    final xpEnRango  = usuario.xpTotal - usuario.rango.xpMinimo;
    final xpNecesario = usuario.rango.xpMaximo - usuario.rango.xpMinimo;

    return FadeTransition(
      opacity: _fadeAnims[1],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _verde.withValues(alpha: 0.10),
                  _cian.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _verde.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título de sección
                const Text(
                  '🎖️ Progreso de Rango',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                // Rangos con flechas
                Row(
                  children: [
                    _buildRangoBadge(
                        usuario.rango.emoji, usuario.rango.nombre, true),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progreso.clamp(0.0, 1.0),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [_verde, _cian]),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: _verde.withValues(alpha: 0.5),
                                        blurRadius: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildRangoBadge(
                      siguiente?.emoji ?? '👑',
                      siguiente?.nombre ?? 'Leyenda',
                      false,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Texto de progreso
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '+$xpEnRango XP en este rango',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        siguiente != null
                            ? '${xpNecesario - xpEnRango} XP para ${siguiente.nombre}'
                            : '¡Nivel máximo! 👑',
                        style: const TextStyle(
                          color: _verde,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangoBadge(String emoji, String nombre, bool activo) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 2),
        Text(
          nombre,
          style: TextStyle(
            color: activo ? _verde : Colors.white.withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ─── Actividad de 7 días (gráfica de barras) ──────────────────────────────
  Widget _buildActividad(UserModel usuario) {
    return FadeTransition(
      opacity: _fadeAnims[2],
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    '📅 Actividad — Últimos 7 días',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _verde.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🔥 ${usuario.streakActual}d',
                    style: const TextStyle(
                      color: _verde,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildBarChart(usuario),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(UserModel usuario) {
    // Simulamos actividad de los últimos 7 días basada en el streak
    final diasSemana = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final hoy = DateTime.now().weekday - 1; // 0 = Lunes

    // Genera valores de barras: días del streak recientes tienen valor 1
    final valores = List.generate(7, (i) {
      final diasDesdeHoy = (hoy - i + 7) % 7;
      // Si el streak del usuario cubre ese día, marcamos actividad
      if (diasDesdeHoy < usuario.streakActual) return 0.6 + (i % 3) * 0.2;
      return 0.0;
    }).reversed.toList();

    final maxVal = valores.isEmpty
        ? 1.0
        : valores.reduce((a, b) => a > b ? a : b).clamp(0.001, 10.0);

    return SizedBox(
      height: 95,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final val = valores[i];
          final alturaRel = val / maxVal;
          final esHoy = i == hoy;
          final activo = val > 0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Barra
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 60),
                    curve: Curves.easeOutCubic,
                    height: (alturaRel * 56).clamp(4, 56),
                    decoration: BoxDecoration(
                      gradient: activo
                          ? LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: esHoy
                                  ? [_verde, _cian]
                                  : [
                                      _verde.withValues(alpha: 0.5),
                                      _cian.withValues(alpha: 0.3),
                                    ],
                            )
                          : null,
                      color: activo
                          ? null
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: activo && esHoy
                          ? [
                              BoxShadow(
                                  color: _verde.withValues(alpha: 0.4),
                                  blurRadius: 8),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Etiqueta día
                  Text(
                    diasSemana[i],
                    style: TextStyle(
                      color: esHoy
                          ? _verde
                          : Colors.white.withValues(alpha: 0.3),
                      fontSize: 11,
                      fontWeight:
                          esHoy ? FontWeight.w800 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Grid de insignias ────────────────────────────────────────────────────
  Widget _buildInsignias(UserModel usuario) {
    // Insignias disponibles en el juego
    final todasLasInsignias = [
      _InsigniaInfo('primeros_pasos', '🎯', 'Primeros Pasos',
          'Completa tu primera lección'),
      _InsigniaInfo('racha_7', '🔥', 'En Llamas', 'Mantén una racha de 7 días'),
      _InsigniaInfo('racha_30', '🌋', 'Imparable',
          'Mantén una racha de 30 días'),
      _InsigniaInfo('python_master', '🐍', 'Pythonista',
          'Completa todas las lecciones de Python'),
      _InsigniaInfo('js_master', '⚡', 'JS Ninja',
          'Completa todas las lecciones de JavaScript'),
      _InsigniaInfo('java_master', '☕', 'Java Dev',
          'Completa todas las lecciones de Java'),
      _InsigniaInfo('cpp_master', '⚙️', 'C++ Wizard',
          'Completa todas las lecciones de C++'),
      _InsigniaInfo('velocista', '🚀', 'Velocista',
          'Responde 10 respuestas correctas seguidas'),
      _InsigniaInfo('perfeccionista', '💎', 'Perfeccionista',
          'Completa una lección con 100% de acierto'),
      _InsigniaInfo('leyenda', '👑', 'Leyenda',
          'Alcanza el rango Legend'),
    ];

    return FadeTransition(
      opacity: _fadeAnims[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🏅 Insignias',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${usuario.insignias.length}/${todasLasInsignias.length}',
                style: const TextStyle(
                  color: _verde,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: todasLasInsignias.length,
            itemBuilder: (context, i) {
              final ins = todasLasInsignias[i];
              final ganada = usuario.insignias.contains(ins.id);
              return _buildInsigniaItem(ins, ganada);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsigniaItem(_InsigniaInfo ins, bool ganada) {
    return GestureDetector(
      onTap: () => _mostrarDetalleInsignia(ins, ganada),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ganada
                  ? _amarillo.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: ganada
                    ? _amarillo.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
              boxShadow: ganada
                  ? [
                      BoxShadow(
                          color: _amarillo.withValues(alpha: 0.2),
                          blurRadius: 8),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                ins.emoji,
                style: TextStyle(
                  fontSize: 22,
                  color: ganada
                      ? null
                      : Colors.white.withValues(alpha: 0.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ins.nombre,
            style: TextStyle(
              color: ganada
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.2),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── Dialog de detalle de insignia ────────────────────────────────────────
  void _mostrarDetalleInsignia(_InsigniaInfo ins, bool ganada) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF111627),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ganada
                  ? _amarillo.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ins.emoji, style: const TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text(
                ins.nombre,
                style: TextStyle(
                  color: ganada ? _amarillo : Colors.white54,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ins.descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: ganada
                      ? _verde.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ganada ? '✅ ¡Ya la ganaste!' : '🔒 Aún no desbloqueada',
                  style: TextStyle(
                    color: ganada ? _verde : Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _verde.withValues(alpha: 0.15),
                    foregroundColor: _verde,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Cerrar',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Dialog de ajustes ────────────────────────────────────────────────────
  void _mostrarAjustes(UserModel usuario) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            decoration: BoxDecoration(
              color: const Color(0xFF111627).withValues(alpha: 0.97),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '⚙️ Ajustes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),

                // Info del usuario
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_verde, _cian]),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            usuario.iniciales,
                            style: const TextStyle(
                              color: _fondo,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(usuario.nombre,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          if (usuario.email.isNotEmpty)
                            Text(usuario.email,
                                style: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: 0.4),
                                  fontSize: 12,
                                )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Opción: Reset de progreso
                _buildOpcionAjuste(
                  icono: Icons.restart_alt_rounded,
                  label: 'Reiniciar progreso',
                  color: const Color(0xFFFF4757),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmarReset();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpcionAjuste({
    required IconData icono,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icono, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Confirmar reset de progreso ──────────────────────────────────────────
  void _confirmarReset() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF111627),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              const Text(
                '¿Reiniciar todo el progreso?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Perderás todo tu XP, rangos, streaks e insignias. Esta acción no se puede deshacer.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await StorageService.borrarTodoElProgreso();
                        if (mounted) {
                          setState(() => _cargando = true);
                          _cargarDatos();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF4757).withValues(alpha: 0.2),
                        foregroundColor: const Color(0xFFFF4757),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Reiniciar',
                          style:
                              TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Modelo de info de insignia ──────────────────────────────────────────────
class _InsigniaInfo {
  final String id;
  final String emoji;
  final String nombre;
  final String descripcion;

  const _InsigniaInfo(this.id, this.emoji, this.nombre, this.descripcion);
}
