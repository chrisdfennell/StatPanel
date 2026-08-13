-- Locales/ruRU.lua (Russian)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export ruRU`, then
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
--     Russian too if a global ever disappears.
--
-- This locale could not ship before 2.5.0: the addon named Fonts\FRIZQT__.TTF
-- directly in eleven places, and a font chosen by filename is not guaranteed to
-- carry Cyrillic. Media:UIFont() now asks the client for its own font instead.
--
-- NOT reviewed by a native speaker. Terminology follows the Russian client's
-- own wording where it exists. Corrections are very welcome:
-- https://github.com/chrisdfennell/StatPanel/issues

local _, SP = ...
local L = SP.Locale("ruRU")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "Показать только в моём чате"
L["Say"] = "Сказать"
L["Party"] = "Группа"
L["Raid"] = "Рейд"
L["Instance"] = "Подземелье"
L["Guild"] = "Гильдия"
L["Officer"] = "Офицер"
L["Yell"] = "Крик"
L["Whisper"] = "Шепот"
L["iLvl %.2f (%.2f overall)"] = "ур. предметов %.2f (%.2f всего)"
L["iLvl %.2f"] = "ур. предметов %.2f"
L["priority %s"] = "приоритет %s"
L["peak speed %.0f%%"] = "макс. скорость %.0f%%"
L["%d missing enchant(s)"] = "не хватает чар: %d"
L["%d empty socket(s)"] = "пустых гнёзд: %d"
L["%d/%d tier set"] = "комплект: %d/%d"
L["You aren't in a group."] = "Вы не в группе."
L["You aren't in a raid."] = "Вы не в рейде."
L["You aren't in a guild."] = "Вы не в гильдии."
L["hold on - you can announce again in %.0f seconds."] = "подождите - следующее сообщение можно отправить через %.0f сек."
L["nothing to announce - enable some fields on the Announce page."] = "нечего отправлять - включите нужные поля на странице «Объявление»."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "пропущено значений: %d. Игра защищает эти характеристики, и отправить их в чат нельзя."
L["%s Showing it here instead:"] = "%s Показываю здесь:"
L["whisper needs a name: /sp announce whisper <name>"] = "для шепота нужно имя: /sp announce whisper <имя>"
L["the game refused to send that message. Showing it here instead:"] = "игра отклонила это сообщение. Показываю здесь:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "Открытый мир"
L["Delve"] = "Вылазка"
L["Dungeon"] = "Подземелье"
L["Mythic+ dungeon"] = "Подземелье эпохального+"
L["Arena"] = "Арена"
L["Battleground"] = "Поле боя"
L["Scenario"] = "Сценарий"
L["switched to profile '%s' (%s rule)."] = "выбран профиль «%s» (правило: %s)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "Уровень предметов"
L["FPS"] = "Кадров/с"
L["Spec"] = "Специализация"
L["Profile"] = "Профиль"
L["|cffffff00Left-click|r  open options"] = "|cffffff00Левый клик|r  открыть настройки"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00Правый клик|r  быстрое меню"
L["%.0f fps"] = "%.0f кадр/с"
L["%.0f fps  |  iLvl %.0f"] = "%.0f кадр/с  |  ур. пред. %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "Имя профиля не может быть пустым."
L["A profile named '%s' already exists."] = "Профиль с именем «%s» уже существует."
L["The Default profile cannot be deleted."] = "Профиль Default нельзя удалить."
L["No such profile."] = "Такого профиля нет."
L["Nothing to import."] = "Нечего импортировать."
L["That import string is too large to be a profile."] = "Эта строка слишком велика, чтобы быть профилем."
L["That doesn't look like a StatPanel export string."] = "Это не похоже на строку экспорта StatPanel."
L["The import string is corrupt."] = "Строка импорта повреждена."
L["Could not read the import string: %s"] = "Не удалось прочитать строку импорта: %s"
L["The import string did not contain a profile."] = "В строке импорта не оказалось профиля."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "проверка снаряжения"
L["empty"] = "пусто"
L["no enchant"] = "нет чар"
L["%d rare gem(s)"] = "редких самоцветов: %d"
L["lowest"] = "минимум"
L["Equipped"] = "Надето"
L["Tier set    %d/%d"] = "Комплект    %d/%d"
L["%d item(s) not fully upgraded"] = "не улучшено до конца предметов: %d"
L["Everything is enchanted and socketed."] = "Все чары наложены, все гнёзда заполнены."
L["%d enchant(s)"] = "чар: %d"
L["%d socket(s)"] = "гнёзд: %d"
L["%d empty slot(s)"] = "пустых слотов: %d"
L["Missing: %s"] = "Не хватает: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "Голова"
L["Neck"] = "Шея"
L["Shoulder"] = "Плечи"
L["Back"] = "Спина"
L["Chest"] = "Грудь"
L["Wrist"] = "Запястья"
L["Hands"] = "Кисти рук"
L["Waist"] = "Пояс"
L["Legs"] = "Ноги"
L["Feet"] = "Ступни"
L["Ring 1"] = "Кольцо 1"
L["Ring 2"] = "Кольцо 2"
L["Trinket 1"] = "Аксессуар 1"
L["Trinket 2"] = "Аксессуар 2"
L["Main Hand"] = "Правая рука"
L["Off Hand"] = "Левая рука"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "Нет"
L["Outline"] = "Контур"
L["Thick Outline"] = "Толстый контур"
L["Monochrome"] = "Монохромный"
L["Monochrome Outline"] = "Монохромный контур"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "Показать панель"
L["Lock position"] = "Закрепить положение"
L["Show FPS"] = "Показывать кадры/с"
L["Apply preset"] = "Применить набор"
L["Announce to"] = "Объявить в"
L["Audit my gear"] = "Проверить снаряжение"
L["Open options"] = "Открыть настройки"
L["Reset position"] = "Сбросить положение"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "Слева"
L["Center"] = "По центру"
L["Right"] = "Справа"
L["Proportional to value"] = "Пропорционально значению"
L["Always full"] = "Всегда полная"
L["No fill (text only)"] = "Без заливки (только текст)"
L["Per-stat colors"] = "Цвет для каждой характеристики"
L["Class color"] = "Цвет класса"
L["Single color"] = "Один цвет"
L["Value gradient"] = "Градиент по значению"
L["Bars"] = "Полосы"
L["Text only"] = "Только текст"
L["Player name"] = "Имя персонажа"
L["Specialization"] = "Специализация"
L["Custom text"] = "Свой текст"
L["Hidden"] = "Скрыто"
L["Total effect (character sheet)"] = "Общий эффект (как в окне персонажа)"
L["Bonus from rating only"] = "Только бонус от рейтинга"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "Панель"
L["Enable StatPanel"] = "Включить StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "Главный переключатель. Если выключить, панель полностью скрывается."
L["Stops the panel from being dragged."] = "Запрещает перетаскивать панель."
L["Keep on screen"] = "Удерживать на экране"
L["Prevents dragging the panel off the edge of the screen."] = "Не даёт утащить панель за край экрана."
L["Scale"] = "Масштаб"
L["Opacity"] = "Непрозрачность"
L["Frame layer"] = "Слой отрисовки"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "На каком слое рисуется панель. Поднимите его, если панель перекрывает другой аддон."
L["Update interval (seconds)"] = "Интервал обновления (сек.)"
L["How often values refresh. Higher values use less CPU."] = "Как часто обновляются значения. Больше значение - меньше нагрузка на процессор."
L["Stat values show"] = "Значения показывают"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "«Общий эффект» совпадает с окном персонажа. «Бонус от рейтинга» показывает только вклад рейтинга вашего снаряжения."
L["Visibility"] = "Видимость"
L["Hide during combat"] = "Скрывать в бою"
L["Turning this on clears 'Show only during combat'."] = "Включение снимает «Показывать только в бою»."
L["Show only during combat"] = "Показывать только в бою"
L["Turning this on clears 'Hide during combat'."] = "Включение снимает «Скрывать в бою»."
L["Hide while dead"] = "Скрывать при смерти"
L["Hide in vehicles"] = "Скрывать в транспорте"
L["Hide in pet battles"] = "Скрывать в битвах питомцев"
L["Hide inside instances"] = "Скрывать в подземельях"
L["Turning this on clears 'Hide outside instances'."] = "Включение снимает «Скрывать вне подземелий»."
L["Hide outside instances"] = "Скрывать вне подземелий"
L["Turning this on clears 'Hide inside instances'."] = "Включение снимает «Скрывать в подземельях»."
L["Mouseover fade"] = "Затухание без курсора"
L["Only show on mouseover"] = "Показывать только при наведении"
L["Fades the panel out until you hover over it."] = "Панель прячется, пока на неё не наведён курсор."
L["Faded opacity"] = "Непрозрачность при затухании"
L["Fade duration (seconds)"] = "Длительность затухания (сек.)"
L["Show tooltips on hover"] = "Подсказки при наведении"
L["Minimap and options"] = "Мини-карта и настройки"
L["Show the minimap button"] = "Показывать кнопку у мини-карты"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "Левый клик открывает эти настройки, правый - быстрое меню. Кнопку можно перетаскивать по краю мини-карты."
L["Show a live preview while configuring"] = "Живой предпросмотр при настройке"
L["Docks the real panel beside this window so you can see changes as you make them."] = "Пристыковывает настоящую панель к этому окну, чтобы изменения были видны сразу."
L["Reset peak speed"] = "Сбросить рекорд скорости"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "Размер"
L["Auto-size width to content"] = "Подгонять ширину под содержимое"
L["Grows and shrinks the panel to fit the widest row."] = "Панель растягивается и сжимается по самой широкой строке."
L["Width"] = "Ширина"
L["Minimum width (auto-size)"] = "Минимальная ширина (автоподбор)"
L["Side padding"] = "Боковые отступы"
L["Top padding"] = "Отступ сверху"
L["Bottom padding"] = "Отступ снизу"
L["Gap between sections"] = "Промежуток между разделами"
L["Section header spacing"] = "Отступ заголовка раздела"
L["Set to 0 to remove section headers entirely."] = "Значение 0 полностью убирает заголовки разделов."
L["Background"] = "Фон"
L["Background texture"] = "Текстура фона"
L["Background color and transparency"] = "Цвет и прозрачность фона"
L["Tile the background"] = "Замостить фон"
L["Tile size"] = "Размер плитки"
L["Border"] = "Рамка"
L["Border style"] = "Стиль рамки"
L["Border color and transparency"] = "Цвет и прозрачность рамки"
L["Border thickness"] = "Толщина рамки"
L["Only affects pixel-style borders; textured borders use their own size."] = "Влияет только на пиксельные рамки; текстурные используют собственный размер."
L["Border inset"] = "Смещение рамки"
L["Title"] = "Заголовок"
L["Show title"] = "Показывать заголовок"
L["Title shows"] = "В заголовке"
L["Title alignment"] = "Выравнивание заголовка"
L["Item level format"] = "Формат уровня предметов"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "Подстановки: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "Подстановки: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "Знаков после запятой в уровне предметов"
L["Custom title text"] = "Свой текст заголовка"
L["Divider"] = "Разделитель"
L["Show divider under title"] = "Разделитель под заголовком"
L["Divider color"] = "Цвет разделителя"
L["Divider thickness"] = "Толщина разделителя"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "Стиль строк"
L["Draw rows as"] = "Рисовать строки как"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "«Полосы» рисуют полосу для каждой характеристики. «Только текст» - одну цветную строку."
L["Text alignment (text style)"] = "Выравнивание текста (текстовый стиль)"
L["Label/value separator (text style)"] = "Разделитель названия и значения (текстовый стиль)"
L["Placed between the stat name and its value, e.g. ': '"] = "Ставится между названием характеристики и значением, например «: »"
L["Line height (text style)"] = "Высота строки (текстовый стиль)"
L["Bar appearance"] = "Вид полос"
L["Bar texture"] = "Текстура полосы"
L["Bar height"] = "Высота полосы"
L["Space between bars"] = "Промежуток между полосами"
L["Horizontal inset"] = "Горизонтальный отступ"
L["Bar opacity"] = "Непрозрачность полосы"
L["Fill from the right"] = "Заполнять справа"
L["Bar colors"] = "Цвета полос"
L["Color mode"] = "Режим окраски"
L["Per-stat colors are set on the Stats page."] = "Цвета отдельных характеристик задаются на странице «Характеристики»."
L["Gradient: low value"] = "Градиент: низкое значение"
L["Gradient: high value"] = "Градиент: высокое значение"
L["Bar background"] = "Фон полосы"
L["Track texture"] = "Текстура дорожки"
L["Track color and transparency"] = "Цвет и прозрачность дорожки"
L["Tint track with the stat color"] = "Красить дорожку в цвет характеристики"
L["Track tint opacity"] = "Непрозрачность окраски дорожки"
L["Bar border"] = "Рамка полосы"
L["Border color"] = "Цвет рамки"
L["Motion"] = "Анимация"
L["Animate value changes"] = "Плавно менять значения"
L["Eases bars toward new values instead of snapping."] = "Полосы плавно движутся к новому значению, а не прыгают."
L["Animation speed"] = "Скорость анимации"
L["Show a spark at the fill edge"] = "Искра на краю заливки"
L["Spark color"] = "Цвет искры"
L["Row text"] = "Текст строки"
L["Show stat names"] = "Показывать названия"
L["Show values"] = "Показывать значения"
L["Color names with the stat color"] = "Красить названия в цвет характеристики"
L["Color values with the stat color"] = "Красить значения в цвет характеристики"
L["Number prioritized stats"] = "Нумеровать по приоритету"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "Добавляет 1, 2, 3... перед характеристиками в разделе, отсортированном по приоритету."
L["Numbering format"] = "Формат нумерации"
L["Name offset"] = "Смещение названия"
L["Value offset"] = "Смещение значения"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "Заголовок раздела"
L["Stat name"] = "Название характеристики"
L["Stat value"] = "Значение характеристики"
L["Priority line"] = "Строка приоритета"
L["Footer"] = "Нижняя строка"
L["Font"] = "Шрифт"
L["Font face (all text)"] = "Шрифт (весь текст)"
L["Drop shadow"] = "Тень"
L["Shadow color"] = "Цвет тени"
L["Shadow X offset"] = "Смещение тени по X"
L["Shadow Y offset"] = "Смещение тени по Y"
L["Per-element size and color"] = "Размер и цвет по элементам"
L["Editing"] = "Редактируется"
L["Color"] = "Цвет"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "Цвета названия и значения переопределяются, если на странице «Строки и полосы» включена окраска в цвет характеристики."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "Настройки характеристик"
L["Editing stat"] = "Редактируется характеристика"
L["Show this stat"] = "Показывать эту характеристику"
L["Stat color"] = "Цвет характеристики"
L["Use class color for this stat"] = "Использовать цвет класса"
L["Display name (blank for default)"] = "Отображаемое имя (пусто - по умолчанию)"
L["Value format"] = "Формат значения"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "Подстановки: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nПример: «$rating - $value%» даёт «285 - 10.65%»."
L["Decimal places"] = "Знаков после запятой"
L["Bar scale"] = "Шкала полосы"
L["Bar fill"] = "Заливка полосы"
L["Value at a full bar"] = "Значение при полной полосе"
L["Grow the scale automatically"] = "Наращивать шкалу автоматически"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "Поднимает верхнюю границу, когда характеристика её превышает. Полезно для скорости: в небесном полёте потолка нет."
L["Reset all stats"] = "Сбросить все характеристики"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "Разделы"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "Разделы рисуются сверху вниз в этом порядке. В каждом может быть любой набор характеристик."
L["Editing section"] = "Редактируется раздел"
L["Section title"] = "Название раздела"
L["Show this section"] = "Показывать этот раздел"
L["Show the section header"] = "Показывать заголовок раздела"
L["Order by spec stat priority"] = "Сортировать по приоритету специализации"
L["Re-sorts this section's stats to match your specialization's priority."] = "Пересортировывает характеристики раздела под приоритет вашей специализации."
L["Header alignment"] = "Выравнивание заголовка"
L["Move section up"] = "Переместить раздел вверх"
L["Move section down"] = "Переместить раздел вниз"
L["Stats in this section"] = "Характеристики в разделе"
L["Up"] = "Вверх"
L["Down"] = "Вниз"
L["Remove"] = "Убрать"
L["Add a stat to this section"] = "Добавить характеристику в раздел"
L["(every stat is already here)"] = "(все характеристики уже здесь)"
L["Reset sections"] = "Сбросить разделы"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "Нижняя строка"
L["Show the footer"] = "Показывать нижнюю строку"
L["Frames per second"] = "Кадров в секунду"
L["Home latency"] = "Задержка (дом)"
L["World latency"] = "Задержка (мир)"
L["Addon memory use"] = "Память аддона"
L["Separator between entries"] = "Разделитель между записями"
L["Formats"] = "Форматы"
L["FPS format"] = "Формат кадров/с"
L["Home latency format"] = "Формат домашней задержки"
L["World latency format"] = "Формат мировой задержки"
L["Memory format"] = "Формат памяти"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "Используются стандартные числовые форматы: %d - целое, %.1f - один знак после запятой."
L["Performance coloring"] = "Окраска по производительности"
L["Color by performance"] = "Красить по производительности"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "Окрашивает кадры/с и задержку в зелёный, жёлтый или красный по порогам ниже."
L["Good"] = "Хорошо"
L["Fair"] = "Средне"
L["Poor"] = "Плохо"
L["FPS considered good"] = "Кадров/с считается хорошим"
L["FPS considered poor"] = "Кадров/с считается плохим"
L["Latency considered good (ms)"] = "Задержка считается хорошей (мс)"
L["Latency considered poor (ms)"] = "Задержка считается плохой (мс)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "Показывать цепочку приоритета"
L["Separator"] = "Разделитель"
L["Color each stat name"] = "Красить каждое название"
L["Prefix with the spec name"] = "Добавлять название специализации"
L["Priority for your current spec"] = "Приоритет для текущей специализации"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "Встроенный порядок - это общая отправная точка. Точный ответ даст симуляция вашего персонажа; результат впишите сюда."
L["Current specialization: %s"] = "Текущая специализация: %s"
L["unknown"] = "неизвестно"
L["Priority %d"] = "Приоритет %d"
L["Paste a stat weight string"] = "Вставьте строку весов характеристик"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Вставьте строку Pawn (из Raidbots, симуляции или профильного сайта) или просто порядок вида «Искусность > Скорость > Крит > Универсальность». StatPanel возьмёт четыре вторичные характеристики и задаст порядок для текущей специализации."
L["Weights or order"] = "Веса или порядок"
L["Apply pasted weights"] = "Применить вставленные веса"
L["no active specialization to apply to."] = "нет активной специализации для применения."
L["priority for %s set to %s."] = "приоритет для %s задан: %s."
L["your spec"] = "вашей специализации"
L["Use the built-in order"] = "Использовать встроенный порядок"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "Наборы"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "Набор перезаписывает настройки внешнего вида в текущем профиле. Положение, правила видимости и профили не трогаются."
L["Start over"] = "Начать заново"
L["Reset this profile"] = "Сбросить этот профиль"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "Каждый персонаж помнит свой профиль, поэтому можно задать один вид всем или каждому свой."
L["Active profile"] = "Активный профиль"
L["New profile name"] = "Имя нового профиля"
L["Create"] = "Создать"
L["Copy current"] = "Копировать текущий"
L["Delete current"] = "Удалить текущий"
L["Deleted profile '%s'."] = "Профиль «%s» удалён."
L["Share"] = "Поделиться"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "Экспорт создаёт строку, которую можно передать другому игроку. Импорт перезаписывает указанный ниже профиль, а если поле пустое - активный."
L["Export string"] = "Строка экспорта"
L["Generate export"] = "Создать строку экспорта"
L["Import string"] = "Строка импорта"
L["Import into profile (blank = active)"] = "Импортировать в профиль (пусто - активный)"
L["Import"] = "Импорт"
L["Imported into profile '%s'."] = "Импортировано в профиль «%s»."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "Объявление"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "Отправляет сводку по снаряжению в чат. Автоматически не отправляется ничего - только по кнопке, команде или через правый клик."
L["Send to"] = "Отправить в"
L["Whisper to (for the Whisper channel)"] = "Шепнуть кому (для канала «Шепот»)"
L["Prefix"] = "Префикс"
L["Include"] = "Включить"
L["Stats"] = "Характеристики"
L["Stat priority"] = "Приоритет характеристик"
L["Session peak speed"] = "Рекорд скорости за сессию"
L["Missing enchants and sockets"] = "Отсутствующие чары и гнёзда"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "Игра защищает большинство боевых характеристик и не позволяет аддонам отправлять их в чат, поэтому они пропускаются автоматически. Уровень предметов, специализация, скорость и предупреждения по снаряжению отправляются. Если будущее обновление снимет защиту, характеристика появится сама."
L["Preview"] = "Предпросмотр"
L["Announce now"] = "Объявить сейчас"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "Надетое снаряжение"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "Данные о предметах игра не защищает, поэтому, в отличие от боевых характеристик, их можно прочитать полностью."
L["Refresh"] = "Обновить"
L["Print report"] = "Вывести отчёт"
L["Average equipped item level %.2f.%s  %s"] = "Средний уровень надетых предметов %.2f.%s  %s"
L["  Tier set %d/%d."] = "  Комплект %d/%d."
L["Nothing missing."] = "Ничего не пропущено."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(нет правила)"
L["Automatic profile switching"] = "Автоматическая смена профиля"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "Правила сохраняются для каждого персонажа. Правило по контенту важнее правила по специализации, поэтому можно держать профиль под спек и всё равно принудительно менять его в рейде. Пункты со значением «(нет правила)» игнорируются."
L["Switch profiles automatically"] = "Менять профили автоматически"
L["By content"] = "По контенту"
L["By specialization"] = "По специализации"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "Показана только текущая специализация. Смените спек и вернитесь, чтобы задать правило для другой."
L["Profile for this specialization"] = "Профиль для этой специализации"
L["Apply rules now"] = "Применить правила сейчас"
L["no rule matches your current spec or location."] = "ни одно правило не подходит к вашей специализации или месту."
L["already on '%s', the profile your rules call for."] = "профиль «%s» уже активен - именно его требуют правила."
L["Clear all rules"] = "Очистить все правила"
L["cleared this character's automatic rules."] = "автоматические правила этого персонажа очищены."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "Общее"
L["Rows & Bars"] = "Строки и полосы"
L["Fonts"] = "Шрифты"
L["Priority"] = "Приоритет"
L["Gear"] = "Снаряжение"
L["Profiles"] = "Профили"
L["Automation"] = "Автоматизация"
L["Dark"] = "Тёмный"
L["Grey"] = "Серый"
L["Light"] = "Светлый"
L["Game"] = "Игра"
L["Background: %s"] = "Фон: %s"
L["Live Preview"] = "Живой предпросмотр"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "Настоящая панель, пристыкованная сюда. Перетаскивайте это окно, чтобы её двигать; при закрытии настроек панель вернётся на место."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "Введите /sp для списка команд. Панель двигается перетаскиванием."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "Стандартный вид: плоская тёмная панель с цветными полосами."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "Без полос. Одна цветная строка на характеристику: «Искусность: 285 - 10.65%»."
L["Thin headerless bars for a small footprint."] = "Тонкие полосы без заголовков, минимум места."
L["Blizzard textures and a tooltip border, to match the default UI."] = "Текстуры Blizzard и рамка подсказки - под стандартный интерфейс."
L["No background or border at all - just floating text and bars."] = "Ни фона, ни рамки - только текст и полосы в воздухе."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "Мелкий монохромный текст без фона. Тихо стоит в углу."
L["High-contrast glow bars on near-black, with a value gradient."] = "Контрастные светящиеся полосы на почти чёрном, с градиентом по значению."
L["Warm parchment and gold, in keeping with the default UI art."] = "Тёплый пергамент и золото, в духе стандартного оформления."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "Упор на защиту: броня, уворот, парирование, блок и уклонение сверху."
L["Big live speed readout with your session record, and little else."] = "Крупный показ текущей скорости с рекордом сессии, и почти ничего больше."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "Вторичные характеристики, уровень предметов и обе задержки - то, что смотрят перед пуллом."
L["Cold blues and whites on deep navy."] = "Холодная синева и белый на тёмно-синем."
L["Warm reds and ambers on charcoal."] = "Тёплый красный и янтарный на угольном."
L["Every bar takes your class color. Clean and unfussy."] = "Все полосы в цвете вашего класса. Чисто и без затей."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "Крупный жирный контрастный текст. Читается с одного взгляда."
L["The smallest useful readout: four secondaries, nothing else."] = "Самый компактный полезный вариант: четыре вторичные характеристики и ничего больше."
L["Green-on-black monospace, like a console readout."] = "Зелёный моноширинный на чёрном, как вывод консоли."
L["Throughput stats plus leech, with your primary attribute on top."] = "Характеристики урона и лечения плюс вытягивание жизни, основной атрибут сверху."
L["Versatility first, with avoidance, dodge and speed alongside."] = "Универсальность на первом месте, рядом уклонение, уворот и скорость."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "Под ElvUI: плоская тёмная панель, чёрная рамка в 1 пиксель, узкий шрифт."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "Популярный прозрачный стиль ElvUI: почти чёрное стекло, тончайшая рамка."
L["preset hook failed: %s"] = "обработчик набора завершился с ошибкой: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "команды:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - открыть настройки"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - показать или скрыть панель"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - закрепить или освободить панель"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - вернуть панель в центр"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <name>|r - применить набор (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <name>|r - сменить профиль"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - показать и сбросить рекорд скорости"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - показать или скрыть кнопку у мини-карты"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - проверить чары, гнёзда и уровень предметов"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [channel]|r - отправить сводку по снаряжению в чат"
L["panel shown."] = "панель показана."
L["panel hidden."] = "панель скрыта."
L["panel locked."] = "панель закреплена."
L["panel unlocked."] = "панель освобождена."
L["position reset."] = "положение сброшено."
L["applied the '%s' preset."] = "применён набор «%s»."
L["unknown preset. Available: %s"] = "неизвестный набор. Доступны: %s"
L["switched to profile '%s'."] = "выбран профиль «%s»."
L["profiles: %s"] = "профили: %s"
L["session speed record cleared."] = "рекорд скорости за сессию сброшен."
L["minimap button hidden."] = "кнопка у мини-карты скрыта."
L["minimap button shown."] = "кнопка у мини-карты показана."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "Основной атрибут"
L["Armor DR"] = "Броня (снижение урона)"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "Крит"
L["Haste"] = "Скорость"
L["Mast"] = "Иск."
L["Vers"] = "Унив."

L["a display setting could not be applied (%s)."] = "не удалось применить настройку отображения (%s)."
L["The game protects this value; see the panel itself."] = "Игра защищает это значение; смотрите саму панель."
L["Value"] = "Значение"
L["Rating"] = "Рейтинг"
L["Yards/sec"] = "Метров/сек."
L["Session peak"] = "Рекорд сессии"
L["Attribute"] = "Атрибут"
L["Drag to move  |  /sp for options"] = "Перетащите, чтобы двигать  |  /sp - настройки"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "Сила"
L["Agility"] = "Ловкость"
L["Stamina"] = "Выносливость"
L["Intellect"] = "Интеллект"
L["Mastery"] = "Искусность"
L["Versatility"] = "Универсальность"
L["Dodge"] = "Уворот"
L["Parry"] = "Парирование"
L["Block"] = "Блокирование"
L["Leech"] = "Вытягивание жизни"
L["Avoidance"] = "Уклонение"
L["Speed"] = "Скорость"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "Показать или скрыть панель"
L["Open the options"] = "Открыть настройки"
L["Lock or unlock the panel"] = "Закрепить или освободить панель"
L["Switch to the next profile"] = "Перейти к следующему профилю"
L["Run the gear audit"] = "Запустить проверку снаряжения"
L["only one profile exists."] = "существует только один профиль."

-- Diagnostics.lua
L["yes"] = "да"
L["no"] = "нет"
L["LibStub not present"] = "LibStub отсутствует"
L["absent"] = "отсутствует"
L["present (revision %s)"] = "присутствует (ревизия %s)"
L["not present in this client"] = "отсутствует в этом клиенте"
L["present, could not sample"] = "присутствует, проверить не удалось"
L["active (crit chance is protected)"] = "активна (шанс крита защищён)"
L["present but crit chance is readable"] = "присутствует, но шанс крита читается"
L["Locale"] = "Язык"
L["Class"] = "Класс"
L["Secret values"] = "Защищённые значения"
L["Profiles stored"] = "Сохранённых профилей"
L["Custom stat priority"] = "Свой приоритет характеристик"
L["enabled"] = "включена"
L["disabled"] = "выключена"
L["locked"] = "закреплена"
L["unlocked"] = "не закреплена"
L["auto width"] = "автоширина"
L["width %d"] = "ширина %d"
L["Position"] = "Положение"
L[" (substituted: not readable in this locale)"] = " (заменён: нечитаем в этом языке)"
L["Stat rows"] = "Строк характеристик"
L["%d shown of %d placed"] = "показано %d из %d размещённых"
L["StatPanel diagnostics"] = "Диагностика StatPanel"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "Ctrl-A - выделить всё, Ctrl-C - копировать. Вставьте это в сообщение об ошибке."

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "обновлён до %s. Что нового:"
L["  Full changelog: %s"] = "  Полный список изменений: %s"
L["Updated for World of Warcraft patch 12.1.0."] = "Обновлено для патча 12.1.0 World of Warcraft."
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "Горячие клавиши для показа, закрепления, смены профиля и проверки снаряжения."
L["New stats: attack power, spell power, health, mana and stagger."] = "Новые характеристики: сила атаки, сила заклинаний, здоровье, мана и расплата."
L["The $per token shows what one percent of a stat costs in rating."] = "Подстановка $per показывает, сколько рейтинга стоит один процент характеристики."
L["Gear durability and repair cost can now sit in the footer."] = "Прочность снаряжения и стоимость починки теперь можно вывести в нижнюю строку."
L["A Colorblind Safe preset, and precise X/Y position controls."] = "Набор для дальтоников и точные регуляторы положения по X и Y."
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug собирает всё нужное для отчёта об ошибке в одно копируемое окно."

-- Options.lua: anchor points and position
L["Top left"] = "Сверху слева"
L["Top"] = "Сверху"
L["Top right"] = "Сверху справа"
L["Bottom left"] = "Снизу слева"
L["Bottom"] = "Снизу"
L["Bottom right"] = "Снизу справа"
L["Anchor point"] = "Точка привязки"
L["Which corner of the panel the position below is measured from."] = "От какого угла панели отсчитывается положение ниже."
L["Anchored to screen"] = "Привязка к экрану"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "До какой точки экрана идёт отсчёт. Привязка к углу удержит панель на месте при смене разрешения."
L["Horizontal position"] = "Положение по горизонтали"
L["Vertical position"] = "Положение по вертикали"
L[" (not readable in this language)"] = " (нечитаем в этом языке)"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "Наименьшая прочность снаряжения"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "Худшая прочность среди надетых предметов, чтобы вы видели сломанную вещь, а не среднее."
L["Repair cost"] = "Стоимость починки"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "Игра может оценить починку только у торговца, поэтому до разговора с ним ничего не показывается."
L["Durability format"] = "Формат прочности"
L["Durability considered good"] = "Прочность считается хорошей"
L["Durability considered poor"] = "Прочность считается плохой"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "Палитра Окабэ-Ито, читаемая при красно-зелёном дальтонизме. С номерами приоритета."

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - показать диагностику для отчёта об ошибке"
L["diagnostics:"] = "диагностика:"

-- StatPanel.lua: new stat names
L["Attack Power"] = "Сила атаки"
L["Spell Power"] = "Сила заклинаний"
L["Health"] = "Здоровье"
L["Mana"] = "Мана"
L["Stagger"] = "Расплата"
