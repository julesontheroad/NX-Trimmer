***********
NX-Trimmer (v0.3)
***********
Elaborado por JulesOnTheRoad para elotrolado.net
Próximamente en: https://github.com/julesontheroad/NX-Trimmer
---------------
0. Changelog
---------------
v0.3.0 - Realizados bastantes cambios desde la verisón inicial. Los cuáles se detallan a continuación.
   I - Añadida compatibilidad con juegos con más de 5 nca. Estos se dividen en dos casos, los cuáles se detallan a continuación.
       a) Juegos con manual en html (5 nca). En estos se ha decidido eliminar el manual del juego, lo cuál no impide su ejecución. 
	  El intento de acceder al manual desde los juegos que lo incluyen resulta en una acción que no da lugar a ningún 
	  resultado. Los juegos probados pueden jugarse perfectamente sin manual.
       b) Juegos rev con actualizaciones o incluso dlcs. En estos juegos se ha decidido eliminar las actualizaciones y dlcs del xci.
	  Adicionalmente se crean nsps con las actualizaciones o dlcs correspondientes. Para esta función es necesario tener instalado
	  Python en el ordenador.
   II - La ruta de salida se ha movido ha la carpeta "output_nxt" para tenerlo todo más organizado y de cara a que se pueda tener NX-Trimmer
	en la misma carpeta que XCI_Builder, el usará "output_xb" como salida.
   III - Reformado de carpeta ztools, eliminando aplicaciones. 
   IV - Actualización de hacbuild.exe para corregir el warning por falta de "xci_header_key", la cuál no es necesaria para completar el
	proceso pero ahora se puede incorporar rellenando el archivo "header_key.txt" en ztools.
   V  - Añadida plantilla para keys.txt en la carpeta ztools
   VI - Añadido sistema de códigos para la salida de los ficheros. Este consiste en lo siguiente:
	a) Se eliminan las tags [] de los ficheros. Para eliminar cosas como trimmed.
        b) Se eliminan los caracteres _ (más que nada porque no me gusta como quedan)
	c) Se añade las siguientes tags a la salida.
	   [nxt] xci trimeado con NX-Trimmer
	   [nm] "no manual", es decir se ha eliminado el manual para hacer funcionar el xci.
	   [c1][c2]... En nsp de salida: número de orden del contenido adicional incluido en el xci. (Actualizaciones, dlcs ...)
	   [dlc] En nsp de salida significa que el contenido es un dlc
	   [upd] En nsp de salida significa que el contenido es una actualización
	d) Los dlc de salida son ticketless, deberían ir cifrados con la clave de cartucho y ser solo funcionales con SX OS. Para
           hacerlos funcionales habría que añadir un ticket falso como hace 4XCI, lo cuál no es mi objetivo actual.
	e) Las actualizaciones usan common tickets firmados por Nintendo, deberían de ser funcionales con cualquier FW.
  VII - Se elimina el contenido de la partición "normal" ya que está pensada en caso de que cambie el contenido del nca "meta" y el nca "control"
	en revisiones de cartuchos, a día de hoy estos se incluyen también en secure y no es necesaria la copia en "normal". Los cartuchos
	card2 llevan normal vacío por este motivo.
	Dependiendo de las revisiones que introduzcan los futuros card3 puede ser necesario actualizar el programa.
 VIII - Mejor uso de hactool, extrayendo únicamente el contenido de la partición secure.

NOTA: Si se viene de una versión anterior sustituir las aplicaciones de ztools. Se ha actualizado hactool y se ha realizado una pequeña 
      modificación en hacbuild.

v0.2.x - Versiones de desarrollo
v0.1.0 - Lanzamiento inicial

---------------
1. Descripción
---------------
Esta herramienta está pensada para limpiar la partición update y limpiar el padding en archivos xci.
Esta herramienta está diseñada en código batch sirviendo de interfaz de intercambio entre los siguientes programas:
a.) hacbuild: Programa para creación de archivos xci mediante archivos nca. Diseñado por LucaFraga
https://github.com/LucaFraga/hacbuild
b.) hactool: Programa cuya función es mostrar la información, desencriptar y extraer diversos tipos de archivos de datos de Nintendo Switch.
Hactool ha sido diseñado por SciresM
https://github.com/SciresM/hactool
c.) nspBuild: Programa destinado a la creación de archivos nsp a partir de archivos nca. 
nspBuild ha sido diseñado por CVFireDragon
https://github.com/CVFireDragon/nspBuild
Aplicación inspirada en "A Simple XCI, NCA, NSP Extracting Batch file (Just Drag and Drop) with Titlekey decrypt"
creada por Bigjokker y publicada en gbatemp:
https://gbatemp.net/threads/a-simple-xci-nca-nsp-extracting-batch-file-just-drag-and-drop-with-titlekey-decrypt.513300/
---------------
2. Requisitos
---------------
- Es necesario emplear un ordenador con sistema operativo windows.
- Es necesario disponer de un archivo keys.txt con las claves necesarias para el funcionamiento de hactool.
- Es necesario tener Python instalado para el funcionamiento de nspbuild
- Es necesario tener instalado al menos net frameworks 4.5.2 para el funcionamiento de hactool.
---------------
3. Funciones
---------------
- Eliminación de padding, vaciado de particiones, update y normal y eliminación de partición logo.
- Se reconstruyen los cartuchos como "card1"
- Se separan actualizaciones y dlc de los cartuchos rev.
- Se elimina manual de los cartuchos que lo incluyen (minoría) sin perder su funcionalidad.
- Obtención de archivos "game_info" de los juegos.
---------------
4. Limitaciones
---------------
- Actualmente los archivos xci solo funcionan en SX OS
- Debido a un fallo en el diseño de hacbuild no compatible con la construcción de archivos con más de 5nca.
  Una vez actualizado XCI_Builder para incluir las soluciones de NX-Trimmer se continuará investigando.
  El motivo parece ser algún parámetro no documentado de la cabecera del cartucho que dentifica el número de archivos nca de la
  partición secure. Como la mayoría de los XCI usan 4nca es posible que se haya asumido como valor fijo.
  Para su identificación es necesario reformar hacbuild para que respete el padding de los cartuchos y el orden de construcción en
  las particiones.
- Para los archivos con 5nca es necesario eliminar el manual
- Para los archivos rev es necesario extraer las actualizaciones y dlcs en archivos nsp.
- Actualmente el programa no es capaz de identificar la versión de las actualizaciones.
 (No estoy seguro de que sea posible mediante hactool sin extraer los nca y aumentar el tiempo de procesamiento)
- El tiempo de procesado de los juegos de más de 4gb es en proporción más lento debido al fix empleado en hacbuild para darles compatibilidad.
 (Podría ser interesante investigar si existe una forma mejor de procesarlos)
- El símbolo "!" da fallo al ser pasado a hacbuild. Evitad usarlo de momento en el nombre de los ficheros.
-----------------------
5. Uso de la aplicación
-----------------------
I.-   Para el correcto funcionamiento de la aplicación rellenar el archivo "keys.txt" en la carpeta ztools.
      Más información: https://github.com/SciresM/hactool
II.-  Opcionalmente rellenar el archivo header_key.txt con el valor de xci_header_key para ello google es vuestro amigo.
III.- Para recortar un xci arrastrar el archivo xci sobre "NX-Trimmer_v0.3" y esperar a que se cierre
      la consola de sistema.
IV.-  Se obtendrá una carpeta con el "nombre del archivo original" en output_nxt. Dentro habrá un archivo xci de menor
      tamaño que el original
V.-   En caso de que el cartucho incorpore actualizaciones o dlcs se añadirán a la misma carpeta
V.-   Adicionalmente se almacenará el archivo game_info.ini del juego en la carpeta "game_info"
VI.-  Cargar archivo xci en lanzador de SX OS.
VII.- Opcionalmente instalar las actualizaciones o dlcs generados.
------------------
6. Compatibilidad
------------------
Con los cambios añadidos y aceptando las limitaciones descritas este método debería de ser compatible con todos los xci actuales.
Al menos yo no he encontrado incompatibilidades.
--------------------
7. Agradecimentos a: 
--------------------
LucaFraga, SciresM, CVFireDragon y a los miembros de gbatemp y  elotrolado.net

