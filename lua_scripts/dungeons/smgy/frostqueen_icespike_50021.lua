-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 50021
local frostqueenEntry = 50010

local timers = {}
local spells = {}

spells["icespikevisual"] = 90042
spells["icespikedamage"] = 90043
spells["knockup"] = 90044

timers["icespikeduration"] = 2000

local range = 0.5

local function knockup(_, _, _, cr)
  local players = cr:GetPlayersInRange(range)
  local frostqueen = cr:GetCreaturesInRange(300, frostqueenEntry)[1]

  for _, player in ipairs(players) do 
    player:CastSpell(player, spells["knockup"])

    if frostqueen ~= nil then 
      frostqueen:CastSpell(player, spells["icespikedamage"], true)
    end
  end
end

local function icespike(_, _, _, cr)
  cr:CastSpell(cr, spells["icespikevisual"])
  cr:RegisterEvent(knockup, timers["icespikeduration"], 1)
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(icespike, 0, 1)
end

RegisterCreatureEvent(npcEntry, 5, OnSpawn)