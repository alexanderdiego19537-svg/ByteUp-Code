# 📁 El Mapa de ByteUP Code 🗺️

¿Te has perdido entre tantas carpetas? ¡No te preocupes! Aquí tienes la guía definitiva para entender dónde vive cada parte de nuestra academia digital.

---

## 🚀 `lib/` — El Motor Principal
Aquí es donde escribimos casi todo el código Dart que hace que la app cobre vida.

### 📱 `lib/screens/` — Las Pantallas (Donde sucede la acción)
| Archivo | Lo que verás |
|---|---|
| `home_screen.dart` | **Tu Centro de Mando** — El dashboard con tus stats, lenguajes y ese saludo de "¡Hola, Dev! 👋". |
| `learn_screen.dart` | **El Mapa del Tesoro** — Tu ruta de aprendizaje con todos los niveles por conquistar. |
| `lesson_screen.dart` | **La Arena de Entrenamiento** — Donde aprendes con el método Master Elite de 6 pasos. |
| `ai_tutor_screen.dart` | **Chat con Fon Master** — Tu rincón privado para charlar con el tutor IA. |
| `dev_studio_screen.dart` | **El Laboratorio** — Un IDE real para escribir y probar código en vivo. |
| `ranking_screen.dart` | **El Salón de la Fama** — Donde los mejores programadores presumen su XP. |
| `profile_screen.dart` | **Tu Identidad Digital** — Tus medallas, racha y progreso acumulado. |
| `auth_screen.dart` | **La Puerta de Entrada** — Login, registro y acceso para invitados. |
| `onboarding_screen.dart` | **La Bienvenida** — Donde Fon Master te conoce y evalúa tu nivel. |
| `splash_screen.dart` | **El Primer Latido** — Esa animación elegante que ves al abrir la app. |

---

### 🧩 `lib/widgets/` — Los Ladrillos (Componentes visuales)
| Archivo | Para qué sirve |
|---|---|
| `fon_master_widget.dart` | **Fon Master** — Nuestra querida mascota animada que te da consejos. |
| `draggable_fon_master.dart` | **Fon Flotante** — Un acceso rápido al tutor que puedes mover por toda la pantalla. |
| `background_particles.dart` | **Polvo de Estrellas** — Esas partículas verdes que flotan al fondo y dan el toque premium. |
| `typewriter_text.dart` | **Efecto de Escritura** — Hace que los textos aparezcan letra a letra, ¡como en un juego retro! |
| `racha_animacion.dart` | **Fuego en los Ojos** — La animación épica que sale cuando mantienes tu racha. |

---

### 📊 `lib/models/` y `lib/services/` — El Cerebro y la Memoria
*   **Models**: Definen qué es un Usuario, una Lección o un Lenguaje.
*   **Services**: Se encargan del trabajo sucio. Guardar datos en el cofre (`Storage`), calcular tu XP (`Game`), poner música (`Audio`) o hablar con Gemini (`AI`).

---

### 📚 `lib/data/` — El Tesoro del Conocimiento
Aquí en `lessons_data.dart` es donde vive cada palabra de teoría y cada pregunta de los exámenes. ¡Es el libro sagrado de ByteUP!

---

## 🛠️ Carpetas de Plataforma (`android/`, `ios/`, etc.)
Son los cimientos para que la app corra en tu móvil o PC. Normalmente no las tocamos a menos que necesitemos permisos especiales o cambiar el icono de la app.

## 📄 `pubspec.yaml`
Es la lista de la compra. Aquí le decimos a Flutter qué paquetes externos y qué imágenes necesitamos para que todo funcione.

---
*¡Exelente! Ahora ya conoces cada rincón de nuestro código. ¡A seguir programando!* 💻✨
