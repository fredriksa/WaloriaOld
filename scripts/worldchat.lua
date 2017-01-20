-- by slp13at420 of EmuDevs.com
-- a mutation of FoeReaper's world chat with basic bells an whistles.
-- simple world chat WITHOUT the '#chat' command...WTF you say?
-- just change to /say channel 
-- turn it on
-- and chat away.
-- names are clickable for whispers and sub menu.

local WorldChat = {};
local channel_name = "Waloria";
local on = "chat on";
local off = "chat off";
local duration = 5; -- in seconds.

local Colors =  { -- colors for names and misc
  [0] = "|cff3399FF", -- blue for alliance name
  [1] = "|cff3399FF", -- red for horde name
  [3] = "|cffFF0000", -- black for [channel name]
  [4] = "|cff00cc00", -- green for "message"
  [5] = "|cff3399ff", -- good responce
  [6] = "|cffFF0000", -- bad responce
    };
  
local function ChatSystem(event, player, msg, type, lang, channel)

  local acct_id = player:GetAccountId();

  if not(WorldChat[acct_id])then
  
    WorldChat[acct_id] = {
            chat = 0,
            time = GetGameTime()-duration,
    };
  end
  
  if(lang ~= -1)then
  
    if(msg ~= "")then
      
      if(msg ~= "Away")then
        
          if(WorldChat[acct_id].chat == 1)then -- 0 = world chat off :: 1 = world chat on
  
            local time = GetGameTime();

            if(time-WorldChat[acct_id].time >= duration)then
            
                local t = table.concat{"[", Colors[3], channel_name, "|r]", "[", Colors[player:GetTeam()],"|Hplayer:", player:GetName(),  "|h", player:GetName(), "|h", "|r]: ", Colors[4], msg, "|r"};
                SendWorldMessage(t);
                WorldChat[acct_id].time = time;
            else
                  player:SendBroadcastMessage(Colors[6].."Refrain from spamming.|r")
            end       

          return false;
          end
      end
    end
  end
end

local function ChatSystemCommand(event, player, command)
  local acct_id = player:GetAccountId();

  if not(WorldChat[acct_id])then
    WorldChat[acct_id] = {
            chat = 0,
            time = GetGameTime()-duration,
    };
  end

  if(command == off)then
    WorldChat[acct_id].chat = 0;
    player:SendBroadcastMessage(Colors[5].."World chat off.|r")
    return false;
  end
        
  if(command == on)then
    WorldChat[acct_id].chat = 1;
    player:SendBroadcastMessage(Colors[5].."World chat on.|r")
    return false;
  end
end
  
RegisterPlayerEvent(18, ChatSystem)
RegisterPlayerEvent(42, ChatSystemCommand)