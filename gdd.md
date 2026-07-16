# 🎮 GAME DESIGN DOCUMENT 
## 1 – Introducción 
### 1.1 – Descripción General 
[“El Recolector del Cielo” es un videojuego llamativo, de esos que son descargados simplemente para pasar el rato y despejar la mente, por la facilidad de juego y lo sencillo de la dinámica. Del tipo que te entretendría en la sala de espera de una guardia médica].

[El personaje principal es un Robot, cuyo nombre es Sky, – un reciente avance para la ciencia del futuro – al principio del juego sus habilidades son básicas y sus movimientos lentos, pero que van mejorando a medida que se alcanzan ciertos niveles hito (nivel 5, 10, 15...) o bien con las adquisiciones en la tienda de mejoras (cuya moneda de cambio son las recompensas de juego, o bien opciones pagas para el jugador)]. 

[Como el nombre del juego lo indica, Sky deberá recolectar recursos necesarios para que la humanidad sobreviva, siendo este el motivo de su creación. Esos recursos están dispersos por el espacio interestelar. El problema es que, ciertas afecciones en el clima por el calentamiento global, han hecho que haya una constante lluvia de meteoritos que él debe esquivar (y, de no hacerlo, se pierden las vidas del personaje)]. 

[A medida que los niveles crecen en dificultad, si bien Sky tiene habilidades mayores, también se incrementa la intensidad de esas lluvias de meteoros, y los recursos permanecen menos tiempo en pantalla para ser atrapados]. 



[Los niveles se superan cuando se alcanza la cantidad requerida de recursos, en el tiempo de partida determinado]. 

[El juego tiene una estética colorida, controles simples y partidas rápidas, pensado como una aplicación para dispositivos celulares]. 

### 1.2 – Audiencia Objetivo 
[Jugadores casuales entre 8 y 25 años que disfrutan de los videojuegos rápidos, con recompensas y mejoras inmediatas. Está pensado para quienes quieren una distracción rápida, con partidas cortas, y progresión en la dificultad de sus niveles]. 
 ### 1.3 – Ejemplos de Juegos Similares 
[•	Asteroids: comparte la inclusión de meteoritos/asteroides en la filosofía de juego, siendo precisamente el objetivo sobrevivir y esquivarlos. Aunque es un juego sin ninguna narrativa detrás. 
•	Subway Surfers: tienen en común la dinámica de juego que es recolectar y esquivar. Es un juego que también fue pensado para celulares y tiempos de juego cortos, y que a su vez incluye un sistema de mejoras (mejoras en el personaje, power ups, etc.) 
•	Galaga: mismo contexto de juego (el espacio interestelar), de estilo arcade, y en donde se tiene que reaccionar con rapidez, siendo que si no se evita el impacto se pierden vidas de juego]. 

### 1.4 – Puntos Clave de Venta 
[•	Es un juego sencillo y fácil de aprender, que abarca a un amplio rango etario de los jugadores.
•	Partidas rápidas, que te permiten entretenerte en lapsos cortos y luego retomar donde lo dejaste. 
•	Incremento constante en la dificultad: lo que mantiene al jugador atrapado en la dinámica y con esa necesidad de progresar. 
•	Estética atractiva visualmente, sin perder la simpleza]. 

### 2 – Gameplay y Mecánicas 
[El gameplay de “El Recolector del Cielo” se centra en un mundo intergaláctico, compuesto por cinco esferas en las que el jugador avanza a medida que se desbloquean los niveles. Cada una de esas esferas hace alusión lo que en algún momento fueron los continentes, antes de que la humanidad destruyera lo que fue el Planeta Tierra]. 

[Cada nivel abre una escena de juego (ambientada según la esfera de jugabilidad), en la cual el jugador debe moverse para recolectar recursos (carbón, distintos metales, elementos medicinales humanos, comidas enlatadas) y a su vez esquivar los peligrosos meteoros]. 

[Los niveles son superados a medida que se completa el requerimiento del nivel (Ej: recolectar 15 gemas de diamante y 2 latas de atún). Existiendo un tiempo determinado en el marcador del reloj. 
Si el personaje robótico Sky es golpeado más de tres (3) veces por los meteoros, se pierde una vida y debe reiniciarse el nivel]. 

[Cada nivel se incrementa en dificultad, y una vez superado le da al jugador recompensas (dinero intergaláctico) que puede dirigirse a gastar en la tienda (conocido como el Taller)].

[Hay recursos que aparecen con menor frecuencia que otros – son raros – y que son necesarios para completar misiones subalternas que otorgan créditos extra para usar en la tienda]. 
________________________________________
### 2.1 – Loop del Juego 
[1.	El juego inicia con una breve presentación de Sky, el Robot protagonista. 
2.	El jugador comienza una partida, y cuenta con un total de cinco (5) vidas, que son regeneradas a lo largo de 1 hora, o bien pueden obtenerse mediante pago si no se desea esperar.
3.	Al iniciar el nivel, se indican en pantalla los recursos necesarios para superarlo y un temporizador. 
4.	Durante la partida, el jugador debe recolectar dichos recursos, esquivando meteoritos.  
5.	La dificultad aumenta progresivamente, tanto en su frecuencia de aparición como en su velocidad de impacto.
6.	La partida finaliza si el jugador recibe más de tres (3) impactos de meteoros, o si se agota el tiempo sin alcanzar el objetivo de recursos, perdiendo la vida en ambos casos. 
7.	Al completar el nivel, se le atribuyen al jugador recompensas (dinero intergaláctico). 
8.	El jugador puede gastar el dinero del juego en la tienda, en pro de adquirir mejoras.
9.	Existen misiones complementarias, que son completadas con recursos especiales – que aparecen esporádicamente y con escasa frecuencia –. 
10.	 A medida que avanza el juego, aumentan los obstáculos, pero también mejoran las capacidades de Sky, como su velocidad de movimiento].  
________________________________________
### 2.2 – Sistema de Progresión y Árbol de Mejoras
[El juego incorpora un árbol de mejoras que permite ampliar el gameplay y evitar la repetición constante de partidas idénticas. Al finalizar cada partida, el jugador obtiene:
•	Una determinada cantidad de créditos/recompensas, el cual en la jerga del juego es conocido como “dinero intergaláctico”. El cual el jugador puede gastar libremente en la tienda, mejor conocida como “el Taller” – en el cual se accede al aludido árbol de mejoras. 
•	Se le entregan los recursos raros que haya recolectados, que como se ha mencionado en el gameplay son de utilidad para completar misiones complementarias (según el tipo de recurso requerido por las mismas). 
•	A su vez, ciertos niveles tienen preestablecidos la entrega de power ups sorpresa].
________________________________________
**🌳 Ramas del Árbol de Mejoras**
**🚀 Movilidad**
[Mejoras enfocadas en la agilidad y control del personaje:
•	Velocidad aumentada: incrementa la capacidad de desplazamiento y aumenta la probabilidad de que aparezcan recursos atípicos. 
•	Visión del futuro: permite una vez por partida predecir el lugar de caída de los meteoritos, antes de que ocurra; es como un mapa previo de donde se estrellarán. 
•	Propulsores: permite sobrevolar el terreno por unos segundos, sin ser atacado por los meteoros]. 
________________________________________
**❤️ Supervivencia**
[Mejoras enfocadas en resistir más tiempo:
•	Vidas adicionales: sin tener que esperar el tiempo pautado para su regeneración.
•	Escudo: repele las tormentas cósmicas.  
•	Congelado: permite congelar el cronómetro de la partida, y seguir recolectando].
________________________________________
**⚡ Recolección**
[Mejoras orientadas a maximizar puntos y recompensas:
•	Imán de recursos: atrae recursos sin tener que acercarse completamente.
•	Ralentización temporal: disminuye la velocidad de todo alrededor, menos la de Sky para recolectar. 
•	Onda de choque: aleja por unos segundos los meteoros del área].
________________________________________
### 2.3 – Power-Ups Temporales
[Durante la partida pueden aparecer power-ups de duración limitada que alteran momentáneamente el gameplay:
•	Fase espectral: Sky puede atravesar los meteoritos sin verse afectado por el impacto. 
•	Vale doble: multiplica los recursos recolectados.
•	Radar intergaláctico: aumenta la probabilidad de aparición de recursos especiales.
•	Absorción energética: los meteoritos se transforman en recursos a medida que caen].
________________________________________
### 2.4 – Enemigos y Amenazas Variadas
[Para ampliar la variedad de situaciones, el juego presenta distintos tipos de peligros:
•	Meteoritos: pequeños y veloces, y que de impactar reducen la supervivencia de Sky.
•	Drones rivales: existen en el universo intergaláctico personas malintencionadas, que quieren apropiarse de los recursos.
•	Tormentas cósmicas: empujan a Sky y dificultan el control. Pueden subsanarse mediante la utilización del escudo. 
•	Plagas orbitales: insectos infecciosos que se pegan a Sky y hacen que el tiempo del cronómetro corra más deprisa].
________________________________________


### 2.5 – Eventos Dinámicos
[Durante la partida pueden activarse eventos aleatorios que modifican temporalmente el entorno:
•	Niebla: una niebla repentina invade la pantalla de juego, reduciendo la visibilidad para recolectar.
•	Inversión gravitatoria: cambia la dirección de caída de los meteoritos.
•	Zonas inseguras temporales: aparición de recursos extremadamente raros, pero los meteoros duplican su tamaño, y con un solo impacto pueden acabar con Sky.
•	Sobrecarga: todo comienza a moverse al doble de su velocidad habitual]. 
________________________________________
### 2.6 – Impacto en la Experiencia de Juego
[El Recolector del Cielo y su gran modalidad, pretenden ser un juego sencillo, que abarque a un amplio rango etario. Como la filosofía de juego es simple (recolectar recursos y esquivar meteoros), es que se añade variedad de amenazas y eventos dinámicos, cuya aparición ocurre a medida que se avanza a través de los niveles]. 

[De esta manera se evita la monotonía y que una partida sea igual a otra. A su vez, el jugador dispone de un amplio árbol de mejoras que puede utilizar a su antojo, sumado a que las partidas son rejugables (permitiéndole ganar experiencia y tomar decisiones estratégicas)]. 
### 3 – Arte 
[•	La idea de juego es caricaturesca, Sky es el personaje principal y tiene una imagen amigable.
•	En el mundo intergaláctico se encuentran flotando cinco (5) esferas brillantes, que demarcan la progresión en los niveles, y cada una tiene su propia ambientación. Esa ambientación se caracteriza por un color principal (ej. rojo) y un derivado del mismo (tonos más oscuros para hacer contraste de sombras, como el violeta). 
•	El espacio interestelar es oscuro, pero la zona se ve constantemente iluminada por la presencia de meteoritos y por los recursos que se iluminan a la vista del jugador. De fondo pueden verse algunas estrellas fugaces o naves perdidas.
•	Los meteoritos son pelotas ovaladas con incrustaciones.  
•	Los power ups aparecen en pantalla como una insignia dorada, como si fueran parches a coser en el traje espacial. 
•	La presencia de eventos dinámicos (como tormentas) figuran como un globo de texto poco segundos antes de hacer presencia]. 



	





Pantalla de inicio: dispositivos móviles.






### 4 – Historia 
[En un futuro distante, la Tierra tal y como la conocemos ha dejado de existir. Tan sólo unos pocos pudieron escapar y sobrevivir en el espacio intergaláctico, con todos los peligros que hay allí afuera]. 

[Se organizaron en ciudades flotantes, en un total de cinco esferas brillantes, como lo que en su momento fueron los cinco continentes. Para que las ciudades funcionen se necesitan recursos: carbón, aleaciones de metal, medicinas y todos los enlatados posibles hasta que los cultivos comiencen de nuevo a funcionar]. 

[Por ello es que un grupo de los mejores científicos, debieron llevar a cabo un proyecto especializado conocido como “El Recolector del Cielo”, y cuyo producto fue Sky – el robot recolector. Los materiales con los que fue construido lo hacen mucho más resistente a una actividad anómala: los meteoros, por lo cual es más seguro que sea él quien se encargue de recolectar los recursos necesarios]. 

[Otros riesgos rondan el espacio interestelar como: tormentas cósmicas, niebla repentina y plagas orbitales. Cada nueva misión de Sky pone a prueba su resistencia, pero también permite mejorar su equipamiento con las adquisiciones en el Taller].
________________________________________
### 5 – Descripción de la Sesión de Juego 
[Al iniciar la sesión, el jugador se le presenta una breve introducción de quien es Sky y el contexto del mundo intergaláctico. Luego accede a la primera de las esferas, donde comienza a jugar por el nivel 1.
Una vez dentro del nivel, la pantalla muestra los recursos necesarios para completarlo y un temporizador. Si se acaba el tiempo, o si Sky es impactado más de (3) veces por meteoros, deberá reiniciarse la partida, restándose una vida del total]. 

[La experiencia de juego es progresiva: se desbloquean recursos especiales y con ellos las misiones complementarias, aparecen en pantalla power ups temporales (preestablecidos según el nivel y su complejidad) y también se descongelan distintos tipos de mejoras en la tienda]. 


[Durante la partida, pueden además activarse eventos dinámicos: como la niebla que le dificulta la visibilidad al jugador, o la sobrecarga haciendo que todo se mueva a un ritmo alarmantemente rápido].

[Si el jugador logra recolectar todos los recursos antes de que se agote el tiempo y sin que Sky sea destrozado por los meteoros: completa el nivel y recibe a cambio dinero intergaláctico, que podrá utilizar para adquirir las mencionadas mejoras].

[Caso contrario, la partida finaliza y el jugador pierde una vida, siendo los niveles rejugables].

### 6 – Música 
[•	Cada partida tiene un sonido tenue de fondo. 
•	Cuando los meteoros alcanzan a Sky se escucha un estruendo por el impacto.
•	Las situaciones de tensión o eventos dinámicos son acompañados musicalmente: algunos ejemplos,
­	la niebla (se escucha como susurro o viento), 
­	zonas inseguras (alarma),
­	sobrecarga (se escuchan como chispazos).
•	Al recolectar un recurso especial se escucha un tintineo por la recompensa].


