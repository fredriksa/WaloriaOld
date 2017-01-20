local function OnResetTalentsCommand(event, player, command)
  if (command == "resettalents") then
    player:ResetTalents()
    player:SendBroadcastMessage("Your talents have been reset.")
    return false
  end 
end

RegisterPlayerEvent(42, OnResetTalentsCommand)