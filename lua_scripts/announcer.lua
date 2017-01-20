local timer = 200 -- Timer in seconds

local announces = {
  --[1] = "Waloria's official launcher is now available for download at waloria.com/launcher.exe",
  --[1] = "Shadowfang Keep is now filled with a variety of loot for all your needs!",
  --[3] = "To write a message to everyone online simply write #w following with your message",
  --[1] = "Read about the latest changes at forum.waloria.com",
  --[1] = "Update your patches daily from www.waloria.com",
  --[2] = "Enable or disable world chat by typing .chat on or .chat off then chat in /say",
  [1] = "Please report any bugs revolving Waloria's custom systems on http://forum.waloria.com",
  [2] = "Group up with your friends - no XP loss!",
  [3] = "Reset your talents using command .resettalents",
  [4] = "Waloria is currently open for testing. All content is subject to change.",
  [5] = "To see what spells you can obtain at what level go to http://waloria.com/spells.php"
}

local function announce(eventId, delay, repeats)
  local announceIndex = math.random(1, #announces)
  local currAnnounce = announces[announceIndex]

  SendWorldMessage("[|cff1ABC9CAnnouncer|r] "..currAnnounce)
end

local function announcer(event)
  CreateLuaEvent(announce, timer * 1000, 0)
end

RegisterServerEvent(33, announcer)
