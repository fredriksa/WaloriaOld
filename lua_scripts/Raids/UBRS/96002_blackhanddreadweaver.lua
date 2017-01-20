local helper = require("../creaturehelper").new()
local npcEntry = 96002
local spells = {}
local timers = {}
local creatures = {}

spells["buffaura"] = 93004
spells["purplearrow"] = 93008
spells["drainsoul"] = 93010

timers["checkVeterans"] = 1500
timers["spawndebuff"] = 6000
timers["acidspawn"] = 5000
timers["drainsoul"] = 13000

creatures["veteran"] = 96001
creatures["acidtrigger"] = 96006

local function removeDebuff(cr)
  local existingTargets = cr:GetData("acidtargets")

  if existingTargets ~= nil then 
    for i, existingGUID in ipairs(existingTargets) do 
      local players = cr:GetPlayersInRange(100)
      if not players then return end

      for k, v in ipairs(players) do
        if v:GetGUIDLow() == existingGUID then 

          v:RemoveAura(spells["purplearrow"])
        end
      end
    end
  end
end

local function checkVeterans(_, _, _, cr)
  local veterans = cr:GetCreaturesInRange(15, creatures["veteran"], 0, 1)

  if not veterans or #veterans == 0 then 
    cr:RemoveAura(spells["buffaura"])
  else
    cr:AddAura(spells["buffaura"], cr)
  end
end

--15
local function spawnAcidTriggers(_, _, _, cr)
  local players = cr:GetPlayersInRange(100)
  if not players then return end

  local existingTargets = cr:GetData("acidtargets")
  if not existingTargets then return end


  local removedTargets = false

  for i, existingGUID in ipairs(existingTargets) do 
    for k, v in ipairs(players) do 
      if v:GetGUIDLow() == existingGUID then 

        if v:IsFalling() or v:IsFlying() then 
          cr:RegisterEvent(spawnAcidTriggers, 100, 1)
          return 
        else
          removedTargets = true
          v:RemoveAura(spells["purplearrow"])
          cr:SpawnCreature(creatures["acidtrigger"], v:GetX(), v:GetY(), v:GetZ(), v:GetO(), 2, 300000)
        end
      end
    end
  end

  if removedTargets then 
    cr:SetData("acidtargets", nil)
  end
end

local function spawnDebuff(_, _, _, cr)
  removeDebuff(cr)

  local target1 = helper:PickRandomCreatureTarget(cr)
  local target2 = helper:PickRandomCreatureTarget(cr)
  cr:CastSpell(target1, spells["purplearrow"], true)
  cr:CastSpell(target2, spells["purplearrow"], true)

  local targetGUIDs = {
    [1] = target1:GetGUIDLow(),
    [2] = target2:GetGUIDLow(),
  }

  cr:SetData("acidtargets", targetGUIDs)
  cr:RegisterEvent(spawnAcidTriggers, timers["acidspawn"], 1)
end

local function castDrainSoul(_, _, _, cr)
  cr:CastSpellRAI(cr:GetVictim(), spells["drainsoul"], true)
end

local function OnEnterCombat(event, cr, target)
  cr:RegisterEvent(checkVeterans, 0, 1)
  cr:RegisterEvent(checkVeterans, timers["checkVeterans"], 0)
  cr:RegisterEvent(spawnDebuff, timers["spawndebuff"], 0)
  cr:RegisterEvent(castDrainSoul, timers["drainsoul"], 0)
end

local function OnLeaveCombat(event, cr)
  removeDebuff(cr)
  cr:SetData("acidtargets", nil)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  removeDebuff(cr)
  cr:SetData("acidtargets", nil)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)