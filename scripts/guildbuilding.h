#include "Player.h"
#include "PlayerAI.h"
#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "Containers.h"
#include "GridNotifiers.h"
#include "GameObjectAI.h"
#include "ObjectGuid.h"
#include "MapManager.h"

#include <algorithm>

enum Creatures
{
  CREATURE_FLAG_EFFECT = 97000,
};

enum Gameobjects
{
  GAMEOBJECT_BASE_FLAG = 532852,
};

enum Sounds
{
  SOUND_FLAG_SPAWN = 11705,
};

enum Ranges
{
  //Area sizes in yards
  RANGE_BASE = 25,
  RANGE_BASE_SUCCESS_MUSIC = 12,
};

//Written by Fractional @Ac-web.org
//Video showcase: https://www.youtube.com/watch?v=bVlLA-dB5Pc

class BuildingSystem
{
public:
  class PlayerBase
  {
  public:
    int guildid;
    int flagguid;
    float x;
    float y;
    float z;
  };

  static void createDatabaseEntry(PlayerBase* base)
  {
    WorldDatabase.PExecute("INSERT INTO custom_building_system_bases (guildid, flagguid, x, y,z) VALUES (%i, %i, %f, %f, %f)", base->guildid, base->flagguid, base->x, base->y, base->z);
  }

  static std::list<PlayerBase> getPlayerBases()
  {
    std::list<PlayerBase> playerBases;

    QueryResult result = WorldDatabase.PQuery("SELECT * FROM custom_building_system_bases");
    if (!result) return playerBases;

    do {
      Field* fields = result->Fetch();

      int guildid = fields[0].GetInt32();
      int flagguid = fields[1].GetInt32();
      float x = fields[2].GetFloat();
      float y = fields[3].GetFloat();
      float z = fields[4].GetFloat();

      PlayerBase base;

      base.guildid = guildid;
      base.flagguid = flagguid;
      base.x = x;
      base.y = y;
      base.z = z;

      playerBases.push_back(base);
    } while (result->NextRow());

    return playerBases;
  }
};

class PlayerHelper
{
public:
  static std::list<ObjectGuid> playerGUIDS(std::list<Player*> players)
  {
    std::list<ObjectGuid> guids;

    for (Player* player : players)
      guids.push_back(player->GetGUID());

    return guids;
  }

  static std::list<Player*> getPlayersFromGUIDS(std::list<ObjectGuid> playerGUIDS)
  {
    std::list<Player*> players;

    for (ObjectGuid guid : playerGUIDS)
    {
      Player* player = ObjectAccessor::FindPlayer(guid);

      if (player)
        players.push_back(player);
    }

    return players;
  }

  static std::list<Player*> getPlayersNear(GameObject* object, float range)
  {
    std::list<Player*> players;
    const MapRefManager& playersRef = object->GetMap()->GetPlayers();

    for (auto it = playersRef.begin(); it != playersRef.end(); ++it)
    {
      Player* player = it->GetSource();

      float x = object->GetPosition().GetPositionX();
      float y = object->GetPosition().GetPositionY();
      float z = object->GetPosition().GetPositionZ();

      if (player->IsWithinDist3d(x, y, z, range - object->GetObjectSize()))
        players.push_back(player);
    }

    //Trinity::AnyPlayerInObjectRangeCheck checker(object, 12.f);
    //Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(object, playersNear, checker);
    //object->VisitNearbyWorldObject(12.f, searcher);
    //Code above takes in account for the GameObjectDisplayInfo attributes

    return players;
  }
};

class WorldHelper
{
public:
  static float distanceBetweenCoordinates(float x, float y, float z, float x2, float y2, float z2)
  {
    float xDiff = x - x2;
    float yDiff = y - y2;
    float zDiff = z - z2;

    if (xDiff < 0)
      xDiff *= -1;

    if (yDiff < 0)
      yDiff *= -1;

    if (zDiff < 0)
      zDiff *= -1;

    return xDiff + yDiff + zDiff;
  }

  static bool isWithinBaseArea(float x, float y, float z, int guildid)
  {
    QueryResult result = WorldDatabase.PQuery("SELECT * FROM custom_building_system_bases WHERE guildid=%i", guildid);
    if (!result) return false;

    Field* fields = result->Fetch();

    float base_x = fields[2].GetFloat();
    float base_y = fields[3].GetFloat();
    float base_z = fields[4].GetFloat();

    return distanceBetweenCoordinates(x, y, z, base_x, base_y, base_z) < (float)RANGE_BASE;
  }
};

class ObjectSpawner
{
public:
  static GameObject* spawnPermanent(uint32 entry, Unit* owner, const WorldLocation* location)
  {
    const GameObjectTemplate* objectInfo = sObjectMgr->GetGameObjectTemplate(entry);
    GameObject* object = new GameObject;

    Map* map = owner->GetMap();
    uint32 guidLow = map->GenerateLowGuid<HighGuid::GameObject>();
    Position targetPos = location->GetPosition();

    float x = targetPos.GetPositionX();
    float y = targetPos.GetPositionY();
    float z = targetPos.GetPositionZ();
    float angle = location->GetAngle(x, y);
    float orientation = owner->GetOrientation();

    if (!object->Create(guidLow, objectInfo->entry, map, 1, x, y, z, orientation, 0, 0, 0, 0, 0, GO_STATE_READY))
    {
      delete object;
      return nullptr;
    }

    object->SaveToDB(map->GetId(), (1 << map->GetSpawnMode()), owner->GetPhaseMask());
    guidLow = object->GetSpawnId();

    delete object;

    object = new GameObject();

    if (!object->LoadGameObjectFromDB(guidLow, map))
    {
      delete object;
      return nullptr;
    }

    sObjectMgr->AddGameobjectToGrid(guidLow, sObjectMgr->GetGOData(guidLow));
    return object;
  }
};

class PlayerBaseClaimer
{
public:
  static bool canClaimBase(Player* player, const WorldLocation* location)
  {
    if (playerGuildHasBase(player))
    {
      player->GetSession()->SendAreaTriggerMessage("Your guild already have a base");
      return false;
    }

    if (!isAreaFree(location))
    {
      player->GetSession()->SendAreaTriggerMessage("The land you are trying to claim is already occupied.");
      return false;
    }

    return true;
  }

  static bool isAreaFree(const WorldLocation* location)
  {
    std::list<BuildingSystem::PlayerBase> bases = BuildingSystem::getPlayerBases();

    for (BuildingSystem::PlayerBase base : bases)
    {
      float x2 = location->GetPositionX();
      float y2 = location->GetPositionY();
      float z2 = location->GetPositionZ();

      if (WorldHelper::distanceBetweenCoordinates(base.x, base.y, base.z, x2, y2, z2) < (float)RANGE_BASE)
        return false;
    }

    return true;
  }

private:
  static bool playerGuildHasBase(Player* player)
  {
    if (player->GetGuild() == nullptr) return false;

    QueryResult result = WorldDatabase.PQuery("SELECT * FROM custom_building_system_bases");
    if (!result) return false;

    do {
      Field* fields = result->Fetch();

      int guildid = fields[0].GetInt32();
      int flagguid = fields[1].GetInt32();

      if (guildid == player->GetGuildId())
        return true;

    } while (result->NextRow());

    return false;
  }

};

class gameobject_building_flag : public GameObjectScript
{
public:
  gameobject_building_flag() : GameObjectScript("gameobject_building_flag"){}

  struct gameobject_building_flagAI : public GameObjectAI
  {
    uint32 checkCooldown;
    uint32 cooldownCounter;
    std::list<ObjectGuid> playerGUIDsNear;
    bool existsInDB = false;

    gameobject_building_flagAI(GameObject* go) : GameObjectAI(go) { Initialize(); }

    void Initialize()
    {
      checkCooldown = 1000;
      cooldownCounter = checkCooldown;
      existsInDB = checkForDBEntry();
    }

    void UpdateAI(uint32 diff) override
    {
      GameObjectAI::UpdateAI(diff);

      if (cooldownCounter <= diff)
      {
        if (!existsInDB) return;

        std::list<Player*> playersNear = PlayerHelper::getPlayersNear(go, RANGE_BASE);

        for (Player* player : getEnteringPlayers(go, playersNear))
          onPlayerEnter(player);

        for (Player* player : getLeavingPlayers(go, playersNear))
          onPlayerLeave(player);

        playerGUIDsNear = PlayerHelper::playerGUIDS(playersNear);
        cooldownCounter = checkCooldown;
      }
      else
        cooldownCounter -= diff;
    }

  private:
    void onPlayerEnter(Player* player)
    {
      std::string enterMessage = "You're entering " + getGuildNameFromFlagGUID(go->GetSpawnId()) + "'s territory";
      player->GetSession()->SendAreaTriggerMessage(enterMessage.c_str());
    }

    void onPlayerLeave(Player* player)
    {
      std::string leaveMessage = "You're leaving " + getGuildNameFromFlagGUID(go->GetSpawnId()) + "'s territory";
      player->GetSession()->SendAreaTriggerMessage(leaveMessage.c_str());
    }

    std::list<Player*> getEnteringPlayers(GameObject* object, std::list<Player*> playersNear)
    {
      std::list<Player*> enteringPlayers;
      std::list<Player*> lastPlayersNear = PlayerHelper::getPlayersFromGUIDS(playerGUIDsNear);

      playersNear.sort();
      enteringPlayers.sort();
      lastPlayersNear.sort();

      std::insert_iterator<std::list<Player*>> insert_it(enteringPlayers, enteringPlayers.end());
      std::set_difference(playersNear.begin(), playersNear.end(), lastPlayersNear.begin(), lastPlayersNear.end(), insert_it);

      return enteringPlayers;
    }

    std::list<Player*> getLeavingPlayers(GameObject* object, std::list<Player*> playersNear)
    {
      std::list<Player*> leavingPlayers;
      std::list<Player*> lastPlayersNear = PlayerHelper::getPlayersFromGUIDS(playerGUIDsNear);

      playersNear.sort();
      leavingPlayers.sort();
      lastPlayersNear.sort();

      std::insert_iterator<std::list<Player*>> insert_it(leavingPlayers, leavingPlayers.end());
      std::set_difference(lastPlayersNear.begin(), lastPlayersNear.end(), playersNear.begin(), playersNear.end(), insert_it);

      return leavingPlayers;
    }

    bool checkForDBEntry()
    {
      int guid = go->GetSpawnId();
      QueryResult result = WorldDatabase.PQuery("SELECT guid FROM gameobject WHERE guid=%i", guid);
      return result != nullptr ? true : false; 
    }

    std::string getGuildNameFromFlagGUID(int flagguid)
    {
      std::string guildName = "";
      QueryResult result = WorldDatabase.PQuery("SELECT * FROM custom_building_system_bases WHERE flagguid=%u", flagguid);
      if (!result) return guildName;

      Field* fields = result->Fetch();
      int guildid = fields[0].GetInt32();

      QueryResult result2 = CharacterDatabase.PQuery("SELECT name FROM guild WHERE guildid=%u", guildid);
      if (!result2) return guildName;

      fields = result2->Fetch();
      guildName = fields[0].GetString();

      return guildName;
    }
  };

  gameobject_building_flag::gameobject_building_flagAI* GetAI(GameObject* go) const
  {
    return new gameobject_building_flagAI(go);
  }
};

class spell_building_base : public SpellScriptLoader
{
public:
  spell_building_base() : SpellScriptLoader("spell_building_base") {}

  class spell_building_base_spellscript : public SpellScript
  {
    PrepareSpellScript(spell_building_base_spellscript);

    SpellCastResult CheckCast()
    {
      Player* player = (Player*)GetCaster();
      if (!player) return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;

      if (!PlayerBaseClaimer::canClaimBase(player, GetExplTargetDest()))
        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;

      return SPELL_CAST_OK;
    }

    void onCast()
    {
      GameObject* flag = spawnFlag();
      if (!flag) return;

      Creature* flagEffectCreature = spawnFlagEffectCreature();

      Player* player = (Player*)GetCaster();

      BuildingSystem::PlayerBase base = buildBase(player->GetGuildId(), flag->GetSpawnId(), GetExplTargetDest());
      BuildingSystem::createDatabaseEntry(&base);

      GetCaster()->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
      playSuccessMusic(flag);
    }

    void Register() override
    {
      OnCheckCast += SpellCheckCastFn(spell_building_base_spellscript::CheckCast);
      OnCast += SpellCastFn(spell_building_base_spellscript::onCast);
    }

  private:

    BuildingSystem::PlayerBase buildBase(int guildid, int flagguid, const WorldLocation* location)
    {
      BuildingSystem::PlayerBase base;

      base.guildid = guildid;
      base.flagguid = flagguid;
      base.x = location->GetPositionX();
      base.y = location->GetPositionY();
      base.z = location->GetPositionZ();

      return base;
    }

    GameObject* spawnFlag()
    {
      const SpellInfo* info = GetSpellInfo();
      uint32 objectEntry = info->Effects[0].MiscValue;
      GameObject* flag = ObjectSpawner::spawnPermanent(objectEntry, GetCaster(), GetExplTargetDest());

      auto ai = dynamic_cast<gameobject_building_flag::gameobject_building_flagAI*>(flag->AI());
      ai->existsInDB = true;

      return flag;
    }

    Creature* spawnFlagEffectCreature()
    {
      const Position* position = GetExplTargetDest();

      float x = position->GetPositionX();
      float y = position->GetPositionY();
      float z = position->GetPositionZ();

      return GetCaster()->SummonCreature(CREATURE_FLAG_EFFECT, x, y, z, 0.f, TEMPSUMMON_TIMED_DESPAWN, 3000);
    }

    void playSuccessMusic(GameObject* flag)
    {
      std::list<Player*> players = PlayerHelper::getPlayersNear(flag, RANGE_BASE_SUCCESS_MUSIC);

      for (Player* player : players)
        player->PlayDirectSound(SOUND_FLAG_SPAWN, player);
    }
  };

  SpellScript* GetSpellScript() const override
  {
    return new spell_building_base_spellscript();
  }
};

class spell_building_system : public SpellScriptLoader
{
public:
  spell_building_system() : SpellScriptLoader("spell_building_system") { }

  class spell_building_system_spellscript : public SpellScript
  {
    PrepareSpellScript(spell_building_system_spellscript);

    SpellCastResult CheckCast()
    {
      Player* player = (Player*)GetCaster();
      if (!player) return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;

      if (!player->GetGuild())
      {
        player->GetSession()->SendAreaTriggerMessage("You need to be a member of a guild in order to build");
        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
      }

      const WorldLocation* loc = GetExplTargetDest();
      if (!WorldHelper::isWithinBaseArea(loc->GetPositionX(), loc->GetPositionY(), loc->GetPositionZ(), player->GetGuildId()))
      {
        player->GetSession()->SendAreaTriggerMessage("The target location is not within your guild's territory");
        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
      }

      return SPELL_CAST_OK;
    }


    void onCast()
    {
      const SpellInfo* info = GetSpellInfo();
      uint32 objectEntry = info->Effects[0].MiscValue;

      GetCaster()->Say(std::to_string(objectEntry), LANG_COMMON);
      ObjectSpawner::spawnPermanent(objectEntry, GetCaster(), GetExplTargetDest());
    }

    void Register() override
    {
      OnCheckCast += SpellCheckCastFn(spell_building_system_spellscript::CheckCast);
      OnCast += SpellCastFn(spell_building_system_spellscript::onCast);
    }
  };

  SpellScript* GetSpellScript() const override
  {
    return new spell_building_system_spellscript();
  }
};

void AddSC_building_system()
{
  new spell_building_system();
  new spell_building_base();
  new gameobject_building_flag();
}