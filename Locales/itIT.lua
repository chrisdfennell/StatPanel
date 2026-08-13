-- Locales/itIT.lua (Italian)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export itIT`, then
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
--     Italian too if a global ever disappears.
--
-- NOT REVIEWED BY A NATIVE SPEAKER. Terminology follows the Italian client's own
-- wording where it exists, but corrections are very welcome -- please open an
-- issue at https://github.com/chrisdfennell/StatPanel/issues.

local _, SP = ...
local L = SP.Locale("itIT")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Mostra solo nella mia chat"
L["Say"] = "Dire"
L["Party"] = "Gruppo"
L["Raid"] = "Incursione"
L["Instance"] = "Istanza"
L["Guild"] = "Gilda"
L["Officer"] = "Ufficiale"
L["Yell"] = "Urlare"
L["Whisper"] = "Sussurrare"
L["iLvl %.2f (%.2f overall)"] = "LvO %.2f (%.2f totale)"
L["iLvl %.2f"] = "LvO %.2f"
L["priority %s"] = "priorità %s"
L["peak speed %.0f%%"] = "velocità massima %.0f%%"
L["%d missing enchant(s)"] = "%d incantamento/i mancante/i"
L["%d empty socket(s)"] = "%d alloggiamento/i vuoto/i"
L["%d/%d tier set"] = "%d/%d completo di classe"
L["You aren't in a group."] = "Non sei in un gruppo."
L["You aren't in a raid."] = "Non sei in un'incursione."
L["You aren't in a guild."] = "Non sei in una gilda."
L["hold on - you can announce again in %.0f seconds."] = "un attimo - potrai annunciare di nuovo tra %.0f secondi."
L["nothing to announce - enable some fields on the Announce page."] = "niente da annunciare - attiva qualche campo nella pagina Annuncio."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d valore/i omesso/i: il gioco protegge quelle statistiche, quindi non possono essere inviate in chat."
L["%s Showing it here instead:"] = "%s Mostrato qui invece:"
L["whisper needs a name: /sp announce whisper <name>"] = "il sussurro richiede un nome: /sp announce whisper <nome>"
L["the game refused to send that message. Showing it here instead:"] = "il gioco ha rifiutato di inviare quel messaggio. Mostrato qui invece:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Mondo aperto"
L["Delve"] = "Anfratto"
L["Dungeon"] = "Spedizione"
L["Mythic+ dungeon"] = "Spedizione Mitica+"
L["Arena"] = "Arena"
L["Battleground"] = "Campo di Battaglia"
L["Scenario"] = "Scenario"
L["switched to profile '%s' (%s rule)."] = "passato al profilo '%s' (regola: %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Livello oggetto"
L["FPS"] = "FPS"
L["Spec"] = "Specializzazione"
L["Profile"] = "Profilo"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Clic sinistro|r  apri le opzioni"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Clic destro|r  menu rapido"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  LvO %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "Il nome del profilo non può essere vuoto."
L["A profile named '%s' already exists."] = "Esiste già un profilo chiamato '%s'."
L["The Default profile cannot be deleted."] = "Il profilo predefinito non può essere eliminato."
L["No such profile."] = "Questo profilo non esiste."
L["Nothing to import."] = "Niente da importare."
L["That import string is too large to be a profile."] = "Questa stringa di importazione è troppo grande per essere un profilo."
L["That doesn't look like a StatPanel export string."] = "Non sembra una stringa di esportazione di StatPanel."
L["The import string is corrupt."] = "La stringa di importazione è danneggiata."
L["Could not read the import string: %s"] = "Impossibile leggere la stringa di importazione: %s"
L["The import string did not contain a profile."] = "La stringa di importazione non conteneva alcun profilo."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "controllo dell'equipaggiamento"
L["empty"] = "vuoto"
L["no enchant"] = "nessun incantamento"
L["%d rare gem(s)"] = "%d gemma/e non comune/i"
L["lowest"] = "il più basso"
L["Equipped"] = "Equipaggiato"
L["Tier set    %d/%d"] = "Completo di classe    %d/%d"
L["%d item(s) not fully upgraded"] = "%d oggetto/i non del tutto potenziato/i"
L["Everything is enchanted and socketed."] = "Tutto è incantato e ingemmato."
L["%d enchant(s)"] = "%d incantamento/i"
L["%d socket(s)"] = "%d alloggiamento/i"
L["%d empty slot(s)"] = "%d slot vuoto/i"
L["Missing: %s"] = "Mancante: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Testa"
L["Neck"] = "Collo"
L["Shoulder"] = "Spalle"
L["Back"] = "Schiena"
L["Chest"] = "Torso"
L["Wrist"] = "Polsi"
L["Hands"] = "Mani"
L["Waist"] = "Vita"
L["Legs"] = "Gambe"
L["Feet"] = "Piedi"
L["Ring 1"] = "Anello 1"
L["Ring 2"] = "Anello 2"
L["Trinket 1"] = "Monile 1"
L["Trinket 2"] = "Monile 2"
L["Main Hand"] = "Mano primaria"
L["Off Hand"] = "Mano secondaria"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Nessuno"
L["Outline"] = "Contorno"
L["Thick Outline"] = "Contorno spesso"
L["Monochrome"] = "Monocromatico"
L["Monochrome Outline"] = "Contorno monocromatico"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Mostra il pannello"
L["Lock position"] = "Blocca la posizione"
L["Show FPS"] = "Mostra gli FPS"
L["Apply preset"] = "Applica una preimpostazione"
L["Announce to"] = "Annuncia su"
L["Audit my gear"] = "Controlla il mio equipaggiamento"
L["Open options"] = "Apri le opzioni"
L["Reset position"] = "Reimposta la posizione"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Sinistra"
L["Center"] = "Centro"
L["Right"] = "Destra"
L["Proportional to value"] = "Proporzionale al valore"
L["Always full"] = "Sempre piena"
L["No fill (text only)"] = "Nessun riempimento (solo testo)"
L["Per-stat colors"] = "Colori per statistica"
L["Class color"] = "Colore della classe"
L["Single color"] = "Colore unico"
L["Value gradient"] = "Sfumatura in base al valore"
L["Bars"] = "Barre"
L["Text only"] = "Solo testo"
L["Player name"] = "Nome del giocatore"
L["Specialization"] = "Specializzazione"
L["Custom text"] = "Testo personalizzato"
L["Hidden"] = "Nascosto"
L["Total effect (character sheet)"] = "Effetto totale (scheda del personaggio)"
L["Bonus from rating only"] = "Solo il bonus dalla valutazione"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Pannello"
L["Enable StatPanel"] = "Attiva StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "Interruttore principale. Disattivarlo nasconde del tutto il pannello."
L["Stops the panel from being dragged."] = "Impedisce di trascinare il pannello."
L["Keep on screen"] = "Mantieni sullo schermo"
L["Prevents dragging the panel off the edge of the screen."] = "Impedisce di trascinare il pannello oltre il bordo dello schermo."
L["Scale"] = "Scala"
L["Opacity"] = "Opacità"
L["Frame layer"] = "Livello del riquadro"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "Il livello su cui viene disegnato il pannello. Aumentalo se un altro addon copre il pannello."
L["Update interval (seconds)"] = "Intervallo di aggiornamento (secondi)"
L["How often values refresh. Higher values use less CPU."] = "Ogni quanto i valori si aggiornano. Valori più alti consumano meno CPU."
L["Stat values show"] = "I valori mostrano"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "L'effetto totale corrisponde alla scheda del personaggio. Il bonus dalla valutazione mostra solo ciò che apporta la valutazione del tuo equipaggiamento."
L["Visibility"] = "Visibilità"
L["Hide during combat"] = "Nascondi in combattimento"
L["Turning this on clears 'Show only during combat'."] = "Attivare questa opzione disattiva «Mostra solo in combattimento»."
L["Show only during combat"] = "Mostra solo in combattimento"
L["Turning this on clears 'Hide during combat'."] = "Attivare questa opzione disattiva «Nascondi in combattimento»."
L["Hide while dead"] = "Nascondi da morto"
L["Hide in vehicles"] = "Nascondi nei veicoli"
L["Hide in pet battles"] = "Nascondi nelle lotte tra mascotte"
L["Hide inside instances"] = "Nascondi dentro le istanze"
L["Turning this on clears 'Hide outside instances'."] = "Attivare questa opzione disattiva «Nascondi fuori dalle istanze»."
L["Hide outside instances"] = "Nascondi fuori dalle istanze"
L["Turning this on clears 'Hide inside instances'."] = "Attivare questa opzione disattiva «Nascondi dentro le istanze»."
L["Mouseover fade"] = "Dissolvenza senza il cursore"
L["Only show on mouseover"] = "Mostra solo al passaggio del cursore"
L["Fades the panel out until you hover over it."] = "Dissolve il pannello finché non ci passi sopra con il cursore."
L["Faded opacity"] = "Opacità in dissolvenza"
L["Fade duration (seconds)"] = "Durata della dissolvenza (secondi)"
L["Show tooltips on hover"] = "Mostra i suggerimenti al passaggio del cursore"
L["Minimap and options"] = "Minimappa e opzioni"
L["Show the minimap button"] = "Mostra il pulsante della minimappa"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "Il clic sinistro apre queste opzioni, il destro apre il menu rapido. Trascinalo lungo il bordo della minimappa."
L["Show a live preview while configuring"] = "Mostra un'anteprima dal vivo durante la configurazione"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Aggancia il pannello vero accanto a questa finestra per vedere le modifiche mentre le fai."
L["Reset peak speed"] = "Reimposta la velocità massima"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Dimensione"
L["Auto-size width to content"] = "Adatta la larghezza al contenuto"
L["Grows and shrinks the panel to fit the widest row."] = "Ingrandisce e riduce il pannello per adattarlo alla riga più larga."
L["Width"] = "Larghezza"
L["Minimum width (auto-size)"] = "Larghezza minima (adattamento automatico)"
L["Side padding"] = "Margine laterale"
L["Top padding"] = "Margine superiore"
L["Bottom padding"] = "Margine inferiore"
L["Gap between sections"] = "Spazio tra le sezioni"
L["Section header spacing"] = "Spaziatura delle intestazioni di sezione"
L["Set to 0 to remove section headers entirely."] = "Imposta 0 per rimuovere del tutto le intestazioni di sezione."
L["Background"] = "Sfondo"
L["Background texture"] = "Trama dello sfondo"
L["Background color and transparency"] = "Colore e trasparenza dello sfondo"
L["Tile the background"] = "Ripeti lo sfondo a mosaico"
L["Tile size"] = "Dimensione del mosaico"
L["Border"] = "Bordo"
L["Border style"] = "Stile del bordo"
L["Border color and transparency"] = "Colore e trasparenza del bordo"
L["Border thickness"] = "Spessore del bordo"
L["Only affects pixel-style borders; textured borders use their own size."] = "Influisce solo sui bordi in stile pixel; i bordi con trama usano la propria dimensione."
L["Border inset"] = "Rientro del bordo"
L["Title"] = "Titolo"
L["Show title"] = "Mostra il titolo"
L["Title shows"] = "Il titolo mostra"
L["Title alignment"] = "Allineamento del titolo"
L["Item level format"] = "Formato del livello oggetto"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Segnaposto: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Segnaposto: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Decimali del livello oggetto"
L["Custom title text"] = "Testo del titolo personalizzato"
L["Divider"] = "Separatore"
L["Show divider under title"] = "Mostra un separatore sotto il titolo"
L["Divider color"] = "Colore del separatore"
L["Divider thickness"] = "Spessore del separatore"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Stile delle righe"
L["Draw rows as"] = "Disegna le righe come"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "Le barre disegnano una barra di stato per statistica. Solo testo disegna una singola riga colorata per statistica."
L["Text alignment (text style)"] = "Allineamento del testo (stile testo)"
L["Label/value separator (text style)"] = "Separatore tra nome e valore (stile testo)"
L["Placed between the stat name and its value, e.g. ': '"] = "Inserito tra il nome della statistica e il suo valore, ad es. «: »"
L["Line height (text style)"] = "Altezza della riga (stile testo)"
L["Bar appearance"] = "Aspetto delle barre"
L["Bar texture"] = "Trama delle barre"
L["Bar height"] = "Altezza delle barre"
L["Space between bars"] = "Spazio tra le barre"
L["Horizontal inset"] = "Rientro orizzontale"
L["Bar opacity"] = "Opacità delle barre"
L["Fill from the right"] = "Riempi da destra"
L["Bar colors"] = "Colori delle barre"
L["Color mode"] = "Modalità colore"
L["Per-stat colors are set on the Stats page."] = "I colori per statistica si impostano nella pagina Statistiche."
L["Gradient: low value"] = "Sfumatura: valore basso"
L["Gradient: high value"] = "Sfumatura: valore alto"
L["Bar background"] = "Sfondo delle barre"
L["Track texture"] = "Trama della guida"
L["Track color and transparency"] = "Colore e trasparenza della guida"
L["Tint track with the stat color"] = "Colora la guida con il colore della statistica"
L["Track tint opacity"] = "Opacità della tinta della guida"
L["Bar border"] = "Bordo delle barre"
L["Border color"] = "Colore del bordo"
L["Motion"] = "Movimento"
L["Animate value changes"] = "Anima i cambi di valore"
L["Eases bars toward new values instead of snapping."] = "Fa scorrere le barre verso i nuovi valori invece di farle saltare."
L["Animation speed"] = "Velocità dell'animazione"
L["Show a spark at the fill edge"] = "Mostra una scintilla sul bordo del riempimento"
L["Spark color"] = "Colore della scintilla"
L["Row text"] = "Testo delle righe"
L["Show stat names"] = "Mostra i nomi delle statistiche"
L["Show values"] = "Mostra i valori"
L["Color names with the stat color"] = "Colora i nomi con il colore della statistica"
L["Color values with the stat color"] = "Colora i valori con il colore della statistica"
L["Number prioritized stats"] = "Numera le statistiche prioritarie"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Antepone 1, 2, 3... alle statistiche di una sezione ordinata per priorità."
L["Numbering format"] = "Formato della numerazione"
L["Name offset"] = "Scostamento del nome"
L["Value offset"] = "Scostamento del valore"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "Intestazione di sezione"
L["Stat name"] = "Nome della statistica"
L["Stat value"] = "Valore della statistica"
L["Priority line"] = "Riga della priorità"
L["Footer"] = "Piè di pagina"
L["Font"] = "Carattere"
L["Font face (all text)"] = "Carattere (tutto il testo)"
L["Drop shadow"] = "Ombra esterna"
L["Shadow color"] = "Colore dell'ombra"
L["Shadow X offset"] = "Scostamento X dell'ombra"
L["Shadow Y offset"] = "Scostamento Y dell'ombra"
L["Per-element size and color"] = "Dimensione e colore per elemento"
L["Editing"] = "Modifica"
L["Color"] = "Colore"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "I colori del nome e del valore vengono sostituiti quando la colorazione con il colore della statistica è attiva nella pagina Righe e barre."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Impostazioni per statistica"
L["Editing stat"] = "Statistica in modifica"
L["Show this stat"] = "Mostra questa statistica"
L["Stat color"] = "Colore della statistica"
L["Use class color for this stat"] = "Usa il colore della classe per questa statistica"
L["Display name (blank for default)"] = "Nome visualizzato (vuoto per il predefinito)"
L["Value format"] = "Formato del valore"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Segnaposto: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nEsempio: '$rating - $value%' mostra '285 - 10.65%'."
L["Decimal places"] = "Cifre decimali"
L["Bar scale"] = "Scala delle barre"
L["Bar fill"] = "Riempimento delle barre"
L["Value at a full bar"] = "Valore a barra piena"
L["Grow the scale automatically"] = "Aumenta la scala automaticamente"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Alza il valore di barra piena ogni volta che la statistica lo supera. Utile per Velocità, che non ha un tetto durante il volo draconico."
L["Reset all stats"] = "Reimposta tutte le statistiche"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Sezioni"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "Le sezioni sono disegnate dall'alto in basso in quest'ordine. Ognuna può contenere le statistiche che preferisci."
L["Editing section"] = "Sezione in modifica"
L["Section title"] = "Titolo della sezione"
L["Show this section"] = "Mostra questa sezione"
L["Show the section header"] = "Mostra l'intestazione della sezione"
L["Order by spec stat priority"] = "Ordina per priorità della specializzazione"
L["Re-sorts this section's stats to match your specialization's priority."] = "Riordina le statistiche di questa sezione secondo la priorità della tua specializzazione."
L["Header alignment"] = "Allineamento dell'intestazione"
L["Move section up"] = "Sposta la sezione in alto"
L["Move section down"] = "Sposta la sezione in basso"
L["Stats in this section"] = "Statistiche di questa sezione"
L["Up"] = "Su"
L["Down"] = "Giù"
L["Remove"] = "Rimuovi"
L["Add a stat to this section"] = "Aggiungi una statistica a questa sezione"
L["(every stat is already here)"] = "(tutte le statistiche sono già presenti)"
L["Reset sections"] = "Reimposta le sezioni"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Riga a piè di pagina"
L["Show the footer"] = "Mostra il piè di pagina"
L["Frames per second"] = "Fotogrammi al secondo"
L["Home latency"] = "Latenza locale"
L["World latency"] = "Latenza di mondo"
L["Addon memory use"] = "Memoria usata dall'addon"
L["Separator between entries"] = "Separatore tra le voci"
L["Formats"] = "Formati"
L["FPS format"] = "Formato degli FPS"
L["Home latency format"] = "Formato della latenza locale"
L["World latency format"] = "Formato della latenza di mondo"
L["Memory format"] = "Formato della memoria"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Questi usano i formati numerici standard: %d per un numero intero, %.1f per un decimale."
L["Performance coloring"] = "Colorazione in base alle prestazioni"
L["Color by performance"] = "Colora in base alle prestazioni"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Rende FPS e latenza verdi, gialli o rossi in base alle soglie qui sotto."
L["Good"] = "Buono"
L["Fair"] = "Discreto"
L["Poor"] = "Scarso"
L["FPS considered good"] = "FPS considerati buoni"
L["FPS considered poor"] = "FPS considerati scarsi"
L["Latency considered good (ms)"] = "Latenza considerata buona (ms)"
L["Latency considered poor (ms)"] = "Latenza considerata scarsa (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Mostra la catena di priorità"
L["Separator"] = "Separatore"
L["Color each stat name"] = "Colora ogni nome di statistica"
L["Prefix with the spec name"] = "Anteponi il nome della specializzazione"
L["Priority for your current spec"] = "Priorità per la tua specializzazione attuale"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "L'ordine integrato è un riferimento generico. Simula il tuo personaggio per la risposta definitiva, poi impostala qui."
L["Current specialization: %s"] = "Specializzazione attuale: %s"
L["unknown"] = "sconosciuta"
L["Priority %d"] = "Priorità %d"
L["Paste a stat weight string"] = "Incolla una stringa di pesi delle statistiche"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Incolla una stringa di Pawn (da Raidbots, da una simulazione o da un sito di statistiche) oppure un semplice ordine come 'Mastery > Haste > Crit > Versatility'. StatPanel legge le quattro statistiche secondarie e imposta l'ordine per la tua specializzazione attuale."
L["Weights or order"] = "Pesi o ordine"
L["Apply pasted weights"] = "Applica i pesi incollati"
L["no active specialization to apply to."] = "nessuna specializzazione attiva a cui applicarlo."
L["priority for %s set to %s."] = "priorità di %s impostata su %s."
L["your spec"] = "la tua specializzazione"
L["Use the built-in order"] = "Usa l'ordine integrato"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Preimpostazioni"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Una preimpostazione sovrascrive le impostazioni di aspetto del profilo attuale. La posizione, le regole di visibilità e i profili restano intatti."
L["Start over"] = "Ricomincia"
L["Reset this profile"] = "Reimposta questo profilo"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Ogni personaggio ricorda il profilo che usa, così puoi condividere un aspetto tra gli alt o darne uno diverso a ciascuno."
L["Active profile"] = "Profilo attivo"
L["New profile name"] = "Nome del nuovo profilo"
L["Create"] = "Crea"
L["Copy current"] = "Copia quello attuale"
L["Delete current"] = "Elimina quello attuale"
L["Deleted profile '%s'."] = "Profilo '%s' eliminato."
L["Share"] = "Condividi"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "L'esportazione genera una stringa che puoi passare a qualcun altro. L'importazione sovrascrive il profilo indicato qui sotto, o quello attivo se lasci il campo vuoto."
L["Export string"] = "Stringa di esportazione"
L["Generate export"] = "Genera l'esportazione"
L["Import string"] = "Stringa di importazione"
L["Import into profile (blank = active)"] = "Importa nel profilo (vuoto = attivo)"
L["Import"] = "Importa"
L["Imported into profile '%s'."] = "Importato nel profilo '%s'."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Annuncio"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Invia in chat un riepilogo del tuo equipaggiamento. Non viene mai inviato nulla automaticamente: solo se usi il pulsante, il comando slash o il menu contestuale."
L["Send to"] = "Invia a"
L["Whisper to (for the Whisper channel)"] = "Sussurra a (per il canale Sussurro)"
L["Prefix"] = "Prefisso"
L["Include"] = "Includi"
L["Stats"] = "Statistiche"
L["Stat priority"] = "Priorità delle statistiche"
L["Session peak speed"] = "Velocità massima della sessione"
L["Missing enchants and sockets"] = "Incantamenti e alloggiamenti mancanti"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "Il gioco protegge la maggior parte delle statistiche di combattimento e non permette a nessun addon di inviarle in chat, quindi vengono omesse automaticamente. Livello oggetto, specializzazione, velocità e avvisi sull'equipaggiamento passano senza problemi. Se una patch futura toglierà la protezione a una statistica, comparirà senza bisogno di alcuna modifica."
L["Preview"] = "Anteprima"
L["Announce now"] = "Annuncia adesso"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Equipaggiamento indossato"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "I dati degli oggetti non sono protetti dal gioco, quindi, a differenza delle statistiche di combattimento, possono essere letti per intero."
L["Refresh"] = "Aggiorna"
L["Print report"] = "Mostra il rapporto"
L["Average equipped item level %.2f.%s  %s"] = "Livello oggetto medio indossato %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Completo di classe %d/%d."
L["Nothing missing."] = "Non manca nulla."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(nessuna regola)"
L["Automatic profile switching"] = "Cambio automatico di profilo"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "Le regole sono salvate per personaggio. Una regola di contenuto ha la precedenza su una di specializzazione, quindi puoi mantenere in generale un profilo di specializzazione e forzarne un altro in incursione. Tutto ciò che resta su «(nessuna regola)» viene ignorato."
L["Switch profiles automatically"] = "Cambia profilo automaticamente"
L["By content"] = "Per contenuto"
L["By specialization"] = "Per specializzazione"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "È elencata solo la tua specializzazione attuale. Cambia specializzazione e torna qui per impostare una regola per un'altra."
L["Profile for this specialization"] = "Profilo per questa specializzazione"
L["Apply rules now"] = "Applica le regole adesso"
L["no rule matches your current spec or location."] = "nessuna regola corrisponde alla tua specializzazione o posizione attuale."
L["already on '%s', the profile your rules call for."] = "sei già su '%s', il profilo richiesto dalle tue regole."
L["Clear all rules"] = "Cancella tutte le regole"
L["cleared this character's automatic rules."] = "regole automatiche di questo personaggio cancellate."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "Generale"
L["Rows & Bars"] = "Righe e barre"
L["Fonts"] = "Caratteri"
L["Priority"] = "Priorità"
L["Gear"] = "Equipaggiamento"
L["Profiles"] = "Profili"
L["Automation"] = "Automazione"
L["Dark"] = "Scuro"
L["Grey"] = "Grigio"
L["Light"] = "Chiaro"
L["Game"] = "Gioco"
L["Background: %s"] = "Sfondo: %s"
L["Live Preview"] = "Anteprima dal vivo"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "Il pannello vero, agganciato qui. Trascina questa finestra per spostarla; il pannello torna al suo posto quando chiudi le opzioni."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Digita /sp per i comandi slash. Trascina il pannello stesso per spostarlo."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "L'aspetto originale: pannello scuro e piatto con barre colorate."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Niente barre. Una riga colorata per statistica: 'Maestria: 285 - 10.65%'."
L["Thin headerless bars for a small footprint."] = "Barre sottili senza intestazioni, per occupare poco spazio."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Trame Blizzard e bordo da suggerimento, in tinta con l'interfaccia predefinita."
L["No background or border at all - just floating text and bars."] = "Nessuno sfondo né bordo - solo testo e barre fluttuanti."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Testo monocromatico minuscolo, senza sfondo. Se ne sta discreto in un angolo."
L["High-contrast glow bars on near-black, with a value gradient."] = "Barre luminose ad alto contrasto su quasi nero, con sfumatura in base al valore."
L["Warm parchment and gold, in keeping with the default UI art."] = "Pergamena calda e oro, in linea con la grafica dell'interfaccia predefinita."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Impostazione difensiva: armatura, schivata, parata, blocco ed elusione in cima."
L["Big live speed readout with your session record, and little else."] = "Grande lettura della velocità dal vivo con il record della sessione, e poco altro."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Statistiche secondarie, livello oggetto ed entrambe le latenze: ciò che si controlla prima di un pull."
L["Cold blues and whites on deep navy."] = "Blu freddi e bianchi su blu notte profondo."
L["Warm reds and ambers on charcoal."] = "Rossi caldi e ambre su antracite."
L["Every bar takes your class color. Clean and unfussy."] = "Ogni barra assume il colore della tua classe. Pulito e senza fronzoli."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Testo grande, spesso e ad alto contrasto. Leggibile a colpo d'occhio."
L["The smallest useful readout: four secondaries, nothing else."] = "La lettura utile più piccola: quattro statistiche secondarie e nulla più."
L["Green-on-black monospace, like a console readout."] = "Verde su nero a spaziatura fissa, come una console."
L["Throughput stats plus leech, with your primary attribute on top."] = "Statistiche di resa più sanguisuga, con il tuo attributo primario in cima."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Versatilità per prima, con elusione, schivata e velocità accanto."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "In tinta con ElvUI: pannello scuro e piatto, bordo nero da 1 px, carattere stretto."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "Il noto stile trasparente di ElvUI: vetro quasi nero, bordo sottilissimo."
L["preset hook failed: %s"] = "hook della preimpostazione fallito: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "comandi:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - apri le opzioni"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - mostra o nascondi il pannello"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - blocca o sblocca il trascinamento"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - riporta il pannello al centro"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <nome>|r - applica una preimpostazione (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <nome>|r - cambia profilo"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - mostra e azzera il record di velocità della sessione"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - mostra o nascondi il pulsante della minimappa"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - controlla incantamenti, alloggiamenti e livello oggetto"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [canale]|r - annuncia il tuo equipaggiamento in chat"
L["panel shown."] = "pannello mostrato."
L["panel hidden."] = "pannello nascosto."
L["panel locked."] = "pannello bloccato."
L["panel unlocked."] = "pannello sbloccato."
L["position reset."] = "posizione reimpostata."
L["applied the '%s' preset."] = "preimpostazione '%s' applicata."
L["unknown preset. Available: %s"] = "preimpostazione sconosciuta. Disponibili: %s"
L["switched to profile '%s'."] = "passato al profilo '%s'."
L["profiles: %s"] = "profili: %s"
L["session speed record cleared."] = "record di velocità della sessione azzerato."
L["minimap button hidden."] = "pulsante della minimappa nascosto."
L["minimap button shown."] = "pulsante della minimappa mostrato."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Attributo primario"
L["Armor DR"] = "Riduzione armatura"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Crit"
L["Haste"] = "Celer."
L["Mast"] = "Maest."
L["Vers"] = "Vers."

L["a display setting could not be applied (%s)."] = "non è stato possibile applicare un'impostazione di visualizzazione (%s)."
L["The game protects this value; see the panel itself."] = "Il gioco protegge questo valore; guarda il pannello stesso."
L["Value"] = "Valore"
L["Rating"] = "Valutazione"
L["Yards/sec"] = "Metri/sec"
L["Session peak"] = "Record della sessione"
L["Attribute"] = "Attributo"
L["Drag to move  |  /sp for options"] = "Trascina per spostare  |  /sp per le opzioni"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Forza"
L["Agility"] = "Agilità"
L["Stamina"] = "Vigore"
L["Intellect"] = "Intelletto"
L["Mastery"] = "Maestria"
L["Versatility"] = "Versatilità"
L["Dodge"] = "Schivata"
L["Parry"] = "Parata"
L["Block"] = "Blocco"
L["Leech"] = "Sanguisuga"
L["Avoidance"] = "Elusione"
L["Speed"] = "Velocità"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "Mostra o nascondi il pannello"
L["Open the options"] = "Apri le opzioni"
L["Lock or unlock the panel"] = "Blocca o sblocca il pannello"
L["Switch to the next profile"] = "Passa al profilo successivo"
L["Run the gear audit"] = "Esegui il controllo dell'equipaggiamento"
L["only one profile exists."] = "esiste un solo profilo."

-- Diagnostics.lua
L["yes"] = "sì"
L["no"] = "no"
L["LibStub not present"] = "LibStub non presente"
L["absent"] = "assente"
L["present (revision %s)"] = "presente (revisione %s)"
L["not present in this client"] = "non presente in questo client"
L["present, could not sample"] = "presente, impossibile verificare"
L["active (crit chance is protected)"] = "attivo (la probabilità di critico è protetta)"
L["present but crit chance is readable"] = "presente ma la probabilità di critico è leggibile"
L["Locale"] = "Lingua"
L["Class"] = "Classe"
L["Secret values"] = "Valori protetti"
L["Profiles stored"] = "Profili salvati"
L["Custom stat priority"] = "Priorità delle statistiche personalizzata"
L["enabled"] = "attivo"
L["disabled"] = "disattivato"
L["locked"] = "bloccato"
L["unlocked"] = "sbloccato"
L["auto width"] = "larghezza automatica"
L["width %d"] = "larghezza %d"
L["Position"] = "Posizione"
L[" (substituted: not readable in this locale)"] = " (sostituito: non leggibile in questa lingua)"
L["Stat rows"] = "Righe delle statistiche"
L["%d shown of %d placed"] = "%d mostrate su %d collocate"
L["StatPanel diagnostics"] = "Diagnostica di StatPanel"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "Ctrl-A per selezionare tutto, Ctrl-C per copiare. Incolla questo nella tua segnalazione."

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "aggiornato a %s. Novità di questa versione:"
L["  Full changelog: %s"] = "  Elenco completo delle modifiche: %s"
L["Updated for World of Warcraft patch 12.1.0."] = "Aggiornato per la patch 12.1.0 di World of Warcraft."
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "Scorciatoie da tastiera per mostrare, bloccare, cambiare profilo e controllare l'equipaggiamento."
L["New stats: attack power, spell power, health, mana and stagger."] = "Nuove statistiche: potere d'attacco, potere magico, salute, mana e barcollamento."
L["The $per token shows what one percent of a stat costs in rating."] = "Il token $per mostra quanto costa in punteggio un uno per cento di una statistica."
L["Gear durability and repair cost can now sit in the footer."] = "La durabilità dell'equipaggiamento e il costo di riparazione possono ora comparire nel piè di pagina."
L["A Colorblind Safe preset, and precise X/Y position controls."] = "Un preset adatto al daltonismo e controlli precisi di posizione X/Y."
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug raccoglie tutto ciò che serve a una segnalazione in un riquadro copiabile."

-- Options.lua: anchor points and position
L["Top left"] = "In alto a sinistra"
L["Top"] = "In alto"
L["Top right"] = "In alto a destra"
L["Bottom left"] = "In basso a sinistra"
L["Bottom"] = "In basso"
L["Bottom right"] = "In basso a destra"
L["Anchor point"] = "Punto di ancoraggio"
L["Which corner of the panel the position below is measured from."] = "Da quale angolo del pannello viene misurata la posizione qui sotto."
L["Anchored to screen"] = "Ancorato allo schermo"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "A quale punto dello schermo viene misurata. Ancorare a un angolo mantiene lì il pannello quando cambia la risoluzione."
L["Horizontal position"] = "Posizione orizzontale"
L["Vertical position"] = "Posizione verticale"
L[" (not readable in this language)"] = " (non leggibile in questa lingua)"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "Durabilità più bassa dell'equipaggiamento"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "La peggiore durabilità fra gli slot equipaggiati, così vedi il pezzo rovinato e non una media."
L["Repair cost"] = "Costo di riparazione"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "Il gioco può calcolare una riparazione solo da un mercante, quindi non mostra nulla finché non ne consulti uno."
L["Durability format"] = "Formato della durabilità"
L["Durability considered good"] = "Durabilità considerata buona"
L["Durability considered poor"] = "Durabilità considerata scarsa"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "Palette Okabe-Ito, leggibile con daltonismo rosso-verde. Con numeri di ordine."

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - mostra la diagnostica da incollare in una segnalazione"
L["diagnostics:"] = "diagnostica:"

-- StatPanel.lua: new stat names
L["Attack Power"] = "Potere d'attacco"
L["Spell Power"] = "Potere magico"
L["Health"] = "Salute"
L["Mana"] = "Mana"
L["Stagger"] = "Barcollamento"
