-- tests/spec_media.lua (Media registry and the locale font substitution)

return function(H, SP)
    local Media = SP.Media

    H.describe("Media:Fetch", function()
        H.it("returns the path for a built-in name", function()
            H.eq(Media:Fetch("statusbar", "Flat"), [[Interface\Buttons\WHITE8X8]])
        end)

        H.it("falls back rather than returning nil for an unknown name", function()
            H.eq(Media:Fetch("statusbar", "Some Uninstalled Addon Texture"),
                [[Interface\Buttons\WHITE8X8]],
                "an uninstalled shared-media texture must fall back, not blank the bar")
        end)

        H.it("passes a literal file path straight through", function()
            local path = [[Interface\AddOns\ElvUI\Media\Textures\Melli.tga]]
            H.eq(Media:Fetch("statusbar", path), path,
                "presets borrow media from other addons by path")
        end)

        H.it("never returns nil for a font", function()
            -- SetFont raises on a nil path since 12.0.7, so this is the
            -- difference between a fallback and a broken options window.
            H.ok(Media:Fetch("font", nil), "nil name")
            H.ok(Media:Fetch("font", "No Such Font"), "unknown name")
            H.ok(Media:Fetch("font", "Game Default"), "the default name")
        end)
    end)

    H.describe("the client's own font", function()
        H.it("resolves to a real path", function()
            local font = Media:UIFont()
            H.eq(type(font), "string")
            H.ok(#font > 0, "non-empty")
        end)

        H.it("is what 'Game Default' means", function()
            H.eq(Media:Fetch("font", "Game Default"), Media:UIFont())
        end)

        H.it("is exported as SP.UIFont for the three files that draw chrome", function()
            H.eq(SP.UIFont(), Media:UIFont())
        end)

        H.it("leaves Latin faces alone on a Latin client", function()
            -- The stub reports enUS, where Friz Quadrata is perfectly readable
            -- and must not be silently swapped out from under the user.
            H.notOk(Media:IsUnreadableFace("Friz Quadrata"))
            H.eq(Media:Fetch("font", "Morpheus"), [[Fonts\MORPHEUS.TTF]])
        end)

        H.it("never claims a shared-media font is unreadable", function()
            -- Another addon installed that font on purpose. Overriding it would
            -- be a worse bug than the one being prevented.
            H.notOk(Media:IsUnreadableFace("PT Sans Narrow"))
        end)
    end)

    H.describe("Media:List", function()
        H.it("offers Game Default in the font list", function()
            local found = false
            for _, name in ipairs(Media:List("font")) do
                if name == "Game Default" then found = true end
            end
            H.ok(found, "the only universally readable choice must be selectable")
        end)

        H.it("sorts None to the top of the border list", function()
            H.eq(Media:List("border")[1], "None")
        end)
    end)

    H.describe("Media:FetchBorder", function()
        H.it("returns nil for None", function()
            H.eq(Media:FetchBorder("None"), nil)
            H.eq(Media:FetchBorder(nil), nil)
        end)

        H.it("scales a pixel border's inset with its size", function()
            local border = Media:FetchBorder("Pixel", 3)
            H.eq(border.edgeSize, 3)
            H.eq(border.inset, 3)
        end)

        H.it("never lets a pixel border reach zero thickness", function()
            -- edgeSize = 0 is not "no border", it is an error inside SetBackdrop.
            H.eq(Media:FetchBorder("Pixel", 0).edgeSize, 1)
        end)
    end)
end
