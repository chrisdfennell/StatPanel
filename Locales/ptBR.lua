-- Locales/ptBR.lua (Portuguese, Brazil)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export ptBR`, then
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
--     Portuguese too if a global ever disappears.
--
-- NOT REVIEWED BY A NATIVE SPEAKER. Terminology follows the Brazilian client's
-- own wording where it exists, but corrections are very welcome -- please open
-- an issue at https://github.com/chrisdfennell/StatPanel/issues.

local _, SP = ...
local L = SP.Locale("ptBR")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Exibir somente no meu bate-papo"
L["Say"] = "Falar"
L["Party"] = "Grupo"
L["Raid"] = "Raide"
L["Instance"] = "Instância"
L["Guild"] = "Guilda"
L["Officer"] = "Oficial"
L["Yell"] = "Gritar"
L["Whisper"] = "Sussurrar"
L["iLvl %.2f (%.2f overall)"] = "NvI %.2f (%.2f total)"
L["iLvl %.2f"] = "NvI %.2f"
L["priority %s"] = "prioridade %s"
L["peak speed %.0f%%"] = "velocidade máxima %.0f%%"
L["%d missing enchant(s)"] = "%d encantamento(s) faltando"
L["%d empty socket(s)"] = "%d engaste(s) vazio(s)"
L["%d/%d tier set"] = "%d/%d conjunto de classe"
L["You aren't in a group."] = "Você não está em um grupo."
L["You aren't in a raid."] = "Você não está em um raide."
L["You aren't in a guild."] = "Você não está em uma guilda."
L["hold on - you can announce again in %.0f seconds."] = "aguarde - você poderá anunciar novamente em %.0f segundos."
L["nothing to announce - enable some fields on the Announce page."] = "nada a anunciar - ative alguns campos na página Anunciar."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d valor(es) omitido(s): o jogo protege esses atributos, portanto não podem ser enviados ao bate-papo."
L["%s Showing it here instead:"] = "%s Exibindo aqui em vez disso:"
L["whisper needs a name: /sp announce whisper <name>"] = "o sussurro precisa de um nome: /sp announce whisper <nome>"
L["the game refused to send that message. Showing it here instead:"] = "o jogo recusou o envio dessa mensagem. Exibindo aqui em vez disso:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Mundo aberto"
L["Delve"] = "Precipício"
L["Dungeon"] = "Masmorra"
L["Mythic+ dungeon"] = "Masmorra Mítica+"
L["Arena"] = "Arena"
L["Battleground"] = "Campo de Batalha"
L["Scenario"] = "Cenário"
L["switched to profile '%s' (%s rule)."] = "alterado para o perfil '%s' (regra: %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Nível de item"
L["FPS"] = "FPS"
L["Spec"] = "Especialização"
L["Profile"] = "Perfil"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Clique esquerdo|r  abrir as opções"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Clique direito|r  menu rápido"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  NvI %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "O nome do perfil não pode ficar vazio."
L["A profile named '%s' already exists."] = "Já existe um perfil chamado '%s'."
L["The Default profile cannot be deleted."] = "O perfil padrão não pode ser excluído."
L["No such profile."] = "Esse perfil não existe."
L["Nothing to import."] = "Nada a importar."
L["That import string is too large to be a profile."] = "Essa cadeia de importação é grande demais para ser um perfil."
L["That doesn't look like a StatPanel export string."] = "Isso não parece uma cadeia de exportação do StatPanel."
L["The import string is corrupt."] = "A cadeia de importação está corrompida."
L["Could not read the import string: %s"] = "Não foi possível ler a cadeia de importação: %s"
L["The import string did not contain a profile."] = "A cadeia de importação não continha nenhum perfil."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "auditoria de equipamento"
L["empty"] = "vazio"
L["no enchant"] = "sem encantamento"
L["%d rare gem(s)"] = "%d gema(s) incomum(ns)"
L["lowest"] = "o mais baixo"
L["Equipped"] = "Equipado"
L["Tier set    %d/%d"] = "Conjunto de classe    %d/%d"
L["%d item(s) not fully upgraded"] = "%d item(ns) não totalmente aprimorado(s)"
L["Everything is enchanted and socketed."] = "Tudo está encantado e engastado."
L["%d enchant(s)"] = "%d encantamento(s)"
L["%d socket(s)"] = "%d engaste(s)"
L["%d empty slot(s)"] = "%d espaço(s) vazio(s)"
L["Missing: %s"] = "Faltando: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Cabeça"
L["Neck"] = "Pescoço"
L["Shoulder"] = "Ombros"
L["Back"] = "Costas"
L["Chest"] = "Peito"
L["Wrist"] = "Pulsos"
L["Hands"] = "Mãos"
L["Waist"] = "Cintura"
L["Legs"] = "Pernas"
L["Feet"] = "Pés"
L["Ring 1"] = "Anel 1"
L["Ring 2"] = "Anel 2"
L["Trinket 1"] = "Berloque 1"
L["Trinket 2"] = "Berloque 2"
L["Main Hand"] = "Mão principal"
L["Off Hand"] = "Mão secundária"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Nenhum"
L["Outline"] = "Contorno"
L["Thick Outline"] = "Contorno grosso"
L["Monochrome"] = "Monocromático"
L["Monochrome Outline"] = "Contorno monocromático"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Exibir o painel"
L["Lock position"] = "Travar a posição"
L["Show FPS"] = "Exibir FPS"
L["Apply preset"] = "Aplicar predefinição"
L["Announce to"] = "Anunciar em"
L["Audit my gear"] = "Auditar meu equipamento"
L["Open options"] = "Abrir as opções"
L["Reset position"] = "Redefinir a posição"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Esquerda"
L["Center"] = "Centro"
L["Right"] = "Direita"
L["Proportional to value"] = "Proporcional ao valor"
L["Always full"] = "Sempre cheia"
L["No fill (text only)"] = "Sem preenchimento (somente texto)"
L["Per-stat colors"] = "Cores por atributo"
L["Class color"] = "Cor da classe"
L["Single color"] = "Cor única"
L["Value gradient"] = "Gradiente pelo valor"
L["Bars"] = "Barras"
L["Text only"] = "Somente texto"
L["Player name"] = "Nome do jogador"
L["Specialization"] = "Especialização"
L["Custom text"] = "Texto personalizado"
L["Hidden"] = "Oculto"
L["Total effect (character sheet)"] = "Efeito total (ficha do personagem)"
L["Bonus from rating only"] = "Somente o bônus do índice"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Painel"
L["Enable StatPanel"] = "Ativar o StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "Chave principal. Desativar oculta o painel por completo."
L["Stops the panel from being dragged."] = "Impede que o painel seja arrastado."
L["Keep on screen"] = "Manter na tela"
L["Prevents dragging the panel off the edge of the screen."] = "Impede arrastar o painel para fora da borda da tela."
L["Scale"] = "Escala"
L["Opacity"] = "Opacidade"
L["Frame layer"] = "Camada do quadro"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "A camada em que o painel é desenhado. Aumente-a se outro addon cobrir o painel."
L["Update interval (seconds)"] = "Intervalo de atualização (segundos)"
L["How often values refresh. Higher values use less CPU."] = "Com que frequência os valores são atualizados. Valores maiores consomem menos CPU."
L["Stat values show"] = "Os valores exibem"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "O efeito total corresponde à ficha do personagem. O bônus do índice mostra apenas o que o índice do seu equipamento contribui."
L["Visibility"] = "Visibilidade"
L["Hide during combat"] = "Ocultar em combate"
L["Turning this on clears 'Show only during combat'."] = "Ativar isto desmarca “Exibir somente em combate”."
L["Show only during combat"] = "Exibir somente em combate"
L["Turning this on clears 'Hide during combat'."] = "Ativar isto desmarca “Ocultar em combate”."
L["Hide while dead"] = "Ocultar quando morto"
L["Hide in vehicles"] = "Ocultar em veículos"
L["Hide in pet battles"] = "Ocultar em batalhas de mascotes"
L["Hide inside instances"] = "Ocultar dentro de instâncias"
L["Turning this on clears 'Hide outside instances'."] = "Ativar isto desmarca “Ocultar fora de instâncias”."
L["Hide outside instances"] = "Ocultar fora de instâncias"
L["Turning this on clears 'Hide inside instances'."] = "Ativar isto desmarca “Ocultar dentro de instâncias”."
L["Mouseover fade"] = "Esmaecer sem o cursor"
L["Only show on mouseover"] = "Exibir somente com o cursor sobre"
L["Fades the panel out until you hover over it."] = "Esmaece o painel até você passar o cursor sobre ele."
L["Faded opacity"] = "Opacidade ao esmaecer"
L["Fade duration (seconds)"] = "Duração do esmaecimento (segundos)"
L["Show tooltips on hover"] = "Exibir dicas ao passar o cursor"
L["Minimap and options"] = "Minimapa e opções"
L["Show the minimap button"] = "Exibir o botão do minimapa"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "O clique esquerdo abre estas opções e o direito abre o menu rápido. Arraste-o pela borda do minimapa."
L["Show a live preview while configuring"] = "Exibir uma prévia ao vivo durante a configuração"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Encaixa o painel real ao lado desta janela para você ver as mudanças conforme as faz."
L["Reset peak speed"] = "Redefinir a velocidade máxima"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Tamanho"
L["Auto-size width to content"] = "Ajustar a largura ao conteúdo"
L["Grows and shrinks the panel to fit the widest row."] = "Aumenta e reduz o painel para caber a linha mais larga."
L["Width"] = "Largura"
L["Minimum width (auto-size)"] = "Largura mínima (ajuste automático)"
L["Side padding"] = "Margem lateral"
L["Top padding"] = "Margem superior"
L["Bottom padding"] = "Margem inferior"
L["Gap between sections"] = "Espaço entre as seções"
L["Section header spacing"] = "Espaçamento dos cabeçalhos de seção"
L["Set to 0 to remove section headers entirely."] = "Defina 0 para remover totalmente os cabeçalhos de seção."
L["Background"] = "Plano de fundo"
L["Background texture"] = "Textura do plano de fundo"
L["Background color and transparency"] = "Cor e transparência do plano de fundo"
L["Tile the background"] = "Repetir o plano de fundo"
L["Tile size"] = "Tamanho do ladrilho"
L["Border"] = "Borda"
L["Border style"] = "Estilo da borda"
L["Border color and transparency"] = "Cor e transparência da borda"
L["Border thickness"] = "Espessura da borda"
L["Only affects pixel-style borders; textured borders use their own size."] = "Afeta apenas bordas em estilo pixel; bordas texturizadas usam o próprio tamanho."
L["Border inset"] = "Recuo da borda"
L["Title"] = "Título"
L["Show title"] = "Exibir o título"
L["Title shows"] = "O título exibe"
L["Title alignment"] = "Alinhamento do título"
L["Item level format"] = "Formato do nível de item"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Marcadores: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Marcadores: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Casas decimais do nível de item"
L["Custom title text"] = "Texto de título personalizado"
L["Divider"] = "Divisória"
L["Show divider under title"] = "Exibir uma divisória sob o título"
L["Divider color"] = "Cor da divisória"
L["Divider thickness"] = "Espessura da divisória"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Estilo das linhas"
L["Draw rows as"] = "Desenhar as linhas como"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "Barras desenham uma barra de status por atributo. Somente texto desenha uma única linha colorida por atributo."
L["Text alignment (text style)"] = "Alinhamento do texto (estilo texto)"
L["Label/value separator (text style)"] = "Separador entre nome e valor (estilo texto)"
L["Placed between the stat name and its value, e.g. ': '"] = "Colocado entre o nome do atributo e o valor, p. ex. “: ”"
L["Line height (text style)"] = "Altura da linha (estilo texto)"
L["Bar appearance"] = "Aparência das barras"
L["Bar texture"] = "Textura das barras"
L["Bar height"] = "Altura das barras"
L["Space between bars"] = "Espaço entre as barras"
L["Horizontal inset"] = "Recuo horizontal"
L["Bar opacity"] = "Opacidade das barras"
L["Fill from the right"] = "Preencher a partir da direita"
L["Bar colors"] = "Cores das barras"
L["Color mode"] = "Modo de cor"
L["Per-stat colors are set on the Stats page."] = "As cores por atributo são definidas na página Atributos."
L["Gradient: low value"] = "Gradiente: valor baixo"
L["Gradient: high value"] = "Gradiente: valor alto"
L["Bar background"] = "Fundo das barras"
L["Track texture"] = "Textura da trilha"
L["Track color and transparency"] = "Cor e transparência da trilha"
L["Tint track with the stat color"] = "Tingir a trilha com a cor do atributo"
L["Track tint opacity"] = "Opacidade do tingimento da trilha"
L["Bar border"] = "Borda das barras"
L["Border color"] = "Cor da borda"
L["Motion"] = "Movimento"
L["Animate value changes"] = "Animar as mudanças de valor"
L["Eases bars toward new values instead of snapping."] = "Desliza as barras até os novos valores em vez de saltar."
L["Animation speed"] = "Velocidade da animação"
L["Show a spark at the fill edge"] = "Exibir um brilho na borda do preenchimento"
L["Spark color"] = "Cor do brilho"
L["Row text"] = "Texto das linhas"
L["Show stat names"] = "Exibir os nomes dos atributos"
L["Show values"] = "Exibir os valores"
L["Color names with the stat color"] = "Colorir os nomes com a cor do atributo"
L["Color values with the stat color"] = "Colorir os valores com a cor do atributo"
L["Number prioritized stats"] = "Numerar os atributos priorizados"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Antepõe 1, 2, 3... aos atributos de uma seção ordenada por prioridade."
L["Numbering format"] = "Formato da numeração"
L["Name offset"] = "Deslocamento do nome"
L["Value offset"] = "Deslocamento do valor"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "Cabeçalho de seção"
L["Stat name"] = "Nome do atributo"
L["Stat value"] = "Valor do atributo"
L["Priority line"] = "Linha de prioridade"
L["Footer"] = "Rodapé"
L["Font"] = "Fonte"
L["Font face (all text)"] = "Fonte (todo o texto)"
L["Drop shadow"] = "Sombra projetada"
L["Shadow color"] = "Cor da sombra"
L["Shadow X offset"] = "Deslocamento X da sombra"
L["Shadow Y offset"] = "Deslocamento Y da sombra"
L["Per-element size and color"] = "Tamanho e cor por elemento"
L["Editing"] = "Editando"
L["Color"] = "Cor"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "As cores do nome e do valor são substituídas quando a coloração pela cor do atributo está ativa na página Linhas e barras."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Ajustes por atributo"
L["Editing stat"] = "Atributo em edição"
L["Show this stat"] = "Exibir este atributo"
L["Stat color"] = "Cor do atributo"
L["Use class color for this stat"] = "Usar a cor da classe para este atributo"
L["Display name (blank for default)"] = "Nome exibido (vazio para o padrão)"
L["Value format"] = "Formato do valor"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Marcadores: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExemplo: '$rating - $value%' exibe '285 - 10.65%'."
L["Decimal places"] = "Casas decimais"
L["Bar scale"] = "Escala das barras"
L["Bar fill"] = "Preenchimento das barras"
L["Value at a full bar"] = "Valor com a barra cheia"
L["Grow the scale automatically"] = "Aumentar a escala automaticamente"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Aumenta o valor de barra cheia sempre que o atributo o ultrapassa. Útil para Velocidade, que não tem teto durante o voo dracônico."
L["Reset all stats"] = "Redefinir todos os atributos"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Seções"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "As seções são desenhadas de cima para baixo nesta ordem. Cada uma pode conter os atributos que você quiser."
L["Editing section"] = "Seção em edição"
L["Section title"] = "Título da seção"
L["Show this section"] = "Exibir esta seção"
L["Show the section header"] = "Exibir o cabeçalho da seção"
L["Order by spec stat priority"] = "Ordenar pela prioridade da especialização"
L["Re-sorts this section's stats to match your specialization's priority."] = "Reordena os atributos desta seção conforme a prioridade da sua especialização."
L["Header alignment"] = "Alinhamento do cabeçalho"
L["Move section up"] = "Mover a seção para cima"
L["Move section down"] = "Mover a seção para baixo"
L["Stats in this section"] = "Atributos desta seção"
L["Up"] = "Subir"
L["Down"] = "Descer"
L["Remove"] = "Remover"
L["Add a stat to this section"] = "Adicionar um atributo a esta seção"
L["(every stat is already here)"] = "(todos os atributos já estão aqui)"
L["Reset sections"] = "Redefinir as seções"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Linha de rodapé"
L["Show the footer"] = "Exibir o rodapé"
L["Frames per second"] = "Quadros por segundo"
L["Home latency"] = "Latência local"
L["World latency"] = "Latência de mundo"
L["Addon memory use"] = "Memória usada pelo addon"
L["Separator between entries"] = "Separador entre as entradas"
L["Formats"] = "Formatos"
L["FPS format"] = "Formato do FPS"
L["Home latency format"] = "Formato da latência local"
L["World latency format"] = "Formato da latência de mundo"
L["Memory format"] = "Formato da memória"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Estes usam os formatos numéricos padrão: %d para um número inteiro, %.1f para uma casa decimal."
L["Performance coloring"] = "Coloração por desempenho"
L["Color by performance"] = "Colorir pelo desempenho"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Deixa o FPS e a latência verdes, amarelos ou vermelhos conforme os limites abaixo."
L["Good"] = "Bom"
L["Fair"] = "Razoável"
L["Poor"] = "Ruim"
L["FPS considered good"] = "FPS considerado bom"
L["FPS considered poor"] = "FPS considerado ruim"
L["Latency considered good (ms)"] = "Latência considerada boa (ms)"
L["Latency considered poor (ms)"] = "Latência considerada ruim (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Exibir a cadeia de prioridade"
L["Separator"] = "Separador"
L["Color each stat name"] = "Colorir cada nome de atributo"
L["Prefix with the spec name"] = "Antepor o nome da especialização"
L["Priority for your current spec"] = "Prioridade para sua especialização atual"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "A ordem embutida é uma referência genérica. Simule seu próprio personagem para a resposta definitiva e defina-a aqui."
L["Current specialization: %s"] = "Especialização atual: %s"
L["unknown"] = "desconhecida"
L["Priority %d"] = "Prioridade %d"
L["Paste a stat weight string"] = "Cole uma cadeia de pesos de atributos"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Cole uma cadeia do Pawn (do Raidbots, de uma simulação ou de um site de atributos) ou uma ordem simples como 'Mastery > Haste > Crit > Versatility'. O StatPanel lê os quatro atributos secundários e define a ordem para sua especialização atual."
L["Weights or order"] = "Pesos ou ordem"
L["Apply pasted weights"] = "Aplicar os pesos colados"
L["no active specialization to apply to."] = "nenhuma especialização ativa para aplicar."
L["priority for %s set to %s."] = "prioridade de %s definida como %s."
L["your spec"] = "sua especialização"
L["Use the built-in order"] = "Usar a ordem embutida"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Predefinições"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Uma predefinição sobrescreve os ajustes de aparência do perfil atual. Sua posição, suas regras de visibilidade e seus perfis não são alterados."
L["Start over"] = "Recomeçar"
L["Reset this profile"] = "Redefinir este perfil"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Cada personagem lembra qual perfil usa, então você pode compartilhar uma aparência entre os alts ou dar uma própria a cada um."
L["Active profile"] = "Perfil ativo"
L["New profile name"] = "Nome do novo perfil"
L["Create"] = "Criar"
L["Copy current"] = "Copiar o atual"
L["Delete current"] = "Excluir o atual"
L["Deleted profile '%s'."] = "Perfil '%s' excluído."
L["Share"] = "Compartilhar"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "A exportação gera uma cadeia que você pode passar a outra pessoa. A importação sobrescreve o perfil indicado abaixo, ou o ativo se você deixar em branco."
L["Export string"] = "Cadeia de exportação"
L["Generate export"] = "Gerar a exportação"
L["Import string"] = "Cadeia de importação"
L["Import into profile (blank = active)"] = "Importar para o perfil (vazio = ativo)"
L["Import"] = "Importar"
L["Imported into profile '%s'."] = "Importado para o perfil '%s'."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Anunciar"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Envia ao bate-papo um resumo do seu equipamento. Nada é enviado automaticamente - apenas quando você usa o botão, o comando de barra ou o menu de contexto."
L["Send to"] = "Enviar para"
L["Whisper to (for the Whisper channel)"] = "Sussurrar para (para o canal Sussurrar)"
L["Prefix"] = "Prefixo"
L["Include"] = "Incluir"
L["Stats"] = "Atributos"
L["Stat priority"] = "Prioridade de atributos"
L["Session peak speed"] = "Velocidade máxima da sessão"
L["Missing enchants and sockets"] = "Encantamentos e engastes faltando"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "O jogo protege a maioria dos atributos de combate e não permite que nenhum addon os envie ao bate-papo, então eles são omitidos automaticamente. Nível de item, especialização, velocidade e avisos de equipamento passam normalmente. Se uma atualização futura desproteger um atributo, ele passará a aparecer sem nenhuma mudança."
L["Preview"] = "Prévia"
L["Announce now"] = "Anunciar agora"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Equipamento em uso"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "Os dados de item não são protegidos pelo jogo, portanto, ao contrário dos atributos de combate, podem ser lidos por completo."
L["Refresh"] = "Atualizar"
L["Print report"] = "Exibir o relatório"
L["Average equipped item level %.2f.%s  %s"] = "Nível de item médio equipado %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Conjunto de classe %d/%d."
L["Nothing missing."] = "Não falta nada."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(sem regra)"
L["Automatic profile switching"] = "Troca automática de perfil"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "As regras são salvas por personagem. Uma regra de conteúdo tem precedência sobre uma de especialização, então você pode manter um perfil de especialização em geral e forçar outro dentro de um raide. Tudo que ficar como “(sem regra)” é ignorado."
L["Switch profiles automatically"] = "Trocar de perfil automaticamente"
L["By content"] = "Por conteúdo"
L["By specialization"] = "Por especialização"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "Apenas sua especialização atual é listada. Troque de especialização e volte para definir uma regra para outra."
L["Profile for this specialization"] = "Perfil para esta especialização"
L["Apply rules now"] = "Aplicar as regras agora"
L["no rule matches your current spec or location."] = "nenhuma regra corresponde à sua especialização ou localização atual."
L["already on '%s', the profile your rules call for."] = "já está em '%s', o perfil que suas regras pedem."
L["Clear all rules"] = "Limpar todas as regras"
L["cleared this character's automatic rules."] = "regras automáticas deste personagem limpas."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "Geral"
L["Rows & Bars"] = "Linhas e barras"
L["Fonts"] = "Fontes"
L["Priority"] = "Prioridade"
L["Gear"] = "Equipamento"
L["Profiles"] = "Perfis"
L["Automation"] = "Automação"
L["Dark"] = "Escuro"
L["Grey"] = "Cinza"
L["Light"] = "Claro"
L["Game"] = "Jogo"
L["Background: %s"] = "Plano de fundo: %s"
L["Live Preview"] = "Prévia ao vivo"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "O painel real, encaixado aqui. Arraste esta janela para movê-la; o painel volta ao lugar quando você fecha as opções."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Digite /sp para ver os comandos de barra. Arraste o próprio painel para movê-lo."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "A aparência original: painel escuro e plano com barras coloridas."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Sem barras. Uma linha colorida por atributo: 'Maestria: 285 - 10.65%'."
L["Thin headerless bars for a small footprint."] = "Barras finas sem cabeçalhos, para ocupar pouco espaço."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Texturas da Blizzard e borda de dica, combinando com a interface padrão."
L["No background or border at all - just floating text and bars."] = "Sem plano de fundo nem borda - apenas texto e barras flutuantes."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Texto monocromático minúsculo, sem plano de fundo. Fica discreto em um canto."
L["High-contrast glow bars on near-black, with a value gradient."] = "Barras luminosas de alto contraste sobre quase preto, com gradiente pelo valor."
L["Warm parchment and gold, in keeping with the default UI art."] = "Pergaminho quente e dourado, no espírito da arte da interface padrão."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Foco defensivo: armadura, esquiva, aparar, bloqueio e evitação no topo."
L["Big live speed readout with your session record, and little else."] = "Grande leitura de velocidade ao vivo com seu recorde da sessão, e pouco mais."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Atributos secundários, nível de item e as duas latências - o que se confere antes de um pull."
L["Cold blues and whites on deep navy."] = "Azuis frios e brancos sobre azul-marinho profundo."
L["Warm reds and ambers on charcoal."] = "Vermelhos quentes e âmbares sobre grafite."
L["Every bar takes your class color. Clean and unfussy."] = "Cada barra assume a cor da sua classe. Limpo e sem firulas."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Texto grande, pesado e de alto contraste. Fácil de ler num relance."
L["The smallest useful readout: four secondaries, nothing else."] = "A menor leitura útil: quatro atributos secundários e nada mais."
L["Green-on-black monospace, like a console readout."] = "Verde sobre preto em monoespaçada, como um console."
L["Throughput stats plus leech, with your primary attribute on top."] = "Atributos de dano e cura mais sanguessuga, com seu atributo principal no topo."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Versatilidade primeiro, ao lado de evitação, esquiva e velocidade."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "Combina com o ElvUI: painel escuro e plano, borda preta de 1 px, fonte estreita."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "O conhecido estilo transparente do ElvUI: vidro quase preto, borda finíssima."
L["preset hook failed: %s"] = "falha no hook da predefinição: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "comandos:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - abrir as opções"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - exibir ou ocultar o painel"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - travar ou destravar o arrasto"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - devolver o painel ao centro"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <nome>|r - aplicar uma predefinição (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <nome>|r - trocar de perfil"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - exibir e zerar o recorde de velocidade da sessão"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - exibir ou ocultar o botão do minimapa"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - auditar encantamentos, engastes e nível de item"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [canal]|r - anunciar seu equipamento no bate-papo"
L["panel shown."] = "painel exibido."
L["panel hidden."] = "painel ocultado."
L["panel locked."] = "painel travado."
L["panel unlocked."] = "painel destravado."
L["position reset."] = "posição redefinida."
L["applied the '%s' preset."] = "predefinição '%s' aplicada."
L["unknown preset. Available: %s"] = "predefinição desconhecida. Disponíveis: %s"
L["switched to profile '%s'."] = "alterado para o perfil '%s'."
L["profiles: %s"] = "perfis: %s"
L["session speed record cleared."] = "recorde de velocidade da sessão zerado."
L["minimap button hidden."] = "botão do minimapa ocultado."
L["minimap button shown."] = "botão do minimapa exibido."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Atributo principal"
L["Armor DR"] = "Redução de armadura"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Crít"
L["Haste"] = "Acel."
L["Mast"] = "Maest."
L["Vers"] = "Vers."

L["a display setting could not be applied (%s)."] = "não foi possível aplicar um ajuste de exibição (%s)."
L["The game protects this value; see the panel itself."] = "O jogo protege este valor; consulte o próprio painel."
L["Value"] = "Valor"
L["Rating"] = "Índice"
L["Yards/sec"] = "Metros/seg"
L["Session peak"] = "Recorde da sessão"
L["Attribute"] = "Atributo"
L["Drag to move  |  /sp for options"] = "Arraste para mover  |  /sp para as opções"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Força"
L["Agility"] = "Agilidade"
L["Stamina"] = "Vigor"
L["Intellect"] = "Intelecto"
L["Mastery"] = "Maestria"
L["Versatility"] = "Versatilidade"
L["Dodge"] = "Esquiva"
L["Parry"] = "Aparar"
L["Block"] = "Bloqueio"
L["Leech"] = "Sanguessuga"
L["Avoidance"] = "Evitação"
L["Speed"] = "Velocidade"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "Mostrar ou ocultar o painel"
L["Open the options"] = "Abrir as opções"
L["Lock or unlock the panel"] = "Travar ou destravar o painel"
L["Switch to the next profile"] = "Mudar para o próximo perfil"
L["Run the gear audit"] = "Executar a auditoria de equipamento"
L["only one profile exists."] = "existe apenas um perfil."

-- Diagnostics.lua
L["yes"] = "sim"
L["no"] = "não"
L["LibStub not present"] = "LibStub ausente"
L["absent"] = "ausente"
L["present (revision %s)"] = "presente (revisão %s)"
L["not present in this client"] = "ausente neste cliente"
L["present, could not sample"] = "presente, não foi possível verificar"
L["active (crit chance is protected)"] = "ativo (a chance de crítico está protegida)"
L["present but crit chance is readable"] = "presente, mas a chance de crítico é legível"
L["Locale"] = "Idioma"
L["Class"] = "Classe"
L["Secret values"] = "Valores protegidos"
L["Profiles stored"] = "Perfis salvos"
L["Custom stat priority"] = "Prioridade de atributos personalizada"
L["enabled"] = "ativado"
L["disabled"] = "desativado"
L["locked"] = "travado"
L["unlocked"] = "destravado"
L["auto width"] = "largura automática"
L["width %d"] = "largura %d"
L["Position"] = "Posição"
L[" (substituted: not readable in this locale)"] = " (substituída: ilegível neste idioma)"
L["Stat rows"] = "Linhas de atributos"
L["%d shown of %d placed"] = "%d exibidas de %d posicionadas"
L["StatPanel diagnostics"] = "Diagnóstico do StatPanel"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "Ctrl-A para selecionar tudo, Ctrl-C para copiar. Cole isto no seu relatório de erro."

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "atualizado para %s. Novidades desta versão:"
L["  Full changelog: %s"] = "  Registro de alterações completo: %s"
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "Atalhos de teclado para exibir, travar, alternar perfis e auditar o equipamento."
L["New stats: attack power, spell power, health, mana and stagger."] = "Novos atributos: poder de ataque, poder mágico, vida, mana e cambaleio."
L["The $per token shows what one percent of a stat costs in rating."] = "O token $per mostra quanto custa em índice um por cento de um atributo."
L["Gear durability and repair cost can now sit in the footer."] = "A durabilidade do equipamento e o custo de reparo agora podem ficar no rodapé."
L["A Colorblind Safe preset, and precise X/Y position controls."] = "Uma predefinição adequada ao daltonismo e controles precisos de posição X/Y."
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug reúne tudo o que um relatório de erro precisa em uma caixa copiável."

-- Options.lua: anchor points and position
L["Top left"] = "Superior esquerdo"
L["Top"] = "Superior"
L["Top right"] = "Superior direito"
L["Bottom left"] = "Inferior esquerdo"
L["Bottom"] = "Inferior"
L["Bottom right"] = "Inferior direito"
L["Anchor point"] = "Ponto de ancoragem"
L["Which corner of the panel the position below is measured from."] = "De qual canto do painel a posição abaixo é medida."
L["Anchored to screen"] = "Ancorado à tela"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "Até qual ponto da tela a medida é feita. Ancorar em um canto mantém o painel ali quando a resolução muda."
L["Horizontal position"] = "Posição horizontal"
L["Vertical position"] = "Posição vertical"
L[" (not readable in this language)"] = " (ilegível neste idioma)"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "Menor durabilidade do equipamento"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "A pior durabilidade entre os espaços equipados, para você ver a peça danificada e não uma média."
L["Repair cost"] = "Custo de reparo"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "O jogo só consegue calcular um reparo diante de um comerciante, então nada aparece até você falar com um."
L["Durability format"] = "Formato da durabilidade"
L["Durability considered good"] = "Durabilidade considerada boa"
L["Durability considered poor"] = "Durabilidade considerada ruim"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "Paleta Okabe-Ito, legível com daltonismo vermelho-verde. Com números de ordem."

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - mostrar o diagnóstico para colar em um relatório de erro"
L["diagnostics:"] = "diagnóstico:"

-- StatPanel.lua: new stat names
L["Attack Power"] = "Poder de ataque"
L["Spell Power"] = "Poder mágico"
L["Health"] = "Vida"
L["Mana"] = "Mana"
L["Stagger"] = "Cambaleio"
