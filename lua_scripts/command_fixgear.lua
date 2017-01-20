--[[
    SLOT_HEAD                          = 0,
    SLOT_NECK                          = 1,
    SLOT_SHOULDERS                     = 2,
    SLOT_SHIRT                         = 3,
    SLOT_CHEST                         = 4,
    SLOT_WAIST                         = 5,
    SLOT_LEGS                          = 6,
    SLOT_FEET                          = 7,
    SLOT_WRISTS                        = 8,
    SLOT_HANDS                         = 9,
    SLOT_FINGER1                       = 10,
    SLOT_FINGER2                       = 11,
    SLOT_TRINKET1                      = 12,
    SLOT_TRINKET2                      = 13,
    SLOT_BACK                          = 14,
    SLOT_MAIN_HAND                     = 15,
    SLOT_OFF_HAND                      = 16,
    SLOT_RANGED                        = 17,
    SLOT_TABARD                        = 18,
    SLOT_EMPTY                         = 19
--]]

function getPlayerCharacterGUID(player)
    query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end

local function canFixItem(player, entry)
  local query = WorldDBQuery(string.format("SELECT * FROM custom_fixgear WHERE characterGUID=%i AND itemEntry=%i", getPlayerCharacterGUID(player), entry))

  if query then
    return false
  end

  return true
end

local function addFixedItem(player, entry)
  local characterGUID = getPlayerCharacterGUID(player)

  WorldDBExecute(string.format("INSERT INTO custom_fixgear VALUES (%i, %i)", characterGUID, entry))
end

local function FixGearCommand(event, player, command)
  if (command == "fixgear") then
    local items = {}
    local slots = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19}

    for i, slot in pairs(slots) do 
      item = player:GetEquippedItemBySlot(slot)

      if item then 
        local entry = item:GetEntry()

        if entry then 
          if canFixItem(player, entry) then 
            if player:AddItem(20023) then 
              player:RemoveItem(20023, 1)
              player:RemoveItem(entry, 1)
              player:AddItem(entry)
              addFixedItem(player, entry)
            end
          end
        end
      end
    end

    player:SendBroadcastMessage("The gear you had room for in your inventory has been fixed.")
    player:SendBroadcastMessage("WARNING: Command will be available for one week.")
    return false
  end 
end

RegisterPlayerEvent(42, FixGearCommand)