-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local Kagar = {}

spells["charge"] = 68764
spells["whirlwind"] = 90008
spells["cleave"] = 90010
spells["heroicstrike"] = 90011
spells["magneticpull"] = 30010
spells["chaincosmetic"] = 54549
spells["stun"] = 46441 
spells["enrage"] = 54287
spells["explosion"] = 64079

timers["phaseOne"] = 6500
timers["phaseTwo"] =  12000
timers["cleave"] = 1500
timers["heroicstrike"] = 6000
timers["stun"] = 500

local function reset(creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
end

-- Phases

function Kagar.phaseOne(eventID, delay, pCall, creature) 
  local players = creature:GetPlayersInRange(15)

  -- Pull all players in range
  for _, player in pairs(players) do 

    -- Force casts the cosmetic chain
    creature:CastSpell(player, spells["chaincosmetic"], true)

    -- Force casts the pull
    creature:CastSpell(player, spells["magneticpull"], true)
  end

  -- Casts cleave on player, timer being the delay until cast
  creature:RegisterEvent(Kagar.castCleave, timers["cleave"], 1)
end

function Kagar.phaseTwo(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(30)

  -- Select random player
  local nPlayers = #players
  local playerIndex = math.random(1, nPlayers)

  local target = players[playerIndex]

  -- Charges at random target
  creature:CastSpell(target, spells["charge"], true)

  -- Stuns all players 3 times for a total of 3 seconds
  creature:RegisterEvent(Kagar.castStun, timers["stun"], 1)

  creature:CastSpell(target, spells["whirlwind"], true)
end

function Kagar.phaseThree(creature) 
  creature:SendUnitYell("You're pissing me off!", 0)
  creature:CastSpell(creature, spells["enrage"], true)
end

function Kagar.castStun(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(30)

  for _, player in pairs(players) do 
    player:CastSpell(player, spells["stun"], true)
  end
end

function Kagar.castCleave(eventID, delay, pCall, creature) 
  local cleaveTarget = creature:GetPlayersInRange(8)[1]
  local players = creature:GetPlayersInRange(30)

  creature:CastSpell(cleaveTarget, spells["cleave"], true)

  -- Remove chain visual after casting cleave (cleave 'breaks' the chain)
  for _, player in pairs(players) do 
    player:RemoveAura(spells["chaincosmetic"])
  end
end

function Kagar.castHeroicstrike(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["heroicstrike"], true)
end


local function OnEnterCombat(event, creature, target)
  reset(creature)
  creature:SendUnitYell("You think you stand a chance?", 0)
  creature:CastSpell(target, spells["charge"], target)
  creature:RegisterEvent(Kagar.castHeroicstrike, timers["heroicstrike"], 0)
end

RegisterCreatureEvent(95000, 1, OnEnterCombat)

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct > 50 and cHealthPct < 90 and not creature:GetData("one") then
    creature:RegisterEvent(Kagar.castHeroicstrike, timers["heroicstrike"], 0)
    creature:RegisterEvent(Kagar.phaseOne, 0, 1)
    creature:RegisterEvent(Kagar.phaseOne, timers["phaseOne"], 0)
  
    creature:SetData("one", true)
  end

  if cHealthPct > 10 and cHealthPct < 50 and not creature:GetData("two") then
    creature:RemoveEvents()
    creature:RegisterEvent(Kagar.castHeroicstrike, timers["heroicstrike"], 0)
    creature:RegisterEvent(Kagar.phaseTwo, 0, 1)
    creature:RegisterEvent(Kagar.phaseTwo, timers["phaseTwo"], 0)

    creature:SetData("two", true)
  end

  if cHealthPct < 10 and not creature:GetData("three") then 
    creature:RemoveEvents()
    creature:RegisterEvent(Kagar.castHeroicstrike, timers["heroicstrike"], 0)
    Kagar.phaseThree(creature)

    creature:SetData("three", true)
  end
end

RegisterCreatureEvent(95000, 9, OnDamageTaken)

function OnLeaveCombat(event, creature)
  reset(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95000, 2, OnLeaveCombat)

function OnDied(event, creature, killer)
  creature:SendUnitYell("I failed my call..", 0)
  creature:CastSpell(creature, spells["explosion"], true)
  reset(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95000, 4, OnDied)