-- Locales/esES.lua (Spanish, Spain)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export esES`, then
-- translated by hand. Run the linter after editing: it catches the two mistakes
-- the SP.L fallback hides -- a mistyped key (renders English forever, nobody
-- notices) and a translation that drops or reorders a format specifier.
--
-- Rules followed here:
--   * $tokens, |cff...|r color codes, /sp subcommands and %-specifiers are
--     copied verbatim -- the code parses them.
--   * Media names ("Flat", "Pixel", "Friz Quadrata") are absent on purpose:
--     they are lookup keys and LibSharedMedia registration names, not display
--     text, and translating them would break saved profiles.
--   * Stat and gear-slot names are translated even though SP.Global normally
--     serves them from Blizzard's own GlobalStrings, so the fallback path is
--     Spanish too if a global ever disappears.
--
-- NOT REVIEWED BY A NATIVE SPEAKER. Terminology follows the Spanish client's own
-- wording where it exists, but corrections are very welcome -- please open an
-- issue at https://github.com/chrisdfennell/StatPanel/issues.

local _, SP = ...
local L = SP.Locale("esES")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Mostrar solo en mi chat"
L["Say"] = "Decir"
L["Party"] = "Grupo"
L["Raid"] = "Banda"
L["Instance"] = "Instancia"
L["Guild"] = "Hermandad"
L["Officer"] = "Oficial"
L["Yell"] = "Gritar"
L["Whisper"] = "Susurrar"
L["iLvl %.2f (%.2f overall)"] = "NvO %.2f (%.2f total)"
L["iLvl %.2f"] = "NvO %.2f"
L["priority %s"] = "prioridad %s"
L["peak speed %.0f%%"] = "velocidad máxima %.0f%%"
L["%d missing enchant(s)"] = "%d encantamiento(s) que faltan"
L["%d empty socket(s)"] = "%d ranura(s) vacía(s)"
L["%d/%d tier set"] = "%d/%d conjunto de clase"
L["You aren't in a group."] = "No estás en un grupo."
L["You aren't in a raid."] = "No estás en una banda."
L["You aren't in a guild."] = "No estás en una hermandad."
L["hold on - you can announce again in %.0f seconds."] = "espera - podrás anunciar de nuevo en %.0f segundos."
L["nothing to announce - enable some fields on the Announce page."] = "nada que anunciar - activa algunos campos en la página Anunciar."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d valor(es) omitido(s): el juego protege esas estadísticas, así que no se pueden enviar al chat."
L["%s Showing it here instead:"] = "%s Se muestra aquí en su lugar:"
L["whisper needs a name: /sp announce whisper <name>"] = "el susurro necesita un nombre: /sp announce whisper <nombre>"
L["the game refused to send that message. Showing it here instead:"] = "el juego rechazó enviar ese mensaje. Se muestra aquí en su lugar:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Mundo abierto"
L["Delve"] = "Sima"
L["Dungeon"] = "Mazmorra"
L["Mythic+ dungeon"] = "Mazmorra Mítica+"
L["Arena"] = "Arena"
L["Battleground"] = "Campo de batalla"
L["Scenario"] = "Escenario"
L["switched to profile '%s' (%s rule)."] = "se cambió al perfil '%s' (regla: %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Nivel de objeto"
L["FPS"] = "FPS"
L["Spec"] = "Especialización"
L["Profile"] = "Perfil"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Clic izquierdo|r  abrir opciones"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Clic derecho|r  menú rápido"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  NvO %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "El nombre del perfil no puede estar vacío."
L["A profile named '%s' already exists."] = "Ya existe un perfil llamado '%s'."
L["The Default profile cannot be deleted."] = "El perfil predeterminado no se puede eliminar."
L["No such profile."] = "Ese perfil no existe."
L["Nothing to import."] = "Nada que importar."
L["That import string is too large to be a profile."] = "Esa cadena de importación es demasiado grande para ser un perfil."
L["That doesn't look like a StatPanel export string."] = "Eso no parece una cadena de exportación de StatPanel."
L["The import string is corrupt."] = "La cadena de importación está dañada."
L["Could not read the import string: %s"] = "No se pudo leer la cadena de importación: %s"
L["The import string did not contain a profile."] = "La cadena de importación no contenía ningún perfil."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "auditoría de equipo"
L["empty"] = "vacío"
L["no enchant"] = "sin encantamiento"
L["%d rare gem(s)"] = "%d gema(s) poco común(es)"
L["lowest"] = "el más bajo"
L["Equipped"] = "Equipado"
L["Tier set    %d/%d"] = "Conjunto de clase    %d/%d"
L["%d item(s) not fully upgraded"] = "%d objeto(s) sin mejorar del todo"
L["Everything is enchanted and socketed."] = "Todo está encantado y engarzado."
L["%d enchant(s)"] = "%d encantamiento(s)"
L["%d socket(s)"] = "%d ranura(s)"
L["%d empty slot(s)"] = "%d espacio(s) vacío(s)"
L["Missing: %s"] = "Falta: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Cabeza"
L["Neck"] = "Cuello"
L["Shoulder"] = "Hombros"
L["Back"] = "Espalda"
L["Chest"] = "Pecho"
L["Wrist"] = "Muñecas"
L["Hands"] = "Manos"
L["Waist"] = "Cintura"
L["Legs"] = "Piernas"
L["Feet"] = "Pies"
L["Ring 1"] = "Anillo 1"
L["Ring 2"] = "Anillo 2"
L["Trinket 1"] = "Abalorio 1"
L["Trinket 2"] = "Abalorio 2"
L["Main Hand"] = "Mano derecha"
L["Off Hand"] = "Mano izquierda"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Ninguno"
L["Outline"] = "Contorno"
L["Thick Outline"] = "Contorno grueso"
L["Monochrome"] = "Monocromo"
L["Monochrome Outline"] = "Contorno monocromo"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Mostrar panel"
L["Lock position"] = "Bloquear posición"
L["Show FPS"] = "Mostrar FPS"
L["Apply preset"] = "Aplicar preajuste"
L["Announce to"] = "Anunciar en"
L["Audit my gear"] = "Auditar mi equipo"
L["Open options"] = "Abrir opciones"
L["Reset position"] = "Restablecer posición"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Izquierda"
L["Center"] = "Centro"
L["Right"] = "Derecha"
L["Proportional to value"] = "Proporcional al valor"
L["Always full"] = "Siempre llena"
L["No fill (text only)"] = "Sin relleno (solo texto)"
L["Per-stat colors"] = "Colores por estadística"
L["Class color"] = "Color de clase"
L["Single color"] = "Un solo color"
L["Value gradient"] = "Degradado según el valor"
L["Bars"] = "Barras"
L["Text only"] = "Solo texto"
L["Player name"] = "Nombre del jugador"
L["Specialization"] = "Especialización"
L["Custom text"] = "Texto personalizado"
L["Hidden"] = "Oculto"
L["Total effect (character sheet)"] = "Efecto total (hoja de personaje)"
L["Bonus from rating only"] = "Solo la bonificación por índice"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Panel"
L["Enable StatPanel"] = "Activar StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "Interruptor principal. Desactivarlo oculta el panel por completo."
L["Stops the panel from being dragged."] = "Impide que se arrastre el panel."
L["Keep on screen"] = "Mantener en pantalla"
L["Prevents dragging the panel off the edge of the screen."] = "Impide arrastrar el panel fuera del borde de la pantalla."
L["Scale"] = "Escala"
L["Opacity"] = "Opacidad"
L["Frame layer"] = "Capa del marco"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "La capa en la que se dibuja el panel. Súbela si otro accesorio tapa el panel."
L["Update interval (seconds)"] = "Intervalo de actualización (segundos)"
L["How often values refresh. Higher values use less CPU."] = "Con qué frecuencia se actualizan los valores. Un valor más alto consume menos CPU."
L["Stat values show"] = "Los valores muestran"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "El efecto total coincide con la hoja de personaje. La bonificación por índice muestra solo lo que aporta el índice de tu equipo."
L["Visibility"] = "Visibilidad"
L["Hide during combat"] = "Ocultar en combate"
L["Turning this on clears 'Show only during combat'."] = "Activar esto desactiva «Mostrar solo en combate»."
L["Show only during combat"] = "Mostrar solo en combate"
L["Turning this on clears 'Hide during combat'."] = "Activar esto desactiva «Ocultar en combate»."
L["Hide while dead"] = "Ocultar al estar muerto"
L["Hide in vehicles"] = "Ocultar en vehículos"
L["Hide in pet battles"] = "Ocultar en duelos de mascotas"
L["Hide inside instances"] = "Ocultar dentro de instancias"
L["Turning this on clears 'Hide outside instances'."] = "Activar esto desactiva «Ocultar fuera de instancias»."
L["Hide outside instances"] = "Ocultar fuera de instancias"
L["Turning this on clears 'Hide inside instances'."] = "Activar esto desactiva «Ocultar dentro de instancias»."
L["Mouseover fade"] = "Desvanecer sin el cursor"
L["Only show on mouseover"] = "Mostrar solo al pasar el cursor"
L["Fades the panel out until you hover over it."] = "Desvanece el panel hasta que pasas el cursor por encima."
L["Faded opacity"] = "Opacidad al desvanecerse"
L["Fade duration (seconds)"] = "Duración del desvanecido (segundos)"
L["Show tooltips on hover"] = "Mostrar descripciones al pasar el cursor"
L["Minimap and options"] = "Minimapa y opciones"
L["Show the minimap button"] = "Mostrar el botón del minimapa"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "El clic izquierdo abre estas opciones y el derecho el menú rápido. Arrástralo por el borde del minimapa."
L["Show a live preview while configuring"] = "Mostrar una vista previa en directo al configurar"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Acopla el panel real junto a esta ventana para que veas los cambios mientras los haces."
L["Reset peak speed"] = "Restablecer la velocidad máxima"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Tamaño"
L["Auto-size width to content"] = "Ajustar el ancho al contenido"
L["Grows and shrinks the panel to fit the widest row."] = "Agranda y encoge el panel para ajustarlo a la fila más ancha."
L["Width"] = "Ancho"
L["Minimum width (auto-size)"] = "Ancho mínimo (ajuste automático)"
L["Side padding"] = "Margen lateral"
L["Top padding"] = "Margen superior"
L["Bottom padding"] = "Margen inferior"
L["Gap between sections"] = "Espacio entre secciones"
L["Section header spacing"] = "Espaciado de los encabezados de sección"
L["Set to 0 to remove section headers entirely."] = "Ponlo a 0 para eliminar por completo los encabezados de sección."
L["Background"] = "Fondo"
L["Background texture"] = "Textura del fondo"
L["Background color and transparency"] = "Color y transparencia del fondo"
L["Tile the background"] = "Repetir el fondo en mosaico"
L["Tile size"] = "Tamaño del mosaico"
L["Border"] = "Borde"
L["Border style"] = "Estilo del borde"
L["Border color and transparency"] = "Color y transparencia del borde"
L["Border thickness"] = "Grosor del borde"
L["Only affects pixel-style borders; textured borders use their own size."] = "Solo afecta a los bordes de estilo píxel; los bordes con textura usan su propio tamaño."
L["Border inset"] = "Sangría del borde"
L["Title"] = "Título"
L["Show title"] = "Mostrar el título"
L["Title shows"] = "El título muestra"
L["Title alignment"] = "Alineación del título"
L["Item level format"] = "Formato del nivel de objeto"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Comodines: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Comodines: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Decimales del nivel de objeto"
L["Custom title text"] = "Texto de título personalizado"
L["Divider"] = "Separador"
L["Show divider under title"] = "Mostrar un separador bajo el título"
L["Divider color"] = "Color del separador"
L["Divider thickness"] = "Grosor del separador"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Estilo de fila"
L["Draw rows as"] = "Dibujar las filas como"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "Las barras dibujan una barra de estado por estadística. Solo texto dibuja una única línea coloreada por estadística."
L["Text alignment (text style)"] = "Alineación del texto (estilo texto)"
L["Label/value separator (text style)"] = "Separador entre nombre y valor (estilo texto)"
L["Placed between the stat name and its value, e.g. ': '"] = "Se coloca entre el nombre de la estadística y su valor, p. ej. «: »"
L["Line height (text style)"] = "Altura de línea (estilo texto)"
L["Bar appearance"] = "Aspecto de las barras"
L["Bar texture"] = "Textura de las barras"
L["Bar height"] = "Altura de las barras"
L["Space between bars"] = "Espacio entre barras"
L["Horizontal inset"] = "Sangría horizontal"
L["Bar opacity"] = "Opacidad de las barras"
L["Fill from the right"] = "Rellenar desde la derecha"
L["Bar colors"] = "Colores de las barras"
L["Color mode"] = "Modo de color"
L["Per-stat colors are set on the Stats page."] = "Los colores por estadística se ajustan en la página Estadísticas."
L["Gradient: low value"] = "Degradado: valor bajo"
L["Gradient: high value"] = "Degradado: valor alto"
L["Bar background"] = "Fondo de las barras"
L["Track texture"] = "Textura de la guía"
L["Track color and transparency"] = "Color y transparencia de la guía"
L["Tint track with the stat color"] = "Teñir la guía con el color de la estadística"
L["Track tint opacity"] = "Opacidad del tinte de la guía"
L["Bar border"] = "Borde de las barras"
L["Border color"] = "Color del borde"
L["Motion"] = "Movimiento"
L["Animate value changes"] = "Animar los cambios de valor"
L["Eases bars toward new values instead of snapping."] = "Desliza las barras hacia los nuevos valores en lugar de saltar."
L["Animation speed"] = "Velocidad de la animación"
L["Show a spark at the fill edge"] = "Mostrar un destello en el borde del relleno"
L["Spark color"] = "Color del destello"
L["Row text"] = "Texto de las filas"
L["Show stat names"] = "Mostrar los nombres de las estadísticas"
L["Show values"] = "Mostrar los valores"
L["Color names with the stat color"] = "Colorear los nombres con el color de la estadística"
L["Color values with the stat color"] = "Colorear los valores con el color de la estadística"
L["Number prioritized stats"] = "Numerar las estadísticas priorizadas"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Antepone 1, 2, 3... a las estadísticas de una sección ordenada por prioridad."
L["Numbering format"] = "Formato de numeración"
L["Name offset"] = "Desplazamiento del nombre"
L["Value offset"] = "Desplazamiento del valor"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "Encabezado de sección"
L["Stat name"] = "Nombre de la estadística"
L["Stat value"] = "Valor de la estadística"
L["Priority line"] = "Línea de prioridad"
L["Footer"] = "Pie"
L["Font"] = "Fuente"
L["Font face (all text)"] = "Fuente (todo el texto)"
L["Drop shadow"] = "Sombra paralela"
L["Shadow color"] = "Color de la sombra"
L["Shadow X offset"] = "Desplazamiento X de la sombra"
L["Shadow Y offset"] = "Desplazamiento Y de la sombra"
L["Per-element size and color"] = "Tamaño y color por elemento"
L["Editing"] = "Editando"
L["Color"] = "Color"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "Los colores del nombre y del valor se sustituyen cuando el coloreado con el color de la estadística está activo en la página Filas y barras."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Ajustes por estadística"
L["Editing stat"] = "Estadística en edición"
L["Show this stat"] = "Mostrar esta estadística"
L["Stat color"] = "Color de la estadística"
L["Use class color for this stat"] = "Usar el color de clase para esta estadística"
L["Display name (blank for default)"] = "Nombre mostrado (vacío para el predeterminado)"
L["Value format"] = "Formato del valor"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Comodines: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nEjemplo: '$rating - $value%' muestra '285 - 10.65%'."
L["Decimal places"] = "Decimales"
L["Bar scale"] = "Escala de las barras"
L["Bar fill"] = "Relleno de las barras"
L["Value at a full bar"] = "Valor con la barra llena"
L["Grow the scale automatically"] = "Aumentar la escala automáticamente"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Sube el valor de barra llena cuando la estadística lo supera. Útil para Velocidad, que no tiene techo al surcar los cielos."
L["Reset all stats"] = "Restablecer todas las estadísticas"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Secciones"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "Las secciones se dibujan de arriba abajo en este orden. Cada una puede contener las estadísticas que quieras."
L["Editing section"] = "Sección en edición"
L["Section title"] = "Título de la sección"
L["Show this section"] = "Mostrar esta sección"
L["Show the section header"] = "Mostrar el encabezado de la sección"
L["Order by spec stat priority"] = "Ordenar por la prioridad de la especialización"
L["Re-sorts this section's stats to match your specialization's priority."] = "Reordena las estadísticas de esta sección según la prioridad de tu especialización."
L["Header alignment"] = "Alineación del encabezado"
L["Move section up"] = "Subir la sección"
L["Move section down"] = "Bajar la sección"
L["Stats in this section"] = "Estadísticas de esta sección"
L["Up"] = "Subir"
L["Down"] = "Bajar"
L["Remove"] = "Quitar"
L["Add a stat to this section"] = "Añadir una estadística a esta sección"
L["(every stat is already here)"] = "(todas las estadísticas ya están aquí)"
L["Reset sections"] = "Restablecer las secciones"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Línea de pie"
L["Show the footer"] = "Mostrar el pie"
L["Frames per second"] = "Fotogramas por segundo"
L["Home latency"] = "Latencia local"
L["World latency"] = "Latencia de mundo"
L["Addon memory use"] = "Memoria usada por el accesorio"
L["Separator between entries"] = "Separador entre entradas"
L["Formats"] = "Formatos"
L["FPS format"] = "Formato de FPS"
L["Home latency format"] = "Formato de la latencia local"
L["World latency format"] = "Formato de la latencia de mundo"
L["Memory format"] = "Formato de la memoria"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Usan los formatos numéricos estándar: %d para un número entero, %.1f para un decimal."
L["Performance coloring"] = "Coloreado por rendimiento"
L["Color by performance"] = "Colorear según el rendimiento"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Pone los FPS y la latencia en verde, amarillo o rojo según los umbrales de abajo."
L["Good"] = "Bueno"
L["Fair"] = "Regular"
L["Poor"] = "Malo"
L["FPS considered good"] = "FPS considerados buenos"
L["FPS considered poor"] = "FPS considerados malos"
L["Latency considered good (ms)"] = "Latencia considerada buena (ms)"
L["Latency considered poor (ms)"] = "Latencia considerada mala (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Mostrar la cadena de prioridad"
L["Separator"] = "Separador"
L["Color each stat name"] = "Colorear cada nombre de estadística"
L["Prefix with the spec name"] = "Anteponer el nombre de la especialización"
L["Priority for your current spec"] = "Prioridad para tu especialización actual"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "El orden integrado es una referencia general. Simula tu propio personaje para obtener la respuesta fiable y anótala aquí."
L["Current specialization: %s"] = "Especialización actual: %s"
L["unknown"] = "desconocida"
L["Priority %d"] = "Prioridad %d"
L["Paste a stat weight string"] = "Pegar una cadena de pesos de estadísticas"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Pega una cadena de Pawn (de Raidbots, una simulación o una web de estadísticas) o un orden simple como 'Mastery > Haste > Crit > Versatility'. StatPanel lee las cuatro secundarias y fija el orden para tu especialización actual."
L["Weights or order"] = "Pesos u orden"
L["Apply pasted weights"] = "Aplicar los pesos pegados"
L["no active specialization to apply to."] = "no hay ninguna especialización activa a la que aplicarlo."
L["priority for %s set to %s."] = "prioridad de %s establecida en %s."
L["your spec"] = "tu especialización"
L["Use the built-in order"] = "Usar el orden integrado"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Preajustes"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Un preajuste sobrescribe los ajustes de aspecto del perfil actual. Tu posición, tus reglas de visibilidad y tus perfiles no se tocan."
L["Start over"] = "Empezar de nuevo"
L["Reset this profile"] = "Restablecer este perfil"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Cada personaje recuerda el perfil que usa, así que puedes compartir un mismo aspecto entre alters o dar uno propio a cada uno."
L["Active profile"] = "Perfil activo"
L["New profile name"] = "Nombre del nuevo perfil"
L["Create"] = "Crear"
L["Copy current"] = "Copiar el actual"
L["Delete current"] = "Eliminar el actual"
L["Deleted profile '%s'."] = "Perfil '%s' eliminado."
L["Share"] = "Compartir"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "La exportación genera una cadena que puedes pasar a otra persona. La importación sobrescribe el perfil que indiques abajo, o el activo si lo dejas en blanco."
L["Export string"] = "Cadena de exportación"
L["Generate export"] = "Generar exportación"
L["Import string"] = "Cadena de importación"
L["Import into profile (blank = active)"] = "Importar en el perfil (vacío = activo)"
L["Import"] = "Importar"
L["Imported into profile '%s'."] = "Importado en el perfil '%s'."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Anunciar"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Envía al chat un resumen de tu equipo. Nunca se envía nada automáticamente: solo cuando usas el botón, el comando de barra o el menú contextual."
L["Send to"] = "Enviar a"
L["Whisper to (for the Whisper channel)"] = "Susurrar a (para el canal Susurrar)"
L["Prefix"] = "Prefijo"
L["Include"] = "Incluir"
L["Stats"] = "Estadísticas"
L["Stat priority"] = "Prioridad de estadísticas"
L["Session peak speed"] = "Velocidad máxima de la sesión"
L["Missing enchants and sockets"] = "Encantamientos y ranuras que faltan"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "El juego protege la mayoría de las estadísticas de combate y no permite que ningún accesorio las envíe al chat, así que se omiten automáticamente. El nivel de objeto, la especialización, la velocidad y los avisos de equipo sí pasan. Si un parche futuro desprotege una estadística, aparecerá sin necesidad de cambiar nada."
L["Preview"] = "Vista previa"
L["Announce now"] = "Anunciar ahora"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Equipo puesto"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "Los datos de objeto no están protegidos por el juego, así que, a diferencia de las estadísticas de combate, se pueden leer por completo."
L["Refresh"] = "Actualizar"
L["Print report"] = "Mostrar el informe"
L["Average equipped item level %.2f.%s  %s"] = "Nivel de objeto medio equipado %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Conjunto de clase %d/%d."
L["Nothing missing."] = "No falta nada."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(sin regla)"
L["Automatic profile switching"] = "Cambio automático de perfil"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "Las reglas se guardan por personaje. Una regla de contenido tiene prioridad sobre una de especialización, así que puedes mantener un perfil de especialización en general y forzar otro dentro de una banda. Todo lo que quede como «(sin regla)» se ignora."
L["Switch profiles automatically"] = "Cambiar de perfil automáticamente"
L["By content"] = "Por contenido"
L["By specialization"] = "Por especialización"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "Solo aparece tu especialización actual. Cambia de especialización y vuelve para definir una regla para otra."
L["Profile for this specialization"] = "Perfil para esta especialización"
L["Apply rules now"] = "Aplicar las reglas ahora"
L["no rule matches your current spec or location."] = "ninguna regla coincide con tu especialización o ubicación actual."
L["already on '%s', the profile your rules call for."] = "ya estás en '%s', el perfil que piden tus reglas."
L["Clear all rules"] = "Borrar todas las reglas"
L["cleared this character's automatic rules."] = "reglas automáticas de este personaje borradas."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "General"
L["Rows & Bars"] = "Filas y barras"
L["Fonts"] = "Fuentes"
L["Priority"] = "Prioridad"
L["Gear"] = "Equipo"
L["Profiles"] = "Perfiles"
L["Automation"] = "Automatización"
L["Dark"] = "Oscuro"
L["Grey"] = "Gris"
L["Light"] = "Claro"
L["Game"] = "Juego"
L["Background: %s"] = "Fondo: %s"
L["Live Preview"] = "Vista previa en directo"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "El panel real, acoplado aquí. Arrastra esta ventana para moverla; el panel vuelve a su sitio al cerrar las opciones."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Escribe /sp para ver los comandos de barra. Arrastra el propio panel para moverlo."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "El aspecto original: panel oscuro y plano con barras de colores."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Sin barras. Una línea coloreada por estadística: 'Maestría: 285 - 10.65%'."
L["Thin headerless bars for a small footprint."] = "Barras finas sin encabezados, para ocupar poco espacio."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Texturas de Blizzard y borde de descripción, a juego con la interfaz predeterminada."
L["No background or border at all - just floating text and bars."] = "Sin fondo ni borde: solo texto y barras flotantes."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Texto monocromo diminuto, sin fondo. Descansa discreto en una esquina."
L["High-contrast glow bars on near-black, with a value gradient."] = "Barras luminosas de alto contraste sobre casi negro, con degradado según el valor."
L["Warm parchment and gold, in keeping with the default UI art."] = "Pergamino cálido y oro, en la línea del arte de la interfaz predeterminada."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Enfoque defensivo: armadura, esquivar, parada, bloqueo y evitación arriba."
L["Big live speed readout with your session record, and little else."] = "Gran lectura de velocidad en directo con tu récord de sesión, y poco más."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Estadísticas secundarias, nivel de objeto y ambas latencias: lo que se mira antes de un pull."
L["Cold blues and whites on deep navy."] = "Azules fríos y blancos sobre azul marino profundo."
L["Warm reds and ambers on charcoal."] = "Rojos cálidos y ámbares sobre gris carbón."
L["Every bar takes your class color. Clean and unfussy."] = "Cada barra toma el color de tu clase. Limpio y sin adornos."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Texto grande, grueso y de alto contraste. Fácil de leer de un vistazo."
L["The smallest useful readout: four secondaries, nothing else."] = "La lectura útil más pequeña: cuatro secundarias y nada más."
L["Green-on-black monospace, like a console readout."] = "Verde sobre negro en monoespaciado, como una consola."
L["Throughput stats plus leech, with your primary attribute on top."] = "Estadísticas de rendimiento más robo de vida, con tu atributo principal arriba."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Versatilidad primero, junto a evitación, esquivar y velocidad."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "A juego con ElvUI: panel oscuro y plano, borde negro de 1 px, fuente estrecha."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "El conocido estilo transparente de ElvUI: cristal casi negro, borde finísimo."
L["preset hook failed: %s"] = "falló el hook del preajuste: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "comandos:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - abrir las opciones"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - mostrar u ocultar el panel"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - bloquear o desbloquear el arrastre"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - devolver el panel al centro"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <nombre>|r - aplicar un preajuste (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <nombre>|r - cambiar de perfil"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - mostrar y reiniciar el récord de velocidad de la sesión"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - mostrar u ocultar el botón del minimapa"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - auditar encantamientos, ranuras y nivel de objeto"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [canal]|r - anunciar tu equipo en el chat"
L["panel shown."] = "panel mostrado."
L["panel hidden."] = "panel oculto."
L["panel locked."] = "panel bloqueado."
L["panel unlocked."] = "panel desbloqueado."
L["position reset."] = "posición restablecida."
L["applied the '%s' preset."] = "preajuste '%s' aplicado."
L["unknown preset. Available: %s"] = "preajuste desconocido. Disponibles: %s"
L["switched to profile '%s'."] = "cambiado al perfil '%s'."
L["profiles: %s"] = "perfiles: %s"
L["session speed record cleared."] = "récord de velocidad de la sesión reiniciado."
L["minimap button hidden."] = "botón del minimapa oculto."
L["minimap button shown."] = "botón del minimapa mostrado."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Atributo principal"
L["Armor DR"] = "Reducción de armadura"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Crít"
L["Haste"] = "Celer."
L["Mast"] = "Maest."
L["Vers"] = "Vers."

L["a display setting could not be applied (%s)."] = "no se pudo aplicar un ajuste de presentación (%s)."
L["The game protects this value; see the panel itself."] = "El juego protege este valor; consúltalo en el propio panel."
L["Value"] = "Valor"
L["Rating"] = "Índice"
L["Yards/sec"] = "Metros/seg"
L["Session peak"] = "Récord de la sesión"
L["Attribute"] = "Atributo"
L["Drag to move  |  /sp for options"] = "Arrastra para mover  |  /sp para las opciones"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Fuerza"
L["Agility"] = "Agilidad"
L["Stamina"] = "Aguante"
L["Intellect"] = "Intelecto"
L["Mastery"] = "Maestría"
L["Versatility"] = "Versatilidad"
L["Dodge"] = "Esquivar"
L["Parry"] = "Parada"
L["Block"] = "Bloquear"
L["Leech"] = "Robo de vida"
L["Avoidance"] = "Evitación"
L["Speed"] = "Velocidad"
