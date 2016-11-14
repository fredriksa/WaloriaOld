-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 100003

local spells = {}
local timers = {}

spells["infernalball"] = 150003
spells["aoeknockupdamage"] = 150004
spells["felimmolate"] = 150005

spells["cosmeticexplosion"] = 64079

local movementPath = {
  [1] = {1, 56.341835, 121.857231, 83.545624},
  [2] = {2, 24.506247, 158.195282, 83.545624},
  [3] = {3, -3.581095, 120.810921, 83.545624},
  [4] = {4, -30.634377, 162.363220, 83.545723},
  [5] = {5, -52.241520, 138.573486, 83.545624},
  [6] = {6, -34.158676, 120.475624, 83.546471},
  [7] = {7, -6.167376, 162.789291, 83.545639},
  [8] = {8, 21.290506, 126.409035, 83.545715},
  [9] = {9, 29.998611, 155.795044, 83.545609},
  [10] = {10, 56.341835, 121.857231, 83.545624},
}

local function playerCollision(_, _, _, creature)
  local players = creature:GetPlayersInRange(1)

  if players then 
    local hitPlayer = false

    for _, playerHit in pairs(players) do
      if not playerHit:IsGM() then 
        hitPlayer = true
        playerHit:CastSpell(playerHit, spells["aoeknockupdamage"], true)

        playerHit:CastSpell(playerHit, spells["felimmolate"], true)
        playerHit:CastSpell(playerHit, spells["cosmeticexplosion"], true)

        -- Get all the players surrounding the hit player and add fire damage
        local playersHit = playerHit:GetPlayersInRange(5)
        for _, player in pairs(playersHit) do 
          if player:GetGUIDLow() ~= playerHit:GetGUIDLow() then
            player:CastSpell(player, spells["felimmolate"], true)
          end
        end

      end
    end

    if hitPlayer then
      creature:DespawnOrUnsummon(0)
    end
  end
end

local function nextWP(_, _, _, creature)
  local nextMoveIndex = creature:GetData("lastWaypoint") + 1

  if nextMoveIndex > #movementPath then 
    nextMoveIndex = 0
  end

  local nextMove = movementPath[nextMoveIndex]
  if not nextMove then 
    nextMove = movementPath[1]
    creature:SetData("lastWaypoint", 1)
  end

  creature:MoveTo(nextMove[1], nextMove[2], nextMove[3], nextMove[4])
end

local function OnReachWP(event, creature, type, id)
  creature:SetData("lastWaypoint", id)
  creature:RegisterEvent(nextWP, 0, 1)
end

local function OnSpawn(event, creature)
  creature:CastSpell(creature, spells["infernalball"], true)

  creature:RegisterEvent(playerCollision, 50, 0)

  --local nextMoveIndex = math.random(1, #movementPath)
  --local nextMove = movementPath[nextMoveIndex]
  --creature:MoveTo(nextMove[1], nextMove[2], nextMove[3], nextMove[4])
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 6, OnReachWP)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 4, OnDied)