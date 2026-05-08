// auth_screen.dart — ¡El primer paso de tu aventura!
// ═══════════════════════════════════════════════════════════════════════════
// Esta es la puerta de entrada a ByteUP Code. Aquí es donde decides si quieres
// ser parte de nuestra comunidad de devs o si prefieres explorar como invitado.
// Diseñada con un estilo "Glassmorphism" para que se vea súper moderna y pro.
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../widgets/background_particles.dart';
import 'home_screen.dart';

// ─── Paleta ──────────────────────────────────────────────────────────────────
const _fondoColor = Color(0xFF0A0E1A);
const _verdeColor = Color(0xFF00FF88);
const _cianColor  = Color(0xFF22D3EE);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nombreController   = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _mostrarPassword = false;
  bool _cargando        = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoColor,
      body: BackgroundParticles(
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 40),

              _buildLogo(),
              const SizedBox(height: 12),

              // Nombre con gradiente"cambio de color"
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_verdeColor, _cianColor],
                ).createShader(bounds),
                child: const Text(
                  'ByteUP Code',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tu camino hacia el código empieza aquí',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.4),
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 36),

              _buildTabs(),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) => _buildFormulario(),
                ),
              ),

              const SizedBox(height: 20),
              _buildBotonPrincipal(),
              const SizedBox(height: 20),
              _buildDivisor(),
              const SizedBox(height: 20),
              _buildBotonSinCuenta(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      ),
    );
  }

  // ─── Logo con glow ────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0x4000FF88), Color(0x1500FF88), Colors.transparent],
          stops: [0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _verdeColor.withValues(alpha: 0.25),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2340), Color(0xFF0F1628)],
          ),
          border: Border.all(
            color: _verdeColor.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: const Center(
          child: Text(
            '</>',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: _verdeColor,
              shadows: [Shadow(color: _verdeColor, blurRadius: 15)],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Tabs Login / Registro ────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [_verdeColor, _cianColor]),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: _fondoColor,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        tabs: const [
          Tab(text: 'Iniciar Sesión'),
          Tab(text: 'Registrarse'),
        ],
      ),
    );
  }

  // ─── Formulario dinámico ──────────────────────────────────────────────────
  Widget _buildFormulario() {
    final esRegistro = _tabController.index == 1;

    return Column(
      children: [
        if (esRegistro) ...[
          _buildCampoTexto(
            controller: _nombreController,
            label: 'Nombre completo',
            icono: Icons.person_rounded,
            validador: (valor) {
              if (esRegistro && (valor == null || valor.trim().isEmpty)) {
                return 'Escribe tu nombre, crack 😎';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],

        _buildCampoTexto(
          controller: _emailController,
          label: 'Correo electrónico',
          icono: Icons.email_rounded,
          teclado: TextInputType.emailAddress,
          validador: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'Necesitamos tu email 📧';
            }
            if (!valor.contains('@') || !valor.contains('.')) {
              return 'Ese email no se ve bien 🤔';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildCampoTexto(
          controller: _passwordController,
          label: 'Contraseña',
          icono: Icons.lock_rounded,
          esPassword: true,
          validador: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'La contraseña no puede estar vacía 🔒';
            }
            if (valor.length < 6) {
              return 'Mínimo 6 caracteres, ¡tú puedes! 💪';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ─── Campo de texto premium ───────────────────────────────────────────────
  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    TextInputType teclado = TextInputType.text,
    bool esPassword = false,
    String? Function(String?)? validador,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TextFormField(
          controller: controller,
          keyboardType: teclado,
          obscureText: esPassword && !_mostrarPassword,
          validator: validador,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            prefixIcon: Icon(icono, color: _verdeColor, size: 22),
            suffixIcon: esPassword
                ? IconButton(
                    icon: Icon(
                      _mostrarPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white38,
                      size: 22,
                    ),
                    onPressed: () =>
                        setState(() => _mostrarPassword = !_mostrarPassword),
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _verdeColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
            ),
            errorStyle: const TextStyle(fontSize: 12),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }

  // ─── Botón principal ──────────────────────────────────────────────────────
  Widget _buildBotonPrincipal() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [_verdeColor, _cianColor]),
          boxShadow: [
            BoxShadow(
              color: _verdeColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _cargando ? null : _procesarAuth,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: _fondoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
          ),
          child: _cargando
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: _fondoColor),
                )
              : Text(
                  _tabController.index == 0 ? 'Iniciar Sesión' : 'Crear Cuenta',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5),
                ),
        ),
      ),
    );
  }

  // ─── Divisor decorativo ───────────────────────────────────────────────────
  Widget _buildDivisor() {
    return Row(
      children: [
        Expanded(
            child: Container(height: 1,
                color: Colors.white.withValues(alpha: 0.08))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('o',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 14)),
        ),
        Expanded(
            child: Container(height: 1,
                color: Colors.white.withValues(alpha: 0.08))),
      ],
    );
  }

  // ─── Botón sin cuenta ─────────────────────────────────────────────────────
  Widget _buildBotonSinCuenta() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _continuarSinCuenta,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white70,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
        icon: const Icon(Icons.rocket_launch_rounded, size: 20),
        label: const Text(
          'Continuar sin cuenta',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ─── Lógica de autenticación (local) ─────────────────────────────────────
  Future<void> _procesarAuth() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _cargando = true);

    await Future.delayed(const Duration(milliseconds: 800)); // Simula red

    final esRegistro = _tabController.index == 1;
    final email = _emailController.text.trim();
    final pwdInput = _passwordController.text;
    final bytes = utf8.encode(pwdInput);
    final passwordHash = sha256.convert(bytes).toString();

    UserModel usuario;

    if (esRegistro) {
      final nombre = _nombreController.text.trim();
      if (StorageService.emailRegistrado(email)) {
        setState(() => _cargando = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Este email ya está registrado.')));
        }
        return;
      }

      await StorageService.registrarCuenta(
        email: email,
        passwordHash: passwordHash,
        nombre: nombre,
      );

      // Crear nuevo usuario y setear password
      usuario = UserModel(
        nombre: nombre,
        email: email,
      )..passwordHash = passwordHash;
    } else {
      // Login
      final nombreEncontrado = StorageService.verificarLogin(email, passwordHash);
      if (nombreEncontrado == null) {
        setState(() => _cargando = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email o contraseña incorrecta.')));
        }
        return;
      }
      
      // Intentar cargar progreso existente
      usuario = StorageService.cargarUsuario() ?? UserModel(nombre: nombreEncontrado, email: email);
      // Si era otro usuario el local, mejor reiniciar para el que inicia sesión
      if (usuario.email != email) {
         usuario = UserModel(nombre: nombreEncontrado, email: email);
      }
      usuario.passwordHash = passwordHash;
    }

    await StorageService.guardarUsuario(usuario);

    if (mounted) {
      setState(() => _cargando = false);
      _irAlHome();
    }
  }

  // ─── Continuar sin cuenta ─────────────────────────────────────────────────
  Future<void> _continuarSinCuenta() async {
    setState(() => _cargando = true);

    final usuario = UserModel(nombre: 'Dev');
    await StorageService.guardarUsuario(usuario);

    if (mounted) {
      setState(() => _cargando = false);
      _irAlHome();
    }
  }

  // ─── Navegar al Home con transición suave ────────────────────────────────
  void _irAlHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
