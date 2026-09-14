# Documento de Diseño Técnico
## Technical Design Document (TDD)

### El recolector del cielo
**Versión 0.0.1**

**Equipo / estudio:** Alejandro Spengler – Trabajo Final Programación de Videojuegos 3

---

## Descripción Técnica del Proyecto

Proyecto de videojuego 2D desarrollado en **Godot 4.6** utilizando **GDScript** como lenguaje principal. El proyecto está organizado de forma modular mediante carpetas específicas para personajes, niveles, objetos, sistemas, interfaz de usuario, audio y tilesets.

La escena inicial del proyecto es `res://main/main_menu.tscn`. La lógica del juego incluye control de personaje mediante acciones de movimiento y salto, administración de niveles, interfaz de usuario y un sistema de persistencia de partida.

El guardado se realiza mediante `ConfigFile` y almacena información como nivel actual, puntaje y cantidad de muertes.

---

## Plataformas Objetivo y Requerimientos

- **Plataforma principal:** PC / escritorio.
- **Motor:** Godot 4.6.
- **Resolución base:** 800 x 800 píxeles.
- **Modo de escalado:** `viewport`.
- **Framerate objetivo:** 60 FPS.
- **Interpolación de físicas:** activada.
- **Controles principales:** teclado.
- **Carga de partida:** local, sin necesidad de conexión a Internet.
- **Persistencia:** almacenamiento en `user://savegame.cfg`.

> Nota: el repositorio público no incluye información suficiente para confirmar presets de exportación adicionales. Por este motivo, PC se considera la plataforma objetivo principal del TDD.

---

## Herramientas y Versiones

- **Motor de juego:** Godot 4.6.
- **Lenguaje principal:** GDScript.
- **Sistema de escenas:** escenas `.tscn` de Godot.
- **Sistema de recursos:** recursos nativos de Godot.
- **Persistencia:** `ConfigFile` de Godot.
- **Control de versiones:** Git.
- **Repositorio remoto:** GitHub.
- **Edición gráfica / animaciones:** recursos importados dentro del proyecto; la herramienta externa concreta no se encuentra especificada en el repositorio.
- **Sistema de builds:** exportación mediante Godot; no se observa actualmente una configuración pública de CI/CD en el repositorio.

---

## Estructura Técnica del Proyecto

El proyecto utiliza una estructura modular por responsabilidad.

- `/audio/`: recursos relacionados con sonido y música.
- `/characters/`: personajes y lógica asociada.
- `/levels/`: escenas y recursos correspondientes a los niveles.
- `/main/`: escenas principales y menú del juego.
- `/objects/`: objetos interactivos o reutilizables.
- `/systems/`: sistemas generales de gameplay.
- `/tileset/`: recursos y configuraciones de TileSet.
- `/ui/`: elementos de interfaz de usuario.
- `/Documentos/`: documentación del proyecto.
- `/comentarios/`: archivos complementarios o anotaciones del proyecto.
- `project.godot`: configuración general del proyecto.
- `save_system.gd`: sistema de guardado y carga.

La escena de inicio definida en el proyecto es:

`res://main/main_menu.tscn`

La separación por carpetas permite mantener independientes los elementos de gameplay, presentación, niveles, audio y persistencia.

---

## Guía de estilo

Para mantener consistencia con GDScript y con la estructura existente del proyecto:

- Utilizar **snake_case** para variables y funciones.
  - Ejemplo: `current_level`, `save_game()`.
- Utilizar nombres descriptivos para scripts, escenas y nodos.
- Utilizar **MAYÚSCULAS_CON_GUIONES_BAJOS** para constantes.
  - Ejemplo: `SAVE_FILE_PATH`.
- Las funciones internas del ciclo de Godot mantienen la nomenclatura propia del motor:
  - `_ready()`
  - `_process()`
  - `_physics_process()`
- Utilizar una tabulación por nivel de indentación.
- Agregar comentarios solamente cuando la intención del código no sea evidente.
- Separar responsabilidades: la lógica de persistencia debe permanecer fuera de la lógica específica de las escenas.
- Evitar rutas absolutas del sistema; utilizar `res://` y `user://`.
- Mantener nombres de carpetas y archivos consistentes y descriptivos.

---

## Integraciones Externas

Actualmente no se identifican SDK externos obligatorios dentro del repositorio.

Integraciones utilizadas:

- **GitHub:** alojamiento y control de versiones del código fuente.
- **Godot Engine:** motor y APIs internas utilizadas por el proyecto.
- **Sistema de archivos local de Godot:** utilizado para la persistencia de partidas mediante `ConfigFile`.

No se observan servicios externos de login, analytics, servidores o APIs web requeridos para ejecutar el juego.

---

## Riesgos Técnicos

- El guardado depende de un único archivo `user://savegame.cfg`; un archivo corrupto puede impedir recuperar el progreso.
- No se observa un sistema de versionado o migración del formato de partidas guardadas.
- El sistema de guardado persiste únicamente datos concretos (`current_level`, `score`, `deaths`), por lo que cualquier nueva variable de progreso deberá incorporarse explícitamente.
- La estructura del proyecto contiene distintos sistemas y escenas que deben conservar referencias válidas al mover o renombrar archivos.
- Las configuraciones de input dependen de acciones registradas en `project.godot`; cambiar sus nombres requiere actualizar los scripts que las utilizan.
- El proyecto utiliza una resolución base cuadrada de 800x800, por lo que debe comprobarse la adaptación de UI y cámaras en relaciones de aspecto diferentes.
- Al no observarse pruebas automatizadas ni CI público, existe riesgo de introducir regresiones al integrar cambios.

---

## Sistemas de Juego

### Movimiento e input

El proyecto define acciones propias en el Input Map de Godot:

- `jump`
- `move_bottom`
- `move_left`
- `move_right`
- `move_up`

La entrada principal se realiza mediante teclado. La configuración permite desacoplar las teclas físicas de la lógica de movimiento.

### Físicas

- El proyecto utiliza el sistema de físicas de Godot.
- La interpolación de físicas está habilitada.
- El proyecto utiliza ajuste de transformaciones 2D a píxel, apropiado para mantener estabilidad visual en elementos 2D.

### Niveles

Los niveles se encuentran separados dentro de `/levels/`.

El sistema de persistencia registra el número del nivel actual en `current_level`, permitiendo recuperar el progreso de una partida guardada.

### Puntaje

El sistema de guardado mantiene un valor `score`, utilizado para conservar el puntaje entre sesiones.

### Muertes

El sistema registra un contador `deaths`, que forma parte del progreso persistente.

### Guardado y carga

El script `save_system.gd` administra la persistencia.

Datos almacenados:

- `has_save`
- `current_level`
- `score`
- `deaths`

Funciones principales:

- `save_game(level, score, deaths)`
- `load_game()`
- `has_save()`
- `delete_save()`
- `get_current_level()`

El archivo se guarda en:

`user://savegame.cfg`

### Interfaz

La UI se mantiene separada dentro de `/ui/`.

La aplicación comienza en un menú principal mediante:

`res://main/main_menu.tscn`

---

## Flujo de pantallas

Flujo general previsto a partir de la estructura actual:

```text
Inicio de aplicación
        |
        v
Menú Principal
        |
        +---- Nueva partida ----> Nivel 1
        |
        +---- Continuar --------> Cargar savegame.cfg
        |                         |
        |                         v
        |                    Nivel guardado
        |
        +---- Salir
```

Durante gameplay:

```text
Nivel actual
    |
    +--> Movimiento del jugador
    |
    +--> Objetos / sistemas del nivel
    |
    +--> UI
    |
    +--> Puntaje
    |
    +--> Muertes
    |
    +--> Guardado de progreso
```

El menú principal funciona como punto de entrada del proyecto y desde allí se organiza el acceso al gameplay y a las partidas guardadas.

---

## Control de Versiones y política de branching

- **Sistema:** Git.
- **Repositorio remoto:** GitHub.
- **Repositorio:** `Alesparg/Trabajo-final-programacion-de-videjuegos-3`.
- **Rama principal observada:** `main`.

Política recomendada para el proyecto:

- `main`: versión estable y entregable.
- `develop`: integración de cambios antes de pasar a producción.
- `feature/nombre-feature`: nuevas funcionalidades.
- `fix/nombre-fix`: correcciones de errores.
- `docs/nombre-documento`: cambios de documentación.

Formato recomendado para versiones:

`v[mayor].[menor].[parche]`

Ejemplos:

- `v0.1.0`
- `v0.2.0`
- `v1.0.0`

Los commits deben describir claramente la modificación realizada y evitar mezclar funcionalidades independientes en un mismo commit.

---

## Objetivos Técnicos

- Mantener una ejecución estable a **60 FPS** en equipos de escritorio de gama media.
- Mantener separadas las responsabilidades de personajes, niveles, UI, audio, objetos y sistemas.
- Evitar dependencias innecesarias entre escenas.
- Mantener una resolución lógica base de **800x800** con adaptación mediante viewport.
- Garantizar que el guardado y la carga no bloqueen el gameplay.
- Conservar correctamente nivel actual, puntaje y muertes entre sesiones.
- Permitir agregar nuevos niveles sin modificar de forma significativa la arquitectura global.
- Facilitar el mantenimiento del proyecto mediante una estructura de carpetas consistente.
- Evitar referencias rotas al reorganizar escenas o recursos.

---

## Detalles de creación de objetos de juego

### Construcción de un personaje

1. Crear la escena del personaje dentro de `/characters/`.
2. Utilizar un nodo adecuado al tipo de personaje, por ejemplo `CharacterBody2D` para personajes controlados mediante físicas.
3. Agregar el elemento visual correspondiente (`Sprite2D` o `AnimatedSprite2D`).
4. Incorporar una forma de colisión mediante `CollisionShape2D`.
5. Asociar el script de comportamiento del personaje.
6. Leer los inputs mediante las acciones configuradas en `project.godot`.
7. Procesar el movimiento dentro del ciclo de físicas.
8. Agregar la escena del personaje al nivel correspondiente mediante instanciación.

### Creación de un nivel

1. Crear una nueva escena dentro de `/levels/`.
2. Incorporar los TileMaps/TileSets necesarios utilizando recursos de `/tileset/`.
3. Instanciar al personaje.
4. Agregar objetos desde `/objects/`.
5. Instanciar la interfaz necesaria desde `/ui/`.
6. Configurar colisiones y límites del escenario.
7. Incorporar los sistemas requeridos.
8. Definir las condiciones para finalizar o cambiar de nivel.
9. Actualizar el valor de `current_level` al guardar el progreso.

### Creación de objetos

1. Crear la escena reutilizable dentro de `/objects/`.
2. Definir un nodo raíz según su comportamiento.
3. Agregar representación gráfica.
4. Configurar colisiones si el objeto interactúa físicamente.
5. Asociar un script solamente si requiere lógica propia.
6. Instanciar el objeto dentro de uno o más niveles.

### Configuración de parámetros del juego

Los parámetros globales deben definirse en ubicaciones centralizadas siempre que sea posible:

- Acciones de teclado: `project.godot`.
- Configuración de ventana: `project.godot`.
- Persistencia: `save_system.gd`.
- Recursos de nivel: `/levels/`.
- Recursos visuales de mapa: `/tileset/`.
- Interfaz: `/ui/`.

---

## Detalles de funcionamiento de sistemas

### Flujo de guardado

```text
Gameplay
   |
   v
save_game(level, score, deaths)
   |
   v
Actualizar diccionario save_data
   |
   v
Crear ConfigFile
   |
   v
Guardar valores en sección "game"
   |
   v
user://savegame.cfg
```

### Flujo de carga

```text
Menú / Sistema
   |
   v
load_game()
   |
   v
Abrir user://savegame.cfg
   |
   +---- Error ----> No existe partida / retornar null
   |
   v
Leer sección "game"
   |
   v
Restaurar:
- has_save
- current_level
- score
- deaths
   |
   v
Continuar partida
```

### Eliminación del guardado

`delete_save()` elimina el archivo de guardado y reinicia los valores internos a:

- `has_save = false`
- `current_level = 1`
- `score = 0`
- `deaths = 0`

### Cambio y recuperación de nivel

`get_current_level()` comprueba primero si existe una partida guardada. Si existe, carga los datos y devuelve el nivel almacenado. Si no existe, devuelve el nivel 1 como valor inicial.

---

## Otros

- El proyecto utiliza **Godot 4.6**.
- La resolución lógica configurada es **800 x 800**.
- El modo de estiramiento configurado es `viewport`.
- La interpolación de físicas se encuentra habilitada.
- El ajuste de transformaciones 2D a píxel se encuentra habilitado.
- El menú principal es la escena inicial.
- El sistema de guardado utiliza `ConfigFile`, evitando dependencias de librerías externas.
- Los datos persistentes se almacenan dentro de `user://`, por lo que permanecen separados de los recursos incluidos en el ejecutable.
- El proyecto se encuentra organizado modularmente en carpetas especializadas, facilitando la expansión y el mantenimiento.
