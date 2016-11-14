-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 50023
local frostqueenEntry = 50010

local timers = {}
local spells = {}

spells["frostboltaoe"] = 72015
spells["enrage"] = 54427

timers["frostboltaoe"] = 4000

local triggerRange = 2

local function reset(cr)
  cr:SetData("activated", false)
end

local function frostboltaoe(_, _, _, cr)
  cr:CastSpell(cr:GetVictim(), spells["frostboltaoe"], true)
end

local function checkEnrage(_, _, _, cr)
  local players = cr:GetPlayersInRange(triggerRange)

  if not next(players) and not cr:GetData("activated") then -- If activates
    cr:SetData("activated", true)
    
    cr:ClearUnitState(256)
    cr:ClearUnitState(5129)

    cr:CastSpell(cr, spells["enrage"], true)


    cr:RegisterEvent(frostboltaoe, timers["frostboltaoe"], 0)
  end
end

local function OnLeaveCombat(event, cr)
  reset(cr)
  cr:SetRooted(false)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  reset(cr)
  cr:SetRooted(false)
  cr:RemoveEvents()
end

local function OnSpawn(event, cr)
  cr:SetData("activated", false)
  cr:RegisterEvent(checkEnrage, 1000, 0)
end

RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)