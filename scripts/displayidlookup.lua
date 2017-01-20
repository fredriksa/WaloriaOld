local function OnPlayerChat(event, player, msg, type, lang)
  if string.match(msg, "#display") then 
    if not player:IsGM() then 
      return
    end

    words = {}
    for word in msg:gmatch("%w+") do 
      table.insert(words, word)
    end

    if #words == 0 then 
      player:SendBroadcastMessage("You must provide a display ID!")
      return false
    end

    -- Finds item display id
    query = WorldDBQuery(string.format("SELECT displayid FROM item_template WHERE entry=%s", words[2]))

    if not query then
      player:SendBroadcastMessage("No display ID found") 
      return false
    end

    row = query:GetRow()

    player:SendBroadcastMessage("Display ID: "..row["displayid"])

    return false
  end
end

RegisterPlayerEvent(18, OnPlayerChat)