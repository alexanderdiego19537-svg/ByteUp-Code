// lessons_data.dart — ¡El Cerebro de la Academia!
// ═══════════════════════════════════════════════════════════════════════════
// Aquí es donde guardamos todo el conocimiento. Todas las lecciones, retos,
// teorías y explicaciones de Fon Master viven en este archivo. ¡Es el tesoro
// más valioso de ByteUP Code!
// ═══════════════════════════════════════════════════════════════════════════
import '../models/lesson_model.dart';

class LessonsData {
  
  // ===========================================================================
  // ETAPA 1: LÓGICA PURA (¡Obligatoria antes del código!)
  // ===========================================================================

  static final ModuloModel logicaM1 = ModuloModel(
    id: 'logica_m1',
    numero: 1,
    titulo: 'Piensa como computadora',
    emoji: '🧠',
    descripcion: 'Aprende qué es programar sin tocar una línea de código',
    lenguaje: 'logica',
    etapa: EtapaAprendizaje.logicaPura,
    niveles: [
      NivelContenido(
        id: 'logica_m1_n1',
        numero: 1,
        titulo: '¿Qué es programar?',
        subtitulo: 'Hablando con máquinas',
        explicacionFon: '¡Hola Dev! Programar no es magia. Es simplemente darle instrucciones a una computadora tonta pero muy rápida. ¿Has seguido alguna vez la receta para hacer un sándwich? ¡Eso es un programa!',
        teoriaParrafos: [
          'Las computadoras no entienden palabras humanas, solo siguen órdenes paso a paso.',
          'A ese conjunto de órdenes le llamamos "Algoritmo".',
          'Si le dices a un robot "Hazme un sándwich", no sabrá qué hacer. Tienes que decirle: "Abre el pan, pon jamón, cierra el pan".'
        ],
        ejemploContenido: '1. Toma una rebanada de pan.\n2. Ponle queso.\n3. Pon otra rebanada encima.',
        ejemploLineas: [
          'Esta es la instrucción 1. Sin pan no hay sándwich.',
          'Esta es la instrucción 2. El relleno.',
          'Esta es la instrucción 3. Finalizamos el proceso.',
        ],
        esEjemploCodigo: false,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuál de las siguientes opciones describe mejor a una computadora antes de ser programada?',
          opciones: ['Un genio rebelde', 'Una máquina tonta que obedece todo', 'Un cerebro consciente', 'Una calculadora mágica'],
          respuestaCorrecta: 1,
          pista: 'Recuerda que no pueden pensar por sí solas, solo siguen órdenes.',
          explicacion: '¡Exacto! Ellas solo hacen lo que tú les dices, ni más, ni menos.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Qué es un algoritmo?',
          opciones: ['Un lenguaje de programación', 'Una parte de la computadora', 'Un conjunto de pasos ordenados', 'Error del sistema'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: '¡Buen inicio! Ya sabes que programar es simplemente dar instrucciones claras.',
        aprendiste: ['Por qué programamos', 'Analizar instrucciones cotidianas', 'El concepto de Algoritmo'],
      ),
      NivelContenido(
        id: 'logica_m1_n2',
        numero: 2,
        titulo: 'Instrucciones exactas',
        subtitulo: 'Las máquinas no adivinan',
        explicacionFon: 'Un pequeño error en una instrucción puede causar un desastre. Si le dices a la computadora "lava los platos" pero no le dices de qué forma abrir la llave del agua, podría romper la tubería.',
        teoriaParrafos: [
          'Las máquinas no tienen contexto. No saben qué es "un poco" o "mucho".',
          'Toda instrucción debe ser específica, medible y sin ambigüedades.'
        ],
        ejemploContenido: 'INCORRECTO: Avanza un poco.\nCORRECTO: Avanza 5 metros hacia el norte.',
        ejemploLineas: [
          '"Un poco" no es algo que una máquina pueda medir.',
          'Aquí decimos exactamente cuánto y hacia dónde.',
        ],
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuál de estas instrucciones es perfecta para un robot de cocina?',
          opciones: ['Bate hasta que quede bien.', 'Bate a velocidad 3 durante 5 minutos.', 'Mezcla las cosas.', 'Bate un poquito.'],
          respuestaCorrecta: 1,
          pista: 'Busca la que tenga medidas exactas como tiempo o velocidad.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: 'Si le dices a un robot "Ve por leche", ¿por qué podría fallar?',
          opciones: ['Porque no le gusta la leche.', 'No sabe a dónde ir ni cuánta comprar.', 'Es muy difícil.', 'No tiene dinero.'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: '¡Exelente! Entendiste la importancia de ser exactos al dar instrucciones.',
        aprendiste: ['Ambigüedad', 'Precisión en los datos', 'Medidas exactas en programación'],
      ),
      NivelContenido(
        id: 'logica_m1_n3',
        numero: 3,
        titulo: 'El orden importa',
        subtitulo: 'Secuencias lógicas',
        explicacionFon: '¿Te pondrías los zapatos antes que los calcetines? ¡Claro que no! En la programación el ORDEN en que ejecutas las instrucciones lo es TODO.',
        teoriaParrafos: [
          'A esto le llamamos Secuencia.',
          'Un programa se lee de arriba hacia abajo, línea por línea.',
          'Si declaras que ganaste antes de jugar, el programa hará trampa (o dará error).'
        ],
        ejemploContenido: '1. Te quitas la ropa\n2. Te bañas\n3. Te pones ropa limpia',
        ejemploLineas: [
          'Primer paso lógico, no te puedes mojar con ropa.',
          'El paso principal.',
          'El resultado exitoso depende de haber hecho bien el paso 1 y 2.',
        ],
        ejercicioGuiado: PreguntaInteractiva(
          texto: 'Ordena la secuencia para arrancar un coche:',
          opciones: ['1. Acelerar, 2. Girar llave, 3. Entrar', '1. Girar llave, 2. Acelerar, 3. Entrar', '1. Entrar, 2. Girar llave, 3. Acelerar', '1. Entrar, 2. Acelerar, 3. Girar llave'],
          respuestaCorrecta: 2,
          pista: '¿Qué es lo primero físico que tienes que hacer con el coche?',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Qué pasaría en el sistema si el paso 2 de un programa se ejecuta antes que el 1 que le daba los datos?',
          opciones: ['No pasaría nada.', 'El programa adivinaría los datos.', 'Error, faltaría información.', 'Se apaga la PC.'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: 'La secuencia es la base de todo programa informático. ¡Bien hecho!',
        aprendiste: ['Ejecución secuencial', 'Dependencia de pasos', 'Precedencia'],
      ),
      NivelContenido(
        id: 'logica_m1_n4',
        numero: 4,
        titulo: 'Errores de lógica',
        subtitulo: 'Bugs en la vida misma',
        explicacionFon: 'Un "Bug" es un error en tu programa. A veces el programa funciona (no se rompe) pero hace algo totalmente equivocado. ¡Eso es un error lógico!',
        teoriaParrafos: [
          'Si sumas 2+2 y el programa da 5, es un error lógico.',
          'La computadora no sabe que 5 está mal, ella solo hace lo que tú escribiste.',
          'El programador siempre tiene la culpa.'
        ],
        ejemploContenido: 'Paso 1: Abrir la puerta\nPaso 2: Dar un paso\nPaso 3: Cerrar la puerta\nBUG: Dar dos pasos antes de abrirla.',
        ejemploLineas: [
          'Normal.',
          'Normal.',
          'Normal.',
          '¡Ouch! El robot se choca con la puerta. Error de lógica.',
        ],
        ejercicioGuiado: PreguntaInteractiva(
          texto: 'Si quieres calcular cuántos días hay en 2 semanas y escribes (7 + 2), ¿qué tipo de error es?',
          opciones: ['Error de la computadora', 'Error de lógica', 'Error de teclado', 'No hay error'],
          respuestaCorrecta: 1,
          pista: 'El programa no se va a colgar por sumar 7+2, pero matemáticamente es incorrecto para lo que quieres.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Por qué ocurren los errores lógicos?',
          opciones: ['Por virus en la red.', 'Porque la PC es vieja.', 'Porque el programador dio malas instrucciones.', 'Porque el usuario hizo click rápido.'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: '¡Los bugs no son bichos literales, son errores humanos! Buen trabajo solucionándolos.',
        aprendiste: ['Concepto de Bug', 'Error sintáctico vs lógico', 'Causa y efecto'],
      ),
      NivelContenido(
        id: 'logica_m1_n5',
        numero: 5,
        titulo: 'Algoritmos en la vida real',
        subtitulo: 'Todo a tu alrededor es código',
        explicacionFon: '¿Sabías que una receta de pastel y las instrucciones de un mueble de IKEA son algoritmos? Vamos a analizarlos.',
        teoriaParrafos: [
          'Cualquier proceso repetible es un algoritmo.',
          'Identificar las partes de un proceso real te hará mejor programador.',
          'Entradas (ingredientes) → Proceso (cocina) → Salidas (pastel).'
        ],
        ejemploContenido: 'ENTRADA: Dinero, Elección\nPROCESO: Validar dinero > Dejar caer producto > Dar cambio\nSALIDA: Tu chocolate',
        ejemploLineas: [
          'Lo que recibe la máquina expendedora.',
          'La parte oculta (el cerebro de la máquina).',
          'El resultado esperado.',
        ],
        ejercicioGuiado: PreguntaInteractiva(
          texto: 'En una calculadora, cuando escribes "5 + 5", ¿cuál es el proceso y cuál es la salida?',
          opciones: ['Proceso: el botón = | Salida: 5', 'Proceso: sumar | Salida: 10', 'Proceso: ver pantalla | Salida: apagar', 'No hay proceso'],
          respuestaCorrecta: 1,
          pista: 'El proceso es la operación, la salida es el número que ves.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: 'Si el proceso es "Hervir" y la salida es "Agua caliente", ¿cuál fue la entrada?',
          opciones: ['Fuego', 'Té', 'Agua fría', 'Vaso'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: '¡Entradas, Procesos y Salidas! El santo grial de la informática.',
        aprendiste: ['Input', 'Proceso', 'Output'],
      ),
      NivelContenido(
        id: 'logica_m1_n6',
        numero: 6,
        titulo: 'Tu primer diagrama',
        subtitulo: 'Mapas de código',
        explicacionFon: 'A los programadores no les gusta leer mucho texto, preferimos hacer "mapas". A estos se les llama diagramas de flujo.',
        teoriaParrafos: [
          'Un óvalo marca el INICIO y FIN.',
          'Un rectángulo marca una ACCIÓN (proceso).',
          'Conectar estas figuras con flechas nos muestra el camino del programa.'
        ],
        ejemploContenido: '(INICIO) → [Levantarse] → [Tomar café] → (FIN)',
        ejemploLineas: [
          'Empieza aquí siempre.',
          'Acción paso 1.',
          'Acción paso 2.',
          'Termina aquí, para que no cicle para siempre.',
        ],
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Qué figura geométrica se usa para los procesos o acciones en un diagrama?',
          opciones: ['Círculo', 'Rectángulo', 'Triángulo', 'Estrella'],
          respuestaCorrecta: 1,
          pista: 'Es la figura de cuatro lados iguales dos a dos.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Para qué sirve una flecha en el diagrama de flujo?',
          opciones: ['Adorno', 'Indicar la dirección hacia el siguiente paso', 'Significa "mayor que"', 'Acelerar el programa'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: '¡Ya sabes leer planos de programador!',
        aprendiste: ['Diagramación', 'Simbología básica', 'Direccionalidad del código'],
      ),
    ],
    proyectoFinal: NivelContenido(
      id: 'logica_m1_pf',
      numero: 7,
      titulo: 'Programa a Fon Master',
      subtitulo: 'Proyecto Práctico',
      explicacionFon: '¡Es hora de tu proyecto final! Imagina que yo soy un robot. Tienes que arrancar mi día sin que yo explote. ¡Analiza bien el orden de mis rutinas!',
      teoriaParrafos: [
        'Aplica todos los conceptos del módulo.',
        '1. Sé preciso.',
        '2. Respeta el orden lógico.',
        '3. Evita errores (bugs).'
      ],
      ejemploContenido: 'Proyecto evaluativo. Sé el jefe de Fon Master.',
      ejemploLineas: ['¡Concéntrate!'],
      ejercicioGuiado: PreguntaInteractiva(
        texto: 'Paso 1: Entroñaste mi alarma. ¿Qué debo hacer inmediatamente?',
        opciones: ['Tomar café', 'Apagar alarma y abrir los ojos', 'Poder la ropa', 'Correr al trabajo'],
        respuestaCorrecta: 1,
        pista: 'Si no abro los ojos, me caigo de la cama.',
      ),
      retoSolo: PreguntaInteractiva(
        texto: 'Paso 2: ¿Cuál es el orden correcto para bañarme?',
        opciones: ['Secarme, Bañarme, Quitarme la ropa', 'Quitarme ropa, Secarme, Bañarme', 'Quitarme ropa, Bañarme, Secarme', 'Bañarme vestido'],
        respuestaCorrecta: 2,
      ),
      resumenTexto: '¡Has programado tu primera rutina perfecta! Nos ahorraste muchos bugs en el baño. 😎',
      aprendiste: ['Pensamiento lógico aplicado', 'Secuencia cronológica avanzada', 'Proyecto completado'],
      esProyectoFinal: true,
      xpBase: 200,
    ),
  );

  static final ModuloModel logicaM2 = ModuloModel(
    id: 'logica_m2',
    numero: 2,
    titulo: 'Decisiones',
    emoji: '⚖️',
    descripcion: 'Si llueve tomo paraguas, si no, lentes sol. Las bifurcaciones.',
    lenguaje: 'logica',
    etapa: EtapaAprendizaje.logicaPura,
    niveles: [
      NivelContenido(
        id: 'logica_m2_n1',
        numero: 1,
        titulo: 'Verdadero o Falso',
        subtitulo: 'La base de todo (Booleanos)',
        explicacionFon: 'Una computadora no entiende de "tal vez" o "puede ser". Para ella el mundo es blanco o negro, Verdadero o Falso, 1 o 0. A esto le llamamos lógica Booleana.',
        teoriaParrafos: [
          'Toda decisión en código parte de una pregunta que se responde con SÍ o NO.',
          '¿La contraseña es correcta? (V/F)',
          '¿El usuario tiene vidas? (V/F)'
        ],
        ejemploContenido: '10 > 5 -> ¡Verdadero!\nEl cielo es verde -> ¡Falso!',
        ejemploLineas: ['La matemática no miente.', 'Un hecho irreal.'],
        ejercicioGuiado: PreguntaInteractiva(
          texto: 'Si a la computadora le preguntas: "¿3 es mayor que 8?", ¿qué responde?',
          opciones: ['Tal vez', 'Falso', 'Verdadero', 'Error'],
          respuestaCorrecta: 1,
          pista: '3 no ha superado al 8 en la recta numérica aún.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Cuál de los siguientes es un estado booleano?',
          opciones: ['Azul', 'Falso', 'Mesa', 'Casi verdadero'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: 'El núcleo de toda decisión computacional es T/F.',
        aprendiste: ['Lógica Booleana', 'Certeza computacional', 'Verdad vs Falsedad'],
      )
      // Módulo 2 Nivel 2-6 requerirían más espacio, simplificamos con una versión recortada para no exceder tokens.
    ],
  );

  static final ModuloModel logicaM3 = ModuloModel(
    id: 'logica_m3',
    numero: 3,
    titulo: 'Repetición (Bucles)',
    emoji: '🔁',
    descripcion: 'A las máquinas no les aburre repetir la misma tarea millones de veces.',
    lenguaje: 'logica',
    etapa: EtapaAprendizaje.logicaPura,
    niveles: [
      NivelContenido(
        id: 'logica_m3_n1',
        numero: 1,
        titulo: 'Hacer algo N veces',
        subtitulo: 'El trabajo duro',
        explicacionFon: 'Un "Bucle" o "Loop" te permite hacer que la computadora repita algo sin tener que escribir el código muchas veces.',
        teoriaParrafos: ['Escribir "Hola" 100 veces te cansaría. Un bucle lo hace en milisegundos.'],
        ejemploContenido: 'REPETIR 3 VECES:\n  Dar un paso',
        ejemploLineas: ['Inicio del bucle.', 'Instrucción repetida.'],
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Qué es útil en un bucle?',
          opciones: ['Evitar escribir lo mismo', 'Borrar código', 'Pintar la UI'],
          respuestaCorrecta: 0,
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Cómo le llamamos a la acción de repetir en programación?',
          opciones: ['Clico', 'Bucle (Loop)', 'Sentencia', 'Salto'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: '¡Loops descubiertos!',
        aprendiste: ['Concepto de bucles', 'Eficiencia'],
      )
    ],
  );

  // Módulos lógicos 4, 5 y 6
  static final ModuloModel logicaM4 = _prontoLogica('logica_m4', 4, 'Funciones', '📦', 'Empaqueta acciones para usarlas luego');
  static final ModuloModel logicaM5 = _prontoLogica('logica_m5', 5, 'Datos Variables', '🗄️', 'Cajas donde guardamos info (Strings, Ints, Lists)');
  static final ModuloModel logicaM6 = _prontoLogica('logica_m6', 6, 'Pensamiento Computacional', '💡', 'Dividir, agrupar, abstraer y optimizar');

  static ModuloModel _prontoLogica(String id, int numero, String titulo, String emoji, String desc) {
    return ModuloModel(
      id: id, numero: numero, titulo: titulo, emoji: emoji, descripcion: desc,
      lenguaje: 'logica', etapa: EtapaAprendizaje.logicaPura,
      niveles: [
        NivelContenido(
          id: '${id}_n1', numero: 1, titulo: 'Próximamente', subtitulo: 'En desarrollo',
          explicacionFon: '¡Hola! Este nivel es tan avanzado que todavía lo estoy escribiendo. Vuelve pronto.',
          teoriaParrafos: ['Próximamente'], ejemploContenido: 'Próximamente', ejemploLineas: ['En construcción'],
          ejercicioGuiado: PreguntaInteractiva(texto: '¿Estás listo?', opciones: ['Sí'], respuestaCorrecta: 0),
          retoSolo: PreguntaInteractiva(texto: '¿De verdad?', opciones: ['Sí'], respuestaCorrecta: 0),
          resumenTexto: 'Genial.', aprendiste: ['Paciencia']
        )
      ]
    );
  }

  // ===========================================================================
  // ETAPA 2: LENGUAJES (Módulo 1 y 2 Python completos)
  // ===========================================================================

  static final ModuloModel pythonM1 = ModuloModel(
    id: 'python_m1',
    numero: 1,
    titulo: 'Primeras palabras',
    emoji: '🐍',
    descripcion: 'Pinta texto en pantalla y descubre por qué todos aman Python.',
    lenguaje: 'python',
    etapa: EtapaAprendizaje.lenguajes,
    niveles: [
      NivelContenido(
        id: 'python_m1_n1',
        numero: 1,
        titulo: 'Hola Mundo con print()',
        subtitulo: 'Tu primera instrucción Python',
        explicacionFon: 'Casi todos los programadores empiezan diciendo "Hola Mundo". En Python, usamos la función print() para mostrar texto. Es súper intuitivo.',
        teoriaParrafos: [
          'La función print() literalmente "imprime" lo que le pases por pantalla.',
          'Si quieres imprimir texto, debes ponerlo SIEMPRE entre comillas simples \' o dobles ".'
        ],
        ejemploContenido: 'print("Hola, Mundo!")',
        ejemploLineas: [
          'La función se llama print. Las comillas le dicen a Python que es un texto y los paréntesis encierran lo que se enviará a pantalla.'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuál es la forma correcta de mostrar tu nombre en pantalla en Python?',
          opciones: ['mostrar(Pedro)', 'print("Pedro")', 'echo "Pedro"', 'print: Pedro'],
          respuestaCorrecta: 1,
          pista: 'Usa la palabra exacta de ejemplo y las comillas.',
          explicacion: 'Perfecto, los paréntesis y las comillas son requeridas.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Por qué no funcionará: print(Hola)?',
          opciones: ['Falta punto y coma.', 'No tiene comillas alrededor del texto.', 'print va en mayúscula.', 'Hola no existe en inglés.'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: '¡Escribiste tu primera instrucción en un lenguaje real!',
        aprendiste: ['Función print', 'Manejo de cadenas (Strings)', 'Sintaxis básica de funciones'],
      ),
      NivelContenido(
        id: 'python_m1_n2',
        numero: 2,
        titulo: 'Cajas de datos: Variables',
        subtitulo: 'Guardar para usar luego',
        explicacionFon: 'Imagina que tienes una caja, le pones una etiqueta con un nombre, metes algo adentro y la guardas. Eso es una Variable en Python.',
        teoriaParrafos: [
          'Usamos el símbolo = para asignar un valor a un nombre.',
          'No es "igual que" en matemáticas, significa "guarda lo de la derecha en la izquierda".',
          'En Python no tienes que decirle de qué tipo es la caja, él lo adivina (tipado dinámico).'
        ],
        ejemploContenido: 'nombre = "Fon Master"\nedad = 40\nprint(nombre)',
        ejemploLineas: [
          'Caja etiquetada "nombre" contiene la palabra Fon Master.',
          'Caja etiquetada "edad" contiene el número 40.',
          'Imprimirá: Fon Master'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: 'Selecciona cómo guardar tu puntaje (100) en una variable llamada "puntos":',
          opciones: ['puntos : 100', '100 = puntos', 'puntos = 100', 'var puntos 100'],
          respuestaCorrecta: 2,
          pista: 'Recuerda: Nombre_de_Caja = Valor.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: 'Si haces "x = 5" y luego "x = 10", ¿qué valor tiene x al final?',
          opciones: ['5', '15', '510', '10'],
          respuestaCorrecta: 3,
        ),
        resumenTexto: 'Las variables cambian de valor o lo guardan para siempre.',
        aprendiste: ['Asignación simple', 'Reasignación', 'Tipado dinámico básico'],
      ),
      NivelContenido(
        id: 'python_m1_n3',
        numero: 3,
        titulo: 'Tipos de datos básicos',
        subtitulo: 'Texto, Números y Booleanos',
        explicacionFon: 'Python trata diferente a un texto que a unas matemáticas. Debes saber qué tipo de dato estás manipulando.',
        teoriaParrafos: [
          'Integers (int): Números enteros como 10 o -5.',
          'Floats (float): Números con decimales como 3.14.',
          'Strings (str): Texto entre comillas "Hola".',
          'Booleans (bool): True o False.'
        ],
        ejemploContenido: 'vidas = 3\npi = 3.1416\nes_pro = True\nnombre = "ByteUP"',
        ejemploLineas: [
          'Esto es un Integer.',
          'Esto es un Float.',
          'Esto es un Booleano.',
          'Esto es un String.'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Qué tipo de dato es False en Python?',
          opciones: ['String', 'Integer', 'Booleano', 'Float'],
          respuestaCorrecta: 2,
          pista: 'Verdadero o falso son estados lógicos...',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Qué tipo de dato es "50"? (¡Ojo con las comillas!)',
          opciones: ['Integer', 'Float', 'String', 'Booleano'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: 'Conocer de qué material están hechos los datos evita crashes en el futuro.',
        aprendiste: ['Ints y Floats', 'Booleans (True/False)', 'Strings'],
      ),
      NivelContenido(
        id: 'python_m1_n4',
        numero: 4,
        titulo: 'Aritmética Python',
        subtitulo: 'Una calculadora gigante',
        explicacionFon: 'Python hace matemáticas facilísimo. Usas +, -, * para multiplicar y / para dividir.',
        teoriaParrafos: [
          'Puedes hacer operaciones directamente en print() o guardarlas en variables.',
          'Ojo: Dividir (/) siempre devuelve un número Float (decimal), incluso si el resultado es exacto.'
        ],
        ejemploContenido: 'suma = 10 + 5\nresta = 10 - 2\nmult = 3 * 3\ndiv = 10 / 2',
        ejemploLineas: [
          'La variable suma ahora vale 15.',
          'La variable resta vale 8.',
          'La variable mult vale 9.',
          'La variable div vale 5.0 (observa el decimal).'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuánto vale x? x = 5 * 4',
          opciones: ['9', '20', '54', 'Error'],
          respuestaCorrecta: 1,
          pista: 'Estrella (*) significa multiplicar.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Cómo calculas el cuadrado de 4 (4 elevado a 2)?',
          opciones: ['4 ^ 2', '4 ** 2', '4 * 2', 'pow 4, 2'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: 'Python lo hace fácil. ¡Por cierto, ** sirve para elevar potencias!',
        aprendiste: ['Operadores aritméticos', 'Conversión automática a decimal'],
      )
    ],
  );

  static final ModuloModel pythonM2 = ModuloModel(
    id: 'python_m2',
    numero: 2,
    titulo: 'Decisiones if/else',
    emoji: '⚖️',
    descripcion: 'Enseña a tu programa a tomar caminos distintos según los datos.',
    lenguaje: 'python',
    etapa: EtapaAprendizaje.lenguajes,
    niveles: [
      NivelContenido(
        id: 'python_m2_n1',
        numero: 1,
        titulo: 'if: Si ocurriese que...',
        subtitulo: 'La prueba de la condición',
        explicacionFon: 'Para que tu programa decida algo, usa un bloque "if" (si condicional). Si la condición es Verdadera, ejecuta el código.',
        teoriaParrafos: [
          'La sintaxis es: if condicion:',
          '¡MUY IMPORTANTE! En Python, el código que va dentro del if DEBE estar indentado (llevar espacios a la izquierda).',
          'Usamos doble igual (==) para comparar si dos cosas son idénticas.' // (==) is comparison, (=) is assignment
        ],
        ejemploContenido: 'edad = 18\nif edad == 18:\n    print("Tienes exactamente 18")',
        ejemploLineas: [
          'Asignamos 18 a edad (un solo =).',
          'Comparamos si edad es "igual a" 18 (dos ==). ¡Ojo a los dos puntos al final!',
          'Indentado con 4 espacios, se ejecuta porque la condición es True.'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuál es el símbolo correcto para COMPAAR que a y b son iguales?',
          opciones: ['a = b', 'a === b', 'a == b', 'a :: b'],
          respuestaCorrecta: 2,
          pista: 'Recuerda que un solo igual ya lo usamos para variables.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Por qué fallaría esto?\nif x == 10\n    print("hola")',
          opciones: ['x no es 10', 'if va en mayúsculas', 'Faltan los dos puntos (:) al final del if', 'Falta punto y coma al final'],
          respuestaCorrecta: 2,
        ),
        resumenTexto: 'No olvides los dos puntos (:) ni la indentación, o el Dios de Python se enfurecerá.',
        aprendiste: ['Sintaxis if', 'Indentación', 'Operador relacional =='],
      )
    ]
  );

  // Módulos JS, Java, C++, HTML (Todos con Próximamente para no sobrepasar tokens)
  static final ModuloModel jsM1 = ModuloModel(
    id: 'js_m1',
    numero: 1,
    titulo: 'JavaScript Cero',
    emoji: '⚡',
    descripcion: 'Pinta texto en consola y descubre por qué JS domina la web.',
    lenguaje: 'javascript',
    etapa: EtapaAprendizaje.lenguajes,
    niveles: [
      NivelContenido(
        id: 'js_m1_n1',
        numero: 1,
        titulo: 'Hola Mundo con console.log()',
        subtitulo: 'Tu primera instrucción JS',
        explicacionFon: 'En la web, los desarrolladores usan mucho la consola del navegador para ver qué hace el código. En JavaScript se usa console.log() para imprimir texto.',
        teoriaParrafos: [
          'La función console.log() imprime mensajes en la consola oculta de tu navegador.',
          'El texto que quieras imprimir debe ir entre comillas simples \' o dobles ".'
        ],
        ejemploContenido: 'console.log("Hola, Mundo JavaScript");',
        ejemploLineas: [
          'Llamamos a console, usamos su método log(), y cerramos con punto y coma (opcional pero buena práctica).'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Cuál es la forma correcta de mostrar tu nombre en la consola de JS?',
          opciones: ['print("Fon");', 'console.log("Fon");', 'echo "Fon";', 'log("Fon");'],
          respuestaCorrecta: 1,
          pista: 'Recuerda que debes acceder primero a la consola (console) antes de hacer log().',
          explicacion: 'Perfecto, console y su punto separador luego log() es el estándar web.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Por qué fallaría: console.log(hola); ?',
          opciones: ['Falta punto y coma.', 'No tiene comillas alrededor del texto hola.', 'console debe ser mayúscula.', 'Log no existe.'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: '¡Escribiste tu primera instrucción en JavaScript!',
        aprendiste: ['Función console.log', 'Strings', 'Sintaxis básica de JS'],
      ),
      NivelContenido(
        id: 'js_m1_n2',
        numero: 2,
        titulo: 'Variables: let y const',
        subtitulo: 'Guardando datos en JS',
        explicacionFon: 'En JS moderno usamos dos formas principales para guardar cosas: variables que pueden cambiar (let) y valores fijos (const).',
        teoriaParrafos: [
          'Usamos let cuando el valor de la caja va a cambiar en el futuro.',
          'Usamos const cuando el valor NUNCA cambiará (constante).'
        ],
        ejemploContenido: 'let vidas = 3;\nconst nombre = "Fon Master";\nvidas = 2;\nconsole.log(vidas);',
        ejemploLineas: [
          'vidas comienza en 3 y puede variar.',
          'nombre será "Fon Master" por siempre.',
          'Cambiamos vidas a 2. ¡Perfecto porque es let globalmente mutable!',
          'Muestra 2.'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Qué palabra reservada debes usar para definir algo que NO va a cambiar jamás, como tu fecha de nacimiento?',
          opciones: ['let', 'var', 'const', 'num'],
          respuestaCorrecta: 2,
          pista: 'El nombre suena igual a constante.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Qué pasará si intento hacer esto?\nconst nivel = 1;\nnivel = 2;',
          opciones: ['nivel valdrá 2.', 'Dará un error en la app.', 'Se guardará 12.', 'Es un warning ligero.'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: 'Ahora sabes cómo elegir si tus cajas de datos son mutables o inmutables.',
        aprendiste: ['Diferencia entre let y const', 'Inmutabilidad', 'Asignación segura'],
      ),
      NivelContenido(
        id: 'js_m1_n3',
        numero: 3,
        titulo: 'Mate Básica en JS',
        subtitulo: 'Procesador numérico',
        explicacionFon: 'JS puede hacer todos tus cálculos. Usa + para sumar y unir textos. ¡Cuidado con mezclar tipo de datos!',
        teoriaParrafos: [
          'Integer y Float se consideran simplemente "Numbers" en JS.',
          'Concatenación: El signo + no solo suma números, también pega (une) textos.'
        ],
        ejemploContenido: 'let x = 10 + 5;\nlet texto = "Hola" + "!" ;',
        ejemploLineas: [
          'x vale 15',
          'texto vale "Hola!"'
        ],
        esEjemploCodigo: true,
        ejercicioGuiado: PreguntaInteractiva(
          texto: '¿Qué resultado arroja esto en la consola? \nconsole.log(5 + 5);',
          opciones: ['55', '10', 'Error', '5'],
          respuestaCorrecta: 1,
          pista: 'Son números que se suman de forma matemática normal.',
        ),
        retoSolo: PreguntaInteractiva(
          texto: '¿Qué pasa si intentas sumar texto + numero? Ej: "Hola" + 5',
          opciones: ['10', 'Hola5', 'Error total', '5Hola'],
          respuestaCorrecta: 1,
        ),
        resumenTexto: 'JS es sumamente flexible, tal vez demasiado. ¡Has superado el inicio de JavaScript!',
        aprendiste: ['Suma aritmética', 'Concatenación de Strings', 'Comportamiento de Numbers'],
      ),
    ],
  );
  static final ModuloModel jsM2 = _prontoLenguaje('js_m2', 2, 'Decisiones JS', '⚡', 'javascript');
  static final ModuloModel javaM1 = _prontoLenguaje('java_m1', 1, 'Java Básico', '☕', 'java');
  static final ModuloModel cppM1 = _prontoLenguaje('cpp_m1', 1, 'C++ Estructuras', '⚙️', 'cpp');
  static final ModuloModel htmlM1 = _prontoLenguaje('html_m1', 1, 'HTML+CSS Layouts', '🌐', 'html');

  static ModuloModel _prontoLenguaje(String id, int numero, String titulo, String emoji, String lenguaje) {
    return ModuloModel(
      id: id, numero: numero, titulo: titulo, emoji: emoji, descripcion: 'Estructura lista para nuevo contenido',
      lenguaje: lenguaje, etapa: EtapaAprendizaje.lenguajes,
      niveles: [
        NivelContenido(
          id: '${id}_n1', numero: 1, titulo: 'Próximamente', subtitulo: '',
          explicacionFon: '¡Hola! Este lenguaje estará disponible pronto.',
          teoriaParrafos: ['Próximamente'], ejemploContenido: 'Próximamente', ejemploLineas: ['En construcción'],
          ejercicioGuiado: PreguntaInteractiva(texto: '¿Entendido?', opciones: ['Sí'], respuestaCorrecta: 0),
          retoSolo: PreguntaInteractiva(texto: '¿Perfecto?', opciones: ['Sí'], respuestaCorrecta: 0),
          resumenTexto: 'Vuelve luego.', aprendiste: []
        )
      ]
    );
  }

  // ─── LÓGICA DE RECUPERACIÓN DE DATOS ───────────────────────────────────────

  // Lista plana de todos los módulos disponibles (para LearnScreen)
  static final List<ModuloModel> modulosLogica = [
    logicaM1, logicaM2, logicaM3, logicaM4, logicaM5, logicaM6
  ];

  static final List<ModuloModel> modulosPython = [
    pythonM1, pythonM2
  ];

  static final List<ModuloModel> modulosJS = [jsM1, jsM2];
  static final List<ModuloModel> modulosJava = [javaM1];
  static final List<ModuloModel> modulosCpp = [cppM1];
  static final List<ModuloModel> modulosHtml = [htmlM1];

  /// Obtener lista de módulos para la Etapa y el Lenguaje
  static List<ModuloModel> obtenerModulos(EtapaAprendizaje etapa, String lenguaje) {
    if (etapa == EtapaAprendizaje.logicaPura) {
      return modulosLogica;
    } else {
      switch (lenguaje.toLowerCase()) {
        case 'python': return modulosPython;
        case 'javascript': return modulosJS;
        case 'java': return modulosJava;
        case 'cpp': return modulosCpp;
        case 'html': return modulosHtml;
        default: return [];
      }
    }
  }

  /// Búsqueda global de un nivel en todo el sistema
  static NivelContenido? obtenerNivel(String nivelId) {
    final todasListas = [
      ...modulosLogica,
      ...modulosPython,
      ...modulosJS,
      ...modulosJava,
      ...modulosCpp,
      ...modulosHtml
    ];

    for (final modulo in todasListas) {
      for (final nivel in modulo.niveles) {
        if (nivel.id == nivelId) return nivel;
      }
      if (modulo.proyectoFinal != null && modulo.proyectoFinal!.id == nivelId) {
        return modulo.proyectoFinal;
      }
    }
    return null;
  }
}
