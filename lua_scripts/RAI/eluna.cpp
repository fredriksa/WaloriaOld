int CastSpellRAI(Eluna* /*E*/, lua_State* L, Unit* unit)
{
  Unit* target = Eluna::CHECKOBJ<Unit>(L, 2, NULL);
  uint32 spell = Eluna::CHECKVAL<uint32>(L, 3);
  bool triggered = Eluna::CHECKVAL<bool>(L, 4, false);
  SpellEntry const* spellEntry = sSpellStore.LookupEntry(spell);
  if (!spellEntry)
    return 0;

  int bitMask = TRIGGERED_IGNORE_POWER_AND_REAGENT_COST;

  unit->CastSpell(target, spell, static_cast<TriggerCastFlags>(bitMask));
  return 0;
}

int PatrolArea(Eluna* /*E*/, lua_State* L, Unit* unit)
{
  float radius = Eluna::CHECKVAL<float>(L, 2);
  Creature* creature = static_cast<Creature*>(unit);
  creature->SetDefaultMovementType(RANDOM_MOTION_TYPE);
  creature->SetRespawnRadius(radius);

  return 0;
}

int ReInitialize(Eluna* /*E*/, lua_State* L, Unit* unit)
{
  Creature* creature = static_cast<Creature*>(unit); 
  if (creature->IsInWorld())
    creature->AIM_Initialize();

  return 0;
}