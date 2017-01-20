function giveUpdate(player)
  local query = WorldDBQuery("SELECT * FROM custom_update_spells") 

  if query then
    repeat

    local row = query:GetRow()

    local spellID = tonumber(row["spellID"])

    if not player:HasSpell(spellID) then
      player:LearnSpell(spellID)
    end

    until not query:NextRow()
  end
end

local function OnUpdateCommand(event, player, command)
  if (command == "update") then
    giveUpdate(player)
    player:SendBroadcastMessage("Missing spells/skills have been added to your character.")
    return false
  end 
end

local function OnLogin(event, player)
  giveUpdate(player)
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(42, OnUpdateCommand)