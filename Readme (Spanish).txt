***********
NX-Trimmer (v0.3)
***********
Elaborado por JulesOnTheRoad para elotrolado.net
Pr�ximamente en: https://github.com/julesontheroad/NX-Trimmer
---------------
0. Changelog
---------------
v0.3.0 - Realizados bastantes cambios desde la veris�n inicial. Los cu�les se detallan a continuaci�n.
   I - A�adida compatibilidad con juegos con m�s de 5 nca. Estos se dividen en dos casos, los cu�les se detallan a continuaci�n.
       a) Juegos con manual en html (5 nca). En estos se ha decidido eliminar el manual del juego, lo cu�l no impide su ejecuci�n. 
	  El intento de acceder al manual desde los juegos que lo incluyen resulta en una acci�n que no da lugar a ning�n 
	  resultado. Los juegos probados pueden jugarse perfectamente sin manual.
       b) Juegos rev con actualizaciones o incluso dlcs. En estos juegos se ha decidido eliminar las actualizaciones y dlcs del xci.
	  Adicionalmente se crean nsps con las actualizaciones o dlcs correspondientes. Para esta funci�n es necesario tener instalado
	  Python en el ordenador.
   II - La ruta de salida se ha movido ha la carpeta "output_nxt" para tenerlo todo m�s organizado y de cara a que se pueda tener NX-Trimmer
	en la misma carpeta que XCI_Builder, el usar� "output_xb" como salida.
   III - Reformado de carpeta ztools, eliminando aplicaciones. 
   IV - Actualizaci�n de hacbuild.exe para corregir el warning por falta de "xci_header_key", la cu�l no es necesaria para completar el
	proceso pero ahora se puede incorporar rellenando el archivo "header_key.txt" en ztools.
   V  - A�adida plantilla para keys.txt en la carpeta ztools
   VI - A�adido sistema de c�digos para la salida de los ficheros. Este consiste en lo siguiente:
	a) Se eliminan las tags [] de los ficheros. Para eliminar cosas como trimmed.
        b) Se eliminan los caracteres _ (m�s que nada porque no me gusta como quedan)
	c) Se a�ade las siguientes tags a la salida.
	   [nxt] xci trimeado con NX-Trimmer
	   [nm] "no manual", es decir se ha eliminado el manual para hacer funcionar el xci.
	   [c1][c2]... En nsp de salida: n�mero de orden del contenido adicional incluido en el xci. (Actualizaciones, dlcs ...)
	   [dlc] En nsp de salida significa que el contenido es un dlc
	   [upd] En nsp de salida significa que el contenido es una actualizaci�n
	d) Los dlc de salida son ticketless, deber�an ir cifrados con la clave de cartucho y ser solo funcionales con SX OS. Para
           hacerlos funcionales habr�a que a�adir un ticket falso como hace 4XCI, lo cu�l no es mi objetivo actual.
	e) Las actualizaciones usan common tickets firmados por Nintendo, deber�an de ser funcionales con cualquier FW.
  VII - Se elimina el contenido de la partici�n "normal" ya que est� pensada en caso de que cambie el contenido del nca "meta" y el nca "control"
	en revisiones de cartuchos, a d�a de hoy estos se incluyen tambi�n en secure y no es necesaria la copia en "normal". Los cartuchos
	card2 llevan normal vac�o por este motivo.
	Dependiendo de las revisiones que introduzcan los futuros card3 puede ser necesario actualizar el programa.
 VIII - Mejor uso de hactool, extrayendo �nicamente el contenido de la partici�n secure.

NOTA: Si se viene de una versi�n anterior sustituir las aplicaciones de ztools. Se ha actualizado hactool y se ha realizado una peque�a 
      modificaci�n en hacbuild.

v0.2.x - Versiones de desarrollo
v0.1.0 - Lanzamiento inicial

---------------
1. Descripci�n
---------------
Esta herramienta est� pensada para limpiar la partici�n update y limpiar el padding en archivos xci.
Esta herramienta est� dise�ada en c�digo batch sirviendo de interfaz de intercambio entre los siguientes programas:
a.) hacbuild: Programa para creaci�n de archivos xci mediante archivos nca. Dise�ado por LucaFraga
https://github.com/LucaFraga/hacbuild
b.) hactool: Programa cuya funci�n es mostrar la informaci�n, desencriptar y extraer diversos tipos de archivos de datos de Nintendo Switch.
Hactool ha sido dise�ado por SciresM
https://github.com/SciresM/hactool
c.) nspBuild: Programa destinado a la creaci�n de archivos nsp a partir de archivos nca. 
nspBuild ha sido dise�ado por CVFireDragon
https://github.com/CVFireDragon/nspBuild
Aplicaci�n inspirada en "A Simple XCI, NCA, NSP Extracting Batch file (Just Drag and Drop) with Titlekey decrypt"
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
- Eliminaci�n de padding, vaciado de particiones, update y normal y eliminaci�n de partici�n logo.
- Se reconstruyen los cartuchos como "card1"
- Se separan actualizaciones y dlc de los cartuchos rev.
- Se elimina manual de los cartuchos que lo incluyen (minor�a) sin perder su funcionalidad.
- Obtenci�n de archivos "game_info" de los juegos.
---------------
4. Limitaciones
---------------
- Actualmente los archivos xci solo funcionan en SX OS
- Debido a un fallo en el dise�o de hacbuild no compatible con la construcci�n de archivos con m�s de 5nca.
  Una vez actualizado XCI_Builder para incluir las soluciones de NX-Trimmer se continuar� investigando.
  El motivo parece ser alg�n par�metro no documentado de la cabecera del cartucho que dentifica el n�mero de archivos nca de la
  partici�n secure. Como la mayor�a de los XCI usan 4nca es posible que se haya asumido como valor fijo.
  Para su identificaci�n es necesario reformar hacbuild para que respete el padding de los cartuchos y el orden de construcci�n en
  las particiones.
- Para los archivos con 5nca es necesario eliminar el manual
- Para los archivos rev es necesario extraer las actualizaciones y dlcs en archivos nsp.
- Actualmente el programa no es capaz de identificar la versi�n de las actualizaciones.
 (No estoy seguro de que sea posible mediante hactool sin extraer los nca y aumentar el tiempo de procesamiento)
- El tiempo de procesado de los juegos de m�s de 4gb es en proporci�n m�s lento debido al fix empleado en hacbuild para darles compatibilidad.
 (Podr�a ser interesante investigar si existe una forma mejor de procesarlos)
- El s�mbolo "!" da fallo al ser pasado a hacbuild. Evitad usarlo de momento en el nombre de los ficheros.
-----------------------
5. Uso de la aplicaci�n
-----------------------
I.-   Para el correcto funcionamiento de la aplicaci�n rellenar el archivo "keys.txt" en la carpeta ztools.
      M�s informaci�n: https://github.com/SciresM/hactool
II.-  Opcionalmente rellenar el archivo header_key.txt con el valor de xci_header_key para ello google es vuestro amigo.
III.- Para recortar un xci arrastrar el archivo xci sobre "NX-Trimmer_v0.3" y esperar a que se cierre
      la consola de sistema.
IV.-  Se obtendr� una carpeta con el "nombre del archivo original" en output_nxt. Dentro habr� un archivo xci de menor
      tama�o que el original
V.-   En caso de que el cartucho incorpore actualizaciones o dlcs se a�adir�n a la misma carpeta
V.-   Adicionalmente se almacenar� el archivo game_info.ini del juego en la carpeta "game_info"
VI.-  Cargar archivo xci en lanzador de SX OS.
VII.- Opcionalmente instalar las actualizaciones o dlcs generados.
------------------
6. Compatibilidad
------------------
Con los cambios a�adidos y aceptando las limitaciones descritas este m�todo deber�a de ser compatible con todos los xci actuales.
Al menos yo no he encontrado incompatibilidades.
--------------------
7. Agradecimentos a: 
--------------------
LucaFraga, SciresM, CVFireDragon y a los miembros de gbatemp y  elotrolado.net

