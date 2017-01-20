-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 100005

local spells = {
  ["purpleffectchest"] = 68862,
  ["voidaura"] = 150015,
  ["shadownova"] = 150014,
  ["knockback"] = 65100,
  ["frenzy"] = 41305,
  ["sinisterbeam"] = 40859,
  ["voidstrike"] = 60590,
}

local timers = {
  ["meteor"] = 2000,
  ["stunself"] = 1000, -- Delay timer
  ["frenzy"] = 10000,
  ["sinisterbeam"] = 4000,
  ["voidstrike"] = 3500,
}

local objects = {
  ["wall"] = 4001779,
}

local creatures = {
  ["ballcontroller"] = 100007,
  ["meteorcontroller"] = 100006,
  ["infernalball"] = 100003,
  ["magicshield"] = 100009,
}

local magicShieldPos = {
  [1] = {42.638317, 142.655502, 83.544601, 3.157894},
}

local function despawnWall(creature)
  local gameObjects = creature:GetGameObjectsInRange(300, objects["wall"])

  if gameObjects then 
    for _, gameObject in pairs(gameObjects) do
      if gameObject:GetGUIDLow() == creature:GetData("wallGUID") then 
        gameObject:Despawn(0)
      end
    end
  end
end

local function spawnWall(_, _, _, creature)
  local gameObject = creature:SummonGameObject(objects["wall"], 58.792629, 142.812698, 83.489021, 3, 300000000)
  creature:SetData("wallGUID", gameObject:GetGUIDLow())
end

local function despawnBalls(creature)
  local balls = creature:GetCreaturesInRange(150, creatures["infernalball"])

  for _, ball in pairs(balls) do 
    ball:DespawnOrUnsummon(0)
  end
end

local function despawnBallController(creature)
  local ballcontrollers = creature:GetCreaturesInRange(150, creatures["ballcontroller"])
  local ballcontrollerGUIDs = creature:GetData("ballcontrollerGUIDs")

  for _, ballcontroller in pairs(ballcontrollers) do 
    for _, ballcontrollerGUID in pairs(ballcontrollerGUIDs) do 
      if ballcontroller:GetGUIDLow() == ballcontrollerGUID then
        ballcontroller:DespawnOrUnsummon(0)
      end
    end
  end
end

local function spawnBallController(_, _, _, creature)
  local x = creature:GetX()
  local y = creature:GetY()
  local z = 83.545609
  local o = creature:GetO()

  local ballcontroller = creature:SpawnCreature(creatures["ballcontroller"], x, y, z, o, 2, 300000)

  local ballcontrollerGUIDs = creature:GetData("ballcontrollerGUIDs")
  table.insert(ballcontrollerGUIDs, ballcontroller:GetGUIDLow())
  creature:SetData("ballcontrollerGUIDs", ballcontrollerGUIDs)
end

local function despawnMeteors(creature)
  local meteorcontrollers = creature:GetCreaturesInRange(150, creatures["meteorcontroller"])
  local meteorcontrollerGUIDs = creature:GetData("meteorcontrollerGUIDs")

  for _, meteorcontroller in pairs(meteorcontrollers) do 
    for _, meteorcontrollerGUID in pairs(meteorcontrollerGUIDs) do 
      if meteorcontroller:GetGUIDLow() == meteorcontrollerGUID then
        meteorcontroller:DespawnOrUnsummon(0)
      end
    end
  end
end

local function spawnMeteor(_, _, _, creature)
  local players = creature:GetPlayersInRange(150)
  local playerIndex = math.random(1, #players)
  local target = players[playerIndex]

  local x = target:GetX()
  local y = target:GetY()
  local z = target:GetZ()
  local o = target:GetO()

  local meteorcontroller = creature:SpawnCreature(creatures["meteorcontroller"], x, y, z, o, 2, 300000)

  local meteorcontrollerGUIDs = creature:GetData("meteorcontrollerGUIDs")
  table.insert(meteorcontrollerGUIDs, meteorcontroller:GetGUIDLow())
  creature:SetData("meteorcontrollerGUIDs", meteorcontrollerGUIDs)
end

local function despawnMagicShield(creature)
  local magicshields = creature:GetCreaturesInRange(150, creatures["magicshield"])
  local magicshieldGUIDs = creature:GetData("magicshieldGUIDs")

  for _, magicshield in pairs(magicshields) do 
    for _, magicshieldGUID in pairs(magicshieldGUIDs) do 
      if magicshield:GetGUIDLow() == magicshieldGUID then 
        magicshield:DespawnOrUnsummon(0)
      end
    end
  end
end

local function spawnMagicShield(_, _, _, creature)
  local position = magicShieldPos[1]

  local x = position[1]
  local y = position[2]
  local z = position[3]
  local o = position[4]

  local magicshield = creature:SpawnCreature(creatures["magicshield"], x, y, z, o, 2, 300000)

  local magicshieldGUIDs = creature:GetData("magicshieldGUIDs")
  table.insert(magicshieldGUIDs, magicshield:GetGUIDLow())
  creature:SetData("magicshieldGUIDs", magicshieldGUIDs)
end

local function castShadowNova(_, _, _, creature)
  creature:CastSpell(creature, spells["shadownova"])
end

local function playerNovaAuras(_, _, _, creature)
  local players = creature:GetPlayersInRange(150)

  for _, player in pairs(players) do 
    local shield = player:GetCreaturesInRange(3, creatures["magicshield"])[1]

    if shield then 
      player:AddAura(spells["voidaura"], player)
    else
      player:RemoveAura(spells["voidaura"])
    end
  end
end

local function removePlayerAuras(creature)
  local players = creature:GetPlayersInRange(150)

  for _, player in pairs(players) do 
    player:RemoveAura(spells["voidaura"])
  end
end

local function castFrenzy(_, _, _, creature)
  creature:CastSpell(creature, spells["frenzy"], true)
end

local function knockback(_, _, _, creature)
  creature:CastSpell(creature, spells["knockback"], true)
end

local function sinisterbeam(_, _, _, creature)
  creature:CastSpell(creature:GetVictim(), spells["sinisterbeam"], true)
end

local function voidstrike(_, _, _, creature)
  creature:CastSpell(creature:GetVictim(), spells["voidstrike"], true)
end

local function registerBasic(creature)
  creature:RegisterEvent(sinisterbeam, timers["sinisterbeam"], 0)
  creature:RegisterEvent(voidstrike, timers["voidstrike"], 0)
end

local function despawnMagicShieldTimed(_, _, _, creature)
  despawnMagicShield(creature)
end

local function afternova(_, _, _, creature)
  creature:RemoveAura(spells["voidaura"])
  creature:RegisterEvent(despawnMagicShieldTimed, 1300, 1)

  creature:SetAggroEnabled(true)
  creature:SetRooted(false)

  creature:SetHealth(6391)
  creature:SendUnitYell("What is this immense power?", 0)

  registerBasic(creature)
  creature:RegisterEvent(castFrenzy, 0, 1)
  creature:RegisterEvent(castFrenzy, 10000, 0)
  creature:RegisterEvent(spawnMeteor, timers["meteor"], 0)
end

local function phaseOne(creature)
  creature:SendUnitYell("Begone!", 0)
  registerBasic(creature)
  creature:RegisterEvent(spawnMeteor, timers["meteor"], 0)
end

local function phaseTwo(creature)
  creature:SendUnitYell("Stop this nonsense!", 0)
  registerBasic(creature)
  creature:RegisterEvent(spawnBallController, 0, 1) 
end

local function phaseThree(creature)
  creature:SendUnitYell("Enough already!", 0)
  creature:RegisterEvent(sinisterbeam, timers["sinisterbeam"], 0)
  creature:RegisterEvent(castFrenzy, timers["frenzy"], 0)

  creature:RegisterEvent(spawnBallController, 0, 1)
  creature:RegisterEvent(spawnBallController, 2500, 1)
  creature:RegisterEvent(spawnMeteor, timers["meteor"], 0)

  creature:RegisterEvent(knockback, 0, 1)
  creature:RegisterEvent(knockback, 12000, 0)
end

local function phaseFour(creature)
  despawnBallController(creature)
  despawnBalls(creature)

  creature:RegisterEvent(spawnMagicShield, 0, 1)

  creature:AttackStop()
  creature:SetAggroEnabled(false)
  creature:SetRooted(true)

  creature:CastSpell(creature, spells["voidaura"], true)
  creature:CastSpell(creature, spells["purpleffectchest"], true)
  creature:SendUnitYell("I'm starting to feel.. unstable...", 0)

  local players = creature:GetPlayersInRange(50)
  for _, player in pairs(players) do
    player:SendAreaTriggerMessage("Fel'Ron starts to channel Shadow Nova.")
  end

  creature:RegisterEvent(playerNovaAuras, 50, 0)
  creature:RegisterEvent(castShadowNova, 0, 1)
  creature:RegisterEvent(afternova, 7001, 1)
end

local function reset(creature)
  creature:SetAggroEnabled(true)
  creature:SetRooted(false)

  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
  creature:SetData("four", false)

  creature:SetData("ballcontrollerGUIDs", {})
  creature:SetData("meteorcontrollerGUIDs", {})
  creature:SetData("magicshieldGUIDs", {})
end

local function OnSpawn(event, creature)
  reset(creature)
end

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct > 60 and cHealthPct < 90 and not creature:GetData("one") then
    creature:RemoveEvents()
    phaseOne(creature)
  
    creature:SetData("one", true)
  end

  if cHealthPct > 30 and cHealthPct < 60 and not creature:GetData("two") then
    creature:RemoveEvents()
    phaseTwo(creature)

    creature:SetData("two", true)
  end

  if cHealthPct > 5 and cHealthPct < 30 and not creature:GetData("three") then 
    creature:RemoveEvents()
    phaseThree(creature)

    creature:SetData("three", true)
  end

  if cHealthPct < 5 and not creature:GetData("four") then 
    creature:RemoveEvents()
    phaseFour(creature)

    creature:SetData("four", true)
  end
end

local function OnEnterCombat(event, creature, target) 
  creature:SendUnitYell("You puny folks will not stand a chance against me!", 8)
  creature:RegisterEvent(spawnWall, 0, 1)
  registerBasic(creature)
end

local function OnLeaveCombat(event, creature)
  removePlayerAuras(creature)
  despawnWall(creature)
  despawnMeteors(creature)
  despawnMagicShield(creature)
  despawnBallController(creature)
  despawnBalls(creature)
  reset(creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  removePlayerAuras(creature)
  despawnWall(creature)
  despawnMeteors(creature)
  despawnMagicShield(creature)
  despawnBallController(creature)
  despawnBalls(creature)
  reset(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 9, OnDamageTaken)