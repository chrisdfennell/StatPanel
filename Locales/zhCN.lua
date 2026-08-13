-- Locales/zhCN.lua (Simplified Chinese)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export zhCN`, then
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
--     Chinese too if a global ever disappears.
--
-- This locale could not ship before 2.5.0. The addon named Fonts\FRIZQT__.TTF
-- directly in eleven places; that file exists on the Simplified Chinese client
-- but carries Latin glyphs only, so every string here would have rendered as
-- empty boxes -- loading successfully, raising nothing, and showing nothing
-- readable. Media:UIFont() now asks the client for its own font instead.
--
-- NOT reviewed by a native speaker. Terminology follows the Simplified Chinese
-- client's own wording where it exists. Corrections are very welcome:
-- https://github.com/chrisdfennell/StatPanel/issues

local _, SP = ...
local L = SP.Locale("zhCN")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "仅显示在我的聊天框"
L["Say"] = "说"
L["Party"] = "小队"
L["Raid"] = "团队"
L["Instance"] = "副本"
L["Guild"] = "公会"
L["Officer"] = "官员"
L["Yell"] = "大喊"
L["Whisper"] = "密语"
L["iLvl %.2f (%.2f overall)"] = "装等 %.2f（总计 %.2f）"
L["iLvl %.2f"] = "装等 %.2f"
L["priority %s"] = "优先级 %s"
L["peak speed %.0f%%"] = "最高速度 %.0f%%"
L["%d missing enchant(s)"] = "缺少 %d 个附魔"
L["%d empty socket(s)"] = "%d 个空插槽"
L["%d/%d tier set"] = "套装 %d/%d"
L["You aren't in a group."] = "你不在小队中。"
L["You aren't in a raid."] = "你不在团队中。"
L["You aren't in a guild."] = "你不在公会中。"
L["hold on - you can announce again in %.0f seconds."] = "请稍候 —— %.0f 秒后才能再次通报。"
L["nothing to announce - enable some fields on the Announce page."] = "没有可通报的内容 —— 请在“通报”页面启用一些项目。"
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "已略过 %d 项数值：游戏保护了这些属性，无法发送到聊天框。"
L["%s Showing it here instead:"] = "%s 改为显示在此："
L["whisper needs a name: /sp announce whisper <name>"] = "密语需要目标名称：/sp announce whisper <名称>"
L["the game refused to send that message. Showing it here instead:"] = "游戏拒绝发送该消息。改为显示在此："

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "野外"
L["Delve"] = "地下堡"
L["Dungeon"] = "地下城"
L["Mythic+ dungeon"] = "史诗钥石地下城"
L["Arena"] = "竞技场"
L["Battleground"] = "战场"
L["Scenario"] = "场景战役"
L["switched to profile '%s' (%s rule)."] = "已切换到配置“%s”（%s 规则）。"

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "装备等级"
L["FPS"] = "帧数"
L["Spec"] = "专精"
L["Profile"] = "配置"
L["|cffffff00Left-click|r  open options"] = "|cffffff00左键|r  打开设置"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00右键|r  快捷菜单"
L["%.0f fps"] = "%.0f 帧"
L["%.0f fps  |  iLvl %.0f"] = "%.0f 帧  |  装等 %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "配置名称不能为空。"
L["A profile named '%s' already exists."] = "已存在名为“%s”的配置。"
L["The Default profile cannot be deleted."] = "Default 配置无法删除。"
L["No such profile."] = "没有这个配置。"
L["Nothing to import."] = "没有可导入的内容。"
L["That import string is too large to be a profile."] = "该导入字符串过大，不可能是一份配置。"
L["That doesn't look like a StatPanel export string."] = "这看起来不像 StatPanel 的导出字符串。"
L["The import string is corrupt."] = "导入字符串已损坏。"
L["Could not read the import string: %s"] = "无法读取导入字符串：%s"
L["The import string did not contain a profile."] = "导入字符串中没有配置。"

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "装备检查"
L["empty"] = "空"
L["no enchant"] = "无附魔"
L["%d rare gem(s)"] = "%d 颗稀有品质宝石"
L["lowest"] = "最低"
L["Equipped"] = "已装备"
L["Tier set    %d/%d"] = "套装    %d/%d"
L["%d item(s) not fully upgraded"] = "%d 件装备未升级到顶"
L["Everything is enchanted and socketed."] = "所有附魔和插槽都已完成。"
L["%d enchant(s)"] = "%d 个附魔"
L["%d socket(s)"] = "%d 个插槽"
L["%d empty slot(s)"] = "%d 个空栏位"
L["Missing: %s"] = "缺少：%s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "头部"
L["Neck"] = "颈部"
L["Shoulder"] = "肩部"
L["Back"] = "背部"
L["Chest"] = "胸部"
L["Wrist"] = "手腕"
L["Hands"] = "手"
L["Waist"] = "腰部"
L["Legs"] = "腿部"
L["Feet"] = "脚"
L["Ring 1"] = "戒指 1"
L["Ring 2"] = "戒指 2"
L["Trinket 1"] = "饰品 1"
L["Trinket 2"] = "饰品 2"
L["Main Hand"] = "主手"
L["Off Hand"] = "副手"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "无"
L["Outline"] = "描边"
L["Thick Outline"] = "粗描边"
L["Monochrome"] = "单色"
L["Monochrome Outline"] = "单色描边"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "显示面板"
L["Lock position"] = "锁定位置"
L["Show FPS"] = "显示帧数"
L["Apply preset"] = "应用预设"
L["Announce to"] = "通报到"
L["Audit my gear"] = "检查装备"
L["Open options"] = "打开设置"
L["Reset position"] = "重置位置"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "左对齐"
L["Center"] = "居中"
L["Right"] = "右对齐"
L["Proportional to value"] = "按数值比例"
L["Always full"] = "始终填满"
L["No fill (text only)"] = "不填充（仅文字）"
L["Per-stat colors"] = "各属性独立配色"
L["Class color"] = "职业颜色"
L["Single color"] = "单一颜色"
L["Value gradient"] = "按数值渐变"
L["Bars"] = "条状"
L["Text only"] = "仅文字"
L["Player name"] = "角色名称"
L["Specialization"] = "专精"
L["Custom text"] = "自定义文字"
L["Hidden"] = "隐藏"
L["Total effect (character sheet)"] = "总效果（与角色面板一致）"
L["Bonus from rating only"] = "仅等级值提供的加成"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "面板"
L["Enable StatPanel"] = "启用 StatPanel"
L["Master switch. Turning this off hides the panel entirely."] = "总开关。关闭后面板将完全隐藏。"
L["Stops the panel from being dragged."] = "禁止拖动面板。"
L["Keep on screen"] = "保持在屏幕内"
L["Prevents dragging the panel off the edge of the screen."] = "防止把面板拖出屏幕边缘。"
L["Scale"] = "缩放"
L["Opacity"] = "不透明度"
L["Frame layer"] = "框架层级"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "面板绘制所在的层级。若被其他插件遮挡，请调高。"
L["Update interval (seconds)"] = "刷新间隔（秒）"
L["How often values refresh. Higher values use less CPU."] = "数值刷新的频率。数值越大，占用的处理器资源越少。"
L["Stat values show"] = "属性数值显示"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "“总效果”与角色面板一致。“仅等级值加成”只显示装备等级值贡献的部分。"
L["Visibility"] = "显示条件"
L["Hide during combat"] = "战斗中隐藏"
L["Turning this on clears 'Show only during combat'."] = "启用此项会取消“仅战斗中显示”。"
L["Show only during combat"] = "仅战斗中显示"
L["Turning this on clears 'Hide during combat'."] = "启用此项会取消“战斗中隐藏”。"
L["Hide while dead"] = "死亡时隐藏"
L["Hide in vehicles"] = "载具中隐藏"
L["Hide in pet battles"] = "宠物对战中隐藏"
L["Hide inside instances"] = "副本内隐藏"
L["Turning this on clears 'Hide outside instances'."] = "启用此项会取消“副本外隐藏”。"
L["Hide outside instances"] = "副本外隐藏"
L["Turning this on clears 'Hide inside instances'."] = "启用此项会取消“副本内隐藏”。"
L["Mouseover fade"] = "鼠标悬停淡入"
L["Only show on mouseover"] = "仅在鼠标悬停时显示"
L["Fades the panel out until you hover over it."] = "在鼠标悬停之前淡出面板。"
L["Faded opacity"] = "淡出时的不透明度"
L["Fade duration (seconds)"] = "淡入淡出时长（秒）"
L["Show tooltips on hover"] = "悬停时显示提示"
L["Minimap and options"] = "小地图与设置"
L["Show the minimap button"] = "显示小地图按钮"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "左键打开本设置，右键打开快捷菜单。可沿小地图边缘拖动。"
L["Show a live preview while configuring"] = "配置时显示实时预览"
L["Docks the real panel beside this window so you can see changes as you make them."] = "把真实面板停靠在本窗口旁，改动即时可见。"
L["Reset peak speed"] = "重置最高速度"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "尺寸"
L["Auto-size width to content"] = "宽度自适应内容"
L["Grows and shrinks the panel to fit the widest row."] = "面板会按最宽的一行自动伸缩。"
L["Width"] = "宽度"
L["Minimum width (auto-size)"] = "最小宽度（自适应时）"
L["Side padding"] = "左右内边距"
L["Top padding"] = "上内边距"
L["Bottom padding"] = "下内边距"
L["Gap between sections"] = "分组之间的间距"
L["Section header spacing"] = "分组标题间距"
L["Set to 0 to remove section headers entirely."] = "设为 0 可完全去掉分组标题。"
L["Background"] = "背景"
L["Background texture"] = "背景材质"
L["Background color and transparency"] = "背景颜色与透明度"
L["Tile the background"] = "平铺背景"
L["Tile size"] = "平铺尺寸"
L["Border"] = "边框"
L["Border style"] = "边框样式"
L["Border color and transparency"] = "边框颜色与透明度"
L["Border thickness"] = "边框粗细"
L["Only affects pixel-style borders; textured borders use their own size."] = "仅影响像素边框；材质边框使用自身尺寸。"
L["Border inset"] = "边框内缩"
L["Title"] = "标题"
L["Show title"] = "显示标题"
L["Title shows"] = "标题内容"
L["Title alignment"] = "标题对齐"
L["Item level format"] = "装等格式"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "可用标记：$equipped、$overall、$name、$spec、$class、$level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "可用标记：$equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "装等小数位数"
L["Custom title text"] = "自定义标题文字"
L["Divider"] = "分隔线"
L["Show divider under title"] = "在标题下显示分隔线"
L["Divider color"] = "分隔线颜色"
L["Divider thickness"] = "分隔线粗细"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "行样式"
L["Draw rows as"] = "行的绘制方式"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "“条状”为每个属性绘制一条状态条。“仅文字”为每个属性绘制一行带色文字。"
L["Text alignment (text style)"] = "文字对齐（文字样式）"
L["Label/value separator (text style)"] = "名称与数值的分隔符（文字样式）"
L["Placed between the stat name and its value, e.g. ': '"] = "置于属性名称与数值之间，例如“：”"
L["Line height (text style)"] = "行高（文字样式）"
L["Bar appearance"] = "条的外观"
L["Bar texture"] = "条的材质"
L["Bar height"] = "条的高度"
L["Space between bars"] = "条之间的间距"
L["Horizontal inset"] = "水平内缩"
L["Bar opacity"] = "条的不透明度"
L["Fill from the right"] = "从右侧填充"
L["Bar colors"] = "条的颜色"
L["Color mode"] = "配色方式"
L["Per-stat colors are set on the Stats page."] = "各属性的颜色在“属性”页面设置。"
L["Gradient: low value"] = "渐变：低值端"
L["Gradient: high value"] = "渐变：高值端"
L["Bar background"] = "条的背景"
L["Track texture"] = "轨道材质"
L["Track color and transparency"] = "轨道颜色与透明度"
L["Tint track with the stat color"] = "用属性颜色为轨道着色"
L["Track tint opacity"] = "轨道着色不透明度"
L["Bar border"] = "条的边框"
L["Border color"] = "边框颜色"
L["Motion"] = "动画"
L["Animate value changes"] = "数值变化时播放动画"
L["Eases bars toward new values instead of snapping."] = "让条平滑过渡到新数值，而不是直接跳变。"
L["Animation speed"] = "动画速度"
L["Show a spark at the fill edge"] = "在填充边缘显示光点"
L["Spark color"] = "光点颜色"
L["Row text"] = "行内文字"
L["Show stat names"] = "显示属性名称"
L["Show values"] = "显示数值"
L["Color names with the stat color"] = "名称使用属性颜色"
L["Color values with the stat color"] = "数值使用属性颜色"
L["Number prioritized stats"] = "为优先级属性编号"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "在按优先级排序的分组中，为属性加上 1、2、3…… 前缀。"
L["Numbering format"] = "编号格式"
L["Name offset"] = "名称偏移"
L["Value offset"] = "数值偏移"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "分组标题"
L["Stat name"] = "属性名称"
L["Stat value"] = "属性数值"
L["Priority line"] = "优先级行"
L["Footer"] = "底栏"
L["Font"] = "字体"
L["Font face (all text)"] = "字体（全部文字）"
L["Drop shadow"] = "阴影"
L["Shadow color"] = "阴影颜色"
L["Shadow X offset"] = "阴影 X 偏移"
L["Shadow Y offset"] = "阴影 Y 偏移"
L["Per-element size and color"] = "各元素的字号与颜色"
L["Editing"] = "正在编辑"
L["Color"] = "颜色"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "若在“行与条”页面启用了按属性颜色着色，此处的名称与数值颜色将被覆盖。"

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "各属性设置"
L["Editing stat"] = "正在编辑属性"
L["Show this stat"] = "显示该属性"
L["Stat color"] = "属性颜色"
L["Use class color for this stat"] = "该属性使用职业颜色"
L["Display name (blank for default)"] = "显示名称（留空为默认）"
L["Value format"] = "数值格式"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "可用标记：$value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\n例如“$rating - $value%”会显示为“285 - 10.65%”。"
L["Decimal places"] = "小数位数"
L["Bar scale"] = "条的刻度"
L["Bar fill"] = "条的填充"
L["Value at a full bar"] = "条填满时的数值"
L["Grow the scale automatically"] = "自动扩展刻度"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "当属性超过上限时自动提高上限。对没有上限的驭空术速度很有用。"
L["Reset all stats"] = "重置所有属性"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "分组"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "分组按此顺序自上而下绘制。每个分组可以放入任意属性。"
L["Editing section"] = "正在编辑分组"
L["Section title"] = "分组标题"
L["Show this section"] = "显示该分组"
L["Show the section header"] = "显示分组标题"
L["Order by spec stat priority"] = "按专精属性优先级排序"
L["Re-sorts this section's stats to match your specialization's priority."] = "把该分组的属性重新排序，以匹配你的专精优先级。"
L["Header alignment"] = "标题对齐"
L["Move section up"] = "上移分组"
L["Move section down"] = "下移分组"
L["Stats in this section"] = "该分组中的属性"
L["Up"] = "上移"
L["Down"] = "下移"
L["Remove"] = "移除"
L["Add a stat to this section"] = "向该分组添加属性"
L["(every stat is already here)"] = "（所有属性都已在此）"
L["Reset sections"] = "重置分组"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "底栏"
L["Show the footer"] = "显示底栏"
L["Frames per second"] = "每秒帧数"
L["Home latency"] = "本地延迟"
L["World latency"] = "世界延迟"
L["Addon memory use"] = "插件内存占用"
L["Separator between entries"] = "条目之间的分隔符"
L["Formats"] = "格式"
L["FPS format"] = "帧数格式"
L["Home latency format"] = "本地延迟格式"
L["World latency format"] = "世界延迟格式"
L["Memory format"] = "内存格式"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "使用标准数字格式：%d 表示整数，%.1f 表示保留一位小数。"
L["Performance coloring"] = "性能着色"
L["Color by performance"] = "按性能着色"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "根据下方阈值把帧数和延迟显示为绿色、黄色或红色。"
L["Good"] = "良好"
L["Fair"] = "一般"
L["Poor"] = "较差"
L["FPS considered good"] = "视为良好的帧数"
L["FPS considered poor"] = "视为较差的帧数"
L["Latency considered good (ms)"] = "视为良好的延迟（毫秒）"
L["Latency considered poor (ms)"] = "视为较差的延迟（毫秒）"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "显示优先级链"
L["Separator"] = "分隔符"
L["Color each stat name"] = "为每个属性名称着色"
L["Prefix with the spec name"] = "在前面加上专精名称"
L["Priority for your current spec"] = "当前专精的优先级"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "内置顺序只是通用参考。准确答案请用模拟工具跑自己的角色，再填到这里。"
L["Current specialization: %s"] = "当前专精：%s"
L["unknown"] = "未知"
L["Priority %d"] = "优先级 %d"
L["Paste a stat weight string"] = "粘贴属性权重字符串"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "粘贴 Pawn 字符串（来自 Raidbots、模拟工具或属性站点），或直接写顺序，例如“精通 > 急速 > 暴击 > 全能”。StatPanel 会读取四项副属性，并为当前专精设定顺序。"
L["Weights or order"] = "权重或顺序"
L["Apply pasted weights"] = "应用粘贴的权重"
L["no active specialization to apply to."] = "没有可应用的当前专精。"
L["priority for %s set to %s."] = "已将 %s 的优先级设为 %s。"
L["your spec"] = "你的专精"
L["Use the built-in order"] = "使用内置顺序"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "预设"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "预设会覆盖当前配置中的外观设置。位置、显示条件和配置本身不受影响。"
L["Start over"] = "从头开始"
L["Reset this profile"] = "重置该配置"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "每个角色都会记住自己使用的配置，因此可以让小号共用一套外观，也可以各用各的。"
L["Active profile"] = "当前配置"
L["New profile name"] = "新配置名称"
L["Create"] = "创建"
L["Copy current"] = "复制当前配置"
L["Delete current"] = "删除当前配置"
L["Deleted profile '%s'."] = "已删除配置“%s”。"
L["Share"] = "分享"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "导出会生成一段可以发给别人的字符串。导入会覆盖下方填写的配置；若留空，则覆盖当前配置。"
L["Export string"] = "导出字符串"
L["Generate export"] = "生成导出字符串"
L["Import string"] = "导入字符串"
L["Import into profile (blank = active)"] = "导入到配置（留空为当前配置）"
L["Import"] = "导入"
L["Imported into profile '%s'."] = "已导入到配置“%s”。"

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "通报"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "把装备摘要发送到聊天框。绝不会自动发送 —— 只在你点击按钮、使用命令或右键菜单时才发送。"
L["Send to"] = "发送到"
L["Whisper to (for the Whisper channel)"] = "密语给（用于密语频道）"
L["Prefix"] = "前缀"
L["Include"] = "包含内容"
L["Stats"] = "属性"
L["Stat priority"] = "属性优先级"
L["Session peak speed"] = "本次登录最高速度"
L["Missing enchants and sockets"] = "缺少的附魔与插槽"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "游戏保护了大多数战斗属性，不允许任何插件把它们发送到聊天框，因此这些会被自动略过。装等、专精、速度和装备提醒都可以发送。若日后的补丁解除了某项属性的保护，它会自动开始出现，无需改动。"
L["Preview"] = "预览"
L["Announce now"] = "立即通报"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "已装备的装备"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "装备数据不受游戏保护，因此与战斗属性不同，这些内容可以完整读取。"
L["Refresh"] = "刷新"
L["Print report"] = "输出报告"
L["Average equipped item level %.2f.%s  %s"] = "已装备平均装等 %.2f。%s  %s"
L["  Tier set %d/%d."] = "  套装 %d/%d。"
L["Nothing missing."] = "没有缺失。"

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "（无规则）"
L["Automatic profile switching"] = "自动切换配置"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "规则按角色保存。内容规则优先于专精规则，因此你可以平时使用专精配置，同时在团队副本中强制换成另一套。留作“（无规则）”的项会被忽略。"
L["Switch profiles automatically"] = "自动切换配置"
L["By content"] = "按内容"
L["By specialization"] = "按专精"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "此处只列出当前专精。切换专精后再回来，即可为另一个专精设置规则。"
L["Profile for this specialization"] = "该专精使用的配置"
L["Apply rules now"] = "立即应用规则"
L["no rule matches your current spec or location."] = "没有规则匹配你当前的专精或所在地。"
L["already on '%s', the profile your rules call for."] = "已经在使用规则所要求的配置“%s”。"
L["Clear all rules"] = "清除所有规则"
L["cleared this character's automatic rules."] = "已清除该角色的自动规则。"

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "常规"
L["Rows & Bars"] = "行与条"
L["Fonts"] = "字体"
L["Priority"] = "优先级"
L["Gear"] = "装备"
L["Profiles"] = "配置"
L["Automation"] = "自动化"
L["Dark"] = "深色"
L["Grey"] = "灰色"
L["Light"] = "浅色"
L["Game"] = "游戏画面"
L["Background: %s"] = "背景：%s"
L["Live Preview"] = "实时预览"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "真实面板已停靠于此。拖动本窗口即可移动它；关闭设置后面板会回到原位。"
L["Type /sp for slash commands. Drag the panel itself to move it."] = "输入 /sp 查看命令。直接拖动面板即可移动。"

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "默认外观：扁平深色面板配彩色属性条。"
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "不用条。每个属性一行彩色文字：“精通：285 - 10.65%”。"
L["Thin headerless bars for a small footprint."] = "无标题的细条，占地极小。"
L["Blizzard textures and a tooltip border, to match the default UI."] = "暴雪材质配提示框边框，贴合默认界面。"
L["No background or border at all - just floating text and bars."] = "完全没有背景和边框 —— 只有悬浮的文字和条。"
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "极小的单色文字，无背景。安静地待在角落。"
L["High-contrast glow bars on near-black, with a value gradient."] = "近黑底色上的高对比发光条，带数值渐变。"
L["Warm parchment and gold, in keeping with the default UI art."] = "暖色羊皮纸与金色，呼应默认界面美术。"
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "偏防御：护甲、躲闪、招架、格挡和闪避排在最前。"
L["Big live speed readout with your session record, and little else."] = "大号实时速度显示与本次登录记录，其余从简。"
L["Secondary stats, item level and both latencies - what you check before a pull."] = "副属性、装等和两种延迟 —— 开怪前会看的东西。"
L["Cold blues and whites on deep navy."] = "深藏青底上的冷蓝与白。"
L["Warm reds and ambers on charcoal."] = "炭灰底上的暖红与琥珀。"
L["Every bar takes your class color. Clean and unfussy."] = "所有条都使用你的职业颜色。干净利落。"
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "大号粗体高对比文字。一眼就能看清。"
L["The smallest useful readout: four secondaries, nothing else."] = "最精简的可用显示：四项副属性，别无其他。"
L["Green-on-black monospace, like a console readout."] = "黑底绿字等宽体，像控制台输出。"
L["Throughput stats plus leech, with your primary attribute on top."] = "输出与治疗属性外加吸血，主属性置顶。"
L["Versatility first, with avoidance, dodge and speed alongside."] = "全能优先，旁边配上闪避、躲闪和速度。"
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "贴合 ElvUI：扁平深色面板、1 像素黑边、窄体字。"
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "流行的透明 ElvUI 风格：近黑玻璃感，发丝般的细边。"
L["preset hook failed: %s"] = "预设回调执行失败：%s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "命令："
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - 打开设置"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - 显示或隐藏面板"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - 锁定或解锁拖动"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - 把面板移回屏幕中央"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <name>|r - 应用预设（%s）"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <name>|r - 切换配置"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - 查看并清除本次登录的速度记录"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - 显示或隐藏小地图按钮"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - 检查附魔、插槽和装等"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [channel]|r - 把装备情况发到聊天框"
L["panel shown."] = "面板已显示。"
L["panel hidden."] = "面板已隐藏。"
L["panel locked."] = "面板已锁定。"
L["panel unlocked."] = "面板已解锁。"
L["position reset."] = "位置已重置。"
L["applied the '%s' preset."] = "已应用预设“%s”。"
L["unknown preset. Available: %s"] = "未知预设。可用：%s"
L["switched to profile '%s'."] = "已切换到配置“%s”。"
L["profiles: %s"] = "配置：%s"
L["session speed record cleared."] = "本次登录的速度记录已清除。"
L["minimap button hidden."] = "小地图按钮已隐藏。"
L["minimap button shown."] = "小地图按钮已显示。"

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "主属性"
L["Armor DR"] = "护甲减伤"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "暴击"
L["Haste"] = "急速"
L["Mast"] = "精通"
L["Vers"] = "全能"

L["a display setting could not be applied (%s)."] = "某项显示设置未能应用（%s）。"
L["The game protects this value; see the panel itself."] = "游戏保护了该数值；请直接看面板。"
L["Value"] = "数值"
L["Rating"] = "等级值"
L["Yards/sec"] = "码/秒"
L["Session peak"] = "本次最高"
L["Attribute"] = "属性"
L["Drag to move  |  /sp for options"] = "拖动可移动  |  /sp 打开设置"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "力量"
L["Agility"] = "敏捷"
L["Stamina"] = "耐力"
L["Intellect"] = "智力"
L["Mastery"] = "精通"
L["Versatility"] = "全能"
L["Dodge"] = "躲闪"
L["Parry"] = "招架"
L["Block"] = "格挡"
L["Leech"] = "吸血"
L["Avoidance"] = "闪避"
L["Speed"] = "速度"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "显示或隐藏面板"
L["Open the options"] = "打开设置"
L["Lock or unlock the panel"] = "锁定或解锁面板"
L["Switch to the next profile"] = "切换到下一个配置"
L["Run the gear audit"] = "运行装备检查"
L["only one profile exists."] = "只有一个配置。"

-- Diagnostics.lua
L["yes"] = "是"
L["no"] = "否"
L["LibStub not present"] = "没有 LibStub"
L["absent"] = "不存在"
L["present (revision %s)"] = "存在（修订版 %s）"
L["not present in this client"] = "此客户端中不存在"
L["present, could not sample"] = "存在，但无法采样"
L["active (crit chance is protected)"] = "已生效（暴击几率受保护）"
L["present but crit chance is readable"] = "存在，但暴击几率可读"
L["Locale"] = "语言"
L["Class"] = "职业"
L["Secret values"] = "受保护数值"
L["Profiles stored"] = "已保存的配置"
L["Custom stat priority"] = "自定义属性优先级"
L["enabled"] = "已启用"
L["disabled"] = "已禁用"
L["locked"] = "已锁定"
L["unlocked"] = "未锁定"
L["auto width"] = "自动宽度"
L["width %d"] = "宽度 %d"
L["Position"] = "位置"
L[" (substituted: not readable in this locale)"] = "（已替换：该语言无法显示）"
L["Stat rows"] = "属性行"
L["%d shown of %d placed"] = "已放置 %2$d 行，显示 %1$d 行"
L["StatPanel diagnostics"] = "StatPanel 诊断信息"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "按 Ctrl-A 全选，Ctrl-C 复制。把它粘贴到你的问题报告里。"

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "已更新至 %s。本版本新增："
L["  Full changelog: %s"] = "  完整更新日志：%s"
L["Updated for World of Warcraft patch 12.1.0."] = "已更新以适配《魔兽世界》12.1.0 补丁。"
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "为显示、锁定、切换配置和装备检查提供的快捷键。"
L["New stats: attack power, spell power, health, mana and stagger."] = "新属性：攻击强度、法术强度、生命值、法力值和醉拳。"
L["The $per token shows what one percent of a stat costs in rating."] = "$per 标记显示一个百分点的属性需要多少等级值。"
L["Gear durability and repair cost can now sit in the footer."] = "装备耐久度和修理费用现在可以放进底栏。"
L["A Colorblind Safe preset, and precise X/Y position controls."] = "新增色盲友好预设，以及精确的 X/Y 位置控制。"
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug 把问题报告所需的全部信息收进一个可复制的框里。"

-- Options.lua: anchor points and position
L["Top left"] = "左上"
L["Top"] = "上"
L["Top right"] = "右上"
L["Bottom left"] = "左下"
L["Bottom"] = "下"
L["Bottom right"] = "右下"
L["Anchor point"] = "锚点"
L["Which corner of the panel the position below is measured from."] = "下方的位置从面板的哪个角开始测量。"
L["Anchored to screen"] = "屏幕锚点"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "测量到屏幕上的哪一点。锚定到某个角，可以在分辨率变化时让面板留在原处。"
L["Horizontal position"] = "水平位置"
L["Vertical position"] = "垂直位置"
L[" (not readable in this language)"] = "（该语言无法显示）"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "最低装备耐久度"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "所有已装备栏位中最差的耐久度，让你看到损坏的那件而不是平均值。"
L["Repair cost"] = "修理费用"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "游戏只有在商人处才能算出修理价格，所以在与商人对话之前不会显示任何内容。"
L["Durability format"] = "耐久度格式"
L["Durability considered good"] = "视为良好的耐久度"
L["Durability considered poor"] = "视为较差的耐久度"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "冈部-伊藤配色，红绿色盲也能分辨。已开启排序编号。"

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - 显示可粘贴到问题报告的诊断信息"
L["diagnostics:"] = "诊断信息："

-- StatPanel.lua: new stat names
L["Attack Power"] = "攻击强度"
L["Spell Power"] = "法术强度"
L["Health"] = "生命值"
L["Mana"] = "法力值"
L["Stagger"] = "醉拳"
