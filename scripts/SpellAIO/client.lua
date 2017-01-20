local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("Waloria", {})
local spellButtons = {}

local scale = 1
local nButtons = 4

local frame = nil
local prevpos = false

function buildAndShowFrame(spells)
    frame = CreateFrame("Frame","Frame",UIParent)
    frame:SetWidth((40*4)+20)
    frame:SetHeight(40+20)
    frame:ClearAllPoints()
    frame:SetBackdrop(StaticPopup1:GetBackdrop())
    --frame:SetPoint("CENTER",UIParent)
    frame:SetPoint("TOP", UIParent)
    frame:SetScale(scale)
    frame:Hide()

    frame:RegisterForDrag("LeftButton")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnHide", frame.StopMovingOrSizing)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    AIO.SavePosition(frame)

    for i = 1, nButtons do -- Create 4 static buttons
        local btn = createSpellButton(i)
        spellButtons[i] = btn
    end
end

function createSpellButton(btnID)
    local button = CreateFrame("Button", tostring(btnID).."Button", frame, "ActionButtonTemplate")
    button:SetScale(scale)

    if not prevpos then 
        button:SetPoint("TOPLEFT",frame,"TOPLEFT",13,-13)
    else 
        button:SetPoint("LEFT",prevpos,"RIGHT",4,0)
    end

    prevpos = tostring(btnID).."Button"
    return button
end

function hideButtons()
    for i = 1, #spellButtons do 
        local btn = spellButtons[i]
        btn:Hide()
    end
end

function showButtons()
    for i = 1, #spellButtons do 
        local btn = spellButtons[i]
        btn:Show()
    end
end

function updateCategorySelection(visibleCategories)
    local categories = {
        [1] = "Damage",
        [2] = "Healing",
        [3] = "Buff",
        [4] = "Utility"
    }

    local categoryIcons = {
        [1] = "Interface\\Icons\\icondamage",
        [2] = "Interface\\Icons\\iconhealing",
        [3] = "Interface\\Icons\\iconbuff",
        [4] = "Interface\\Icons\\iconutility"
    }

    local categoryTooltips = {
        [1] = "|cffFFFF00Select a new damaging spell.",
        [2] = "|cffFFFF00Select a new healing spell.",
        [3] = "|cffFFFF00Select a new buff.",
        [4] = "|cffFFFF00Select a new utility spell."
    }

    for i = 1, #visibleCategories do 
        local catIndex = visibleCategories[i]
        local btn = spellButtons[i]

        local ntex = btn:CreateTexture()
        ntex:SetTexture(categoryIcons[catIndex])
        ntex:SetTexCoord(0, 1, 0, 1)
        ntex:SetAllPoints() 
        btn:SetNormalTexture(ntex)

        local ptex = btn:CreateTexture()
        ptex:SetTexture(categoryIcons[catIndex])
        ptex:SetTexCoord(0, 1, 0, 1)
        ptex:SetAllPoints() 
        btn:SetPushedTexture(ptex)

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(categoryTooltips[catIndex], 1, 1, 1, 1)
            GameTooltip:Show()
            PlaySound("GLUECHECKBOXMOUSEOVER", "Master")
        end)

        btn:SetScript("OnLeave", function(self) 
            GameTooltip:Hide()
        end)

        btn:SetScript("OnClick", function(self)
            PlaySound("igSpellBookClose", "Master")
            AIO.Handle("Waloria", "CategorySelection", catIndex)
            frame:Hide()
            GameTooltip:Hide()
            hideButtons()
        end)
    end
end

function updateSpellButtons(spellTable)
    for i = 1, nButtons do 
        local btn = spellButtons[i]
        local spellID = spellTable[i]

        local name, rank, icon, castingTime, minRange, maxRange, _ = GetSpellInfo(spellID)

        local ntex = btn:CreateTexture()
        ntex:SetTexture(icon)
        ntex:SetTexCoord(0, 1, 0, 1)
        ntex:SetAllPoints() 
        btn:SetNormalTexture(ntex)

        local ptex = btn:CreateTexture()
        ptex:SetTexture(icon)
        ptex:SetTexCoord(0, 1, 0, 1)
        ptex:SetAllPoints() 
        btn:SetPushedTexture(ptex)

        btn:SetScript("OnEnter", function(self)
             GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
             --GameTooltip:SetSpellByID(spellID)
             GameTooltip:SetHyperlink("spell:"..spellID)
             --GameTooltip:SetText(self.tooltip_text, nil, nil, nil, nil, true)
             GameTooltip:AddLine("|cffFC0000Warning: Spell selection is permanent.", 1, 1, 1, 1)
             GameTooltip:Show()
             PlaySound("GLUECHECKBOXMOUSEOVER", "Master")
        end )

        btn:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        btn:SetScript("OnClick", function(self)
            PlaySound("igSpellBookClose", "Master")
            AIO.Handle("Waloria", "SpellSelection", spellID)
            frame:Hide()
            GameTooltip:Hide()
            hideButtons()
        end)
    end
end

buildAndShowFrame()

function MyHandlers.ShowFrame(player, spellTable)
    updateSpellButtons(spellTable)
    frame:Show()
    showButtons()
end

function MyHandlers.ShowCategory(player, visibleCategories)
    updateCategorySelection(visibleCategories)
    frame:Show()
    showButtons()

    if #visibleCategories < 4 then 
        spellButtons[4]:Hide()
    end
end

-- UNLEARN TOGGLE BELOW

local unlearnToggleButton
local unlearnToggleButtonState = false

function UpdateUnlearnToggleButton(state)
    local ntex = unlearnToggleButton:CreateTexture()
    local ptex = unlearnToggleButton:CreateTexture()

    if state then
        unlearnToggleButtonState = true
        ntex:SetTexture("Interface\\Icons\\iconinscribeactive")
        ptex:SetTexture("Interface\\Icons\\iconinscribeinactive")
    else
        unlearnToggleButtonState = false
        ntex:SetTexture("Interface\\Icons\\iconinscribeinactive")
        ptex:SetTexture("Interface\\Icons\\iconinscribeactive")
    end

    ntex:SetTexCoord(0, 1, 0, 1)
    ntex:SetAllPoints() 
    ptex:SetTexCoord(0, 1, 0, 1)
    ptex:SetAllPoints() 

    unlearnToggleButton:SetNormalTexture(ntex)
    unlearnToggleButton:SetPushedTexture(ptex)

    unlearnToggleButton:Show()
end

unlearnToggleButton = CreateFrame("Button", "UnlearnToggleButton", UIParent, "ActionButtonTemplate")
unlearnToggleButton:SetPoint("LEFT", UIParent, 5, 0)
AIO.Handle("Waloria", "UpdateToggleState")
unlearnToggleButton:Hide()

unlearnToggleButton:RegisterForDrag("LeftButton")
unlearnToggleButton:SetMovable(true)
unlearnToggleButton:EnableMouse(true)
unlearnToggleButton:SetScript("OnDragStart", unlearnToggleButton.StartMoving)
unlearnToggleButton:SetScript("OnHide", unlearnToggleButton.StopMovingOrSizing)
unlearnToggleButton:SetScript("OnDragStop", unlearnToggleButton.StopMovingOrSizing)
AIO.SavePosition(unlearnToggleButton)

local function SpellButton_OnClickHook(self, button)
    if unlearnToggleButtonState == true then 
        local id, slotType = SpellBook_GetSpellID(self:GetID())
        local spellID, subSpellName = GetSpellLink(id, SpellBookFrame.bookType)
        --local _, spellID = GetSpellBookItemInfo(slot, slotType)

        spellID = spellID:match("|Hspell:[0-9]*")
        spellID = spellID:gsub("|Hspell:", "")

        AIO.Handle("Waloria", "UnlearnSpell", spellID)
    end
end

for i = 1, 12 do
    _G["SpellButton"..i]:HookScript("OnClick", SpellButton_OnClickHook)
end

unlearnToggleButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("|cffFFFFFFInscribe\n\nWhen active any spell clicked\non inside your spellbook will\nbe returned as a item scroll.")
    GameTooltip:Show()
end)

unlearnToggleButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

unlearnToggleButton:SetScript("OnClick", function(self)
    -- When we click the UI we ask server to update state, then server must ask client to poll new state
    AIO.Handle("Waloria", "UnlearnToggle")
end)

function MyHandlers.UpdateUnlearnToggle(player, state)
    UpdateUnlearnToggleButton(state)
end

-- MISC

_G["PlayerFrameAlternateManaBar"]:Hide()
_G["PlayerFrameAlternateManaBar"]:SetScript("OnUpdate", function(self)
    _G["PlayerFrameAlternateManaBar"]:Hide()
end)

--[[
_G["MultiCastActionBarFrame"]:RegisterForDrag("LeftButton")
_G["MultiCastActionBarFrame"]:SetMovable(true)
_G["MultiCastActionBarFrame"]:EnableMouse(true)
_G["MultiCastActionBarFrame"]:SetScript("OnDragStart", _G["MultiCastActionBarFrame"].StartMoving)
_G["MultiCastActionBarFrame"]:SetScript("OnHide", _G["MultiCastActionBarFrame"].StopMovingOrSizing)
_G["MultiCastActionBarFrame"]:SetScript("OnDragStop", _G["MultiCastActionBarFrame"].StopMovingOrSizing)
--]]

_G["MultiCastActionBarFrame"]:Hide()
_G["MultiCastActionBarFrame"]:SetScript("OnUpdate", function(self)
    _G["MultiCastActionBarFrame"]:Hide()
end)