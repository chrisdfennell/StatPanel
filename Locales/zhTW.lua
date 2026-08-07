-- Locales/zhTW.lua (Traditional Chinese)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export zhTW`, then
-- translated by hand. Run the linter after editing: it catches the two mistakes
-- the SP.L fallback hides -- a mistyped key (renders English forever, nobody
-- notices) and a translation that drops or reorders a format specifier.
--
-- Written out rather than converted from zhCN. The two clients differ in more
-- than script: Versatility is 臨機應變 here and 全能 there, Crit is 爆擊 not
-- 暴擊, Leech is 汲取 not 吸血, and a character-by-character conversion would
-- produce text that is readable but wrong in exactly the words that matter.
--
-- Rules followed here:
--   * $tokens, |cff...|r color codes, /sp subcommands and %-specifiers are
--     copied verbatim -- the code parses them.
--   * Media names ("Flat", "Pixel", "Friz Quadrata") are absent on purpose:
--     they are lookup keys and LibSharedMedia registration names, not display
--     text, and translating them would break saved profiles.
--   * Stat and gear-slot names are translated even though SP.Global normally
--     serves them from Blizzard's own GlobalStrings, so the fallback path is
--     Chinese too if a global ever disappears.
--
-- This locale could not ship before 2.5.0. The addon named Fonts\FRIZQT__.TTF
-- directly in eleven places; that file exists on the Traditional Chinese client
-- but carries Latin glyphs only, so every string here would have rendered as
-- empty boxes. Media:UIFont() now asks the client for its own font instead.
--
-- NOT reviewed by a native speaker. Terminology follows the Traditional Chinese
-- client's own wording where it exists. Corrections are very welcome:
-- https://github.com/chrisdfennell/StatPanel/issues

local _, SP = ...
local L = SP.Locale("zhTW")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "僅顯示在我的聊天視窗"
L["Say"] = "說話"
L["Party"] = "隊伍"
L["Raid"] = "團隊"
L["Instance"] = "地城"
L["Guild"] = "公會"
L["Officer"] = "幹部"
L["Yell"] = "大喊"
L["Whisper"] = "密語"
L["iLvl %.2f (%.2f overall)"] = "裝等 %.2f（總計 %.2f）"
L["iLvl %.2f"] = "裝等 %.2f"
L["priority %s"] = "優先順序 %s"
L["peak speed %.0f%%"] = "最高速度 %.0f%%"
L["%d missing enchant(s)"] = "缺少 %d 個附魔"
L["%d empty socket(s)"] = "%d 個空插槽"
L["%d/%d tier set"] = "套裝 %d/%d"
L["You aren't in a group."] = "你不在隊伍中。"
L["You aren't in a raid."] = "你不在團隊中。"
L["You aren't in a guild."] = "你不在公會中。"
L["hold on - you can announce again in %.0f seconds."] = "請稍候 —— %.0f 秒後才能再次通報。"
L["nothing to announce - enable some fields on the Announce page."] = "沒有可通報的內容 —— 請在「通報」頁面啟用一些項目。"
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "已略過 %d 項數值：遊戲保護了這些屬性，無法傳送到聊天視窗。"
L["%s Showing it here instead:"] = "%s 改為顯示於此："
L["whisper needs a name: /sp announce whisper <name>"] = "密語需要目標名稱：/sp announce whisper <名稱>"
L["the game refused to send that message. Showing it here instead:"] = "遊戲拒絕傳送該訊息。改為顯示於此："

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "野外"
L["Delve"] = "地底堡"
L["Dungeon"] = "地城"
L["Mythic+ dungeon"] = "傳奇鑰石地城"
L["Arena"] = "競技場"
L["Battleground"] = "戰場"
L["Scenario"] = "劇情戰役"
L["switched to profile '%s' (%s rule)."] = "已切換到設定檔「%s」（%s 規則）。"

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "裝備等級"
L["FPS"] = "幀數"
L["Spec"] = "專精"
L["Profile"] = "設定檔"
L["|cffffff00Left-click|r  open options"] = "|cffffff00左鍵|r  開啟選項"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00右鍵|r  快捷選單"
L["%.0f fps"] = "%.0f 幀"
L["%.0f fps  |  iLvl %.0f"] = "%.0f 幀  |  裝等 %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "設定檔名稱不能空白。"
L["A profile named '%s' already exists."] = "已有名為「%s」的設定檔。"
L["The Default profile cannot be deleted."] = "Default 設定檔無法刪除。"
L["No such profile."] = "沒有這個設定檔。"
L["Nothing to import."] = "沒有可匯入的內容。"
L["That import string is too large to be a profile."] = "該匯入字串過大，不可能是一份設定檔。"
L["That doesn't look like a StatPanel export string."] = "這看起來不像 StatPanel 的匯出字串。"
L["The import string is corrupt."] = "匯入字串已損毀。"
L["Could not read the import string: %s"] = "無法讀取匯入字串：%s"
L["The import string did not contain a profile."] = "匯入字串中沒有設定檔。"

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "裝備檢查"
L["empty"] = "空的"
L["no enchant"] = "無附魔"
L["%d rare gem(s)"] = "%d 顆稀有品質寶石"
L["lowest"] = "最低"
L["Equipped"] = "已裝備"
L["Tier set    %d/%d"] = "套裝    %d/%d"
L["%d item(s) not fully upgraded"] = "%d 件裝備尚未升到頂"
L["Everything is enchanted and socketed."] = "所有附魔與插槽都已完成。"
L["%d enchant(s)"] = "%d 個附魔"
L["%d socket(s)"] = "%d 個插槽"
L["%d empty slot(s)"] = "%d 個空欄位"
L["Missing: %s"] = "缺少：%s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "頭部"
L["Neck"] = "頸部"
L["Shoulder"] = "肩部"
L["Back"] = "背部"
L["Chest"] = "胸部"
L["Wrist"] = "手腕"
L["Hands"] = "手"
L["Waist"] = "腰部"
L["Legs"] = "腿部"
L["Feet"] = "腳"
L["Ring 1"] = "戒指 1"
L["Ring 2"] = "戒指 2"
L["Trinket 1"] = "飾品 1"
L["Trinket 2"] = "飾品 2"
L["Main Hand"] = "主手"
L["Off Hand"] = "副手"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "無"
L["Outline"] = "外框"
L["Thick Outline"] = "粗外框"
L["Monochrome"] = "單色"
L["Monochrome Outline"] = "單色外框"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "顯示面板"
L["Lock position"] = "鎖定位置"
L["Show FPS"] = "顯示幀數"
L["Apply preset"] = "套用預設"
L["Announce to"] = "通報至"
L["Audit my gear"] = "檢查裝備"
L["Open options"] = "開啟選項"
L["Reset position"] = "重設位置"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "靠左"
L["Center"] = "置中"
L["Right"] = "靠右"
L["Proportional to value"] = "依數值比例"
L["Always full"] = "永遠全滿"
L["No fill (text only)"] = "不填滿（僅文字）"
L["Per-stat colors"] = "各屬性獨立配色"
L["Class color"] = "職業顏色"
L["Single color"] = "單一顏色"
L["Value gradient"] = "依數值漸層"
L["Bars"] = "長條"
L["Text only"] = "僅文字"
L["Player name"] = "角色名稱"
L["Specialization"] = "專精"
L["Custom text"] = "自訂文字"
L["Hidden"] = "隱藏"
L["Total effect (character sheet)"] = "總效果（與角色面板一致）"
L["Bonus from rating only"] = "僅等級加成"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "面板"
L["Enable StatPanel"] = "啟用 StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "總開關。關閉後面板會完全隱藏。"
L["Stops the panel from being dragged."] = "禁止拖曳面板。"
L["Keep on screen"] = "保持在螢幕內"
L["Prevents dragging the panel off the edge of the screen."] = "避免把面板拖出螢幕邊緣。"
L["Scale"] = "縮放"
L["Opacity"] = "不透明度"
L["Frame layer"] = "框架層級"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "面板繪製所在的層級。若被其他插件遮住，請調高。"
L["Update interval (seconds)"] = "更新間隔（秒）"
L["How often values refresh. Higher values use less CPU."] = "數值更新的頻率。數值越大，佔用的處理器資源越少。"
L["Stat values show"] = "屬性數值顯示"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "「總效果」與角色面板一致。「僅等級加成」只顯示裝備等級所貢獻的部分。"
L["Visibility"] = "顯示條件"
L["Hide during combat"] = "戰鬥中隱藏"
L["Turning this on clears 'Show only during combat'."] = "啟用此項會取消「僅戰鬥中顯示」。"
L["Show only during combat"] = "僅戰鬥中顯示"
L["Turning this on clears 'Hide during combat'."] = "啟用此項會取消「戰鬥中隱藏」。"
L["Hide while dead"] = "死亡時隱藏"
L["Hide in vehicles"] = "乘坐載具時隱藏"
L["Hide in pet battles"] = "寵物對戰中隱藏"
L["Hide inside instances"] = "地城內隱藏"
L["Turning this on clears 'Hide outside instances'."] = "啟用此項會取消「地城外隱藏」。"
L["Hide outside instances"] = "地城外隱藏"
L["Turning this on clears 'Hide inside instances'."] = "啟用此項會取消「地城內隱藏」。"
L["Mouseover fade"] = "滑鼠移過淡入"
L["Only show on mouseover"] = "僅在滑鼠移過時顯示"
L["Fades the panel out until you hover over it."] = "在滑鼠移過之前淡出面板。"
L["Faded opacity"] = "淡出時的不透明度"
L["Fade duration (seconds)"] = "淡入淡出時間（秒）"
L["Show tooltips on hover"] = "滑鼠移過時顯示提示"
L["Minimap and options"] = "小地圖與選項"
L["Show the minimap button"] = "顯示小地圖按鈕"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "左鍵開啟本選項，右鍵開啟快捷選單。可沿小地圖邊緣拖曳。"
L["Show a live preview while configuring"] = "設定時顯示即時預覽"
L["Docks the real panel beside this window so you can see changes as you make them."] = "把真實面板停靠在本視窗旁，改動立即可見。"
L["Reset peak speed"] = "重設最高速度"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "尺寸"
L["Auto-size width to content"] = "寬度自動配合內容"
L["Grows and shrinks the panel to fit the widest row."] = "面板會依最寬的一行自動伸縮。"
L["Width"] = "寬度"
L["Minimum width (auto-size)"] = "最小寬度（自動調整時）"
L["Side padding"] = "左右內距"
L["Top padding"] = "上方內距"
L["Bottom padding"] = "下方內距"
L["Gap between sections"] = "區塊之間的間距"
L["Section header spacing"] = "區塊標題間距"
L["Set to 0 to remove section headers entirely."] = "設為 0 可完全移除區塊標題。"
L["Background"] = "背景"
L["Background texture"] = "背景材質"
L["Background color and transparency"] = "背景顏色與透明度"
L["Tile the background"] = "平鋪背景"
L["Tile size"] = "平鋪尺寸"
L["Border"] = "邊框"
L["Border style"] = "邊框樣式"
L["Border color and transparency"] = "邊框顏色與透明度"
L["Border thickness"] = "邊框粗細"
L["Only affects pixel-style borders; textured borders use their own size."] = "僅影響像素邊框；材質邊框使用自身尺寸。"
L["Border inset"] = "邊框內縮"
L["Title"] = "標題"
L["Show title"] = "顯示標題"
L["Title shows"] = "標題內容"
L["Title alignment"] = "標題對齊"
L["Item level format"] = "裝等格式"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "可用標記：$equipped、$overall、$name、$spec、$class、$level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "可用標記：$equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "裝等小數位數"
L["Custom title text"] = "自訂標題文字"
L["Divider"] = "分隔線"
L["Show divider under title"] = "在標題下方顯示分隔線"
L["Divider color"] = "分隔線顏色"
L["Divider thickness"] = "分隔線粗細"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "列樣式"
L["Draw rows as"] = "列的繪製方式"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "「長條」為每個屬性繪製一條狀態列。「僅文字」為每個屬性繪製一行帶色文字。"
L["Text alignment (text style)"] = "文字對齊（文字樣式）"
L["Label/value separator (text style)"] = "名稱與數值的分隔符（文字樣式）"
L["Placed between the stat name and its value, e.g. ': '"] = "置於屬性名稱與數值之間，例如「：」"
L["Line height (text style)"] = "行高（文字樣式）"
L["Bar appearance"] = "長條外觀"
L["Bar texture"] = "長條材質"
L["Bar height"] = "長條高度"
L["Space between bars"] = "長條之間的間距"
L["Horizontal inset"] = "水平內縮"
L["Bar opacity"] = "長條不透明度"
L["Fill from the right"] = "由右側填滿"
L["Bar colors"] = "長條顏色"
L["Color mode"] = "配色方式"
L["Per-stat colors are set on the Stats page."] = "各屬性的顏色在「屬性」頁面設定。"
L["Gradient: low value"] = "漸層：低值端"
L["Gradient: high value"] = "漸層：高值端"
L["Bar background"] = "長條背景"
L["Track texture"] = "軌道材質"
L["Track color and transparency"] = "軌道顏色與透明度"
L["Tint track with the stat color"] = "以屬性顏色為軌道著色"
L["Track tint opacity"] = "軌道著色不透明度"
L["Bar border"] = "長條邊框"
L["Border color"] = "邊框顏色"
L["Motion"] = "動態"
L["Animate value changes"] = "數值變化時播放動畫"
L["Eases bars toward new values instead of snapping."] = "讓長條平滑移動到新數值，而不是直接跳動。"
L["Animation speed"] = "動畫速度"
L["Show a spark at the fill edge"] = "在填滿邊緣顯示光點"
L["Spark color"] = "光點顏色"
L["Row text"] = "列內文字"
L["Show stat names"] = "顯示屬性名稱"
L["Show values"] = "顯示數值"
L["Color names with the stat color"] = "名稱使用屬性顏色"
L["Color values with the stat color"] = "數值使用屬性顏色"
L["Number prioritized stats"] = "為優先順序屬性編號"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "在依優先順序排列的區塊中，為屬性加上 1、2、3…… 前綴。"
L["Numbering format"] = "編號格式"
L["Name offset"] = "名稱位移"
L["Value offset"] = "數值位移"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "區塊標題"
L["Stat name"] = "屬性名稱"
L["Stat value"] = "屬性數值"
L["Priority line"] = "優先順序列"
L["Footer"] = "底列"
L["Font"] = "字型"
L["Font face (all text)"] = "字型（全部文字）"
L["Drop shadow"] = "陰影"
L["Shadow color"] = "陰影顏色"
L["Shadow X offset"] = "陰影 X 位移"
L["Shadow Y offset"] = "陰影 Y 位移"
L["Per-element size and color"] = "各元素的字級與顏色"
L["Editing"] = "正在編輯"
L["Color"] = "顏色"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "若在「列與長條」頁面啟用了依屬性顏色著色，此處的名稱與數值顏色會被覆蓋。"

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "各屬性設定"
L["Editing stat"] = "正在編輯屬性"
L["Show this stat"] = "顯示此屬性"
L["Stat color"] = "屬性顏色"
L["Use class color for this stat"] = "此屬性使用職業顏色"
L["Display name (blank for default)"] = "顯示名稱（留空為預設）"
L["Value format"] = "數值格式"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "可用標記：$value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\n例如「$rating - $value%」會顯示為「285 - 10.65%」。"
L["Decimal places"] = "小數位數"
L["Bar scale"] = "長條刻度"
L["Bar fill"] = "長條填滿"
L["Value at a full bar"] = "長條全滿時的數值"
L["Grow the scale automatically"] = "自動擴大刻度"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "當屬性超過上限時自動提高上限。對沒有上限的翔空術速度很有用。"
L["Reset all stats"] = "重設所有屬性"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "區塊"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "區塊會依此順序由上而下繪製。每個區塊都可以放入任意屬性。"
L["Editing section"] = "正在編輯區塊"
L["Section title"] = "區塊標題"
L["Show this section"] = "顯示此區塊"
L["Show the section header"] = "顯示區塊標題"
L["Order by spec stat priority"] = "依專精屬性優先順序排列"
L["Re-sorts this section's stats to match your specialization's priority."] = "把此區塊的屬性重新排序，以符合你的專精優先順序。"
L["Header alignment"] = "標題對齊"
L["Move section up"] = "區塊上移"
L["Move section down"] = "區塊下移"
L["Stats in this section"] = "此區塊中的屬性"
L["Up"] = "上移"
L["Down"] = "下移"
L["Remove"] = "移除"
L["Add a stat to this section"] = "在此區塊加入屬性"
L["(every stat is already here)"] = "（所有屬性都已在此）"
L["Reset sections"] = "重設區塊"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "底列"
L["Show the footer"] = "顯示底列"
L["Frames per second"] = "每秒幀數"
L["Home latency"] = "本地延遲"
L["World latency"] = "世界延遲"
L["Addon memory use"] = "插件記憶體用量"
L["Separator between entries"] = "項目之間的分隔符"
L["Formats"] = "格式"
L["FPS format"] = "幀數格式"
L["Home latency format"] = "本地延遲格式"
L["World latency format"] = "世界延遲格式"
L["Memory format"] = "記憶體格式"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "使用標準數字格式：%d 表示整數，%.1f 表示保留一位小數。"
L["Performance coloring"] = "效能著色"
L["Color by performance"] = "依效能著色"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "依下方門檻把幀數與延遲顯示為綠色、黃色或紅色。"
L["Good"] = "良好"
L["Fair"] = "普通"
L["Poor"] = "不佳"
L["FPS considered good"] = "視為良好的幀數"
L["FPS considered poor"] = "視為不佳的幀數"
L["Latency considered good (ms)"] = "視為良好的延遲（毫秒）"
L["Latency considered poor (ms)"] = "視為不佳的延遲（毫秒）"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "顯示優先順序串"
L["Separator"] = "分隔符"
L["Color each stat name"] = "為每個屬性名稱著色"
L["Prefix with the spec name"] = "在前方加上專精名稱"
L["Priority for your current spec"] = "目前專精的優先順序"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "內建順序只是通用參考。準確答案請用模擬工具跑自己的角色，再填到這裡。"
L["Current specialization: %s"] = "目前專精：%s"
L["unknown"] = "未知"
L["Priority %d"] = "優先順序 %d"
L["Paste a stat weight string"] = "貼上屬性權重字串"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "貼上 Pawn 字串（來自 Raidbots、模擬工具或屬性網站），或直接寫順序，例如「精通 > 加速 > 爆擊 > 臨機應變」。StatPanel 會讀取四項次要屬性，並為目前專精設定順序。"
L["Weights or order"] = "權重或順序"
L["Apply pasted weights"] = "套用貼上的權重"
L["no active specialization to apply to."] = "沒有可套用的目前專精。"
L["priority for %s set to %s."] = "已將 %s 的優先順序設為 %s。"
L["your spec"] = "你的專精"
L["Use the built-in order"] = "使用內建順序"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "預設"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "預設會覆蓋目前設定檔中的外觀設定。位置、顯示條件與設定檔本身不受影響。"
L["Start over"] = "從頭開始"
L["Reset this profile"] = "重設此設定檔"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "每個角色都會記住自己使用的設定檔，因此可以讓分身共用一套外觀，也可以各用各的。"
L["Active profile"] = "目前設定檔"
L["New profile name"] = "新設定檔名稱"
L["Create"] = "建立"
L["Copy current"] = "複製目前設定檔"
L["Delete current"] = "刪除目前設定檔"
L["Deleted profile '%s'."] = "已刪除設定檔「%s」。"
L["Share"] = "分享"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "匯出會產生一段可以傳給別人的字串。匯入會覆蓋下方填寫的設定檔；若留空，則覆蓋目前設定檔。"
L["Export string"] = "匯出字串"
L["Generate export"] = "產生匯出字串"
L["Import string"] = "匯入字串"
L["Import into profile (blank = active)"] = "匯入到設定檔（留空為目前設定檔）"
L["Import"] = "匯入"
L["Imported into profile '%s'."] = "已匯入到設定檔「%s」。"

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "通報"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "把裝備摘要傳送到聊天視窗。絕不會自動傳送 —— 只在你按下按鈕、使用指令或右鍵選單時才傳送。"
L["Send to"] = "傳送至"
L["Whisper to (for the Whisper channel)"] = "密語對象（用於密語頻道）"
L["Prefix"] = "前綴"
L["Include"] = "包含內容"
L["Stats"] = "屬性"
L["Stat priority"] = "屬性優先順序"
L["Session peak speed"] = "本次登入最高速度"
L["Missing enchants and sockets"] = "缺少的附魔與插槽"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "遊戲保護了大多數戰鬥屬性，不允許任何插件把它們傳送到聊天視窗，因此這些會被自動略過。裝等、專精、速度與裝備提醒都可以傳送。若日後的更新解除了某項屬性的保護，它會自動開始出現，無需改動。"
L["Preview"] = "預覽"
L["Announce now"] = "立即通報"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "已裝備的裝備"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "裝備資料不受遊戲保護，因此與戰鬥屬性不同，這些內容可以完整讀取。"
L["Refresh"] = "重新整理"
L["Print report"] = "輸出報告"
L["Average equipped item level %.2f.%s  %s"] = "已裝備平均裝等 %.2f。%s  %s"
L["  Tier set %d/%d."] = "  套裝 %d/%d。"
L["Nothing missing."] = "沒有缺漏。"

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "（無規則）"
L["Automatic profile switching"] = "自動切換設定檔"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "規則依角色儲存。內容規則優先於專精規則，因此你可以平常使用專精設定檔，同時在團隊副本中強制換成另一套。留為「（無規則）」的項目會被忽略。"
L["Switch profiles automatically"] = "自動切換設定檔"
L["By content"] = "依內容"
L["By specialization"] = "依專精"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "此處只列出目前專精。切換專精後再回來，即可為另一個專精設定規則。"
L["Profile for this specialization"] = "此專精使用的設定檔"
L["Apply rules now"] = "立即套用規則"
L["no rule matches your current spec or location."] = "沒有規則符合你目前的專精或所在地。"
L["already on '%s', the profile your rules call for."] = "已經在使用規則所要求的設定檔「%s」。"
L["Clear all rules"] = "清除所有規則"
L["cleared this character's automatic rules."] = "已清除此角色的自動規則。"

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "一般"
L["Rows & Bars"] = "列與長條"
L["Fonts"] = "字型"
L["Priority"] = "優先順序"
L["Gear"] = "裝備"
L["Profiles"] = "設定檔"
L["Automation"] = "自動化"
L["Dark"] = "深色"
L["Grey"] = "灰色"
L["Light"] = "淺色"
L["Game"] = "遊戲畫面"
L["Background: %s"] = "背景：%s"
L["Live Preview"] = "即時預覽"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "真實面板已停靠於此。拖曳本視窗即可移動它；關閉選項後面板會回到原位。"
L["Type /sp for slash commands. Drag the panel itself to move it."] = "輸入 /sp 查看指令。直接拖曳面板即可移動。"

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "預設外觀：扁平深色面板配彩色屬性長條。"
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "不用長條。每個屬性一行彩色文字：「精通：285 - 10.65%」。"
L["Thin headerless bars for a small footprint."] = "無標題的細長條，佔位極小。"
L["Blizzard textures and a tooltip border, to match the default UI."] = "暴雪材質配提示框邊框，貼合預設介面。"
L["No background or border at all - just floating text and bars."] = "完全沒有背景與邊框 —— 只有懸浮的文字與長條。"
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "極小的單色文字，無背景。安靜地待在角落。"
L["High-contrast glow bars on near-black, with a value gradient."] = "近黑底色上的高對比發光長條，帶數值漸層。"
L["Warm parchment and gold, in keeping with the default UI art."] = "暖色羊皮紙與金色，呼應預設介面美術。"
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "偏防禦：護甲、閃躲、招架、格擋與迴避排在最前。"
L["Big live speed readout with your session record, and little else."] = "大字即時速度顯示與本次登入紀錄，其餘從簡。"
L["Secondary stats, item level and both latencies - what you check before a pull."] = "次要屬性、裝等與兩種延遲 —— 開怪前會看的東西。"
L["Cold blues and whites on deep navy."] = "深藏青底上的冷藍與白。"
L["Warm reds and ambers on charcoal."] = "炭灰底上的暖紅與琥珀。"
L["Every bar takes your class color. Clean and unfussy."] = "所有長條都使用你的職業顏色。乾淨俐落。"
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "大字粗體高對比文字。一眼就能看清。"
L["The smallest useful readout: four secondaries, nothing else."] = "最精簡的可用顯示：四項次要屬性，別無其他。"
L["Green-on-black monospace, like a console readout."] = "黑底綠字等寬體，像主控台輸出。"
L["Throughput stats plus leech, with your primary attribute on top."] = "輸出與治療屬性外加汲取，主屬性置頂。"
L["Versatility first, with avoidance, dodge and speed alongside."] = "臨機應變優先，旁邊配上迴避、閃躲與速度。"
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "貼合 ElvUI：扁平深色面板、1 像素黑邊、窄體字。"
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "流行的透明 ElvUI 風格：近黑玻璃感，髮絲般的細邊。"
L["preset hook failed: %s"] = "預設回呼執行失敗：%s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "指令："
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - 開啟選項"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - 顯示或隱藏面板"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - 鎖定或解除拖曳"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - 把面板移回螢幕中央"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <name>|r - 套用預設（%s）"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <name>|r - 切換設定檔"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - 查看並清除本次登入的速度紀錄"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - 顯示或隱藏小地圖按鈕"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - 檢查附魔、插槽與裝等"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [channel]|r - 把裝備狀況發到聊天視窗"
L["panel shown."] = "面板已顯示。"
L["panel hidden."] = "面板已隱藏。"
L["panel locked."] = "面板已鎖定。"
L["panel unlocked."] = "面板已解除鎖定。"
L["position reset."] = "位置已重設。"
L["applied the '%s' preset."] = "已套用預設「%s」。"
L["unknown preset. Available: %s"] = "未知的預設。可用：%s"
L["switched to profile '%s'."] = "已切換到設定檔「%s」。"
L["profiles: %s"] = "設定檔：%s"
L["session speed record cleared."] = "本次登入的速度紀錄已清除。"
L["minimap button hidden."] = "小地圖按鈕已隱藏。"
L["minimap button shown."] = "小地圖按鈕已顯示。"

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "主屬性"
L["Armor DR"] = "護甲減傷"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "爆擊"
L["Haste"] = "加速"
L["Mast"] = "精通"
L["Vers"] = "臨機"

L["a display setting could not be applied (%s)."] = "某項顯示設定未能套用（%s）。"
L["The game protects this value; see the panel itself."] = "遊戲保護了該數值；請直接看面板。"
L["Value"] = "數值"
L["Rating"] = "等級"
L["Yards/sec"] = "碼/秒"
L["Session peak"] = "本次最高"
L["Attribute"] = "屬性"
L["Drag to move  |  /sp for options"] = "拖曳可移動  |  /sp 開啟選項"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "力量"
L["Agility"] = "敏捷"
L["Stamina"] = "耐力"
L["Intellect"] = "智力"
L["Mastery"] = "精通"
L["Versatility"] = "臨機應變"
L["Dodge"] = "閃躲"
L["Parry"] = "招架"
L["Block"] = "格擋"
L["Leech"] = "汲取"
L["Avoidance"] = "迴避"
L["Speed"] = "速度"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "顯示或隱藏面板"
L["Open the options"] = "開啟選項"
L["Lock or unlock the panel"] = "鎖定或解除鎖定面板"
L["Switch to the next profile"] = "切換到下一個設定檔"
L["Run the gear audit"] = "執行裝備檢查"
L["only one profile exists."] = "只有一個設定檔。"

-- Diagnostics.lua
L["yes"] = "是"
L["no"] = "否"
L["LibStub not present"] = "沒有 LibStub"
L["absent"] = "不存在"
L["present (revision %s)"] = "存在（修訂版 %s）"
L["not present in this client"] = "此客戶端中不存在"
L["present, could not sample"] = "存在，但無法取樣"
L["active (crit chance is protected)"] = "已生效（爆擊率受保護）"
L["present but crit chance is readable"] = "存在，但爆擊率可讀取"
L["Locale"] = "語言"
L["Class"] = "職業"
L["Secret values"] = "受保護數值"
L["Profiles stored"] = "已儲存的設定檔"
L["Custom stat priority"] = "自訂屬性優先順序"
L["enabled"] = "已啟用"
L["disabled"] = "已停用"
L["locked"] = "已鎖定"
L["unlocked"] = "未鎖定"
L["auto width"] = "自動寬度"
L["width %d"] = "寬度 %d"
L["Position"] = "位置"
L[" (substituted: not readable in this locale)"] = "（已替換：該語言無法顯示）"
L["Stat rows"] = "屬性列"
L["%d shown of %d placed"] = "已放置 %2$d 列，顯示 %1$d 列"
L["StatPanel diagnostics"] = "StatPanel 診斷資訊"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "按 Ctrl-A 全選，Ctrl-C 複製。把它貼到你的問題回報中。"

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "已更新至 %s。本版本新增："
L["  Full changelog: %s"] = "  完整更新紀錄：%s"
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "為顯示、鎖定、切換設定檔與裝備檢查提供的快捷鍵。"
L["New stats: attack power, spell power, health, mana and stagger."] = "新屬性：攻擊強度、法術強度、生命值、法力值與醉拳。"
L["The $per token shows what one percent of a stat costs in rating."] = "$per 標記顯示一個百分點的屬性需要多少等級值。"
L["Gear durability and repair cost can now sit in the footer."] = "裝備耐久度與修理費用現在可以放進底列。"
L["A Colorblind Safe preset, and precise X/Y position controls."] = "新增色盲友善預設，以及精確的 X/Y 位置控制。"
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug 把問題回報所需的全部資訊收進一個可複製的方框裡。"

-- Options.lua: anchor points and position
L["Top left"] = "左上"
L["Top"] = "上"
L["Top right"] = "右上"
L["Bottom left"] = "左下"
L["Bottom"] = "下"
L["Bottom right"] = "右下"
L["Anchor point"] = "錨點"
L["Which corner of the panel the position below is measured from."] = "下方的位置從面板的哪個角開始測量。"
L["Anchored to screen"] = "螢幕錨點"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "測量到螢幕上的哪一點。錨定到某個角，可以在解析度變化時讓面板留在原處。"
L["Horizontal position"] = "水平位置"
L["Vertical position"] = "垂直位置"
L[" (not readable in this language)"] = "（該語言無法顯示）"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "最低裝備耐久度"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "所有已裝備欄位中最差的耐久度，讓你看到損壞的那件而不是平均值。"
L["Repair cost"] = "修理費用"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "遊戲只有在商人處才能算出修理價格，所以在與商人對話之前不會顯示任何內容。"
L["Durability format"] = "耐久度格式"
L["Durability considered good"] = "視為良好的耐久度"
L["Durability considered poor"] = "視為不佳的耐久度"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "岡部-伊藤配色，紅綠色盲也能分辨。已開啟排序編號。"

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - 顯示可貼到問題回報的診斷資訊"
L["diagnostics:"] = "診斷資訊："

-- StatPanel.lua: new stat names
L["Attack Power"] = "攻擊強度"
L["Spell Power"] = "法術強度"
L["Health"] = "生命值"
L["Mana"] = "法力值"
L["Stagger"] = "醉拳"
