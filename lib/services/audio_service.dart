// audio_service.dart
// ═══════════════════════════════════════════════════════════════════════════
// LA BANDA SONORA DE TU ÉXITO — Servicio de Sonidos y Música
// ═══════════════════════════════════════════════════════════════════════════

import 'package:audioplayers/audioplayers.dart';
import '../services/storage_service.dart';

class AudioService {
  // Varios canales para que los sonidos no se pisen entre sí
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer1 = AudioPlayer();
  static final AudioPlayer _sfxPlayer2 = AudioPlayer();

  static bool get _sonidoActivo {
    return StorageService.cargarConfiguracion()['sonido'] ?? true;
  }

  // ─── ¡A sonar! ──────────────────────────────────────────────────────────

  static Future<void> playBienvenida() async {
    if (!_sonidoActivo) return;
    try {
      await _bgmPlayer.play(AssetSource('sounds/bienvenida.mp3'), volume: 0.8);
    } catch (e) {
      // Ignorar si no existe el archivo
    }
  }

  static Future<void> playClick() async {
    if (!_sonidoActivo) return;
    try {
      await _sfxPlayer1.play(AssetSource('sounds/click.mp3'), volume: 0.5);
    } catch (e) {
      // Ignorar si no existe el archivo
    }
  }

  static Future<void> playCorrecto() async {
    if (!_sonidoActivo) return;
    try {
      // Usamos el player 2 por si el click sigue sonando
      await _sfxPlayer2.play(AssetSource('sounds/correcto.mp3'), volume: 0.8);
    } catch (e) {
      // Ignorar si no existe el archivo
    }
  }

  static Future<void> playError() async {
    if (!_sonidoActivo) return;
    try {
      await _sfxPlayer2.play(AssetSource('sounds/error.mp3'), volume: 0.8);
    } catch (e) {
      // Ignorar si no existe el archivo
    }
  }

  static Future<void> playNivelCompletado() async {
    if (!_sonidoActivo) return;
    try {
      await _bgmPlayer.play(AssetSource('sounds/completado.mp3'), volume: 1.0);
    } catch (e) {
      // Ignorar si no existe el archivo
    }
  }
}
