-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local phaselogger = {}

spells["charge"] = 68764
spells["rend"] = 90000
spells["whirlwind"] = 90001

timers["charge"] = 0
timers["rend"] = 4500
timers["whirlwind"] = 4700

local function reset(creature)
  creature:SetData("whirlwind", true)
end

local function charge(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["charge"], true)
end

local function whirlwind(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["whirlwind"], true)
end

local function rend(eventID, delay, pCall, creature)
  if not creature:HasUnitState(0x00008000) then
    creature:CastSpell(creature:GetVictim(), spells["rend"], true)
  end
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(charge, timers["charge"], 1)
  creature:RegisterEvent(rend, timers["rend"], 0)
end

local function OnSpawn(event, creature)
  creature:SetData("whirlwind", false)
end

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct < 70 and not creature:GetData("whirlwind") then 
    creature:RegisterEvent(whirlwind, timers["whirlwind"], 0)

    creature:SetData("whirlwind", true)
  end
end

local function OnLeaveCombat(event, creature)
  reset(creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  reset(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95002, 1, OnEnterCombat)
RegisterCreatureEvent(95002, 9, OnDamageTaken)
RegisterCreatureEvent(95002, 2, OnLeaveCombat)
RegisterCreatureEvent(95002, 5, OnSpawn)
RegisterCreatureEvent(95002, 4, OnDied)