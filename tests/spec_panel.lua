-- tests/spec_panel.lua (The footer line, and the key bindings)
--
-- Both of these are code that only runs when a particular option is on or a
-- particular key is pressed, which is exactly the code that ships with a typo
-- in a global nobody notices for a month. Calling them once under the stub is
-- cheap and catches that.

return function(H, SP)
    local Panel = SP.Panel

    local function freshDB()
        _G.SPAddonDB = {}
        SP.Config:Init()
    end

    H.describe("the footer", function()
        H.it("builds with everything off", function()
            freshDB()
            local footer = SP.db.footer
            footer.showFPS, footer.showHomeLatency = false, false
            footer.showWorldLatency, footer.showMemory = false, false
            footer.showDurability, footer.showRepairCost = false, false
            H.eq(Panel:BuildFooter(), "")
        end)

        H.it("builds with everything on", function()
            freshDB()
            local footer = SP.db.footer
            footer.showFPS, footer.showHomeLatency = true, true
            footer.showWorldLatency, footer.showMemory = true, true
            footer.showDurability, footer.showRepairCost = true, true

            local text
            H.noRaise(function() text = Panel:BuildFooter() end)
            H.eq(type(text), "string")
            H.ok(#text > 0)
        end)

        H.it("reports durability, and colours it", function()
            freshDB()
            local footer = SP.db.footer
            footer.showFPS, footer.showHomeLatency = false, false
            footer.showWorldLatency, footer.showMemory = false, false
            footer.showDurability, footer.showRepairCost = false, false
            footer.showDurability = true

            local text = Panel:BuildFooter()
            -- The stub has no damaged items, so every slot reports nothing and
            -- the answer is a full 100%.
            H.ok(text:find("100", 1, true), "shows a percentage: " .. tostring(text))
            H.ok(text:find("|cff", 1, true), "colourized by threshold")
        end)

        H.it("hides the repair cost away from a merchant", function()
            -- GetRepairAllCost returns 0 unless a merchant is open, and a
            -- permanent "0g" reads as "your gear is fine" exactly when it is not.
            freshDB()
            local footer = SP.db.footer
            footer.showFPS, footer.showHomeLatency = false, false
            footer.showWorldLatency, footer.showMemory = false, false
            footer.showDurability, footer.showRepairCost = false, true
            H.eq(Panel:BuildFooter(), "")
        end)

        H.it("survives a garbled format string", function()
            freshDB()
            SP.db.footer.showFPS = true
            for _, bad in ipairs({ "%d %d", "%z", "%", "" }) do
                SP.db.footer.fpsFormat = bad
                H.noRaise(function() Panel:BuildFooter() end, "fpsFormat: " .. bad)
            end
        end)

        H.it("survives a garbled durability format", function()
            freshDB()
            SP.db.footer.showFPS = false
            SP.db.footer.showDurability = true
            for _, bad in ipairs({ "%d %d", "%z", "%", "" }) do
                SP.db.footer.durabilityFormat = bad
                H.noRaise(function() Panel:BuildFooter() end, "durabilityFormat: " .. bad)
            end
        end)
    end)

    H.describe("key bindings", function()
        H.it("exposes the five handlers Bindings.xml calls", function()
            -- The XML body is compiled into the global environment and can only
            -- see globals. A rename here is a silent no-op on a keypress.
            for _, name in ipairs({ "StatPanel_BindingToggle", "StatPanel_BindingOptions",
                "StatPanel_BindingLock", "StatPanel_BindingNextProfile",
                "StatPanel_BindingGear" }) do
                H.eq(type(_G[name]), "function", name .. " is not a global function")
            end
        end)

        H.it("names every binding for the Key Bindings window", function()
            for _, name in ipairs({ "BINDING_HEADER_STATPANEL",
                "BINDING_NAME_STATPANEL_TOGGLE", "BINDING_NAME_STATPANEL_OPTIONS",
                "BINDING_NAME_STATPANEL_LOCK", "BINDING_NAME_STATPANEL_NEXTPROFILE",
                "BINDING_NAME_STATPANEL_GEAR" }) do
                H.eq(type(_G[name]), "string", name .. " has no label")
                H.ok(_G[name] ~= "", name .. " is empty")
            end
        end)

        H.it("does nothing before the addon is ready", function()
            -- A binding is live the moment Bindings.xml loads, which is before
            -- PLAYER_LOGIN has built anything.
            freshDB()
            local wasReady, db = SP.ready, SP.db
            SP.ready, SP.db = nil, nil
            for _, name in ipairs({ "StatPanel_BindingToggle", "StatPanel_BindingOptions",
                "StatPanel_BindingLock", "StatPanel_BindingNextProfile",
                "StatPanel_BindingGear" }) do
                H.noRaise(_G[name], name .. " before login")
            end
            SP.ready, SP.db = wasReady, db
        end)

        H.it("cycles profiles in order, wrapping at the end", function()
            freshDB()
            SP.ready = true
            SP.Config:NewProfile("Bravo")
            SP.Config:NewProfile("Charlie")

            -- ProfileList sorts case-insensitively: Bravo, Charlie, Default.
            local list = SP.Config:ProfileList()
            H.eq(#list, 3)

            SP.Config:SetProfile(list[1])
            SP.Bindings:NextProfile()
            H.eq(SP.Config:CurrentProfile(), list[2])

            SP.Config:SetProfile(list[#list])
            SP.Bindings:NextProfile()
            H.eq(SP.Config:CurrentProfile(), list[1], "wraps back to the first")
            SP.ready = nil
        end)

        H.it("says so rather than doing nothing with one profile", function()
            freshDB()
            SP.ready = true
            H.eq(#SP.Config:ProfileList(), 1)
            H.noRaise(function() SP.Bindings:NextProfile() end)
            H.eq(SP.Config:CurrentProfile(), "Default")
            SP.ready = nil
        end)
    end)
end
