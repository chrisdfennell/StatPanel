-- tests/run.lua (Test entry point)
--
--   lua tests/run.lua            -- run everything
--   lua tests/run.lua format     -- run only spec files matching "format"
--
-- Loads the addon the way the game does: each .lua file listed in StatPanel.toc
-- is a separate chunk called with (addonName, sharedTable) as its varargs. Files
-- that only exist to build the options window are skipped -- they construct
-- several hundred frames and test nothing that a stubbed frame could answer.
--
-- Deriving the load order from the TOC rather than hardcoding it means the
-- suite also fails when the TOC and the filesystem disagree, which is the
-- failure mode the CI TOC check exists for.

local ROOT = (function()
    -- Run from the repo root or from inside tests/; find the root either way.
    local candidates = { ".", "..", (arg and arg[0] or ""):match("^(.*)[/\\]") or "." }
    for _, dir in ipairs(candidates) do
        local f = io.open(dir .. "/StatPanel.toc", "r")
        if f then f:close() return dir end
        f = io.open(dir .. "/../StatPanel.toc", "r")
        if f then f:close() return dir .. "/.." end
    end
    error("Cannot find StatPanel.toc -- run this from the repository root.")
end)()

package.path = ROOT .. "/tests/?.lua;" .. package.path

local H = require("harness")
local stub = require("wow_stub")

--------------------------------------------------------------------------------
-- LOAD THE ADDON
--------------------------------------------------------------------------------
stub.install(_G)

-- Options.lua is skipped: it constructs several hundred frames at build time,
-- and what that would exercise is the frame stub rather than the addon.
--
-- Widgets.lua is NOT skipped, even though it is also UI. It defines SP.UI at
-- load and builds nothing until a control is asked for, and other modules call
-- SP.UI:RefreshAll() after changing a setting -- so leaving it out would mean
-- testing those modules against a namespace the game never actually gives them.
local SKIP = {
    ["Options.lua"] = true,
}

local function tocFiles()
    local out = {}
    for line in io.lines(ROOT .. "/StatPanel.toc") do
        line = line:gsub("\r", "")
        -- TOC paths use Windows separators; the filesystem here may not.
        local path = line:match("^%s*([%w_%.\\/%-]+%.[Ll][Uu][Aa])%s*$")
        if path then out[#out + 1] = path:gsub("\\", "/") end
    end
    return out
end

-- The version the addon will actually ship as. Read from the TOC rather than
-- invented, so anything version-dependent -- the what's-new notice, the
-- diagnostics report -- is tested against the real number.
local function tocVersion()
    for line in io.lines(ROOT .. "/StatPanel.toc") do
        local version = line:gsub("\r", ""):match("^##%s*Version:%s*(%S+)")
        if version then return version end
    end
    error("StatPanel.toc has no '## Version:' line")
end

_G.__TOC_VERSION = tocVersion()

-- The shared namespace table the game hands every file as its second vararg.
local SP = {}
_G.__SP = SP

local loaded = {}
for _, relative in ipairs(tocFiles()) do
    local name = relative:match("([^/]+)$")
    if not SKIP[name] then
        local chunk, err = loadfile(ROOT .. "/" .. relative)
        if not chunk then
            error("Failed to load " .. relative .. ": " .. tostring(err))
        end
        local ok, loadErr = pcall(chunk, "StatPanel", SP)
        if not ok then
            error("Error while loading " .. relative .. ": " .. tostring(loadErr))
        end
        loaded[#loaded + 1] = relative
    end
end

io.write("Loaded ", #loaded, " addon files\n\n")

--------------------------------------------------------------------------------
-- RUN THE SPECS
--------------------------------------------------------------------------------
-- Listed explicitly rather than globbed: Lua has no portable directory listing,
-- and an explicit list is a place to see at a glance what is covered.
local SPECS = {
    "spec_media",
    "spec_priority",
    "spec_format",
    "spec_schema",
    "spec_profiles",
    "spec_presets",
    "spec_panel",
    "spec_diagnostics",
}

local filter = arg and arg[1]

for _, spec in ipairs(SPECS) do
    if not filter or spec:find(filter, 1, true) then
        io.write(spec, "\n")
        require(spec)(H, SP)
        io.write("\n")
    end
end

os.exit(H.report() and 0 or 1)
