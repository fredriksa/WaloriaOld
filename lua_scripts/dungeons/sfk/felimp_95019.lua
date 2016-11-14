-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95019

local spells = {}
local timers = {}


local function ripflesh(eventID, delay, pCall, creature)

end


local function OnReachWP(event, creature, type, id) 
  
  if id == 1 then 
    local players = creature:GetPlayersInRange(100)
    local playerIndex = math.random(1, #players)
    local player = players[playerIndex]

    creature:AttackStart(player)
  end
end

local function OnEnterCombat(event, creature, target)

end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 6, OnReachWP)