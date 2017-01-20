local AIO = AIO or require("AIO")
local SpellClass = require("spellclass").new()

local MyHandlers = AIO.AddHandlers("Waloria", {})

local unlearnToggle = {}

local function CheckPlayerSpellChoice(playerGUID)
    local player = GetPlayerByGUID(playerGUID)
    if SpellClass:HasSpellChoices(player) then 
        local spells = SpellClass:GetNextSpellChoiceFromDB(player)
        AIO.Handle(player, "Waloria", "ShowFrame", spells)
    end
end

local function CheckCategorySelectionChoice(player)
    if SpellClass:HasCategoryChoice(player) then
        AIO.Handle(player, "Waloria", "ShowCategory", SpellClass:GetAvailableCategories(player))
    end
end

local function OnFirstLogin(event, player)
    AIO.Handle(player, "Waloria", "ShowCategory", SpellClass:GetAvailableCategories(player))
    CheckCategorySelectionChoice(player)
    SpellClass:SaveCategoryChoice(player)
end

local function OnLogin(event, player)
    CheckCategorySelectionChoice(player)
    CheckPlayerSpellChoice(player:GetGUID())
    player:UpdateCustomSpellAmount()
end

RegisterPlayerEvent(30, OnFirstLogin)
RegisterPlayerEvent(3, OnLogin)

local function OnDelete(event, charGUID)
    SpellClass:DeleteAllSpellChoicesFromDB(charGUID)
end

RegisterPlayerEvent(2, OnDelete)

local function OnLevelChange(event, player, oldLevel)
    SpellClass:SaveCategoryChoice(player)
    CheckCategorySelectionChoice(player)
end

RegisterPlayerEvent(13, OnLevelChange)

local function OnCommand(event, player, command)
    if(player:IsGM() and command == "waloria") then
        if player:HasSpell(21084) then 
            player:Yell("Has: ", 0)
        end

        SpellClass:SaveSpellChoices(player, SpellClass:RandomPlayerSpellSelection(player, 1))
        CheckPlayerSpellChoice(player:GetGUID())
        return false
    end
end

RegisterPlayerEvent(42, OnCommand)

function MyHandlers.SpellSelection(player, spellID) -- For learning the spell
    if SpellClass:CanLearnSpellFromNextChoice(player, spellID) then 
        if SpellClass:CanLearnCustomSpell(player) then 
            player:LearnSpell(spellID)
        elseif player:AddItem(SpellClass:ComputeTomeItemIDFromSpellID(spellID)) then 
            player:SendBroadcastMessage("You have received a spell manual.")
        else
            local tomeID = SpellClass:ComputeTomeItemIDFromSpellID(spellID)
            local subject = "Spell Tome"
            local message = "You have received a spell manual from a previous spell selection.\n\n"
            local sender = SpellClass:GetPlayerCharacterGUID(player)
            local receiver = sender
            SendMail(subject, message, receiver, sender, 61, 0, 0, 0, tomeID, 1)
            player:SendBroadcastMessage("You have received a mail containg your selected spell manual.")
        end

        SpellClass:DeleteNextSpellChoiceFromDB(player)
        CheckPlayerSpellChoice(player:GetGUID())
        CheckCategorySelectionChoice(player)
    end
end

function MyHandlers.CategorySelection(player, categoryID)
    if categoryID == 1 or categoryID == 2 or categoryID == 3 or categoryID == 4 then
        local row = SpellClass:GetNextCategoryChoice(player)
        SpellClass:DeleteNextCategoryChoice(player)
        SpellClass:SaveSpellChoices(player, SpellClass:RandomPlayerSpellSelection(player, categoryID, tonumber(row["level"])))
        local playerGUID = player:GetGUID()
        CreateLuaEvent(function()CheckPlayerSpellChoice(playerGUID)end, 100, 1)
        --CheckPlayerSpellChoice(player)
    end
end

-- UNLEARN TOGGLE BELOW'

function MyHandlers.GetToggleState(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)

    if unlearnToggle[charGUID] == nil then 
        unlearnToggle[charGUID] = false
    end

    return unlearnToggle[charGUID]
end

function MyHandlers.InvertToggleState(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)

    if unlearnToggle[charGUID] then
        unlearnToggle[charGUID] = false
    else
        unlearnToggle[charGUID] = true
    end 
end

function MyHandlers.UpdateToggleState(player)
    if player:GetLevel() < 10 then return end

    AIO.Handle(player, "Waloria", "UpdateUnlearnToggle", MyHandlers.GetToggleState(player))
end

function MyHandlers.UnlearnToggle(player) 
    MyHandlers.InvertToggleState(player)
    unlearnToggle[SpellClass:GetPlayerCharacterGUID(player)] = MyHandlers.GetToggleState(player)
    MyHandlers.UpdateToggleState(player)
end

function MyHandlers.UnlearnSpell(player, spellID) -- For unlearning the spell
    if MyHandlers.GetToggleState(player) and SpellClass:ValidSpellToRemove(spellID) then 
        local tomeEntry = SpellClass:ComputeTomeItemIDFromSpellID(spellID)
        
        if tomeEntry and player:HasSpell(spellID) and player:AddItem(tomeEntry) then
            player:RemoveSpell(spellID, false, false)
            player:RemoveAura(spellID)
        end
    end
end

local function OnLevelChangeToggle(event, player, oldLevel)
    if player:GetLevel() >= 10 then 
        MyHandlers.UpdateToggleState(player)
    end
end

RegisterPlayerEvent(13, OnLevelChangeToggle)

-- Register manual on use

local function ManualOnUse(event, player, item, target)
    if not SpellClass:CanLearnCustomSpell(player) then
        player:SendAreaTriggerMessage("You already know the max amount of spells.")
        return false
    end
end

local query = WorldDBQuery("SELECT entry FROM item_template WHERE item_template.name LIKE '%Manual%' AND entry>90000;")
if query then 
    repeat

    local row = query:GetRow()
    local entry = row["entry"]

    RegisterItemEvent(entry, 2, ManualOnUse)

    until not query:NextRow()
end



