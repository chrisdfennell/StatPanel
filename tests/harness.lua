-- tests/harness.lua (A test framework, in about a hundred lines)
--
-- Hand-rolled for the same reason the locale system is: the addon embeds no
-- libraries, and CI already installs a bare Lua 5.1 with nothing else. busted
-- would be nicer to read and would mean a luarocks dependency, a config file
-- and a second thing to keep working.
--
-- Every assertion records rather than raises, so one bad expectation reports
-- one failure instead of hiding the rest of the file behind it. An unexpected
-- Lua error inside a test is caught and reported as that test failing.

local H = {}

H.passed, H.failed = 0, 0
H.failures = {}

local currentSuite, currentTest, currentFailed

local function record(message)
    currentFailed = true
    H.failures[#H.failures + 1] = {
        suite = currentSuite, test = currentTest, message = message,
    }
end

--------------------------------------------------------------------------------
-- STRUCTURE
--------------------------------------------------------------------------------
function H.describe(name, fn)
    currentSuite = name
    fn()
    currentSuite = nil
end

function H.it(name, fn)
    currentTest = name
    currentFailed = false

    local ok, err = pcall(fn)
    if not ok then
        record("raised: " .. tostring(err))
    end

    if currentFailed then
        H.failed = H.failed + 1
        io.write("  FAIL  ", name, "\n")
    else
        H.passed = H.passed + 1
        io.write("  ok    ", name, "\n")
    end
    currentTest = nil
end

--------------------------------------------------------------------------------
-- ASSERTIONS
--------------------------------------------------------------------------------
-- Rendered rather than tostring'd, so a failure message shows the shape of a
-- table instead of "table: 0x...". Sorted so the output is stable run to run.
local function show(value, depth)
    depth = depth or 0
    if type(value) ~= "table" then
        return type(value) == "string" and string.format("%q", value) or tostring(value)
    end
    if depth > 2 then return "{...}" end

    local keys = {}
    for k in pairs(value) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

    local parts = {}
    for _, k in ipairs(keys) do
        parts[#parts + 1] = tostring(k) .. "=" .. show(value[k], depth + 1)
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end
H.Show = show

function H.ok(value, message)
    if not value then record((message or "expected truthy") .. " (got " .. show(value) .. ")") end
    return value
end

function H.notOk(value, message)
    if value then record((message or "expected falsy") .. " (got " .. show(value) .. ")") end
end

function H.eq(actual, expected, message)
    if actual ~= expected then
        record((message or "values differ")
            .. "\n          expected: " .. show(expected)
            .. "\n          actual:   " .. show(actual))
    end
end

local function deepEqual(a, b)
    if a == b then return true end
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    for k, v in pairs(a) do
        if not deepEqual(v, b[k]) then return false end
    end
    for k in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end
H.DeepEqual = deepEqual

function H.same(actual, expected, message)
    if not deepEqual(actual, expected) then
        record((message or "tables differ")
            .. "\n          expected: " .. show(expected)
            .. "\n          actual:   " .. show(actual))
    end
end

-- Asserts that calling fn does NOT raise. The message carries the error, which
-- is the part worth reading.
function H.noRaise(fn, message)
    local ok, err = pcall(fn)
    if not ok then
        record((message or "expected no error") .. "\n          raised: " .. tostring(err))
    end
    return ok
end

function H.raises(fn, message)
    local ok = pcall(fn)
    if ok then record(message or "expected an error, none raised") end
end

--------------------------------------------------------------------------------
-- REPORT
--------------------------------------------------------------------------------
function H.report()
    io.write("\n")
    if #H.failures > 0 then
        io.write(string.rep("-", 70), "\n")
        for _, f in ipairs(H.failures) do
            io.write(f.suite or "?", " > ", f.test or "?", "\n")
            io.write("        ", f.message, "\n\n")
        end
        io.write(string.rep("-", 70), "\n")
    end

    io.write(string.format("%d passed, %d failed\n", H.passed, H.failed))
    return H.failed == 0
end

return H
