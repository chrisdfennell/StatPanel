-- Locales/deDE.lua (German)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export deDE`, then
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
--     German too if a global ever disappears.
--
-- Reviewed for terminology against the German client's own wording; a native
-- speaker pass on tone would still be welcome.

local _, SP = ...
local L = SP.Locale("deDE")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Nur in meinem Chat ausgeben"
L["Say"] = "Sagen"
L["Party"] = "Gruppe"
L["Raid"] = "Schlachtzug"
L["Instance"] = "Instanz"
L["Guild"] = "Gilde"
L["Officer"] = "Offizier"
L["Yell"] = "Schreien"
L["Whisper"] = "Flüstern"
L["iLvl %.2f (%.2f overall)"] = "GS %.2f (%.2f insgesamt)"
L["iLvl %.2f"] = "GS %.2f"
L["priority %s"] = "Priorität %s"
L["peak speed %.0f%%"] = "Höchsttempo %.0f%%"
L["%d missing enchant(s)"] = "%d fehlende Verzauberung(en)"
L["%d empty socket(s)"] = "%d leere(r) Sockel"
L["%d/%d tier set"] = "%d/%d Klassenset"
L["You aren't in a group."] = "Du bist in keiner Gruppe."
L["You aren't in a raid."] = "Du bist in keinem Schlachtzug."
L["You aren't in a guild."] = "Du bist in keiner Gilde."
L["hold on - you can announce again in %.0f seconds."] = "Moment - du kannst in %.0f Sekunden erneut ankündigen."
L["nothing to announce - enable some fields on the Announce page."] = "Nichts anzukündigen - aktiviere Felder auf der Seite 'Ankündigen'."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d Wert(e) ausgelassen: Das Spiel schützt diese Werte, sie können nicht in den Chat gesendet werden."
L["%s Showing it here instead:"] = "%s Stattdessen hier:"
L["whisper needs a name: /sp announce whisper <name>"] = "Flüstern braucht einen Namen: /sp announce whisper <Name>"
L["the game refused to send that message. Showing it here instead:"] = "Das Spiel hat das Senden der Nachricht abgelehnt. Stattdessen hier:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Offene Welt"
L["Delve"] = "Tiefen"
L["Dungeon"] = "Dungeon"
L["Mythic+ dungeon"] = "Mythisch+-Dungeon"
L["Arena"] = "Arena"
L["Battleground"] = "Schlachtfeld"
L["Scenario"] = "Szenario"
L["switched to profile '%s' (%s rule)."] = "Zu Profil '%s' gewechselt (Regel: %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Gegenstandsstufe"
L["FPS"] = "FPS"
L["Spec"] = "Spezialisierung"
L["Profile"] = "Profil"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Linksklick|r  Optionen öffnen"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Rechtsklick|r  Schnellmenü"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  GS %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "Der Profilname darf nicht leer sein."
L["A profile named '%s' already exists."] = "Ein Profil namens '%s' existiert bereits."
L["The Default profile cannot be deleted."] = "Das Standardprofil kann nicht gelöscht werden."
L["No such profile."] = "Kein solches Profil."
L["Nothing to import."] = "Nichts zu importieren."
L["That import string is too large to be a profile."] = "Diese Importzeichenfolge ist zu groß für ein Profil."
L["That doesn't look like a StatPanel export string."] = "Das sieht nicht nach einer StatPanel-Exportzeichenfolge aus."
L["The import string is corrupt."] = "Die Importzeichenfolge ist beschädigt."
L["Could not read the import string: %s"] = "Die Importzeichenfolge konnte nicht gelesen werden: %s"
L["The import string did not contain a profile."] = "Die Importzeichenfolge enthielt kein Profil."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "Ausrüstungsprüfung"
L["empty"] = "leer"
L["no enchant"] = "keine Verzauberung"
L["%d rare gem(s)"] = "%d seltene(r) Edelstein(e)"
L["lowest"] = "niedrigste"
L["Equipped"] = "Angelegt"
L["Tier set    %d/%d"] = "Klassenset    %d/%d"
L["%d item(s) not fully upgraded"] = "%d Gegenstand/Gegenstände nicht voll aufgewertet"
L["Everything is enchanted and socketed."] = "Alles ist verzaubert und gesockelt."
L["%d enchant(s)"] = "%d Verzauberung(en)"
L["%d socket(s)"] = "%d Sockel"
L["%d empty slot(s)"] = "%d leere(r) Platz/Plätze"
L["Missing: %s"] = "Fehlt: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Kopf"
L["Neck"] = "Hals"
L["Shoulder"] = "Schulter"
L["Back"] = "Rücken"
L["Chest"] = "Brust"
L["Wrist"] = "Handgelenke"
L["Hands"] = "Hände"
L["Waist"] = "Taille"
L["Legs"] = "Beine"
L["Feet"] = "Füße"
L["Ring 1"] = "Ring 1"
L["Ring 2"] = "Ring 2"
L["Trinket 1"] = "Schmuck 1"
L["Trinket 2"] = "Schmuck 2"
L["Main Hand"] = "Waffenhand"
L["Off Hand"] = "Schildhand"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Keine"
L["Outline"] = "Umrandung"
L["Thick Outline"] = "Dicke Umrandung"
L["Monochrome"] = "Monochrom"
L["Monochrome Outline"] = "Monochrome Umrandung"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Panel anzeigen"
L["Lock position"] = "Position sperren"
L["Show FPS"] = "FPS anzeigen"
L["Apply preset"] = "Vorlage anwenden"
L["Announce to"] = "Ankündigen an"
L["Audit my gear"] = "Ausrüstung prüfen"
L["Open options"] = "Optionen öffnen"
L["Reset position"] = "Position zurücksetzen"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Links"
L["Center"] = "Zentriert"
L["Right"] = "Rechts"
L["Proportional to value"] = "Proportional zum Wert"
L["Always full"] = "Immer voll"
L["No fill (text only)"] = "Keine Füllung (nur Text)"
L["Per-stat colors"] = "Farben pro Wert"
L["Class color"] = "Klassenfarbe"
L["Single color"] = "Einzelne Farbe"
L["Value gradient"] = "Wertverlauf"
L["Bars"] = "Balken"
L["Text only"] = "Nur Text"
L["Player name"] = "Spielername"
L["Specialization"] = "Spezialisierung"
L["Custom text"] = "Eigener Text"
L["Hidden"] = "Ausgeblendet"
L["Total effect (character sheet)"] = "Gesamteffekt (Charakterfenster)"
L["Bonus from rating only"] = "Nur Bonus aus Wertung"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Panel"
L["Enable StatPanel"] = "StatPanel aktivieren"
L["Master switch. Turning this off hides the panel entirely."] = "Hauptschalter. Deaktivieren blendet das Panel vollständig aus."
L["Stops the panel from being dragged."] = "Verhindert das Verschieben des Panels."
L["Keep on screen"] = "Auf dem Bildschirm halten"
L["Prevents dragging the panel off the edge of the screen."] = "Verhindert, dass das Panel über den Bildschirmrand hinaus gezogen wird."
L["Scale"] = "Skalierung"
L["Opacity"] = "Deckkraft"
L["Frame layer"] = "Fensterebene"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "Auf welcher Ebene das Panel gezeichnet wird. Erhöhe sie, wenn ein anderes Addon das Panel verdeckt."
L["Update interval (seconds)"] = "Aktualisierungsintervall (Sekunden)"
L["How often values refresh. Higher values use less CPU."] = "Wie oft die Werte aktualisiert werden. Höhere Werte brauchen weniger CPU."
L["Stat values show"] = "Werte zeigen"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "Gesamteffekt entspricht dem Charakterfenster. Bonus aus Wertung zeigt nur, was die Wertung deiner Ausrüstung beiträgt."
L["Visibility"] = "Sichtbarkeit"
L["Hide during combat"] = "Im Kampf ausblenden"
L["Turning this on clears 'Show only during combat'."] = "Aktivieren deaktiviert 'Nur im Kampf anzeigen'."
L["Show only during combat"] = "Nur im Kampf anzeigen"
L["Turning this on clears 'Hide during combat'."] = "Aktivieren deaktiviert 'Im Kampf ausblenden'."
L["Hide while dead"] = "Im Tod ausblenden"
L["Hide in vehicles"] = "In Fahrzeugen ausblenden"
L["Hide in pet battles"] = "In Haustierkämpfen ausblenden"
L["Hide inside instances"] = "In Instanzen ausblenden"
L["Turning this on clears 'Hide outside instances'."] = "Aktivieren deaktiviert 'Außerhalb von Instanzen ausblenden'."
L["Hide outside instances"] = "Außerhalb von Instanzen ausblenden"
L["Turning this on clears 'Hide inside instances'."] = "Aktivieren deaktiviert 'In Instanzen ausblenden'."
L["Mouseover fade"] = "Ausblenden ohne Mauszeiger"
L["Only show on mouseover"] = "Nur bei Mauszeiger anzeigen"
L["Fades the panel out until you hover over it."] = "Blendet das Panel aus, bis du mit der Maus darüberfährst."
L["Faded opacity"] = "Deckkraft im ausgeblendeten Zustand"
L["Fade duration (seconds)"] = "Überblenddauer (Sekunden)"
L["Show tooltips on hover"] = "Tooltips bei Mauszeiger anzeigen"
L["Minimap and options"] = "Minikarte und Optionen"
L["Show the minimap button"] = "Minikartensymbol anzeigen"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "Linksklick öffnet diese Optionen, Rechtsklick das Schnellmenü. Ziehe es am Rand der Minikarte entlang."
L["Show a live preview while configuring"] = "Live-Vorschau beim Konfigurieren anzeigen"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Dockt das echte Panel neben diesem Fenster an, damit du Änderungen sofort siehst."
L["Reset peak speed"] = "Höchsttempo zurücksetzen"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Größe"
L["Auto-size width to content"] = "Breite automatisch an Inhalt anpassen"
L["Grows and shrinks the panel to fit the widest row."] = "Vergrößert und verkleinert das Panel passend zur breitesten Zeile."
L["Width"] = "Breite"
L["Minimum width (auto-size)"] = "Mindestbreite (automatisch)"
L["Side padding"] = "Seitlicher Abstand"
L["Top padding"] = "Abstand oben"
L["Bottom padding"] = "Abstand unten"
L["Gap between sections"] = "Abstand zwischen Abschnitten"
L["Section header spacing"] = "Abstand der Abschnittsüberschriften"
L["Set to 0 to remove section headers entirely."] = "Auf 0 setzen, um Abschnittsüberschriften ganz zu entfernen."
L["Background"] = "Hintergrund"
L["Background texture"] = "Hintergrundtextur"
L["Background color and transparency"] = "Hintergrundfarbe und Transparenz"
L["Tile the background"] = "Hintergrund kacheln"
L["Tile size"] = "Kachelgröße"
L["Border"] = "Rahmen"
L["Border style"] = "Rahmenstil"
L["Border color and transparency"] = "Rahmenfarbe und Transparenz"
L["Border thickness"] = "Rahmenstärke"
L["Only affects pixel-style borders; textured borders use their own size."] = "Wirkt nur auf Pixelrahmen; texturierte Rahmen nutzen ihre eigene Größe."
L["Border inset"] = "Rahmeneinzug"
L["Title"] = "Titel"
L["Show title"] = "Titel anzeigen"
L["Title shows"] = "Titel zeigt"
L["Title alignment"] = "Titelausrichtung"
L["Item level format"] = "Format der Gegenstandsstufe"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Platzhalter: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Platzhalter: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Nachkommastellen der Gegenstandsstufe"
L["Custom title text"] = "Eigener Titeltext"
L["Divider"] = "Trennlinie"
L["Show divider under title"] = "Trennlinie unter dem Titel anzeigen"
L["Divider color"] = "Farbe der Trennlinie"
L["Divider thickness"] = "Stärke der Trennlinie"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Zeilenstil"
L["Draw rows as"] = "Zeilen zeichnen als"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "Balken zeichnen einen Statusbalken pro Wert. Nur Text zeichnet eine einzelne farbige Zeile pro Wert."
L["Text alignment (text style)"] = "Textausrichtung (Textstil)"
L["Label/value separator (text style)"] = "Trennzeichen zwischen Name und Wert (Textstil)"
L["Placed between the stat name and its value, e.g. ': '"] = "Wird zwischen Wertname und Wert gesetzt, z. B. ': '"
L["Line height (text style)"] = "Zeilenhöhe (Textstil)"
L["Bar appearance"] = "Balkendarstellung"
L["Bar texture"] = "Balkentextur"
L["Bar height"] = "Balkenhöhe"
L["Space between bars"] = "Abstand zwischen Balken"
L["Horizontal inset"] = "Horizontaler Einzug"
L["Bar opacity"] = "Deckkraft der Balken"
L["Fill from the right"] = "Von rechts füllen"
L["Bar colors"] = "Balkenfarben"
L["Color mode"] = "Farbmodus"
L["Per-stat colors are set on the Stats page."] = "Farben pro Wert werden auf der Seite 'Werte' festgelegt."
L["Gradient: low value"] = "Verlauf: niedriger Wert"
L["Gradient: high value"] = "Verlauf: hoher Wert"
L["Bar background"] = "Balkenhintergrund"
L["Track texture"] = "Textur der Leiste"
L["Track color and transparency"] = "Farbe und Transparenz der Leiste"
L["Tint track with the stat color"] = "Leiste in der Wertfarbe einfärben"
L["Track tint opacity"] = "Deckkraft der Leistenfärbung"
L["Bar border"] = "Balkenrahmen"
L["Border color"] = "Rahmenfarbe"
L["Motion"] = "Bewegung"
L["Animate value changes"] = "Wertänderungen animieren"
L["Eases bars toward new values instead of snapping."] = "Lässt Balken weich zum neuen Wert laufen, statt zu springen."
L["Animation speed"] = "Animationsgeschwindigkeit"
L["Show a spark at the fill edge"] = "Funken am Füllrand anzeigen"
L["Spark color"] = "Funkenfarbe"
L["Row text"] = "Zeilentext"
L["Show stat names"] = "Wertnamen anzeigen"
L["Show values"] = "Werte anzeigen"
L["Color names with the stat color"] = "Namen in der Wertfarbe einfärben"
L["Color values with the stat color"] = "Werte in der Wertfarbe einfärben"
L["Number prioritized stats"] = "Priorisierte Werte nummerieren"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Stellt Werten in einem nach Priorität sortierten Abschnitt 1, 2, 3... voran."
L["Numbering format"] = "Nummerierungsformat"
L["Name offset"] = "Versatz des Namens"
L["Value offset"] = "Versatz des Werts"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "Abschnittsüberschrift"
L["Stat name"] = "Wertname"
L["Stat value"] = "Wert"
L["Priority line"] = "Prioritätszeile"
L["Footer"] = "Fußzeile"
L["Font"] = "Schriftart"
L["Font face (all text)"] = "Schriftart (gesamter Text)"
L["Drop shadow"] = "Schlagschatten"
L["Shadow color"] = "Schattenfarbe"
L["Shadow X offset"] = "Schattenversatz X"
L["Shadow Y offset"] = "Schattenversatz Y"
L["Per-element size and color"] = "Größe und Farbe pro Element"
L["Editing"] = "Bearbeitung"
L["Color"] = "Farbe"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "Die Farben von Wertname und Wert werden überschrieben, wenn auf der Seite 'Zeilen & Balken' das Einfärben in der Wertfarbe aktiv ist."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Einstellungen pro Wert"
L["Editing stat"] = "Bearbeiteter Wert"
L["Show this stat"] = "Diesen Wert anzeigen"
L["Stat color"] = "Wertfarbe"
L["Use class color for this stat"] = "Klassenfarbe für diesen Wert verwenden"
L["Display name (blank for default)"] = "Anzeigename (leer für Standard)"
L["Value format"] = "Wertformat"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Platzhalter: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nBeispiel: '$rating - $value%' zeigt '285 - 10,65%'."
L["Decimal places"] = "Nachkommastellen"
L["Bar scale"] = "Balkenskala"
L["Bar fill"] = "Balkenfüllung"
L["Value at a full bar"] = "Wert bei vollem Balken"
L["Grow the scale automatically"] = "Skala automatisch erhöhen"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Erhöht den Wert für den vollen Balken, sobald der Wert ihn übersteigt. Nützlich für Geschwindigkeit, die beim Drachenreiten keine Obergrenze hat."
L["Reset all stats"] = "Alle Werte zurücksetzen"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Abschnitte"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "Abschnitte werden in dieser Reihenfolge von oben nach unten gezeichnet. Jeder kann beliebige Werte enthalten."
L["Editing section"] = "Bearbeiteter Abschnitt"
L["Section title"] = "Abschnittstitel"
L["Show this section"] = "Diesen Abschnitt anzeigen"
L["Show the section header"] = "Abschnittsüberschrift anzeigen"
L["Order by spec stat priority"] = "Nach Wertepriorität der Spezialisierung sortieren"
L["Re-sorts this section's stats to match your specialization's priority."] = "Sortiert die Werte dieses Abschnitts nach der Priorität deiner Spezialisierung."
L["Header alignment"] = "Ausrichtung der Überschrift"
L["Move section up"] = "Abschnitt nach oben"
L["Move section down"] = "Abschnitt nach unten"
L["Stats in this section"] = "Werte in diesem Abschnitt"
L["Up"] = "Hoch"
L["Down"] = "Runter"
L["Remove"] = "Entfernen"
L["Add a stat to this section"] = "Wert zu diesem Abschnitt hinzufügen"
L["(every stat is already here)"] = "(alle Werte sind bereits vorhanden)"
L["Reset sections"] = "Abschnitte zurücksetzen"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Fußzeile"
L["Show the footer"] = "Fußzeile anzeigen"
L["Frames per second"] = "Bilder pro Sekunde"
L["Home latency"] = "Latenz (Heimat)"
L["World latency"] = "Latenz (Welt)"
L["Addon memory use"] = "Speicherverbrauch des Addons"
L["Separator between entries"] = "Trennzeichen zwischen Einträgen"
L["Formats"] = "Formate"
L["FPS format"] = "FPS-Format"
L["Home latency format"] = "Format der Heimat-Latenz"
L["World latency format"] = "Format der Welt-Latenz"
L["Memory format"] = "Speicherformat"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Hier gelten die üblichen Zahlenformate: %d für eine ganze Zahl, %.1f für eine Nachkommastelle."
L["Performance coloring"] = "Farbgebung nach Leistung"
L["Color by performance"] = "Nach Leistung einfärben"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Färbt FPS und Latenz je nach den Schwellenwerten unten grün, gelb oder rot."
L["Good"] = "Gut"
L["Fair"] = "Mittel"
L["Poor"] = "Schlecht"
L["FPS considered good"] = "FPS gelten als gut ab"
L["FPS considered poor"] = "FPS gelten als schlecht unter"
L["Latency considered good (ms)"] = "Latenz gilt als gut (ms)"
L["Latency considered poor (ms)"] = "Latenz gilt als schlecht (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Prioritätskette anzeigen"
L["Separator"] = "Trennzeichen"
L["Color each stat name"] = "Jeden Wertnamen einfärben"
L["Prefix with the spec name"] = "Namen der Spezialisierung voranstellen"
L["Priority for your current spec"] = "Priorität für deine aktuelle Spezialisierung"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "Die eingebaute Reihenfolge ist ein allgemeiner Richtwert. Simuliere deinen eigenen Charakter für die verbindliche Antwort und trage sie hier ein."
L["Current specialization: %s"] = "Aktuelle Spezialisierung: %s"
L["unknown"] = "unbekannt"
L["Priority %d"] = "Priorität %d"
L["Paste a stat weight string"] = "Zeichenfolge mit Wertungsgewichten einfügen"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Füge eine Pawn-Zeichenfolge (von Raidbots, einer Sim oder einer Statistikseite) oder eine einfache Reihenfolge wie 'Mastery > Haste > Crit > Versatility' ein. StatPanel liest die vier Sekundärwerte und setzt die Reihenfolge für deine aktuelle Spezialisierung."
L["Weights or order"] = "Gewichte oder Reihenfolge"
L["Apply pasted weights"] = "Eingefügte Gewichte anwenden"
L["no active specialization to apply to."] = "Keine aktive Spezialisierung, auf die das angewendet werden könnte."
L["priority for %s set to %s."] = "Priorität für %s auf %s gesetzt."
L["your spec"] = "deine Spezialisierung"
L["Use the built-in order"] = "Eingebaute Reihenfolge verwenden"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Vorlagen"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Eine Vorlage überschreibt die Darstellungseinstellungen im aktuellen Profil. Position, Sichtbarkeitsregeln und Profile bleiben unangetastet."
L["Start over"] = "Neu beginnen"
L["Reset this profile"] = "Dieses Profil zurücksetzen"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Jeder Charakter merkt sich sein Profil, sodass du ein Aussehen über alle Twinks teilen oder jedem ein eigenes geben kannst."
L["Active profile"] = "Aktives Profil"
L["New profile name"] = "Name des neuen Profils"
L["Create"] = "Erstellen"
L["Copy current"] = "Aktuelles kopieren"
L["Delete current"] = "Aktuelles löschen"
L["Deleted profile '%s'."] = "Profil '%s' gelöscht."
L["Share"] = "Teilen"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "Der Export erzeugt eine Zeichenfolge, die du weitergeben kannst. Der Import überschreibt das unten genannte Profil oder das aktive, wenn du das Feld leer lässt."
L["Export string"] = "Exportzeichenfolge"
L["Generate export"] = "Export erzeugen"
L["Import string"] = "Importzeichenfolge"
L["Import into profile (blank = active)"] = "In Profil importieren (leer = aktives)"
L["Import"] = "Importieren"
L["Imported into profile '%s'."] = "In Profil '%s' importiert."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Ankündigen"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Sendet eine Zusammenfassung deiner Ausrüstung in den Chat. Es wird nie automatisch etwas gesendet - nur über die Schaltfläche, den Slash-Befehl oder das Rechtsklickmenü."
L["Send to"] = "Senden an"
L["Whisper to (for the Whisper channel)"] = "Flüstern an (für den Kanal 'Flüstern')"
L["Prefix"] = "Präfix"
L["Include"] = "Einschließen"
L["Stats"] = "Werte"
L["Stat priority"] = "Wertepriorität"
L["Session peak speed"] = "Höchsttempo der Sitzung"
L["Missing enchants and sockets"] = "Fehlende Verzauberungen und Sockel"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "Das Spiel schützt die meisten Kampfwerte und lässt kein Addon sie in den Chat senden, daher werden sie automatisch weggelassen. Gegenstandsstufe, Spezialisierung, Tempo und Ausrüstungswarnungen kommen durch. Hebt ein späterer Patch den Schutz eines Werts auf, erscheint er ohne weitere Änderung."
L["Preview"] = "Vorschau"
L["Announce now"] = "Jetzt ankündigen"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Angelegte Ausrüstung"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "Gegenstandsdaten werden vom Spiel nicht geschützt, daher lassen sie sich anders als die Kampfwerte vollständig auslesen."
L["Refresh"] = "Aktualisieren"
L["Print report"] = "Bericht ausgeben"
L["Average equipped item level %.2f.%s  %s"] = "Durchschnittliche angelegte Gegenstandsstufe %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Klassenset %d/%d."
L["Nothing missing."] = "Es fehlt nichts."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(keine Regel)"
L["Automatic profile switching"] = "Automatischer Profilwechsel"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "Regeln werden pro Charakter gespeichert. Eine Inhaltsregel schlägt eine Spezialisierungsregel, sodass du allgemein ein Spezialisierungsprofil behalten und im Schlachtzug trotzdem ein anderes erzwingen kannst. Alles auf '(keine Regel)' wird ignoriert."
L["Switch profiles automatically"] = "Profile automatisch wechseln"
L["By content"] = "Nach Inhalt"
L["By specialization"] = "Nach Spezialisierung"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "Nur deine aktuelle Spezialisierung wird aufgeführt. Wechsle die Spezialisierung und komm zurück, um eine Regel für eine andere zu setzen."
L["Profile for this specialization"] = "Profil für diese Spezialisierung"
L["Apply rules now"] = "Regeln jetzt anwenden"
L["no rule matches your current spec or location."] = "Keine Regel passt zu deiner aktuellen Spezialisierung oder deinem Aufenthaltsort."
L["already on '%s', the profile your rules call for."] = "Bereits auf '%s', dem von deinen Regeln geforderten Profil."
L["Clear all rules"] = "Alle Regeln löschen"
L["cleared this character's automatic rules."] = "Automatische Regeln dieses Charakters gelöscht."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "Allgemein"
L["Rows & Bars"] = "Zeilen & Balken"
L["Fonts"] = "Schriftarten"
L["Priority"] = "Priorität"
L["Gear"] = "Ausrüstung"
L["Profiles"] = "Profile"
L["Automation"] = "Automatisierung"
L["Dark"] = "Dunkel"
L["Grey"] = "Grau"
L["Light"] = "Hell"
L["Game"] = "Spiel"
L["Background: %s"] = "Hintergrund: %s"
L["Live Preview"] = "Live-Vorschau"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "Das echte Panel, hier angedockt. Ziehe dieses Fenster, um es zu verschieben; das Panel kehrt zurück, sobald du die Optionen schließt."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Gib /sp für Slash-Befehle ein. Ziehe das Panel selbst, um es zu verschieben."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "Das Standardaussehen: flaches dunkles Panel mit farbigen Wertebalken."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Keine Balken. Eine farbige Zeile pro Wert: 'Meisterschaft: 285 - 10,65%'."
L["Thin headerless bars for a small footprint."] = "Dünne Balken ohne Überschriften für wenig Platzbedarf."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Blizzard-Texturen und ein Tooltip-Rahmen, passend zur Standardoberfläche."
L["No background or border at all - just floating text and bars."] = "Ganz ohne Hintergrund und Rahmen - nur schwebender Text und Balken."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Winziger monochromer Text ohne Hintergrund. Sitzt unauffällig in einer Ecke."
L["High-contrast glow bars on near-black, with a value gradient."] = "Kontrastreiche Leuchtbalken auf fast Schwarz, mit Wertverlauf."
L["Warm parchment and gold, in keeping with the default UI art."] = "Warmes Pergament und Gold, im Stil der Standardoberfläche."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Defensiver Fokus: Rüstung, Ausweichen, Parieren, Blocken und Vermeidung ganz oben."
L["Big live speed readout with your session record, and little else."] = "Große Live-Tempoanzeige mit deinem Sitzungsrekord, und sonst wenig."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Sekundärwerte, Gegenstandsstufe und beide Latenzen - was man vor einem Pull prüft."
L["Cold blues and whites on deep navy."] = "Kühles Blau und Weiß auf tiefem Marineblau."
L["Warm reds and ambers on charcoal."] = "Warmes Rot und Bernstein auf Anthrazit."
L["Every bar takes your class color. Clean and unfussy."] = "Jeder Balken nimmt deine Klassenfarbe an. Klar und schnörkellos."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Großer, fetter, kontrastreicher Text. Auf einen Blick lesbar."
L["The smallest useful readout: four secondaries, nothing else."] = "Die kleinste sinnvolle Anzeige: vier Sekundärwerte, sonst nichts."
L["Green-on-black monospace, like a console readout."] = "Grün auf Schwarz in Festbreitenschrift, wie eine Konsolenausgabe."
L["Throughput stats plus leech, with your primary attribute on top."] = "Schadenswerte plus Lebensraub, mit deinem Primärattribut ganz oben."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Vielseitigkeit zuerst, daneben Vermeidung, Ausweichen und Geschwindigkeit."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "Passend zu ElvUI: flaches dunkles Panel, 1px schwarzer Rahmen, schmale Schrift."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "Der beliebte transparente ElvUI-Stil: fast schwarzes Glas, haarfeiner Rahmen."
L["preset hook failed: %s"] = "Vorlagen-Hook fehlgeschlagen: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "Befehle:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - Optionen öffnen"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - Panel ein- oder ausblenden"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - Verschieben sperren oder freigeben"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - Panel zurück in die Mitte setzen"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <Name>|r - Vorlage anwenden (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <Name>|r - Profil wechseln"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - Temporekord der Sitzung ausgeben und zurücksetzen"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - Minikartensymbol ein- oder ausblenden"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - Verzauberungen, Sockel und Gegenstandsstufe prüfen"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [Kanal]|r - Ausrüstung in den Chat melden"
L["panel shown."] = "Panel eingeblendet."
L["panel hidden."] = "Panel ausgeblendet."
L["panel locked."] = "Panel gesperrt."
L["panel unlocked."] = "Panel entsperrt."
L["position reset."] = "Position zurückgesetzt."
L["applied the '%s' preset."] = "Vorlage '%s' angewendet."
L["unknown preset. Available: %s"] = "Unbekannte Vorlage. Verfügbar: %s"
L["switched to profile '%s'."] = "Zu Profil '%s' gewechselt."
L["profiles: %s"] = "Profile: %s"
L["session speed record cleared."] = "Temporekord der Sitzung zurückgesetzt."
L["minimap button hidden."] = "Minikartensymbol ausgeblendet."
L["minimap button shown."] = "Minikartensymbol eingeblendet."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Primärattribut"
L["Armor DR"] = "Rüstung SR"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Krit"
L["Haste"] = "Tempo"
L["Mast"] = "Meist."
L["Vers"] = "Viels."

L["a display setting could not be applied (%s)."] = "Eine Darstellungseinstellung konnte nicht angewendet werden (%s)."
L["The game protects this value; see the panel itself."] = "Das Spiel schützt diesen Wert; sieh im Panel selbst nach."
L["Value"] = "Wert"
L["Rating"] = "Wertung"
L["Yards/sec"] = "Meter/Sek."
L["Session peak"] = "Höchstwert der Sitzung"
L["Attribute"] = "Attribut"
L["Drag to move  |  /sp for options"] = "Ziehen zum Verschieben  |  /sp für Optionen"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Stärke"
L["Agility"] = "Beweglichkeit"
L["Stamina"] = "Ausdauer"
L["Intellect"] = "Intelligenz"
L["Mastery"] = "Meisterschaft"
L["Versatility"] = "Vielseitigkeit"
L["Dodge"] = "Ausweichen"
L["Parry"] = "Parieren"
L["Block"] = "Blocken"
L["Leech"] = "Lebensraub"
L["Avoidance"] = "Vermeidung"
L["Speed"] = "Geschwindigkeit"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "Panel ein- oder ausblenden"
L["Open the options"] = "Optionen öffnen"
L["Lock or unlock the panel"] = "Panel sperren oder entsperren"
L["Switch to the next profile"] = "Zum nächsten Profil wechseln"
L["Run the gear audit"] = "Ausrüstungsprüfung ausführen"
L["only one profile exists."] = "Es existiert nur ein Profil."

-- Diagnostics.lua
L["yes"] = "ja"
L["no"] = "nein"
L["LibStub not present"] = "LibStub nicht vorhanden"
L["absent"] = "nicht vorhanden"
L["present (revision %s)"] = "vorhanden (Revision %s)"
L["not present in this client"] = "in diesem Client nicht vorhanden"
L["present, could not sample"] = "vorhanden, konnte nicht geprüft werden"
L["active (crit chance is protected)"] = "aktiv (Trefferwertung ist geschützt)"
L["present but crit chance is readable"] = "vorhanden, aber Trefferwertung ist lesbar"
L["Locale"] = "Sprache"
L["Class"] = "Klasse"
L["Secret values"] = "Geschützte Werte"
L["Profiles stored"] = "Gespeicherte Profile"
L["Custom stat priority"] = "Eigene Wertepriorität"
L["enabled"] = "aktiviert"
L["disabled"] = "deaktiviert"
L["locked"] = "gesperrt"
L["unlocked"] = "entsperrt"
L["auto width"] = "automatische Breite"
L["width %d"] = "Breite %d"
L["Position"] = "Position"
L[" (substituted: not readable in this locale)"] = " (ersetzt: in dieser Sprache nicht lesbar)"
L["Stat rows"] = "Wertezeilen"
L["%d shown of %d placed"] = "%d von %d platzierten werden angezeigt"
L["StatPanel diagnostics"] = "StatPanel-Diagnose"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "Strg-A zum Markieren, Strg-C zum Kopieren. Füge dies in deinen Fehlerbericht ein."

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "auf %s aktualisiert. Neu in dieser Version:"
L["  Full changelog: %s"] = "  Vollständige Änderungsliste: %s"
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "Tastenbelegungen für Ein-/Ausblenden, Sperren, Profilwechsel und die Ausrüstungsprüfung."
L["New stats: attack power, spell power, health, mana and stagger."] = "Neue Werte: Angriffskraft, Zaubermacht, Leben, Mana und Staffelung."
L["The $per token shows what one percent of a stat costs in rating."] = "Der Platzhalter $per zeigt, wie viel Wertung ein Prozent eines Wertes kostet."
L["Gear durability and repair cost can now sit in the footer."] = "Haltbarkeit der Ausrüstung und Reparaturkosten können jetzt in der Fußzeile stehen."
L["A Colorblind Safe preset, and precise X/Y position controls."] = "Eine farbenblindensichere Vorlage und genaue X/Y-Positionsregler."
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug sammelt alles für einen Fehlerbericht in einem kopierbaren Feld."

-- Options.lua: anchor points and position
L["Top left"] = "Oben links"
L["Top"] = "Oben"
L["Top right"] = "Oben rechts"
L["Bottom left"] = "Unten links"
L["Bottom"] = "Unten"
L["Bottom right"] = "Unten rechts"
L["Anchor point"] = "Ankerpunkt"
L["Which corner of the panel the position below is measured from."] = "Von welcher Ecke des Panels die Position unten gemessen wird."
L["Anchored to screen"] = "Am Bildschirm verankert"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "Zu welchem Punkt des Bildschirms gemessen wird. Eine Verankerung an einer Ecke hält das Panel dort, wenn sich die Auflösung ändert."
L["Horizontal position"] = "Horizontale Position"
L["Vertical position"] = "Vertikale Position"
L[" (not readable in this language)"] = " (in dieser Sprache nicht lesbar)"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "Niedrigste Haltbarkeit der Ausrüstung"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "Die schlechteste Haltbarkeit aller angelegten Plätze, damit du das kaputte Teil siehst und keinen Durchschnitt."
L["Repair cost"] = "Reparaturkosten"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "Das Spiel kann eine Reparatur nur bei einem Händler beziffern, daher wird bis dahin nichts angezeigt."
L["Durability format"] = "Format der Haltbarkeit"
L["Durability considered good"] = "Haltbarkeit gilt als gut"
L["Durability considered poor"] = "Haltbarkeit gilt als schlecht"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "Okabe-Ito-Palette, lesbar bei Rot-Grün-Sehschwäche. Mit Rangnummern."

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - Diagnose für einen Fehlerbericht anzeigen"
L["diagnostics:"] = "Diagnose:"

-- StatPanel.lua: new stat names
L["Attack Power"] = "Angriffskraft"
L["Spell Power"] = "Zaubermacht"
L["Health"] = "Leben"
L["Mana"] = "Mana"
L["Stagger"] = "Staffelung"
