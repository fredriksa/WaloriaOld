local helper = require("../creaturehelper").new()
local npcEntry = 96012

local spells = {}
local timers = {}
local creatures = {}

spells["renddragonmorph"] = 16167
spells["taunt"] = 93029
spells["berserkeraura"] = 93030
spells["whirlwind"] = 93031
spells["orangearrow"] = 93019
spells["sunder"] = 93033
spells["bludgeoningstrike"] = 93034

creatures["gyth"] = 96013
creatures["tornado"] = 151900
creatures["child"] = 96014

timers["spawnchild"] = 7000
timers["whirlwind"] = 25000
timers["spawntornadomarker"] = 20000
timers["spawntornado"] = 4000
timers["sunder"] = 10000
timers["bludgeoningstrike"] = 5000

spawnpoints = {
  [1] = {178.989426, -407.462952, 123, 3.759662},
  [2] = {157.188155, -407.175018, 123, 3.205145},
  [3] = {159.587357, -434.048340, 123, 3.652806},
  [4] = {141.100250, -429.070831, 123, 3.067684},
  [5] = {131.266541, -427.235443, 123, 1.796783},
  [6] = {130.818344, -408.944092, 123, 0.547341},
  [7] = {139.850861, -420.371307, 123, 6.225755},
  [8] = {186.764069, -418.806915, 123, 6.037264},
  [9] = {187.305450, -433.820801, 123, 5.448205},
  [10] = {163.962204, -420.915344, 123, 2.879955}
}

local gythSpawn = {138.099854, -404.259094, 125.499153}

local function morphMount(_, _, _, cr)
  --cr:CastSpell(cr, spells["renddragonmorph"], true) -- Mounted on dragon
end

local function prepareCreature(cr)
  --Despawn gyth if already spawned
  if cr:GetData("gyth") then 
    local gyth = helper:GetCreatureNear(cr, cr:GetData("gyth"))

    if gyth ~= nil then 
      gyth:DespawnOrUnsummon(0)
    end
  end

  cr:RegisterEvent(morphMount, 15000, 1)

  helper:DespawnCreatureTable(cr, cr:GetData("tornadoes"))
  helper:DespawnCreatureTable(cr, cr:GetData("children"))

  cr:SetData("phase1", false)
  cr:SetData("gythstop", false)
  cr:SetData("phase2", false)
  cr:SetData("phase3", false)
  cr:SetData("gyth", false)
  cr:SetData("tornadoes", false)
  cr:SetData("children", false)
end

local function spawnTornado(_, _, _, cr)
  local players = cr:GetPlayersInRange(100)

  --Get candidates
  local tornadoCandidates = {}
  for k, player in ipairs(players) do 
    if player:HasAura(spells["orangearrow"]) then 
      table.insert(tornadoCandidates, player)
    end
  end
  --Select target
  local target = nil
  if #tornadoCandidates == 1 then 
    target = tornadoCandidates[1]
  elseif #tornadoCandidates > 1 then 
    target = tornadoCandidates[math.random(1, #tornadoCandidates)]
  end 

  --Check if we have a available target
  if not target then return end
  if not helper:IsOnGround(target) then 
    cr:RegisterEvent(spawnTornado, 75, 1)
    return false
  end

  for k, candidate in ipairs(tornadoCandidates) do 
    if helper:IsOnGround(candidate) then 
      local tornado = cr:SpawnCreature(creatures["tornado"], candidate:GetX(), candidate:GetY(), candidate:GetZ(), candidate:GetO(), 2, 3000000)
      tornado:MoveRandom(30)

      local tornadoes = cr:GetData("tornadoes")
      if not tornadoes then 
        tornadoes = {}
      end

      table.insert(tornadoes, tornado:GetGUIDLow())
      cr:SetData("tornadoes", tornadoes)

      if candidate:HasAura(spells["orangearrow"]) then 
        candidate:RemoveAura(spells["orangearrow"])
      end
    else
      cr:RegisterEvent(spawnTornado, 20, 1)
    end
  end
end

local function spawnTornadoMarker(_, _, _, cr)
  local targets = helper:PickRandomCreatureTargetsUnique(cr, 2)
  if not targets then return end

  if #targets == 1 then 
    cr:AddAura(spells["orangearrow"], targets[1])
    cr:RegisterEvent(spawnTornado, timers["spawntornado"], 1)
    return
  end

  for k, v in ipairs(targets) do 
    cr:AddAura(spells["orangearrow"], v)
    cr:RegisterEvent(spawnTornado, timers["spawntornado"], 1)
  end
end

local function spawnChild(_, _, _, cr)
  local loc = spawnpoints[math.random(1, #spawnpoints)]
  local child = cr:SpawnCreature(creatures["child"], loc[1], loc[2], loc[3], loc[4], 2, 300000)
  child:SetWalk(true)
  child:AttackStart(cr)

  local children = cr:GetData("children")
  if not children then children = {} end

  table.insert(children, child:GetGUIDLow())
  cr:SetData("children", children)
end

local function checkChild(_, _, _, cr)
  local children = cr:GetData("children")
  if not children then return end

  for k, guid in ipairs(children) do 
    local child = helper:GetCreatureNear(cr, guid) 

    if child then 
      if child:GetDistance(cr) < 1.2 then 
        cr:CastSpell(cr, spells["berserkeraura"], true)
        child:DespawnOrUnsummon()
      end
    end
  end
end

local function tauntChildren(_, _, _, cr)
  for k, creature in ipairs(cr:GetCreaturesInRange(creatures["child"], 100)) do 
    cr:CastSpell(creature, spells["taunt"], true)
  end
end

local function whirlwind(_, _, _, cr)
  local target = helper:PickRandomCreatureTarget(cr)
  target:CastSpell(cr, spells["taunt"], true)
  cr:CastSpell(cr, spells["whirlwind"], true)
end

local function sunder(_, _, _, cr)
  cr:CastSpell(cr:GetVictim(), spells["sunder"], true)
end

local function bludgeoningstrike(_, _, _, cr)
  cr:CastSpell(cr:GetVictim(), spells["bludgeoningstrike"], true)
end

local function basicRotation(cr)
  cr:RegisterEvent(whirlwind, timers["whirlwind"], 0)
  cr:RegisterEvent(sunder, timers["sunder"], 0)
  cr:RegisterEvent(bludgeoningstrike, timers["bludgeoningstrike"], 0)
end

local function phaseOne(cr)
  cr:DeMorph()
  local gyth = cr:SpawnCreature(creatures["gyth"], 137.707001, -364.882874, 125.136047, 4.729457, 2, 300000)
  --gyth:AttackStart(cr:GetVictim())
  cr:SetData("gyth", gyth:GetGUIDLow())
  cr:SendUnitYell("Release the dragon", 0)
end

local function phaseGythStop(cr)
  cr:SendUnitYell("Gyth, aid me!", 0)
  local gyth = helper:GetCreatureNear(cr, cr:GetData("gyth"))
  if not gyth then return end

  gyth:RemoveEvents()
  gyth:AttackStart(cr:GetVictim())
  gyth:RemoveFlag(59, 256)
  gyth:RemoveFlag(59, 512)
end

local function PhaseTwo(cr)
  cr:SendUnitYell("May fire consume you!", 0)
  cr:RegisterEvent(spawnTornadoMarker, 5000, 1)
  cr:RegisterEvent(spawnTornadoMarker, timers["spawntornadomarker"], 0)
end

local function phaseThree(cr)
  cr:SendUnitYell("Children, feed your master!", 0)
  cr:RegisterEvent(spawnChild, 1, 1)
  cr:RegisterEvent(spawnChild, timers["spawnchild"], 0)
  cr:RegisterEvent(checkChild, 50, 0)
  cr:RegisterEvent(tauntChildren, 100, 0)
  cr:RegisterEvent(spawnTornadoMarker, timers["spawntornadomarker"], 0)
end

local function OnSpawn(event, cr)
  prepareCreature(cr)
end

local function OnEnterCombat(event, cr, target)
  basicRotation(cr)
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

local function OnReset(event, cr)
  prepareCreature(cr)
end

local function OnDamageTaken(event, cr, attacker, damage)
  local healthPct = cr:GetHealthPct()

  if healthPct > 81 and healthPct < 91 and not cr:GetData("phase1") then 
    cr:RemoveEvents()
    basicRotation(cr)
    phaseOne(cr)
    cr:SetData("phase1", true)
  end

  if healthPct > 71 and healthPct < 81 and not cr:GetData("gythstop") then
    cr:RemoveEvents()
    basicRotation(cr)
    phaseGythStop(cr)
    cr:SetData("gythstop", true)
  end

  if healthPct > 40 and healthPct < 71 and not cr:GetData("phase2") then 
    cr:RemoveEvents()
    basicRotation(cr)
    PhaseTwo(cr)
    cr:SetData("phase2", true)
  end

  if healthPct < 41 and not cr:GetData("phase3") then 
    cr:RemoveEvents()
    basicRotation(cr)
    phaseThree(cr)
    cr:SetData("phase3", true)
  end
end 

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 9, OnDamageTaken)
RegisterCreatureEvent(npcEntry, 23, OnReset)

----- GYTH SECTION
local gythEntry = 96013

local spellsGyth = {}
local creaturesGyth = {}
local timersGyth = {}


spellsGyth["firerain"] = 93036
timersGyth["firerain"] = 750
timersGyth["fireduration"] = 10000
creaturesGyth["aoefiretrigger"] = 96015

local gythMovement = {
  [1] = {115.730370, -405.026031, 124.546097, 6.249193},
  [2] = {187.995514, -404.763733, 123.933357, 6.280606},
  [3] = {186.843048, -420.879517, 124.868355, 3.135114},
  [4] = {117.072144, -420.427521, 126.086525, 3.135114},
  [5] = {118.713722, -435.206940, 125.873093, 6.280619},
  [6] = {186.898636, -434.869049, 125.488686, 0.009214}
}

local function fireRain(_, _, _, cr)
  local trigger = cr:SpawnCreature(creaturesGyth["aoefiretrigger"], cr:GetX(), cr:GetY(), 110.862923, 1, 2, 300000)
  --cr:CastSpellAoF(cr:GetX(), cr:GetY(), 110.862923, spellsGyth["firebreath"], true)
end

local function OnReachWPGyth(event, cr, type, id)
  local nextId = id + cr:GetData("direction")

  if nextId == 1 then 
    cr:SetData("direction", 1)
  elseif nextId == #gythMovement then 
    cr:SetData("direction", -1)
  end

  if nextId <= #gythMovement then 
    local nextPos = gythMovement[nextId]
    cr:MoveTo(nextId, nextPos[1], nextPos[2], nextPos[3], false)
  end
end

local function OnSpawnGyth(event, cr)
  cr:RegisterEvent(fireRain, timersGyth["firerain"], 0)
  cr:SetData("direction", 1)
  cr:SetFlag(59, 256) -- 59 = unit_field_flags 256 = immune to pc
  cr:SetFlag(59, 512) -- 512 = immune to npc
  cr:MoveTo(1, gythSpawn[1], gythSpawn[2], gythSpawn[3], false)
end

RegisterCreatureEvent(gythEntry, 6, OnReachWPGyth)
RegisterCreatureEvent(gythEntry, 5, OnSpawnGyth)

--AoEFireTrigger

local function despawnSelf(_, _, _, cr)
  cr:DespawnOrUnsummon(1)
end

local function OnSpawnTrigger(event, cr)
  cr:CastSpellAoF(cr:GetX(), cr:GetY(), cr:GetZ(), spellsGyth["firerain"], true)
  cr:RegisterEvent(despawnSelf, timersGyth["fireduration"], 1)
end

RegisterCreatureEvent(creaturesGyth["aoefiretrigger"], 5, OnSpawnTrigger)