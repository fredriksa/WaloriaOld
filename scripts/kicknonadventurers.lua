local function OnPlayerLogin(_, player)
  if player:GetClass() ~= 11 then 
    player:KickPlayer()
  end
end

RegisterPlayerEvent(3, OnPlayerLogin)