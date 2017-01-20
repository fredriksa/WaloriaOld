local function OnPlayerJoin(_, _, _, player)
  player:SendAreaTriggerMessage("Welcome to Waloria!")

  SendWorldMessage("[|cff1ABC9CAnnouncer|r] Welcome to Waloria "..player:GetName().."!")
end

function OnPlayerFirstJoin(event, player)
  player:RegisterEvent(OnPlayerJoin, 1000, 1)
end

RegisterPlayerEvent(30, OnPlayerFirstJoin)
