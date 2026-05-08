#!/bin/bash

# 1. Descargar Flutter (versión estable)
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 2. Agregar Flutter al PATH para que el sistema lo encuentre
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Preparar Flutter
flutter doctor
flutter config --enable-web

# 4. Obtener las dependencias de tu proyecto
flutter pub get

# 5. Compilar para la web
flutter build web --release
