local npcEntry = 96004
local creatures = {}
local timers = {}

timers["spawnWhelp"] = 2000
creatures["whelp"] = 96005

local function spawnWhelp(eventID, delay, pCall, cr)
  local whelp = cr:SpawnCreature(creatures["whelp"], cr:GetX(), cr:GetY(), cr:GetZ(), cr:GetO(), 2, 300000)
  whelp:AttackStart(cr:GetVictim())

  local whelpGUIDs = cr:GetData("whelps")
  if whelpGUIDs == nil then 
    local guids = {}
    table.insert(guids, whelp:GetGUIDLow())
    cr:SetData("whelps", guids)
  else
    table.insert(whelpGUIDs, whelp:GetGUIDLow())
    cr:SetData("whelps", whelpGUIDs)
  end
end

local function OnEnterCombat(event, cr, target)
  cr:RegisterEvent(spawnWhelp, timers["spawnWhelp"], 0)
end

local function despawnWhelps(cr)
  local whelpGUIDs = cr:GetData("whelps")
  if whelpGUIDs == nil then return end

  for k, whelpGUID in ipairs(whelpGUIDs) do 
    local creatures = cr:GetCreaturesInRange(100)

    for i, creature in ipairs(creatures) do 
      local creatureGUID = creature:GetGUIDLow()
      if whelpGUID == creatureGUID then 
        creature:DespawnOrUnsummon(0)
      end
    end
  end
end

local function OnLeaveCombat(event, cr)
  despawnWhelps(cr)
  cr:SetData("whelps", nil)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  despawnWhelps(cr)
  cr:SetData("whelps", nil)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)