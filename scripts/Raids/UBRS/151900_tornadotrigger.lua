local npcEntry = 151900
local spells = {}
local timers = {}

spells["knockback"] = 90044
spells["immolation"] = 93028

timers["knockbackcooldown"] = 2.5

local function despawnSelf(_, _, _, cr)
  cr:DespawnOrUnsummon(1)
end

local function update(eventID, delay, pCall, cr)
  for k, player in ipairs(cr:GetPlayersInRange(1)) do 
    local timeLast = cr:GetData(player:GetGUIDLow())
    local timeDiff = nil

    if timeLast then 
      timeDiff = os.clock() - timeLast
    end

    if not timeLast or timeDiff >= timers["knockbackcooldown"] then 
      player:CastSpell(player, spells["knockback"], true)
      player:CastSpell(player, spells["immolation"], true)
      cr:SetData(player:GetGUIDLow(), os.clock())
    end
  end
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(update, 25, 0)
  --cr:RegisterEvent(despawnSelf, 114000, 1)
  cr:MoveRandom(25)
end

local function OnEnterCombat(event, cr, target)

end

local function OnLeaveCombat(event, cr)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)