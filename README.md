# Nota

EN 🇬🇧: This app/script allows you to take notes in the Linux console and organize them using a simple command. The notes will be available in any terminal and bash session.

ES 🇪🇸: Esta app/script permite tomar notas en la consola linux y organizarlas mediante un simple comando. Las notas estarán disponibles en cualquier terminal y sessión bash.

![List / lista](screenshots/listanotas_simple.png)

## Description / Descripción

Features:

- 🇬🇧 Can be tested portable (no installation required)
- 🇪🇸 Se puede probar de forma portable (no se requiere instalación)

- 🇬🇧 Can be run from any location once installed
- 🇪🇸 Se puede ejecutar desde cualquier ubicación una vez instalado

- 🇬🇧 Check the list of saved notes, the most recent ones are shown first
- 🇪🇸 Consulta la lista de notas guardadas, se muestran primero las más recientes

- 🇬🇧 Save notes with content (title + content)
- 🇪🇸 Guarda notas con contenido (título + contenido)

- 🇬🇧 Save notes without content (just a title)
- 🇪🇸 Guarda notas sin contenido (sólo un título)

- 🇬🇧 Delete notes
- 🇪🇸 Elimina notas

- 🇬🇧 Edit the content of a note
- 🇪🇸 Edita el contenido de una nota

- 🇬🇧 Edit notes with the default editor (nano) or an external editor (you can edit the .settings file to change the default editor)
- 🇪🇸 Edita notas con el editor por defecto (nano) o un editor externo (puedes editar el file .settings para cambiar el editor por defecto)

- 🇬🇧 Create categories (group of notes)
- 🇪🇸 Crea categorías (grupo de notas)

- 🇬🇧 Rename the title of a note or that of a category
- 🇪🇸 Renombre el título de una nota o el de una categoría

- 🇬🇧 Move notes within a category
- 🇪🇸 Mueve notas dentro de una categoría

- 🇬🇧 Shows the path to the file that represents (contains) a note
- 🇪🇸 Muestra la ruta al archivo que representa (contiene) una nota

- 🇬🇧 Raise a note to be displayed first
- 🇪🇸 Eleva una nota para que se muestre en primer lugar

- 🇬🇧 Easily transportable notes (just copy and paste)
- 🇪🇸 Notas fácilmente transportables (sólo copiar y pegar)

- 🇬🇧 Support for more than one language (Spanish and English for now, you can add your own language)
- 🇪🇸 Soporte para más de un lenguaje (Español e Inglés por ahora, puedes añadir tu propio idioma)


🇬🇧 Notes are saved in the same directory where the script is located (if it is not installed)
🇪🇸 Las notas se guardan en el mismo directorio donde se encuentra el script (si no está instalado)

🇬🇧 Notes are saved within a directory on the user's Home (~/note) (if the script is installed)
🇪🇸 Las notas se guardan dentro de un directorio en el Home del usuario (~/nota) (si el script está isntalado)


## Table of Contents / Tabla de Contenidos

- [Installation / Instalación](#installation--instalación)
- [Usage / Uso](#usage--uso)
- [Contributing / Contribuir](#contributing--contribuir)
- [Screenshots / Capturas de pantalla](#Screenshots--Capturas-de-pantalla)
- [License / Licencia](#license--licencia)

## Installation / Instalación

Para instalar ejecuta './nota.sh install' (se te pedirá contraseña de superusuario para copiar el script)

```shell
# Example code
./nota.sh install
```

Estos son los archivos que se van a instalar automáticamente:

- nota.sh  >  '/usr/local/bin/nota'
- '~/nota'  (Creación de nueva carpeta en HOME, si ya existe y tiene notas, estas no se van borrar)
- .settings  >  '~/nota/.settings'
- .language_EN  >  '~/nota/language_EN'
- .language_ES  >  '~/nota/language_ES'
- .language_... (todos los idiomas encontrados por el script)

## Usage / Uso

🇬🇧 ENGLISH: 🇬🇧

Check the list of notes like this: <span style="color:orange">nota</span>
    Notes are always displayed in order of creation (most recent first)
    Each note has a number with which to manipulate them, and each category a letter

Check the content of a note by indicating its number: <span style="color:orange">nota 1</span>

Add a simple note like this: <span style="color:orange">nota My first note</span> (you can use quotes or not)
Add a note with content like this: <span style="color:orange">nota "Title of the note; Content of the note after the semicolon, all in quotes"</span>
Add a category (to group notes) with a double semicolon at the end: <span style="color:orange">nota "Urgent tasks;;"</span>

Move a note within a category by pointing to note number + category letter: <span style="color:orange">nota 1 B</span> (move note number 1 to category B, you can use lowercase)

Delete a note or category like this: <span style="color:orange">nota -d 1</span> (it will be a letter if you want to delete a category)
    It can also be removed with: <span style="color:orange">-d -del -delete -r -remove</span>

Edit a note like this: <span style="color:orange">nota -edit 1</span>  (edit note 1)
    You can also use <span style="color:orange">-e edit</span>

Edit a note with any text editor like this: <span style="color:orange">nota -edit 1 kate</span> (edit note 1 with the Kate text editor)
    You can also use <span style="color:orange">-e edit</span>

Rename the title of a note or category (group of notes) like this: <span style="color:orange">nota -rename 1</span>  (rename note 1)
    You can also use <span style="color:orange">-name</span>

Show note's path like this: <span style="color:orange">nota -path 1</span> (the path will be printed)
    You can also use <span style="color:orange">-p path</span>

Open file browser in the notes directory like this: <span style="color:orange">nota -browser</span>
    You can also use <span style="color:orange">-b -fb</span>

Elevate a note like this: <span style="color:orange">nota -touch 4</span>
    You can also use <span style="color:orange">-t -up -u</span>

List and/or change available languages like this: <span style="color:orange">nota -language</span>
    You can also use <span style="color:orange">-l -lang</span>

Consult this guide with: <span style="color:orange">nota --help</span>  (or -h; -help; help)

SAY 'THANK YOU' BY SENDING BITCOIN ⚡
https://coinos.io/estebanc
-
- Or Paypal: https://www.paypal.com/donate?token=VDf-ktQ3juHmTEVXNyI0fIuPmGqSfUe6lCcZh5bdsvdSytsdH5w0rcFq1jcUEiBP_Xx1X6skMcVo_moF


-----


🇪🇸 ESPAÑOL: 🇪🇸

Consulta la lista de notas así: <span style="color:orange">nota</span>
    Las notas siembre se muestran por orden de creación (primero las más recientes)
    Cada nota tiene un número con el que poder manupularlas, y cada categoría una letra

Consulta el contenido de una nota señalando su número: <span style="color:orange">nota 1</span>

Añade una nota simple así: <span style="color:orange">nota Mi primer nota</span> (puedes usar comillas o no)
Añade una nota con contenido así: <span style="color:orange">nota "Título de la nota; Contenido de la nota después del semicolon, todo entre comillas"</span>
Añade una categoría (para agrupar notas) con doble punto y coma al final: <span style="color:orange">nota "Tareas urgentes;;"</span>

Mueve una nota dentro de una categoría señalando número de nota + letra de categoría: <span style="color:orange">nota 1 B</span> (mueve la nota número 1 a la categoría B, puedes usar minúsculas)

Elimina una nota o categoría así: <span style="color:orange">nota -d 1</span> (será una letra si quieres eliminar una categoría)
    También se puede eliminar con: <span style="color:orange">-d -del -delete -r -remove</span>

Edita una nota así: <span style="color:orange">nota -edit 1</span> (edita la nota 1)
    También puedes usar <span style="color:orange">-e editar</span>

Edita una nota con cualquier editor de texto así: <span style="color:orange">nota -edit 1 kate</span>  (edita la nota 1 con el editor de texto Kate)
    También puedes usar <span style="color:orange">-e editar</span>

Renombra el título de una nota o categoría (grupo de notas) así: <span style="color:orange">nota -rename 1</span>  (renombra la nota 1)
    También puedes usar <span style="color:orange">-name</span>

Muestra la ruta de la nota así: <span style="color:orange">nota -path 1</span> (the path will be printed)
    También puedes usar <span style="color:orange">-p -ruta ruta</span>

Abra el explorador de archivos en el directorio de notas así: <span style="color:orange">nota -browser</span>
    También puedes usar <span style="color:orange">-b -fb</span>

Eleva una nota así: <span style="color:orange">nota -touch 4</span>
    También puedes usar <span style="color:orange">-t -up -u </span>

Lista y/o cambia idiomas disponibles así: <span style="color:orange">nota -language</span>
    También puedes usar <span style="color:orange">-l -lang</span>

Consultar esta guía con: <span style="color:orange">nota --help</span>  (or -h; -help; ayuda)




### DI 'GRACIAS' ENVIANDO BITCOIN ⚡
https://coinos.io/estebanc
-
- Or Paypal: https://www.paypal.com/donate?token=VDf-ktQ3juHmTEVXNyI0fIuPmGqSfUe6lCcZh5bdsvdSytsdH5w0rcFq1jcUEiBP_Xx1X6skMcVo_moF


## Contributing / Contribuir

🇬🇧 Help me translate this app into your language, to do this you can make a copy of any language file (.language_XX):
Ayúdame a traducir esta app a tu idioma, para ello puedes hacer una copia de cualquier fichero de idiomas (.language_XX):

1
- 🇬🇧 Edit the file name to indicate the new language
- 🇪🇸 Edita el nombre del fichero para indicar el nuevo idioma

2
- 🇬🇧 Edit the first line of the file, replacing the original language with the new one, in capital letters.
- 🇪🇸 Edita la primer línea del fichero reemplazando el idioma original por el nuevo, en mayúsculas.

3
- 🇬🇧 Edit each variable with the translation (keeping the reference text in English)
- 🇪🇸 Edita cada variable con la traducción (manteniendo el texto de referencia en inglés)

4
- 🇬🇧 Submit the file to the repository to share it with others
- 🇪🇸 Añade el fichero al repositorio para compartirlos con otros

----

## Screenshots / Capturas de pantalla

![List / lista](screenshots/listanotas.png)
![Languages / idiomas](screenshots/languages.png)
![Adding a note / Creando una nota](screenshots/savednote_llist.png)
![View content of a note / Ver contenido de una nota](screenshots/list_viewcontent.png)
![Editing the content of a note / Editando el contenido de una nota](screenshots/edit_nano.png)
![Editing note with a different editor (Kate) / Editando una nota con un editor diferente (Kate) ](screenshots/editkate.png)
