-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local creatureEntry = 95008

local spells = {}
local timers = {}
local npcs = {}

spells["drainsoul"] = 90016
spells["curseofagony"] = 90015
spells["fear"] = 38154
spells["shackle"] = 38505
spells["shadowboltaoe"] = 90017
spells["teleport"] = 52096
spells["spawnineffect"] = 28234
spells["enrage"] = 54287

timers["drainsoul"] = 16500
timers["curseofagony"] = 24000
timers["randomplayerfear"] = 4500
timers["randomplayershackle"] = 5500
timers["shadowboltaoe"] = 6500

timers["teleport"] = 8000
timers["zombie"] = 800

npcs["zombie"] = 95009

local function reset(creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
  creature:SetData("basic", false)
  creature:SetData("topside", true)
  creature:SetData("zombieGUIDs", {})
end

local function removeplayershackles(creature)
  local players = creature:GetPlayersInRange(150)

  for _, player in pairs(players) do 
    player:RemoveAura(spells["shackle"])
  end
end

local function curseofagonyaoe(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(50)

  for i = 1, 2 do 
    local playerIndex = math.random(1, #players)
    local playerTarget = players[playerIndex]

    creature:CastSpell(playerTarget, spells["curseofagony"], true)
  end
end

local function drainsoul(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["drainsoul"], true)
end

local function shadowboltaoe(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["shadowboltaoe"], true)
end

local function randomplayerfear(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(50)
  local playerIndex = math.random(1, #players)
  local playerTarget = players[playerIndex]

  creature:CastSpell(playerTarget, spells["fear"], true)
end

local function randomplayershackle(eventID, delay, pCall, creature)
  removeplayershackles(creature)

  local players = creature:GetPlayersInRange(50)
  local playerIndex = math.random(1, #players)
  local playerTarget = players[playerIndex]

  creature:CastSpell(playerTarget, spells["shackle"], true)
end

local function teleport(eventID, delay, pCall, creature)
  if creature:GetData("topside") then 
    -- teleport bottom side
    creature:NearTeleport(-223.190140, 2276.684082, 77.052460, 2.8)
    creature:SetData("topside", false)
  else
    -- teleport top side
    creature:NearTeleport(-269.267, 2293.17, 77.475250, 5.91)
    creature:SetData("topside", true)
  end

  creature:CastSpell(creature, spells["teleport"], true)
  creature:SetRooted(true)

  drainsoul(nil, nil, nil, creature)
end

local function randomiseNumberRange(n1, n2)
  if n1 < n2 then 
    return math.random(n1, n2)
  else
    return math.random(n2, n1)
  end
end

local function spawnzombierandom(eventID, delay, pCall, creature)
  local bottomLeftX = -256.094727
  local bottomLeftY = 2298.627441
  local bottomLeftZ = 74.999527

  local topRightX = -226.274780
  local topRightY = 2271.737549
  local topRightZ = 75.000519

  local x = randomiseNumberRange(bottomLeftX, topRightX)
  local y = randomiseNumberRange(bottomLeftY, topRightY)
  local z = randomiseNumberRange(bottomLeftZ, topRightZ)
  local o = creature:GetO()

  local zombie = creature:SpawnCreature(npcs["zombie"], x, y, z, o, 2, 300000)
  local zombieGUIDs = creature:GetData("zombieGUIDs")
  table.insert(zombieGUIDs, zombie:GetGUIDLow())
  creature:SetData("zombieGUIDs", zombieGUIDs)

  zombie:AttackStart(zombie:GetNearestPlayer())
  zombie:CastSpell(zombie, spells["spawnineffect"], true)
end

local function addNormalEvents(creature)
  creature:RegisterEvent(drainsoul, timers["drainsoul"], 0)
  creature:RegisterEvent(curseofagonyaoe, timers["curseofagony"], 0)
end

local function addPhaseOneEvents(creature)
  creature:RegisterEvent(shadowboltaoe, timers["shadowboltaoe"], 0)
  creature:RegisterEvent(randomplayerfear, timers["randomplayerfear"], 0)
  creature:RegisterEvent(randomplayershackle, timers["randomplayershackle"], 0)
end

local function addPhaseTwoEvents(creature)
  creature:RegisterEvent(teleport, timers["teleport"], 0)
  creature:RegisterEvent(spawnzombierandom, timers["zombie"], 0)
end

local function OnSpawn(event, creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
  creature:SetData("basic", false)
  creature:SetData("topside", true)
  creature:SetData("zombieGUIDs", {})
end

local function OnEnterCombat(event, creature, target)
  creature:SendUnitYell("Who dares to disturb my dance?", 0)

  creature:CastSpell(target, spells["curseofagony"], true)
  creature:CastSpell(target, spells["drainsoul"])

  addNormalEvents(creature)
end

local function despawnZombies(creature)
  local creatures = creature:GetCreaturesInRange(160)

  for _, zLowGUID in pairs(creature:GetData("zombieGUIDs")) do
    for __, creature in pairs(creatures) do 

      if zLowGUID == creature:GetGUIDLow() then
        creature:DespawnOrUnsummon(0) -- Despawns our zombie
      end

    end
  end

end

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct > 90 and not creature:GetData("basic") then 
    addNormalEvents(creature)
    creature:SetData("basic", true)
  end

  if cHealthPct > 60 and cHealthPct < 90 and not creature:GetData("one") then
    creature:SendUnitYell("You got to dance like there's no second dance!", 0) 
    creature:RemoveEvents()
    addNormalEvents(creature)
    addPhaseOneEvents(creature)

    creature:SetData("one", true)
  end

  if cHealthPct > 20 and cHealthPct < 60 and not creature:GetData("two") then
    creature:RemoveEvents()

    addNormalEvents(creature)
    addPhaseTwoEvents(creature)

    removeplayershackles(creature)
    teleport(nil, nil, nil, creature)

    creature:SendUnitYell("Rise from the depths of hell!", 0)

    creature:SetData("two", true)
  end

  if cHealthPct > 0 and cHealthPct < 20 and not creature:GetData("three") then 
    creature:RemoveEvents()
    creature:SetRooted(false)
    addNormalEvents(creature)
    creature:CastSpell(creature, spells["enrage"], true)
    -- Might want to add normal events
    addPhaseOneEvents(creature)

    creature:SetData("three", true)
  end
end

local function OnLeaveCombat(event, creature)
  removeplayershackles(creature)
  despawnZombies(creature)
  creature:SetRooted(false)

  -- Teleport back to table
  creature:CastSpell(creature, spells["teleport"], true)
  creature:NearTeleport(-269.267, 2293.17, 77.475250, 5.91)

  reset(creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  removeplayershackles(creature)
  despawnZombies(creature)
  creature:SetRooted(false)
  reset(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(creatureEntry, 1, OnEnterCombat)
RegisterCreatureEvent(creatureEntry, 9, OnDamageTaken)
RegisterCreatureEvent(creatureEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(creatureEntry, 4, OnDied)
RegisterCreatureEvent(creatureEntry, 5, OnSpawn)