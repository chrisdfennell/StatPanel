-- Locales/koKR.lua (Korean)
--
-- Generated as a stub with `pwsh -File tools\locale-lint.ps1 -Export koKR`, then
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
--     Korean too if a global ever disappears.
--
-- This locale could not ship before 2.5.0. The addon named Fonts\FRIZQT__.TTF
-- directly in eleven places; that file exists on the Korean client but carries
-- Latin glyphs only, so every string here would have rendered as empty boxes --
-- loading successfully, raising nothing, and showing nothing readable.
-- Media:UIFont() now asks the client for its own font instead.
--
-- NOT reviewed by a native speaker. Terminology follows the Korean client's
-- own wording where it exists. Corrections are very welcome:
-- https://github.com/chrisdfennell/StatPanel/issues

local _, SP = ...
local L = SP.Locale("koKR")

--------------------------------------------------------------------------------
-- Announce.lua
--------------------------------------------------------------------------------
L["Print to my chat only"] = "내 대화창에만 표시"
L["Say"] = "일반"
L["Party"] = "파티"
L["Raid"] = "공격대"
L["Instance"] = "인스턴스"
L["Guild"] = "길드"
L["Officer"] = "장교"
L["Yell"] = "외침"
L["Whisper"] = "귓속말"
L["iLvl %.2f (%.2f overall)"] = "아이템 레벨 %.2f (전체 %.2f)"
L["iLvl %.2f"] = "아이템 레벨 %.2f"
L["priority %s"] = "우선순위 %s"
L["peak speed %.0f%%"] = "최고 속도 %.0f%%"
L["%d missing enchant(s)"] = "마법부여 누락 %d개"
L["%d empty socket(s)"] = "빈 홈 %d개"
L["%d/%d tier set"] = "티어 세트 %d/%d"
L["You aren't in a group."] = "파티에 속해 있지 않습니다."
L["You aren't in a raid."] = "공격대에 속해 있지 않습니다."
L["You aren't in a guild."] = "길드에 속해 있지 않습니다."
L["hold on - you can announce again in %.0f seconds."] = "잠시만 기다리세요 - %.0f초 후에 다시 알릴 수 있습니다."
L["nothing to announce - enable some fields on the Announce page."] = "알릴 내용이 없습니다 - 알림 페이지에서 항목을 켜 주세요."
L["%d value(s) left out: the game protects those stats, so they cannot be sent to chat."] = "%d개 값이 제외되었습니다: 게임이 해당 능력치를 보호하므로 대화창으로 보낼 수 없습니다."
L["%s Showing it here instead:"] = "%s 대신 여기에 표시합니다:"
L["whisper needs a name: /sp announce whisper <name>"] = "귓속말에는 이름이 필요합니다: /sp announce whisper <이름>"
L["the game refused to send that message. Showing it here instead:"] = "게임이 해당 메시지 전송을 거부했습니다. 대신 여기에 표시합니다:"

--------------------------------------------------------------------------------
-- AutoProfile.lua
--------------------------------------------------------------------------------
L["Open world"] = "일반 지역"
L["Delve"] = "구렁"
L["Dungeon"] = "던전"
L["Mythic+ dungeon"] = "쐐기돌 던전"
L["Arena"] = "투기장"
L["Battleground"] = "전장"
L["Scenario"] = "시나리오"
L["switched to profile '%s' (%s rule)."] = "'%s' 프로필로 전환했습니다 (%s 규칙)."

--------------------------------------------------------------------------------
-- Broker.lua
--------------------------------------------------------------------------------
L["Item level"] = "아이템 레벨"
L["FPS"] = "FPS"
L["Spec"] = "전문화"
L["Profile"] = "프로필"
L["|cffffff00Left-click|r  open options"] = "|cffffff00좌클릭|r  설정 열기"
L["|cffffff00Right-click|r  quick menu"] = "|cffffff00우클릭|r  빠른 메뉴"
L["%.0f fps"] = "%.0f fps"
L["%.0f fps  |  iLvl %.0f"] = "%.0f fps  |  아이템 %.0f"

--------------------------------------------------------------------------------
-- Config.lua
--------------------------------------------------------------------------------
L["Profile name cannot be empty."] = "프로필 이름은 비워 둘 수 없습니다."
L["A profile named '%s' already exists."] = "'%s' 프로필이 이미 있습니다."
L["The Default profile cannot be deleted."] = "Default 프로필은 삭제할 수 없습니다."
L["No such profile."] = "그런 프로필이 없습니다."
L["Nothing to import."] = "가져올 내용이 없습니다."
L["That import string is too large to be a profile."] = "가져오기 문자열이 프로필이라기에는 너무 큽니다."
L["That doesn't look like a StatPanel export string."] = "StatPanel 내보내기 문자열이 아닌 것 같습니다."
L["The import string is corrupt."] = "가져오기 문자열이 손상되었습니다."
L["Could not read the import string: %s"] = "가져오기 문자열을 읽을 수 없습니다: %s"
L["The import string did not contain a profile."] = "가져오기 문자열에 프로필이 없습니다."

--------------------------------------------------------------------------------
-- Gear.lua
--------------------------------------------------------------------------------
L["gear audit"] = "장비 점검"
L["empty"] = "비어 있음"
L["no enchant"] = "마법부여 없음"
L["%d rare gem(s)"] = "귀한 보석 %d개"
L["lowest"] = "최저"
L["Equipped"] = "착용 중"
L["Tier set    %d/%d"] = "티어 세트    %d/%d"
L["%d item(s) not fully upgraded"] = "완전히 강화되지 않은 아이템 %d개"
L["Everything is enchanted and socketed."] = "모든 마법부여와 홈이 채워져 있습니다."
L["%d enchant(s)"] = "마법부여 %d개"
L["%d socket(s)"] = "홈 %d개"
L["%d empty slot(s)"] = "빈 칸 %d개"
L["Missing: %s"] = "누락: %s"

-- Gear slots. Normally supplied by Blizzard's paper-doll globals; these are the
-- fallback if one of those globals ever goes away.
L["Head"] = "머리"
L["Neck"] = "목"
L["Shoulder"] = "어깨"
L["Back"] = "등"
L["Chest"] = "가슴"
L["Wrist"] = "손목"
L["Hands"] = "손"
L["Waist"] = "허리"
L["Legs"] = "다리"
L["Feet"] = "발"
L["Ring 1"] = "반지 1"
L["Ring 2"] = "반지 2"
L["Trinket 1"] = "장신구 1"
L["Trinket 2"] = "장신구 2"
L["Main Hand"] = "주장비"
L["Off Hand"] = "보조장비"

--------------------------------------------------------------------------------
-- Media.lua (display names only -- the `value` side stays English)
--------------------------------------------------------------------------------
L["None"] = "없음"
L["Outline"] = "외곽선"
L["Thick Outline"] = "굵은 외곽선"
L["Monochrome"] = "단색"
L["Monochrome Outline"] = "단색 외곽선"

--------------------------------------------------------------------------------
-- Menu.lua
--------------------------------------------------------------------------------
L["Show panel"] = "패널 표시"
L["Lock position"] = "위치 고정"
L["Show FPS"] = "FPS 표시"
L["Apply preset"] = "사전 설정 적용"
L["Announce to"] = "알릴 대상"
L["Audit my gear"] = "장비 점검"
L["Open options"] = "설정 열기"
L["Reset position"] = "위치 초기화"

--------------------------------------------------------------------------------
-- Options.lua: dropdown values
--------------------------------------------------------------------------------
L["Left"] = "왼쪽"
L["Center"] = "가운데"
L["Right"] = "오른쪽"
L["Proportional to value"] = "값에 비례"
L["Always full"] = "항상 가득"
L["No fill (text only)"] = "채우지 않음 (글자만)"
L["Per-stat colors"] = "능력치별 색상"
L["Class color"] = "직업 색상"
L["Single color"] = "단일 색상"
L["Value gradient"] = "값에 따른 그라데이션"
L["Bars"] = "막대"
L["Text only"] = "글자만"
L["Player name"] = "캐릭터 이름"
L["Specialization"] = "전문화"
L["Custom text"] = "사용자 지정 문구"
L["Hidden"] = "숨김"
L["Total effect (character sheet)"] = "전체 효과 (캐릭터 창 기준)"
L["Bonus from rating only"] = "평점에 의한 보너스만"

--------------------------------------------------------------------------------
-- Options.lua: General page
--------------------------------------------------------------------------------
L["Panel"] = "패널"
L["Enable StatPanel"] = "StatPanel 사용"
L["Master switch. Turning this off hides the panel entirely."] = "전체 스위치입니다. 끄면 패널이 완전히 숨겨집니다."
L["Stops the panel from being dragged."] = "패널을 끌어서 옮길 수 없게 합니다."
L["Keep on screen"] = "화면 안에 유지"
L["Prevents dragging the panel off the edge of the screen."] = "패널을 화면 밖으로 끌어내지 못하게 합니다."
L["Scale"] = "크기"
L["Opacity"] = "불투명도"
L["Frame layer"] = "프레임 계층"
L["Which layer the panel draws on. Raise it if another addon covers the panel."] = "패널이 그려지는 계층입니다. 다른 애드온이 패널을 가리면 높이세요."
L["Update interval (seconds)"] = "갱신 주기 (초)"
L["How often values refresh. Higher values use less CPU."] = "값을 얼마나 자주 갱신할지입니다. 값이 클수록 CPU를 덜 씁니다."
L["Stat values show"] = "능력치 값 표시 기준"
L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."] = "'전체 효과'는 캐릭터 창과 같습니다. '평점에 의한 보너스'는 장비 평점이 기여한 몫만 보여줍니다."
L["Visibility"] = "표시 조건"
L["Hide during combat"] = "전투 중 숨김"
L["Turning this on clears 'Show only during combat'."] = "이 항목을 켜면 '전투 중에만 표시'가 해제됩니다."
L["Show only during combat"] = "전투 중에만 표시"
L["Turning this on clears 'Hide during combat'."] = "이 항목을 켜면 '전투 중 숨김'이 해제됩니다."
L["Hide while dead"] = "사망 시 숨김"
L["Hide in vehicles"] = "탈것 조종 중 숨김"
L["Hide in pet battles"] = "애완동물 대전 중 숨김"
L["Hide inside instances"] = "인스턴스 안에서 숨김"
L["Turning this on clears 'Hide outside instances'."] = "이 항목을 켜면 '인스턴스 밖에서 숨김'이 해제됩니다."
L["Hide outside instances"] = "인스턴스 밖에서 숨김"
L["Turning this on clears 'Hide inside instances'."] = "이 항목을 켜면 '인스턴스 안에서 숨김'이 해제됩니다."
L["Mouseover fade"] = "마우스오버 페이드"
L["Only show on mouseover"] = "마우스를 올렸을 때만 표시"
L["Fades the panel out until you hover over it."] = "마우스를 올리기 전까지 패널을 흐리게 합니다."
L["Faded opacity"] = "흐릴 때 불투명도"
L["Fade duration (seconds)"] = "페이드 시간 (초)"
L["Show tooltips on hover"] = "마우스를 올리면 툴팁 표시"
L["Minimap and options"] = "미니맵과 설정"
L["Show the minimap button"] = "미니맵 버튼 표시"
L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."] = "좌클릭은 이 설정을, 우클릭은 빠른 메뉴를 엽니다. 미니맵 가장자리를 따라 끌어 옮길 수 있습니다."
L["Show a live preview while configuring"] = "설정 중 실시간 미리보기"
L["Docks the real panel beside this window so you can see changes as you make them."] = "실제 패널을 이 창 옆에 붙여, 바꾸는 즉시 결과를 볼 수 있게 합니다."
L["Reset peak speed"] = "최고 속도 초기화"

--------------------------------------------------------------------------------
-- Options.lua: Appearance
--------------------------------------------------------------------------------
L["Size"] = "크기"
L["Auto-size width to content"] = "내용에 맞춰 너비 자동 조절"
L["Grows and shrinks the panel to fit the widest row."] = "가장 넓은 줄에 맞춰 패널이 늘어나고 줄어듭니다."
L["Width"] = "너비"
L["Minimum width (auto-size)"] = "최소 너비 (자동 조절 시)"
L["Side padding"] = "좌우 여백"
L["Top padding"] = "위쪽 여백"
L["Bottom padding"] = "아래쪽 여백"
L["Gap between sections"] = "구역 사이 간격"
L["Section header spacing"] = "구역 머리글 간격"
L["Set to 0 to remove section headers entirely."] = "0으로 두면 구역 머리글이 완전히 사라집니다."
L["Background"] = "배경"
L["Background texture"] = "배경 텍스처"
L["Background color and transparency"] = "배경 색상과 투명도"
L["Tile the background"] = "배경 타일 반복"
L["Tile size"] = "타일 크기"
L["Border"] = "테두리"
L["Border style"] = "테두리 스타일"
L["Border color and transparency"] = "테두리 색상과 투명도"
L["Border thickness"] = "테두리 두께"
L["Only affects pixel-style borders; textured borders use their own size."] = "픽셀 스타일 테두리에만 적용됩니다. 텍스처 테두리는 자체 크기를 씁니다."
L["Border inset"] = "테두리 안쪽 여백"
L["Title"] = "제목"
L["Show title"] = "제목 표시"
L["Title shows"] = "제목 내용"
L["Title alignment"] = "제목 정렬"
L["Item level format"] = "아이템 레벨 형식"
L["Tokens: $equipped, $overall, $name, $spec, $class, $level"] = "토큰: $equipped, $overall, $name, $spec, $class, $level"
L["Tokens: $equipped  $overall  $name  $spec  $class  $level"] = "토큰: $equipped  $overall  $name  $spec  $class  $level"
L["Item level decimals"] = "아이템 레벨 소수 자릿수"
L["Custom title text"] = "사용자 지정 제목"
L["Divider"] = "구분선"
L["Show divider under title"] = "제목 아래 구분선 표시"
L["Divider color"] = "구분선 색상"
L["Divider thickness"] = "구분선 두께"

--------------------------------------------------------------------------------
-- Options.lua: Rows & Bars page
--------------------------------------------------------------------------------
L["Row style"] = "줄 스타일"
L["Draw rows as"] = "줄 표시 방식"
L["Bars draw a status bar per stat. Text only draws a single colored line per stat."] = "'막대'는 능력치마다 상태 막대를 그립니다. '글자만'은 능력치마다 색이 있는 한 줄을 그립니다."
L["Text alignment (text style)"] = "글자 정렬 (글자 스타일)"
L["Label/value separator (text style)"] = "이름과 값 구분자 (글자 스타일)"
L["Placed between the stat name and its value, e.g. ': '"] = "능력치 이름과 값 사이에 들어갑니다. 예: ': '"
L["Line height (text style)"] = "줄 높이 (글자 스타일)"
L["Bar appearance"] = "막대 모양"
L["Bar texture"] = "막대 텍스처"
L["Bar height"] = "막대 높이"
L["Space between bars"] = "막대 사이 간격"
L["Horizontal inset"] = "가로 안쪽 여백"
L["Bar opacity"] = "막대 불투명도"
L["Fill from the right"] = "오른쪽부터 채우기"
L["Bar colors"] = "막대 색상"
L["Color mode"] = "색상 방식"
L["Per-stat colors are set on the Stats page."] = "능력치별 색상은 능력치 페이지에서 설정합니다."
L["Gradient: low value"] = "그라데이션: 낮은 값"
L["Gradient: high value"] = "그라데이션: 높은 값"
L["Bar background"] = "막대 배경"
L["Track texture"] = "트랙 텍스처"
L["Track color and transparency"] = "트랙 색상과 투명도"
L["Tint track with the stat color"] = "트랙을 능력치 색상으로 물들이기"
L["Track tint opacity"] = "트랙 색조 불투명도"
L["Bar border"] = "막대 테두리"
L["Border color"] = "테두리 색상"
L["Motion"] = "움직임"
L["Animate value changes"] = "값 변화에 애니메이션 적용"
L["Eases bars toward new values instead of snapping."] = "막대가 새 값으로 튀지 않고 부드럽게 이동합니다."
L["Animation speed"] = "애니메이션 속도"
L["Show a spark at the fill edge"] = "채워진 끝에 불꽃 표시"
L["Spark color"] = "불꽃 색상"
L["Row text"] = "줄 글자"
L["Show stat names"] = "능력치 이름 표시"
L["Show values"] = "값 표시"
L["Color names with the stat color"] = "이름을 능력치 색상으로"
L["Color values with the stat color"] = "값을 능력치 색상으로"
L["Number prioritized stats"] = "우선순위 능력치에 번호 매기기"
L["Prefixes stats in a priority-ordered section with 1, 2, 3..."] = "우선순위로 정렬된 구역의 능력치 앞에 1, 2, 3... 을 붙입니다."
L["Numbering format"] = "번호 형식"
L["Name offset"] = "이름 위치 보정"
L["Value offset"] = "값 위치 보정"

--------------------------------------------------------------------------------
-- Options.lua: Fonts page
--------------------------------------------------------------------------------
L["Section header"] = "구역 머리글"
L["Stat name"] = "능력치 이름"
L["Stat value"] = "능력치 값"
L["Priority line"] = "우선순위 줄"
L["Footer"] = "하단 줄"
L["Font"] = "글꼴"
L["Font face (all text)"] = "글꼴 (모든 글자)"
L["Drop shadow"] = "그림자"
L["Shadow color"] = "그림자 색상"
L["Shadow X offset"] = "그림자 X 오프셋"
L["Shadow Y offset"] = "그림자 Y 오프셋"
L["Per-element size and color"] = "요소별 크기와 색상"
L["Editing"] = "편집 중"
L["Color"] = "색상"
L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."] = "'줄과 막대' 페이지에서 능력치 색상 적용을 켜면 이름과 값 색상은 무시됩니다."

--------------------------------------------------------------------------------
-- Options.lua: Stats page
--------------------------------------------------------------------------------
L["Per-stat settings"] = "능력치별 설정"
L["Editing stat"] = "편집 중인 능력치"
L["Show this stat"] = "이 능력치 표시"
L["Stat color"] = "능력치 색상"
L["Use class color for this stat"] = "이 능력치에 직업 색상 사용"
L["Display name (blank for default)"] = "표시 이름 (비우면 기본값)"
L["Value format"] = "값 형식"
L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."] = "토큰: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\n예: '$rating - $value%' 는 '285 - 10.65%' 로 표시됩니다."
L["Decimal places"] = "소수 자릿수"
L["Bar scale"] = "막대 눈금"
L["Bar fill"] = "막대 채우기"
L["Value at a full bar"] = "막대가 가득 찰 때의 값"
L["Grow the scale automatically"] = "눈금 자동 확장"
L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."] = "능력치가 상한을 넘으면 상한을 올립니다. 상한이 없는 하늘탈것 속도에 유용합니다."
L["Reset all stats"] = "모든 능력치 초기화"

--------------------------------------------------------------------------------
-- Options.lua: Sections page
--------------------------------------------------------------------------------
L["Sections"] = "구역"
L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."] = "구역은 이 순서대로 위에서 아래로 그려집니다. 각 구역에는 원하는 능력치를 자유롭게 담을 수 있습니다."
L["Editing section"] = "편집 중인 구역"
L["Section title"] = "구역 제목"
L["Show this section"] = "이 구역 표시"
L["Show the section header"] = "구역 머리글 표시"
L["Order by spec stat priority"] = "전문화 우선순위대로 정렬"
L["Re-sorts this section's stats to match your specialization's priority."] = "이 구역의 능력치를 전문화 우선순위에 맞게 다시 정렬합니다."
L["Header alignment"] = "머리글 정렬"
L["Move section up"] = "구역 위로"
L["Move section down"] = "구역 아래로"
L["Stats in this section"] = "이 구역의 능력치"
L["Up"] = "위로"
L["Down"] = "아래로"
L["Remove"] = "제거"
L["Add a stat to this section"] = "이 구역에 능력치 추가"
L["(every stat is already here)"] = "(모든 능력치가 이미 있습니다)"
L["Reset sections"] = "구역 초기화"

--------------------------------------------------------------------------------
-- Options.lua: Footer page
--------------------------------------------------------------------------------
L["Footer line"] = "하단 줄"
L["Show the footer"] = "하단 줄 표시"
L["Frames per second"] = "초당 프레임"
L["Home latency"] = "홈 지연시간"
L["World latency"] = "월드 지연시간"
L["Addon memory use"] = "애드온 메모리 사용량"
L["Separator between entries"] = "항목 사이 구분자"
L["Formats"] = "형식"
L["FPS format"] = "FPS 형식"
L["Home latency format"] = "홈 지연시간 형식"
L["World latency format"] = "월드 지연시간 형식"
L["Memory format"] = "메모리 형식"
L["These use standard number formats: %d for a whole number, %.1f for one decimal."] = "표준 숫자 형식을 씁니다: %d 는 정수, %.1f 는 소수점 한 자리입니다."
L["Performance coloring"] = "성능 색상"
L["Color by performance"] = "성능에 따라 색칠"
L["Turns FPS and latency green, yellow or red depending on the thresholds below."] = "아래 기준에 따라 FPS와 지연시간을 초록, 노랑, 빨강으로 표시합니다."
L["Good"] = "좋음"
L["Fair"] = "보통"
L["Poor"] = "나쁨"
L["FPS considered good"] = "좋음으로 볼 FPS"
L["FPS considered poor"] = "나쁨으로 볼 FPS"
L["Latency considered good (ms)"] = "좋음으로 볼 지연시간 (ms)"
L["Latency considered poor (ms)"] = "나쁨으로 볼 지연시간 (ms)"

--------------------------------------------------------------------------------
-- Options.lua: Priority page
--------------------------------------------------------------------------------
L["Show the priority chain"] = "우선순위 사슬 표시"
L["Separator"] = "구분자"
L["Color each stat name"] = "능력치 이름마다 색칠"
L["Prefix with the spec name"] = "앞에 전문화 이름 붙이기"
L["Priority for your current spec"] = "현재 전문화의 우선순위"
L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."] = "내장된 순서는 일반적인 기준일 뿐입니다. 정확한 답은 본인 캐릭터를 시뮬레이션해서 얻은 뒤 여기에 넣으세요."
L["Current specialization: %s"] = "현재 전문화: %s"
L["unknown"] = "알 수 없음"
L["Priority %d"] = "우선순위 %d"
L["Paste a stat weight string"] = "능력치 가중치 문자열 붙여넣기"
L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."] = "Pawn 문자열(Raidbots, 시뮬레이션, 능력치 사이트 등)이나 '특화 > 가속 > 치명 > 유연' 같은 단순한 순서를 붙여넣으세요. StatPanel이 이차 능력치 네 개를 읽어 현재 전문화의 순서를 정합니다."
L["Weights or order"] = "가중치 또는 순서"
L["Apply pasted weights"] = "붙여넣은 가중치 적용"
L["no active specialization to apply to."] = "적용할 활성 전문화가 없습니다."
L["priority for %s set to %s."] = "%s의 우선순위를 %s(으)로 설정했습니다."
L["your spec"] = "현재 전문화"
L["Use the built-in order"] = "내장 순서 사용"

--------------------------------------------------------------------------------
-- Options.lua: Presets and Profiles pages
--------------------------------------------------------------------------------
L["Presets"] = "사전 설정"
L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."] = "사전 설정은 현재 프로필의 외형 설정을 덮어씁니다. 위치, 표시 조건, 프로필은 그대로 둡니다."
L["Start over"] = "처음부터"
L["Reset this profile"] = "이 프로필 초기화"
L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."] = "캐릭터마다 사용하는 프로필을 기억하므로, 부캐끼리 같은 모습을 쓰거나 각자 다르게 둘 수 있습니다."
L["Active profile"] = "사용 중인 프로필"
L["New profile name"] = "새 프로필 이름"
L["Create"] = "만들기"
L["Copy current"] = "현재 프로필 복사"
L["Delete current"] = "현재 프로필 삭제"
L["Deleted profile '%s'."] = "'%s' 프로필을 삭제했습니다."
L["Share"] = "공유"
L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."] = "내보내기는 다른 사람에게 붙여넣어 줄 수 있는 문자열을 만듭니다. 가져오기는 아래에 적은 프로필을, 비워 두면 사용 중인 프로필을 덮어씁니다."
L["Export string"] = "내보내기 문자열"
L["Generate export"] = "내보내기 문자열 생성"
L["Import string"] = "가져오기 문자열"
L["Import into profile (blank = active)"] = "가져올 프로필 (비우면 사용 중인 프로필)"
L["Import"] = "가져오기"
L["Imported into profile '%s'."] = "'%s' 프로필로 가져왔습니다."

--------------------------------------------------------------------------------
-- Options.lua: Announce page
--------------------------------------------------------------------------------
L["Announce"] = "알림"
L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."] = "장비 요약을 대화창으로 보냅니다. 자동으로 보내는 일은 없으며, 버튼이나 명령어, 우클릭 메뉴를 쓸 때만 전송됩니다."
L["Send to"] = "보낼 곳"
L["Whisper to (for the Whisper channel)"] = "귓속말 대상 (귓속말 채널용)"
L["Prefix"] = "접두사"
L["Include"] = "포함할 항목"
L["Stats"] = "능력치"
L["Stat priority"] = "능력치 우선순위"
L["Session peak speed"] = "이번 접속 최고 속도"
L["Missing enchants and sockets"] = "누락된 마법부여와 홈"
L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."] = "게임이 대부분의 전투 능력치를 보호하여 어떤 애드온도 대화창으로 보낼 수 없으므로 자동으로 제외됩니다. 아이템 레벨, 전문화, 속도, 장비 경고는 모두 전송됩니다. 앞으로 패치에서 보호가 풀리면 별도 수정 없이 표시되기 시작합니다."
L["Preview"] = "미리보기"
L["Announce now"] = "지금 알리기"

--------------------------------------------------------------------------------
-- Options.lua: Gear page
--------------------------------------------------------------------------------
L["Equipped gear"] = "착용 장비"
L["Item data is not protected by the game, so unlike the combat stats this can be read in full."] = "아이템 정보는 게임이 보호하지 않으므로, 전투 능력치와 달리 온전히 읽을 수 있습니다."
L["Refresh"] = "새로 고침"
L["Print report"] = "보고서 출력"
L["Average equipped item level %.2f.%s  %s"] = "착용 아이템 평균 레벨 %.2f.%s  %s"
L["  Tier set %d/%d."] = "  티어 세트 %d/%d."
L["Nothing missing."] = "누락된 것이 없습니다."

--------------------------------------------------------------------------------
-- Options.lua: Automation page
--------------------------------------------------------------------------------
L["(no rule)"] = "(규칙 없음)"
L["Automatic profile switching"] = "프로필 자동 전환"
L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."] = "규칙은 캐릭터마다 저장됩니다. 콘텐츠 규칙이 전문화 규칙보다 우선하므로, 평소에는 전문화 프로필을 쓰면서 공격대 안에서만 다른 프로필을 강제할 수 있습니다. '(규칙 없음)'인 항목은 무시됩니다."
L["Switch profiles automatically"] = "프로필 자동 전환 사용"
L["By content"] = "콘텐츠 기준"
L["By specialization"] = "전문화 기준"
L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."] = "현재 전문화만 표시됩니다. 다른 전문화 규칙을 정하려면 전환한 뒤 다시 오세요."
L["Profile for this specialization"] = "이 전문화의 프로필"
L["Apply rules now"] = "지금 규칙 적용"
L["no rule matches your current spec or location."] = "현재 전문화나 위치에 맞는 규칙이 없습니다."
L["already on '%s', the profile your rules call for."] = "규칙이 요구하는 '%s' 프로필을 이미 쓰고 있습니다."
L["Clear all rules"] = "모든 규칙 지우기"
L["cleared this character's automatic rules."] = "이 캐릭터의 자동 규칙을 지웠습니다."

--------------------------------------------------------------------------------
-- Options.lua: page names and the preview window
--------------------------------------------------------------------------------
L["General"] = "일반"
L["Rows & Bars"] = "줄과 막대"
L["Fonts"] = "글꼴"
L["Priority"] = "우선순위"
L["Gear"] = "장비"
L["Profiles"] = "프로필"
L["Automation"] = "자동화"
L["Dark"] = "어두움"
L["Grey"] = "회색"
L["Light"] = "밝음"
L["Game"] = "게임"
L["Background: %s"] = "배경: %s"
L["Live Preview"] = "실시간 미리보기"
L["The real panel, docked here. Drag this window to move it; the panel returns home when you close the options."] = "실제 패널이 여기에 붙어 있습니다. 이 창을 끌면 패널이 함께 움직이고, 설정을 닫으면 원래 자리로 돌아갑니다."
L["Type /sp for slash commands. Drag the panel itself to move it."] = "명령어 목록은 /sp 로 확인하세요. 패널은 직접 끌어서 옮깁니다."

--------------------------------------------------------------------------------
-- Presets.lua
--------------------------------------------------------------------------------
L["The stock look: flat dark panel with colored stat bars."] = "기본 모습: 평평한 어두운 패널에 색이 있는 능력치 막대."
L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."] = "막대 없이 능력치마다 색이 있는 한 줄: '특화: 285 - 10.65%'."
L["Thin headerless bars for a small footprint."] = "머리글 없는 얇은 막대로 자리를 적게 차지합니다."
L["Blizzard textures and a tooltip border, to match the default UI."] = "기본 UI에 맞춘 블리자드 텍스처와 툴팁 테두리."
L["No background or border at all - just floating text and bars."] = "배경도 테두리도 없이 글자와 막대만 떠 있습니다."
L["Tiny monochrome text, no background. Sits quietly in a corner."] = "배경 없는 아주 작은 단색 글자. 구석에 조용히 자리합니다."
L["High-contrast glow bars on near-black, with a value gradient."] = "거의 검은 바탕에 대비가 강한 발광 막대와 값 그라데이션."
L["Warm parchment and gold, in keeping with the default UI art."] = "기본 UI 분위기에 맞춘 따뜻한 양피지와 금색."
L["Defensive focus: armor, dodge, parry, block and avoidance up top."] = "방어 중심: 방어도, 회피, 무기 막기, 방패 막기, 방어 감소가 위쪽에."
L["Big live speed readout with your session record, and little else."] = "이번 접속 기록과 함께 큰 실시간 속도 표시, 그 외에는 거의 없음."
L["Secondary stats, item level and both latencies - what you check before a pull."] = "이차 능력치, 아이템 레벨, 두 지연시간 - 풀 직전에 확인하는 것들."
L["Cold blues and whites on deep navy."] = "짙은 남색 위의 차가운 파랑과 흰색."
L["Warm reds and ambers on charcoal."] = "숯색 위의 따뜻한 빨강과 호박색."
L["Every bar takes your class color. Clean and unfussy."] = "모든 막대가 직업 색상을 씁니다. 깔끔하고 담백합니다."
L["Large, heavy, high-contrast text. Easy to read at a glance."] = "크고 굵으며 대비가 강한 글자. 한눈에 읽힙니다."
L["The smallest useful readout: four secondaries, nothing else."] = "쓸모 있는 최소 구성: 이차 능력치 네 개, 그 외에는 없음."
L["Green-on-black monospace, like a console readout."] = "검은 바탕에 초록 고정폭 글꼴, 콘솔 화면 같은 느낌."
L["Throughput stats plus leech, with your primary attribute on top."] = "피해·치유량 능력치와 흡수, 주 능력치가 맨 위에."
L["Versatility first, with avoidance, dodge and speed alongside."] = "유연을 앞세우고 방어 감소, 회피, 속도를 함께."
L["Matches ElvUI: flat dark panel, 1px black border, narrow font."] = "ElvUI에 맞춤: 평평한 어두운 패널, 1픽셀 검은 테두리, 좁은 글꼴."
L["The popular transparent ElvUI style: near-black glass, hairline border."] = "널리 쓰이는 투명 ElvUI 스타일: 거의 검은 유리와 머리카락 굵기 테두리."
L["preset hook failed: %s"] = "사전 설정 후처리에 실패했습니다: %s"

--------------------------------------------------------------------------------
-- SPMain.lua (slash commands -- the /sp subcommands stay English)
--------------------------------------------------------------------------------
L["commands:"] = "명령어:"
L["  |cffffd100/sp|r - open the options"] = "  |cffffd100/sp|r - 설정 열기"
L["  |cffffd100/sp toggle|r - show or hide the panel"] = "  |cffffd100/sp toggle|r - 패널 표시/숨김"
L["  |cffffd100/sp lock|r - lock or unlock dragging"] = "  |cffffd100/sp lock|r - 끌기 잠금/해제"
L["  |cffffd100/sp reset|r - move the panel back to the center"] = "  |cffffd100/sp reset|r - 패널을 화면 가운데로"
L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"] = "  |cffffd100/sp preset <name>|r - 사전 설정 적용 (%s)"
L["  |cffffd100/sp profile <name>|r - switch profiles"] = "  |cffffd100/sp profile <name>|r - 프로필 전환"
L["  |cffffd100/sp peak|r - report and clear the session speed record"] = "  |cffffd100/sp peak|r - 접속 중 최고 속도 확인 및 초기화"
L["  |cffffd100/sp minimap|r - show or hide the minimap button"] = "  |cffffd100/sp minimap|r - 미니맵 버튼 표시/숨김"
L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"] = "  |cffffd100/sp gear|r - 마법부여, 홈, 아이템 레벨 점검"
L["  |cffffd100/sp announce [channel]|r - report your gear to chat"] = "  |cffffd100/sp announce [channel]|r - 장비 요약을 대화창으로"
L["panel shown."] = "패널을 표시했습니다."
L["panel hidden."] = "패널을 숨겼습니다."
L["panel locked."] = "패널을 고정했습니다."
L["panel unlocked."] = "패널 고정을 해제했습니다."
L["position reset."] = "위치를 초기화했습니다."
L["applied the '%s' preset."] = "'%s' 사전 설정을 적용했습니다."
L["unknown preset. Available: %s"] = "알 수 없는 사전 설정입니다. 사용 가능: %s"
L["switched to profile '%s'."] = "'%s' 프로필로 전환했습니다."
L["profiles: %s"] = "프로필: %s"
L["session speed record cleared."] = "접속 중 최고 속도 기록을 지웠습니다."
L["minimap button hidden."] = "미니맵 버튼을 숨겼습니다."
L["minimap button shown."] = "미니맵 버튼을 표시했습니다."

--------------------------------------------------------------------------------
-- StatPanel.lua
--------------------------------------------------------------------------------
L["Primary"] = "주 능력치"
L["Armor DR"] = "방어도 피해 감소"

-- Deliberately abbreviated: these label the compact priority chain, where the
-- full names would not fit.
L["Crit"] = "치명"
L["Haste"] = "가속"
L["Mast"] = "특화"
L["Vers"] = "유연"

L["a display setting could not be applied (%s)."] = "표시 설정을 적용하지 못했습니다 (%s)."
L["The game protects this value; see the panel itself."] = "게임이 이 값을 보호합니다. 패널에서 직접 확인하세요."
L["Value"] = "값"
L["Rating"] = "평점"
L["Yards/sec"] = "야드/초"
L["Session peak"] = "접속 중 최고"
L["Attribute"] = "능력치"
L["Drag to move  |  /sp for options"] = "끌어서 이동  |  /sp 로 설정"

-- Stat names. Normally supplied by Blizzard's GlobalStrings; these are the
-- fallback if one of those globals ever goes away.
L["Strength"] = "힘"
L["Agility"] = "민첩성"
L["Stamina"] = "체력"
L["Intellect"] = "지능"
L["Mastery"] = "특화"
L["Versatility"] = "유연성"
L["Dodge"] = "회피"
L["Parry"] = "무기 막기"
L["Block"] = "방패 막기"
L["Leech"] = "생명력 흡수"
L["Avoidance"] = "광역 피해 감소"
L["Speed"] = "이동 속도"

--------------------------------------------------------------------------------
-- Added in 2.5.0
--------------------------------------------------------------------------------

-- Bindings.lua
L["Show or hide the panel"] = "패널 표시/숨김"
L["Open the options"] = "설정 열기"
L["Lock or unlock the panel"] = "패널 고정/해제"
L["Switch to the next profile"] = "다음 프로필로 전환"
L["Run the gear audit"] = "장비 점검 실행"
L["only one profile exists."] = "프로필이 하나뿐입니다."

-- Diagnostics.lua
L["yes"] = "예"
L["no"] = "아니오"
L["LibStub not present"] = "LibStub 없음"
L["absent"] = "없음"
L["present (revision %s)"] = "있음 (리비전 %s)"
L["not present in this client"] = "이 클라이언트에 없음"
L["present, could not sample"] = "있음, 확인하지 못함"
L["active (crit chance is protected)"] = "적용 중 (치명타 확률이 보호됨)"
L["present but crit chance is readable"] = "있으나 치명타 확률을 읽을 수 있음"
L["Locale"] = "언어"
L["Class"] = "직업"
L["Secret values"] = "보호된 값"
L["Profiles stored"] = "저장된 프로필"
L["Custom stat priority"] = "사용자 지정 능력치 우선순위"
L["enabled"] = "사용"
L["disabled"] = "사용 안 함"
L["locked"] = "고정됨"
L["unlocked"] = "고정 해제됨"
L["auto width"] = "자동 너비"
L["width %d"] = "너비 %d"
L["Position"] = "위치"
L[" (substituted: not readable in this locale)"] = " (대체됨: 이 언어에서 읽을 수 없음)"
L["Stat rows"] = "능력치 줄"
L["%d shown of %d placed"] = "배치된 %2$d개 중 %1$d개 표시"
L["StatPanel diagnostics"] = "StatPanel 진단 정보"
L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."] = "Ctrl-A로 전체 선택, Ctrl-C로 복사하세요. 버그 보고서에 붙여넣으면 됩니다."

-- Diagnostics.lua: the what's-new notice
L["updated to %s. New in this version:"] = "%s(으)로 업데이트되었습니다. 이번 버전의 새로운 점:"
L["  Full changelog: %s"] = "  전체 변경 내역: %s"
L["Key bindings for toggling, locking, cycling profiles and the gear audit."] = "패널 표시, 고정, 프로필 전환, 장비 점검을 위한 단축키."
L["New stats: attack power, spell power, health, mana and stagger."] = "새 능력치: 공격력, 주문력, 생명력, 마나, 시간차 피해."
L["The $per token shows what one percent of a stat costs in rating."] = "$per 토큰은 능력치 1퍼센트가 평점으로 얼마인지 보여줍니다."
L["Gear durability and repair cost can now sit in the footer."] = "장비 내구도와 수리 비용을 하단 줄에 표시할 수 있습니다."
L["A Colorblind Safe preset, and precise X/Y position controls."] = "색약 배려 사전 설정과 정밀한 X/Y 위치 조절."
L["/sp debug collects everything a bug report needs into one copyable box."] = "/sp debug 는 버그 보고에 필요한 모든 정보를 복사 가능한 상자에 모아 줍니다."

-- Options.lua: anchor points and position
L["Top left"] = "왼쪽 위"
L["Top"] = "위"
L["Top right"] = "오른쪽 위"
L["Bottom left"] = "왼쪽 아래"
L["Bottom"] = "아래"
L["Bottom right"] = "오른쪽 아래"
L["Anchor point"] = "고정점"
L["Which corner of the panel the position below is measured from."] = "아래 위치를 패널의 어느 모서리에서 재는지 정합니다."
L["Anchored to screen"] = "화면 기준점"
L["Which point of the screen it is measured to. Anchoring to a corner keeps the panel there when the resolution changes."] = "화면의 어느 지점까지 재는지 정합니다. 모서리에 고정하면 해상도가 바뀌어도 패널이 그 자리에 남습니다."
L["Horizontal position"] = "가로 위치"
L["Vertical position"] = "세로 위치"
L[" (not readable in this language)"] = " (이 언어에서 읽을 수 없음)"

-- Options.lua: durability in the footer
L["Lowest gear durability"] = "가장 낮은 장비 내구도"
L["The worst durability across your equipped slots, so you see the broken piece and not an average."] = "착용 부위 중 가장 나쁜 내구도입니다. 평균이 아니라 망가진 부위가 보입니다."
L["Repair cost"] = "수리 비용"
L["The game can only price a repair at a merchant, so this shows nothing until you are talking to one."] = "게임은 상인 앞에서만 수리 비용을 계산할 수 있으므로, 상인과 대화하기 전에는 아무것도 표시되지 않습니다."
L["Durability format"] = "내구도 형식"
L["Durability considered good"] = "좋음으로 볼 내구도"
L["Durability considered poor"] = "나쁨으로 볼 내구도"

-- Presets.lua
L["Okabe-Ito palette, readable with red-green colour blindness. Rank numbers on."] = "적록 색약에서도 읽히는 오카베-이토 팔레트. 순위 번호 표시."

-- SPMain.lua
L["  |cffffd100/sp debug|r - show diagnostics to paste into a bug report"] = "  |cffffd100/sp debug|r - 버그 보고서에 붙여넣을 진단 정보 표시"
L["diagnostics:"] = "진단 정보:"

-- StatPanel.lua: new stat names
L["Attack Power"] = "공격력"
L["Spell Power"] = "주문력"
L["Health"] = "생명력"
L["Mana"] = "마나"
L["Stagger"] = "시간차 피해"
