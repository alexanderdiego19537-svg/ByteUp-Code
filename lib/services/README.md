# ⚙️ servicios/ (services/) — La lógica de negocio de la app

Los servicios hacen el trabajo "invisible" que mantiene todo funcionando:

| Archivo | Qué hace |
|---|---|
| `storage_service.dart` | **Almacenamiento** — Guarda y recupera los datos del usuario en el teléfono (SharedPreferences) |
| `game_service.dart` | **Motor del juego** — Calcula XP ganado, sube de rango, gestiona rachas de días y corazones |
