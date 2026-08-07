-- tests/spec_diagnostics.lua (/sp debug and the what's-new notice)

return function(H, SP)
    local Diagnostics = SP.Diagnostics

    local function freshDB()
        _G.SPAddonDB = {}
        SP.Config:Init()
        return _G.SPAddonDB
    end

    H.describe("version comparison", function()
        local isNewer = Diagnostics.IsNewerVersion

        H.it("orders ordinary versions", function()
            H.ok(isNewer("2.5.0", "2.4.0"))
            H.ok(isNewer("3.0.0", "2.9.9"))
            H.ok(isNewer("2.4.1", "2.4.0"))
            H.notOk(isNewer("2.4.0", "2.4.0"), "the same version is not newer")
            H.notOk(isNewer("2.3.0", "2.4.0"))
        end)

        H.it("compares numerically, not as text", function()
            -- The bug this exists to prevent: "2.10.0" < "2.9.0" as strings, so
            -- a string comparison silently stops the notice from ever firing
            -- again after the tenth minor release.
            H.ok(isNewer("2.10.0", "2.9.0"), "2.10.0 comes after 2.9.0")
            H.ok(isNewer("2.4.10", "2.4.9"))
            H.ok(isNewer("10.0.0", "9.0.0"))
        end)

        H.it("treats missing components as zero", function()
            H.ok(isNewer("2.5", "2.4.9"))
            H.notOk(isNewer("2.4", "2.4.0"), "2.4 and 2.4.0 are the same version")
            H.ok(isNewer("2.4.1", "2.4"))
        end)

        H.it("survives junk", function()
            for _, pair in ipairs({ { "", "" }, { "v2.5.0", "2.4.0" },
                { "2.5.0-beta1", "2.5.0" }, { nil, "2.4.0" }, { "2.4.0", nil } }) do
                H.noRaise(function() isNewer(pair[1], pair[2]) end)
            end
        end)
    end)

    H.describe("the what's-new notice", function()
        H.it("says nothing on a fresh install, but stamps the version", function()
            local db = freshDB()
            H.eq(db.global.lastSeenVersion, nil, "nothing stamped yet")
            Diagnostics:ShowWhatsNew()
            H.ok(db.global.lastSeenVersion, "stamped so it stays quiet next login")
        end)

        H.it("does not repeat itself", function()
            local db = freshDB()
            Diagnostics:ShowWhatsNew()
            local stamped = db.global.lastSeenVersion
            Diagnostics:ShowWhatsNew()
            H.eq(db.global.lastSeenVersion, stamped)
        end)

        H.it("stamps forward when the version moves", function()
            local db = freshDB()
            db.global.lastSeenVersion = "0.0.1"
            Diagnostics:ShowWhatsNew()
            H.ok(Diagnostics.IsNewerVersion(db.global.lastSeenVersion, "0.0.1"),
                "the stamp must move forward, or the notice repeats every login")
            H.eq(db.global.lastSeenVersion, _G.__TOC_VERSION,
                "it stamps the shipping version, not an invented one")
        end)

        H.it("has highlights for the version being shipped", function()
            -- Bumping the TOC without writing the highlights means the notice
            -- fires and prints a heading with nothing under it.
            local found = false
            for _, entry in ipairs(Diagnostics.HIGHLIGHTS) do
                if entry.version == _G.__TOC_VERSION then found = true end
            end
            H.ok(found, "no highlights entry for version " .. tostring(_G.__TOC_VERSION))
        end)

        H.it("gives every highlights entry a version and some lines", function()
            for _, entry in ipairs(Diagnostics.HIGHLIGHTS) do
                H.eq(type(entry.version), "string")
                H.ok(#entry.lines > 0, entry.version .. " has no lines")
                for _, line in ipairs(entry.lines) do
                    -- These are printed raw, so an unescaped % would be a
                    -- format error if anything ever formatted them.
                    H.eq(type(line), "string")
                    H.ok(line ~= "", entry.version .. " has an empty line")
                end
            end
        end)

        H.it("never raises", function()
            H.noRaise(function()
                local db = freshDB()
                db.global.lastSeenVersion = "not a version"
                Diagnostics:ShowWhatsNew()
            end)
        end)
    end)

    H.describe("the diagnostics report", function()
        H.it("produces text without raising", function()
            freshDB()
            local report
            H.noRaise(function() report = Diagnostics:Report() end)
            H.eq(type(report), "string")
            H.ok(#report > 0)
        end)

        H.it("names what a bug report needs", function()
            freshDB()
            local report = Diagnostics:Report()
            for _, needle in ipairs({ "StatPanel", "Game", "Locale", "Class",
                "Spec", "Secret values", "Profile", "Panel", "Font",
                "LibSharedMedia-3.0" }) do
                H.ok(report:find(needle, 1, true), "report mentions " .. needle)
            end
        end)

        H.it("carries no character or realm name", function()
            -- The usual destination is a public issue tracker.
            freshDB()
            local report = Diagnostics:Report()
            H.notOk(report:find(UnitName("player"), 1, true), "no character name")
            H.notOk(report:find(GetRealmName(), 1, true), "no realm name")
        end)

        H.it("reports both the requested font and the one actually drawn", function()
            freshDB()
            local report = Diagnostics:Report()
            H.ok(report:find("->", 1, true),
                "the requested/actual distinction is what explains a panel full of boxes")
        end)

        H.it("survives a profile with holes in it", function()
            local db = freshDB()
            db.profiles.Default.sections = nil
            db.profiles.Default.customPriority = nil
            SP.Config:Activate("Default")
            H.noRaise(function() Diagnostics:Report() end)
        end)
    end)
end
