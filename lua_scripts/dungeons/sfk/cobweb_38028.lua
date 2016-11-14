-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 38028

local function OnSpawn(event, creature, target)
  creature:SetRooted(true)
  creature:SetAggroEnabled(false)
end

RegisterCreatureEvent(npcEntry, 5, OnSpawn)