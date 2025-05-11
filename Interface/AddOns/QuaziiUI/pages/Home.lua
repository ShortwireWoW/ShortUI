local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pages, page)

local function addonScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            
            -- Reset button state at the beginning for each line
            line.importButton:Enable()
            
            if info == "GraphicsOptimizer" then
                -- Special handling for the graphics optimizer
                line.addonLabel:SetText("Optimize Graphics Settings")
                line.versionLabel:SetText("")
                line.enabledLabel:SetText("")
                line.importButton:SetText("Apply")
                line.importButton:SetClickFunction(
                    function()
                        QuaziiUI:ApplyOptimizedGraphics()
                    end
                )
            else
                -- Normal addon handling
                local addonTitle = C_AddOns and C_AddOns.GetAddOnInfo(info)
                local addonEnabled = C_AddOns and C_AddOns.IsAddOnLoaded(info)
                
                line.addonLabel:SetText(addonTitle or info)
                line.versionLabel:SetText(addonTitle and C_AddOns and C_AddOns.GetAddOnMetadata(info, "Version") or L["NA"])
                line.enabledLabel:SetText(
                    addonEnabled and "|cff00ff00" .. L["True"] .. "|r" or "|cffff0000" .. L["False"] .. "|r"
                )
                
                -- Set button state based on addon state
                if not addonEnabled then
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                elseif addonTitle == "ElvUI" then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(3)
                        end
                    )
                elseif addonTitle == "WeakAuras" then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(4)
                        end
                    )
                elseif addonTitle == "MythicDungeonTools" then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(5)
                        end
                    )
                elseif addonTitle == "Details" then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importDetailsProfile()
                        end
                    )
                elseif addonTitle == "Cell" then
                    line.importButton:SetText(L["Import"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importCellProfile()
                        end
                    )
                elseif addonTitle == "Plater" then
                    line.importButton:SetText(L["Import"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importPlaterProfile()
                        end
                    )
                elseif addonTitle == "OmniCD" then
                    line.importButton:SetText(L["Import"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importOmniCDProfile()
                        end
                    )
                else
                    -- Default case for any other addons
                    line.importButton:SetText(L["Import"])
                end
            end
        end
    end
end

---@param index integer
local function createAddonButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
    line:SetClipsChildren(true)
    line:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -((index - 1) * (self.LineHeight + 1)) - 1)
    line:SetSize(555, self.LineHeight)
    line:SetBackdrop(
        {
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tileSize = 64,
            tile = true
        }
    )
    line:SetBackdropColor(0.8, 0.8, 0.8, 0.2)
    QuaziiUI.DF:Mixin(line, QuaziiUI.DF.HeaderFunctions)

    line.addonLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.addonLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.versionLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.versionLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.enabledLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.enabledLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.importButton = QuaziiUI.DF:CreateButton(line, nil, 105, 30, L["Import"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    line.importButton.text_overlay:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)

    line:AddFrameToHeaderAlignment(line.addonLabel)
    line:AddFrameToHeaderAlignment(line.enabledLabel)
    line:AddFrameToHeaderAlignment(line.versionLabel)
    line:AddFrameToHeaderAlignment(line.importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")

    return line
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateDescription(frame)
    self:CreateAddonList(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateHeader(frame)
    local header =
        QuaziiUI.DF:CreateLabel(frame, "|c" .. QuaziiUI.highlightColorHex .. L["SupportedAddonsHeader"] .. "|r", QuaziiUI.PageHeaderSize)
    header:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateDescription(frame)
    local description = QuaziiUI.DF:CreateLabel(frame, L["SupportedAddonsText"], QuaziiUI.PageTextSize)
    description:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    description:SetWordWrap(true)
    description:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    description:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    description:SetJustifyH("LEFT")
    description:SetJustifyV("TOP")
    self.description = description
end

function page:CreateAddonList(frame)
    local headerTable = {
        -- Widths should add to 551
        {text = "|c" .. QuaziiUI.highlightColorHex .. L["SupportedAddonsTable1stHeader"], width = 221, offset = 2},
        {text = L["SupportedAddonsTable2ndHeader"], width = 70},
        {text = L["SupportedAddonsTable3rdHeader"], width = 150},
        {text = L["Import"], width = 110}
    }
    local options = {text_size = QuaziiUI.TableHeaderSize}
    frame.addonHeader = QuaziiUI.DF:CreateHeader(frame, headerTable, options, "QuaziiUIInstallAddonHeader")
    frame.addonHeader:SetPoint("TOPLEFT", self.description.widget, "BOTTOMLEFT", -2, -10)

    local addonScrollBox =
        QuaziiUI.DF:CreateScrollBox(frame, nil, addonScrollBoxUpdate, {}, 557, 281, 0, 34, createAddonButton, true)
    addonScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    addonScrollBox.ScrollBar.scrollStep = 34
    QuaziiUI.DF:ReskinSlider(addonScrollBox)
    addonScrollBox:SetData(QuaziiUI.supportedAddons)
    addonScrollBox:Refresh()
end

function page:ShouldShow()
    return true
end

function page:Show()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
