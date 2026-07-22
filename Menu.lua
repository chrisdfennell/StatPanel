-- Menu.lua (Right-click context menu)
--
-- Shared by the panel itself and the minimap / broker button, so a right-click
-- gives the same quick actions wherever you make it. Uses the modern MenuUtil
-- API (11.0+); if it's ever missing we just open the full options instead.

local addonName, SP = ...

local REFRESH = _G.MenuResponse and _G.MenuResponse.Refresh

function SP:ShowContextMenu(owner)
    if not (MenuUtil and MenuUtil.CreateContextMenu) then
        SP:OpenOptions()
        return
    end

    MenuUtil.CreateContextMenu(owner, function(_, root)
        root:CreateTitle("StatPanel")

        -- Live toggles. Returning MenuResponse.Refresh keeps the menu open and
        -- re-reads the checkbox so it visibly ticks/unticks under the cursor.
        root:CreateCheckbox("Show panel",
            function() return SP.db.enabled end,
            function() SP:TogglePanel(); SP.UI:RefreshAll(); return REFRESH end)

        root:CreateCheckbox("Lock position",
            function() return SP.db.panel.locked end,
            function()
                SP.db.panel.locked = not SP.db.panel.locked
                SP.UI:RefreshAll()
                return REFRESH
            end)

        root:CreateCheckbox("Show FPS",
            function() return SP.db.footer.showFPS end,
            function()
                SP.db.footer.showFPS = not SP.db.footer.showFPS
                SP:Refresh(); SP.UI:RefreshAll()
                return REFRESH
            end)

        root:CreateDivider()

        -- Presets submenu.
        local presets = root:CreateButton("Apply preset")
        for _, name in ipairs(SP.Presets.order) do
            presets:CreateButton(name, function()
                SP.Presets:Apply(name)
                SP.UI:RefreshAll()
            end)
        end

        -- Profiles submenu, as a radio group so the active one shows a dot.
        local profiles = root:CreateButton("Profile")
        for _, name in ipairs(SP.Config:ProfileList()) do
            profiles:CreateRadio(name,
                function() return SP.Config:CurrentProfile() == name end,
                function()
                    SP.Config:SetProfile(name)
                    SP.UI:RefreshAll()
                end)
        end

        root:CreateDivider()

        -- Announce targets. "Print to my chat only" is first so a misclick
        -- previews rather than broadcasts.
        local announce = root:CreateButton("Announce to")
        for _, channel in ipairs(SP.Announce.channels) do
            if channel.value ~= "WHISPER" then
                announce:CreateButton(channel.name, function()
                    SP.Announce:Send(channel.value)
                end)
            end
        end

        root:CreateButton("Audit my gear", function() SP.Gear:PrintReport() end)

        root:CreateDivider()

        root:CreateButton("Open options", function() SP:OpenOptions() end)
        root:CreateButton("Reset position", function()
            SP.db.panel.pos = SP.Config:DeepCopy(SP.Config.DEFAULTS.panel.pos)
            SP:Refresh()
        end)
    end)
end
