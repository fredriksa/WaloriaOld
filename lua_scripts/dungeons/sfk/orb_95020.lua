-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95020

local spells = {}
local timers = {}
local range = {}

spells["replenishment"] = 61782
timers["replenishment"] = 50

range["replenishment"] = 3

function playerInList(playerList, player)
  for _, p in pairs(playerList) do 
    if p:GetGUIDLow() == player:GetGUIDLow() then
      return true
    end
  end

  return false
end

local function replenishment(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(range["replenishment"])

  for _, player in pairs(players) do 
    if not player:HasAura(spells["replenishment"]) then 
      player:AddAura(spells["replenishment"], player)
    end
  end
end

local function checkReplenishments(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(5)
  local playersClose = creature:GetPlayersInRange(range["replenishment"])

  for _, player in pairs(players) do 
    if not playerInList(playersClose, player) then 
      player:RemoveAura(spells["replenishment"])
    end
  end
end

local function removeReplenishments(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)

  for _, player in pairs(players) do
    if player:HasAura(spells["replenishment"]) then 
      player:RemoveAura(spells["replenishment"])
    end 
  end
end

local function OnDespawn(event, creature, summon)
  creature:RegisterEvent(removeReplenishments, 0, 1)
end

local function OnSpawn(event, creature)
  creature:RegisterEvent(replenishment, timers["replenishment"], 0)
  creature:RegisterEvent(checkReplenishments, timers["replenishment"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RegisterEvent(removeReplenishments, 0, 1)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 20, OnDespawn)