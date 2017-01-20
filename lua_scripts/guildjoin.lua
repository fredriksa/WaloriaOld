local function OnFirstLogin(event, player)
  GetGuildByName("Waloria"):AddMember(player, 4)
end

RegisterPlayerEvent(30, OnFirstLogin)