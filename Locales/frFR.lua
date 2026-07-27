-- Locales/frFR.lua (French)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export frFR`, then
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
--     French too if a global ever disappears.
--
-- NOT REVIEWED BY A NATIVE SPEAKER. Terminology follows the French client's own
-- wording where it exists, but corrections are very welcome -- please open an
-- issue at https://github.com/chrisdfennell/StatPanel/issues.

local _, SP = ...
local L = SP.Locale("frFR")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Afficher uniquement dans ma discussion"
L["Say"] = "Dire"
L["Party"] = "Groupe"
L["Raid"] = "Raid"
L["Instance"] = "Instance"
L["Guild"] = "Guilde"
L["Officer"] = "Officier"
L["Yell"] = "Crier"
L["Whisper"] = "Chuchoter"
L["iLvl %.2f (%.2f overall)"] = "NvO %.2f (%.2f au total)"
L["iLvl %.2f"] = "NvO %.2f"
L["priority %s"] = "priorité %s"
L["peak speed %.0f%%"] = "vitesse maximale %.0f%%"
L["%d missing enchant(s)"] = "%d enchantement(s) manquant(s)"
L["%d empty socket(s)"] = "%d châsse(s) vide(s)"
L["%d/%d tier set"] = "%d/%d panoplie"
L["You aren't in a group."] = "Vous n'êtes pas dans un groupe."
L["You aren't in a raid."] = "Vous n'êtes pas dans un raid."
L["You aren't in a guild."] = "Vous n'êtes pas dans une guilde."
L["hold on - you can announce again in %.0f seconds."] = "un instant - vous pourrez annoncer à nouveau dans %.0f secondes."
L["nothing to announce - enable some fields on the Announce page."] = "rien à annoncer - activez des champs sur la page Annonce."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d valeur(s) omise(s) : le jeu protège ces statistiques, elles ne peuvent pas être envoyées dans la discussion."
L["%s Showing it here instead:"] = "%s Affichage ici à la place :"
L["whisper needs a name: /sp announce whisper <name>"] = "le chuchotement nécessite un nom : /sp announce whisper <nom>"
L["the game refused to send that message. Showing it here instead:"] = "le jeu a refusé d'envoyer ce message. Affichage ici à la place :"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Monde ouvert"
L["Delve"] = "Gouffre"
L["Dungeon"] = "Donjon"
L["Mythic+ dungeon"] = "Donjon Mythique+"
L["Arena"] = "Arène"
L["Battleground"] = "Champ de bataille"
L["Scenario"] = "Scénario"
L["switched to profile '%s' (%s rule)."] = "profil '%s' activé (règle : %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Niveau d'objet"
L["FPS"] = "FPS"
L["Spec"] = "Spécialisation"
L["Profile"] = "Profil"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Clic gauche|r  ouvrir les options"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Clic droit|r  menu rapide"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  NvO %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "Le nom du profil ne peut pas être vide."
L["A profile named '%s' already exists."] = "Un profil nommé '%s' existe déjà."
L["The Default profile cannot be deleted."] = "Le profil par défaut ne peut pas être supprimé."
L["No such profile."] = "Ce profil n'existe pas."
L["Nothing to import."] = "Rien à importer."
L["That import string is too large to be a profile."] = "Cette chaîne d'import est trop volumineuse pour être un profil."
L["That doesn't look like a StatPanel export string."] = "Cela ne ressemble pas à une chaîne d'export StatPanel."
L["The import string is corrupt."] = "La chaîne d'import est corrompue."
L["Could not read the import string: %s"] = "Impossible de lire la chaîne d'import : %s"
L["The import string did not contain a profile."] = "La chaîne d'import ne contenait aucun profil."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "audit d'équipement"
L["empty"] = "vide"
L["no enchant"] = "pas d'enchantement"
L["%d rare gem(s)"] = "%d gemme(s) rare(s)"
L["lowest"] = "le plus bas"
L["Equipped"] = "Équipé"
L["Tier set    %d/%d"] = "Panoplie    %d/%d"
L["%d item(s) not fully upgraded"] = "%d objet(s) pas entièrement amélioré(s)"
L["Everything is enchanted and socketed."] = "Tout est enchanté et serti."
L["%d enchant(s)"] = "%d enchantement(s)"
L["%d socket(s)"] = "%d châsse(s)"
L["%d empty slot(s)"] = "%d emplacement(s) vide(s)"
L["Missing: %s"] = "Manquant : %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Tête"
L["Neck"] = "Cou"
L["Shoulder"] = "Épaules"
L["Back"] = "Dos"
L["Chest"] = "Torse"
L["Wrist"] = "Poignets"
L["Hands"] = "Mains"
L["Waist"] = "Taille"
L["Legs"] = "Jambes"
L["Feet"] = "Pieds"
L["Ring 1"] = "Anneau 1"
L["Ring 2"] = "Anneau 2"
L["Trinket 1"] = "Bijou 1"
L["Trinket 2"] = "Bijou 2"
L["Main Hand"] = "Main droite"
L["Off Hand"] = "Main gauche"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Aucun"
L["Outline"] = "Contour"
L["Thick Outline"] = "Contour épais"
L["Monochrome"] = "Monochrome"
L["Monochrome Outline"] = "Contour monochrome"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Afficher le panneau"
L["Lock position"] = "Verrouiller la position"
L["Show FPS"] = "Afficher les FPS"
L["Apply preset"] = "Appliquer un préréglage"
L["Announce to"] = "Annoncer dans"
L["Audit my gear"] = "Auditer mon équipement"
L["Open options"] = "Ouvrir les options"
L["Reset position"] = "Réinitialiser la position"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Gauche"
L["Center"] = "Centré"
L["Right"] = "Droite"
L["Proportional to value"] = "Proportionnelle à la valeur"
L["Always full"] = "Toujours pleine"
L["No fill (text only)"] = "Sans remplissage (texte seul)"
L["Per-stat colors"] = "Couleurs par statistique"
L["Class color"] = "Couleur de classe"
L["Single color"] = "Couleur unique"
L["Value gradient"] = "Dégradé selon la valeur"
L["Bars"] = "Barres"
L["Text only"] = "Texte seul"
L["Player name"] = "Nom du joueur"
L["Specialization"] = "Spécialisation"
L["Custom text"] = "Texte personnalisé"
L["Hidden"] = "Masqué"
L["Total effect (character sheet)"] = "Effet total (feuille de personnage)"
L["Bonus from rating only"] = "Bonus du score uniquement"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Panneau"
L["Enable StatPanel"] = "Activer StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "Interrupteur principal. Le désactiver masque entièrement le panneau."
L["Stops the panel from being dragged."] = "Empêche le déplacement du panneau."
L["Keep on screen"] = "Garder à l'écran"
L["Prevents dragging the panel off the edge of the screen."] = "Empêche de faire glisser le panneau hors de l'écran."
L["Scale"] = "Échelle"
L["Opacity"] = "Opacité"
L["Frame layer"] = "Couche d'affichage"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "La couche sur laquelle le panneau est dessiné. Augmentez-la si un autre addon recouvre le panneau."
L["Update interval (seconds)"] = "Intervalle de rafraîchissement (secondes)"
L["How often values refresh. Higher values use less CPU."] = "Fréquence de rafraîchissement des valeurs. Une valeur plus élevée consomme moins de CPU."
L["Stat values show"] = "Les valeurs affichent"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "L'effet total correspond à la feuille de personnage. Le bonus du score n'affiche que ce qu'apporte le score de votre équipement."
L["Visibility"] = "Visibilité"
L["Hide during combat"] = "Masquer en combat"
L["Turning this on clears 'Show only during combat'."] = "Activer cette option désactive « Afficher uniquement en combat »."
L["Show only during combat"] = "Afficher uniquement en combat"
L["Turning this on clears 'Hide during combat'."] = "Activer cette option désactive « Masquer en combat »."
L["Hide while dead"] = "Masquer quand vous êtes mort"
L["Hide in vehicles"] = "Masquer dans les véhicules"
L["Hide in pet battles"] = "Masquer dans les combats de mascottes"
L["Hide inside instances"] = "Masquer dans les instances"
L["Turning this on clears 'Hide outside instances'."] = "Activer cette option désactive « Masquer hors des instances »."
L["Hide outside instances"] = "Masquer hors des instances"
L["Turning this on clears 'Hide inside instances'."] = "Activer cette option désactive « Masquer dans les instances »."
L["Mouseover fade"] = "Fondu au survol"
L["Only show on mouseover"] = "Afficher uniquement au survol"
L["Fades the panel out until you hover over it."] = "Estompe le panneau jusqu'à ce que vous le surviez avec la souris."
L["Faded opacity"] = "Opacité estompée"
L["Fade duration (seconds)"] = "Durée du fondu (secondes)"
L["Show tooltips on hover"] = "Afficher les infobulles au survol"
L["Minimap and options"] = "Minicarte et options"
L["Show the minimap button"] = "Afficher le bouton de minicarte"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "Le clic gauche ouvre ces options, le clic droit ouvre le menu rapide. Faites-le glisser le long du bord de la minicarte."
L["Show a live preview while configuring"] = "Afficher un aperçu en direct pendant la configuration"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Ancre le vrai panneau à côté de cette fenêtre pour voir les changements au fur et à mesure."
L["Reset peak speed"] = "Réinitialiser la vitesse maximale"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Taille"
L["Auto-size width to content"] = "Ajuster la largeur au contenu"
L["Grows and shrinks the panel to fit the widest row."] = "Agrandit et réduit le panneau pour l'adapter à la ligne la plus large."
L["Width"] = "Largeur"
L["Minimum width (auto-size)"] = "Largeur minimale (ajustement auto)"
L["Side padding"] = "Marge latérale"
L["Top padding"] = "Marge supérieure"
L["Bottom padding"] = "Marge inférieure"
L["Gap between sections"] = "Espace entre les sections"
L["Section header spacing"] = "Espacement des en-têtes de section"
L["Set to 0 to remove section headers entirely."] = "Mettez 0 pour supprimer entièrement les en-têtes de section."
L["Background"] = "Arrière-plan"
L["Background texture"] = "Texture d'arrière-plan"
L["Background color and transparency"] = "Couleur et transparence de l'arrière-plan"
L["Tile the background"] = "Répéter l'arrière-plan"
L["Tile size"] = "Taille du motif"
L["Border"] = "Bordure"
L["Border style"] = "Style de bordure"
L["Border color and transparency"] = "Couleur et transparence de la bordure"
L["Border thickness"] = "Épaisseur de la bordure"
L["Only affects pixel-style borders; textured borders use their own size."] = "N'affecte que les bordures de style pixel ; les bordures texturées utilisent leur propre taille."
L["Border inset"] = "Retrait de la bordure"
L["Title"] = "Titre"
L["Show title"] = "Afficher le titre"
L["Title shows"] = "Le titre affiche"
L["Title alignment"] = "Alignement du titre"
L["Item level format"] = "Format du niveau d'objet"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Jetons : $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Jetons : $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Décimales du niveau d'objet"
L["Custom title text"] = "Texte de titre personnalisé"
L["Divider"] = "Séparateur"
L["Show divider under title"] = "Afficher un séparateur sous le titre"
L["Divider color"] = "Couleur du séparateur"
L["Divider thickness"] = "Épaisseur du séparateur"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Style de ligne"
L["Draw rows as"] = "Dessiner les lignes en"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "Les barres dessinent une jauge par statistique. Texte seul dessine une seule ligne colorée par statistique."
L["Text alignment (text style)"] = "Alignement du texte (style texte)"
L["Label/value separator (text style)"] = "Séparateur nom/valeur (style texte)"
L["Placed between the stat name and its value, e.g. ': '"] = "Placé entre le nom de la statistique et sa valeur, par ex. « : »"
L["Line height (text style)"] = "Hauteur de ligne (style texte)"
L["Bar appearance"] = "Apparence des barres"
L["Bar texture"] = "Texture des barres"
L["Bar height"] = "Hauteur des barres"
L["Space between bars"] = "Espace entre les barres"
L["Horizontal inset"] = "Retrait horizontal"
L["Bar opacity"] = "Opacité des barres"
L["Fill from the right"] = "Remplir depuis la droite"
L["Bar colors"] = "Couleurs des barres"
L["Color mode"] = "Mode de couleur"
L["Per-stat colors are set on the Stats page."] = "Les couleurs par statistique se règlent sur la page Statistiques."
L["Gradient: low value"] = "Dégradé : valeur basse"
L["Gradient: high value"] = "Dégradé : valeur haute"
L["Bar background"] = "Fond des barres"
L["Track texture"] = "Texture de la glissière"
L["Track color and transparency"] = "Couleur et transparence de la glissière"
L["Tint track with the stat color"] = "Teinter la glissière avec la couleur de la statistique"
L["Track tint opacity"] = "Opacité de la teinte de la glissière"
L["Bar border"] = "Bordure des barres"
L["Border color"] = "Couleur de la bordure"
L["Motion"] = "Animation"
L["Animate value changes"] = "Animer les changements de valeur"
L["Eases bars toward new values instead of snapping."] = "Fait glisser les barres vers les nouvelles valeurs au lieu de sauter."
L["Animation speed"] = "Vitesse d'animation"
L["Show a spark at the fill edge"] = "Afficher une étincelle au bord du remplissage"
L["Spark color"] = "Couleur de l'étincelle"
L["Row text"] = "Texte des lignes"
L["Show stat names"] = "Afficher les noms des statistiques"
L["Show values"] = "Afficher les valeurs"
L["Color names with the stat color"] = "Colorer les noms avec la couleur de la statistique"
L["Color values with the stat color"] = "Colorer les valeurs avec la couleur de la statistique"
L["Number prioritized stats"] = "Numéroter les statistiques prioritaires"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Préfixe les statistiques d'une section triée par priorité avec 1, 2, 3..."
L["Numbering format"] = "Format de numérotation"
L["Name offset"] = "Décalage du nom"
L["Value offset"] = "Décalage de la valeur"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "En-tête de section"
L["Stat name"] = "Nom de la statistique"
L["Stat value"] = "Valeur de la statistique"
L["Priority line"] = "Ligne de priorité"
L["Footer"] = "Pied de page"
L["Font"] = "Police"
L["Font face (all text)"] = "Police (tout le texte)"
L["Drop shadow"] = "Ombre portée"
L["Shadow color"] = "Couleur de l'ombre"
L["Shadow X offset"] = "Décalage X de l'ombre"
L["Shadow Y offset"] = "Décalage Y de l'ombre"
L["Per-element size and color"] = "Taille et couleur par élément"
L["Editing"] = "Modification"
L["Color"] = "Couleur"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "Les couleurs du nom et de la valeur sont remplacées lorsque la coloration par la couleur de la statistique est activée sur la page Lignes et barres."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Réglages par statistique"
L["Editing stat"] = "Statistique modifiée"
L["Show this stat"] = "Afficher cette statistique"
L["Stat color"] = "Couleur de la statistique"
L["Use class color for this stat"] = "Utiliser la couleur de classe pour cette statistique"
L["Display name (blank for default)"] = "Nom affiché (vide pour la valeur par défaut)"
L["Value format"] = "Format de la valeur"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Jetons : $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExemple : '$rating - $value%' affiche '285 - 10.65%'."
L["Decimal places"] = "Nombre de décimales"
L["Bar scale"] = "Échelle des barres"
L["Bar fill"] = "Remplissage des barres"
L["Value at a full bar"] = "Valeur pour une barre pleine"
L["Grow the scale automatically"] = "Augmenter l'échelle automatiquement"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Augmente la valeur de barre pleine dès que la statistique la dépasse. Utile pour la Vitesse, qui n'a pas de plafond en vol dracothrope."
L["Reset all stats"] = "Réinitialiser toutes les statistiques"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Sections"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "Les sections sont dessinées de haut en bas dans cet ordre. Chacune peut contenir les statistiques de votre choix."
L["Editing section"] = "Section modifiée"
L["Section title"] = "Titre de la section"
L["Show this section"] = "Afficher cette section"
L["Show the section header"] = "Afficher l'en-tête de la section"
L["Order by spec stat priority"] = "Trier selon la priorité de la spécialisation"
L["Re-sorts this section's stats to match your specialization's priority."] = "Retrie les statistiques de cette section selon la priorité de votre spécialisation."
L["Header alignment"] = "Alignement de l'en-tête"
L["Move section up"] = "Monter la section"
L["Move section down"] = "Descendre la section"
L["Stats in this section"] = "Statistiques de cette section"
L["Up"] = "Monter"
L["Down"] = "Descendre"
L["Remove"] = "Retirer"
L["Add a stat to this section"] = "Ajouter une statistique à cette section"
L["(every stat is already here)"] = "(toutes les statistiques sont déjà présentes)"
L["Reset sections"] = "Réinitialiser les sections"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Ligne de pied de page"
L["Show the footer"] = "Afficher le pied de page"
L["Frames per second"] = "Images par seconde"
L["Home latency"] = "Latence locale"
L["World latency"] = "Latence monde"
L["Addon memory use"] = "Mémoire utilisée par l'addon"
L["Separator between entries"] = "Séparateur entre les entrées"
L["Formats"] = "Formats"
L["FPS format"] = "Format des FPS"
L["Home latency format"] = "Format de la latence locale"
L["World latency format"] = "Format de la latence monde"
L["Memory format"] = "Format de la mémoire"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Ces champs utilisent les formats numériques standard : %d pour un entier, %.1f pour une décimale."
L["Performance coloring"] = "Coloration selon les performances"
L["Color by performance"] = "Colorer selon les performances"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Colore les FPS et la latence en vert, jaune ou rouge selon les seuils ci-dessous."
L["Good"] = "Bon"
L["Fair"] = "Moyen"
L["Poor"] = "Mauvais"
L["FPS considered good"] = "FPS considérés comme bons"
L["FPS considered poor"] = "FPS considérés comme mauvais"
L["Latency considered good (ms)"] = "Latence considérée comme bonne (ms)"
L["Latency considered poor (ms)"] = "Latence considérée comme mauvaise (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Afficher la chaîne de priorité"
L["Separator"] = "Séparateur"
L["Color each stat name"] = "Colorer chaque nom de statistique"
L["Prefix with the spec name"] = "Préfixer avec le nom de la spécialisation"
L["Priority for your current spec"] = "Priorité pour votre spécialisation actuelle"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "L'ordre intégré est une base générique. Simulez votre propre personnage pour obtenir la réponse fiable, puis renseignez-la ici."
L["Current specialization: %s"] = "Spécialisation actuelle : %s"
L["unknown"] = "inconnue"
L["Priority %d"] = "Priorité %d"
L["Paste a stat weight string"] = "Coller une chaîne de poids de statistiques"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Collez une chaîne Pawn (depuis Raidbots, une simulation ou un site de statistiques) ou un simple ordre tel que 'Mastery > Haste > Crit > Versatility'. StatPanel lit les quatre statistiques secondaires et définit l'ordre pour votre spécialisation actuelle."
L["Weights or order"] = "Poids ou ordre"
L["Apply pasted weights"] = "Appliquer les poids collés"
L["no active specialization to apply to."] = "aucune spécialisation active à laquelle appliquer cela."
L["priority for %s set to %s."] = "priorité pour %s définie sur %s."
L["your spec"] = "votre spécialisation"
L["Use the built-in order"] = "Utiliser l'ordre intégré"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Préréglages"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Un préréglage écrase les réglages d'apparence du profil actuel. Votre position, vos règles de visibilité et vos profils ne sont pas touchés."
L["Start over"] = "Recommencer"
L["Reset this profile"] = "Réinitialiser ce profil"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Chaque personnage retient le profil qu'il utilise : vous pouvez partager une apparence entre vos rerolls ou en donner une à chacun."
L["Active profile"] = "Profil actif"
L["New profile name"] = "Nom du nouveau profil"
L["Create"] = "Créer"
L["Copy current"] = "Copier l'actuel"
L["Delete current"] = "Supprimer l'actuel"
L["Deleted profile '%s'."] = "Profil '%s' supprimé."
L["Share"] = "Partager"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "L'export produit une chaîne que vous pouvez transmettre. L'import écrase le profil nommé ci-dessous, ou le profil actif si vous laissez le champ vide."
L["Export string"] = "Chaîne d'export"
L["Generate export"] = "Générer l'export"
L["Import string"] = "Chaîne d'import"
L["Import into profile (blank = active)"] = "Importer dans le profil (vide = actif)"
L["Import"] = "Importer"
L["Imported into profile '%s'."] = "Importé dans le profil '%s'."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Annonce"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Envoie un résumé de votre équipement dans la discussion. Rien n'est jamais envoyé automatiquement - uniquement via le bouton, la commande slash ou le menu contextuel."
L["Send to"] = "Envoyer à"
L["Whisper to (for the Whisper channel)"] = "Chuchoter à (pour le canal Chuchotement)"
L["Prefix"] = "Préfixe"
L["Include"] = "Inclure"
L["Stats"] = "Statistiques"
L["Stat priority"] = "Priorité des statistiques"
L["Session peak speed"] = "Vitesse maximale de la session"
L["Missing enchants and sockets"] = "Enchantements et châsses manquants"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "Le jeu protège la plupart des statistiques de combat et n'autorise aucun addon à les envoyer dans la discussion : elles sont donc omises automatiquement. Le niveau d'objet, la spécialisation, la vitesse et les alertes d'équipement passent sans problème. Si un futur correctif retire cette protection, la statistique apparaîtra sans aucune modification."
L["Preview"] = "Aperçu"
L["Announce now"] = "Annoncer maintenant"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Équipement porté"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "Les données d'objet ne sont pas protégées par le jeu : contrairement aux statistiques de combat, elles peuvent être lues intégralement."
L["Refresh"] = "Actualiser"
L["Print report"] = "Afficher le rapport"
L["Average equipped item level %.2f.%s  %s"] = "Niveau d'objet moyen porté %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Panoplie %d/%d."
L["Nothing missing."] = "Rien ne manque."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(aucune règle)"
L["Automatic profile switching"] = "Changement automatique de profil"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "Les règles sont enregistrées par personnage. Une règle de contenu l'emporte sur une règle de spécialisation : vous pouvez conserver un profil de spécialisation en général et en imposer un autre en raid. Tout ce qui reste sur « (aucune règle) » est ignoré."
L["Switch profiles automatically"] = "Changer de profil automatiquement"
L["By content"] = "Par contenu"
L["By specialization"] = "Par spécialisation"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "Seule votre spécialisation actuelle est listée. Changez de spécialisation et revenez pour définir une règle pour une autre."
L["Profile for this specialization"] = "Profil pour cette spécialisation"
L["Apply rules now"] = "Appliquer les règles maintenant"
L["no rule matches your current spec or location."] = "aucune règle ne correspond à votre spécialisation ou à votre position actuelle."
L["already on '%s', the profile your rules call for."] = "déjà sur '%s', le profil demandé par vos règles."
L["Clear all rules"] = "Effacer toutes les règles"
L["cleared this character's automatic rules."] = "règles automatiques de ce personnage effacées."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "Général"
L["Rows & Bars"] = "Lignes et barres"
L["Fonts"] = "Polices"
L["Priority"] = "Priorité"
L["Gear"] = "Équipement"
L["Profiles"] = "Profils"
L["Automation"] = "Automatisation"
L["Dark"] = "Sombre"
L["Grey"] = "Gris"
L["Light"] = "Clair"
L["Game"] = "Jeu"
L["Background: %s"] = "Arrière-plan : %s"
L["Live Preview"] = "Aperçu en direct"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "Le vrai panneau, ancré ici. Faites glisser cette fenêtre pour la déplacer ; le panneau reprend sa place quand vous fermez les options."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Tapez /sp pour les commandes slash. Faites glisser le panneau lui-même pour le déplacer."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "L'apparence d'origine : panneau sombre et plat avec des barres colorées."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Pas de barres. Une ligne colorée par statistique : 'Maîtrise : 285 - 10.65%'."
L["Thin headerless bars for a small footprint."] = "Barres fines sans en-tête, pour un encombrement minimal."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Textures Blizzard et bordure d'infobulle, pour s'accorder à l'interface par défaut."
L["No background or border at all - just floating text and bars."] = "Ni arrière-plan ni bordure - juste du texte et des barres flottantes."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Texte monochrome minuscule, sans arrière-plan. Se fait oublier dans un coin."
L["High-contrast glow bars on near-black, with a value gradient."] = "Barres lumineuses très contrastées sur fond presque noir, avec un dégradé selon la valeur."
L["Warm parchment and gold, in keeping with the default UI art."] = "Parchemin chaud et or, dans l'esprit graphique de l'interface par défaut."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Orientation défensive : armure, esquive, parade, blocage et évitement en tête."
L["Big live speed readout with your session record, and little else."] = "Grand affichage de la vitesse en direct avec votre record de session, et peu d'autre chose."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Statistiques secondaires, niveau d'objet et les deux latences - ce que l'on vérifie avant un pull."
L["Cold blues and whites on deep navy."] = "Bleus froids et blancs sur bleu marine profond."
L["Warm reds and ambers on charcoal."] = "Rouges chauds et ambres sur anthracite."
L["Every bar takes your class color. Clean and unfussy."] = "Chaque barre prend la couleur de votre classe. Net et sans fioritures."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Texte large, gras et très contrasté. Lisible d'un coup d'œil."
L["The smallest useful readout: four secondaries, nothing else."] = "Le plus petit affichage utile : quatre statistiques secondaires, rien d'autre."
L["Green-on-black monospace, like a console readout."] = "Vert sur noir en chasse fixe, comme une console."
L["Throughput stats plus leech, with your primary attribute on top."] = "Statistiques de rendement plus ponction, avec votre attribut principal en tête."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Polyvalence en premier, accompagnée d'évitement, d'esquive et de vitesse."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "Assorti à ElvUI : panneau sombre et plat, bordure noire de 1 px, police étroite."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "Le style ElvUI transparent bien connu : verre presque noir, bordure très fine."
L["preset hook failed: %s"] = "échec du hook de préréglage : %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "commandes :"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - ouvrir les options"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - afficher ou masquer le panneau"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - verrouiller ou déverrouiller le déplacement"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - ramener le panneau au centre"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <nom>|r - appliquer un préréglage (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <nom>|r - changer de profil"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - afficher et réinitialiser le record de vitesse de la session"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - afficher ou masquer le bouton de minicarte"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - auditer enchantements, châsses et niveau d'objet"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [canal]|r - annoncer votre équipement dans la discussion"
L["panel shown."] = "panneau affiché."
L["panel hidden."] = "panneau masqué."
L["panel locked."] = "panneau verrouillé."
L["panel unlocked."] = "panneau déverrouillé."
L["position reset."] = "position réinitialisée."
L["applied the '%s' preset."] = "préréglage '%s' appliqué."
L["unknown preset. Available: %s"] = "préréglage inconnu. Disponibles : %s"
L["switched to profile '%s'."] = "profil '%s' activé."
L["profiles: %s"] = "profils : %s"
L["session speed record cleared."] = "record de vitesse de la session réinitialisé."
L["minimap button hidden."] = "bouton de minicarte masqué."
L["minimap button shown."] = "bouton de minicarte affiché."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Attribut principal"
L["Armor DR"] = "Réduction armure"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Crit"
L["Haste"] = "Hâte"
L["Mast"] = "Maît."
L["Vers"] = "Polyv."

L["a display setting could not be applied (%s)."] = "un réglage d'affichage n'a pas pu être appliqué (%s)."
L["The game protects this value; see the panel itself."] = "Le jeu protège cette valeur ; consultez le panneau lui-même."
L["Value"] = "Valeur"
L["Rating"] = "Score"
L["Yards/sec"] = "Mètres/sec"
L["Session peak"] = "Record de la session"
L["Attribute"] = "Attribut"
L["Drag to move  |  /sp for options"] = "Glisser pour déplacer  |  /sp pour les options"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Force"
L["Agility"] = "Agilité"
L["Stamina"] = "Endurance"
L["Intellect"] = "Intelligence"
L["Mastery"] = "Maîtrise"
L["Versatility"] = "Polyvalence"
L["Dodge"] = "Esquive"
L["Parry"] = "Parade"
L["Block"] = "Blocage"
L["Leech"] = "Ponction"
L["Avoidance"] = "Évitement"
L["Speed"] = "Vitesse"
