if (i_path)
  delete i_path;

i_path = new PathGenerator(creature); 
bool result = i_path->CalculatePath(destX, destY, destZ);

if (!result || (i_path->GetPathType() & PATHFIND_NOPATH))
{
  i_recalculateTravel = true;
  return;
}

i_recalculateTravel = false;
creature->AddUnitState(UNIT_STATE_ROAMING_MOVE);
Movement::MoveSplineInit init(creature);
init.MovebyPath(i_path->GetPath());
init.SetWalk(true);
init.Launch();