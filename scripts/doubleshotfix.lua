--[[
Compiled source
Data/Script/_compiled/NextState_RangeAttack.lb
 
Fix for the doubleshot glitch
Ivan are able to shoot twice after a flip
flip(on target) -> switch to sniper -> zoom -> shot -> zoom -> shot
 
--Original code
function Action_Zoom_Shot(obj, key)
  if key == KEY_ML and CheckBuff(obj, "Buff_WeaponDelay_Range") == FALSE then
    if CheckExistBulletsInCurrentMagazine(obj, "rweapon") == TRUE then
      DirectCommonEvent(obj, Event_TransitionState(Zoom_Shot))
    else
      DirectCommonEvent(obj, Event_RemoveBuff("CameraZoomIn"))
      if CheckExistBulletsExtra(obj, "rweapon") == TRUE then
        Do_Reload(obj)
      else
        DirectCommonEvent(obj, Event_TransitionState(ShotFailed))
      end
    end
    return true
  end
  return false
end
]]
 
--Doubleshot fixed
function Action_Zoom_Shot(obj, key)
        --Check if the state are in a lock
  if CheckTag(obj, STATE_LAYER_BEHAVIOR, "LOCK_SHOT") == true or CheckTag(obj, STATE_LAYER_ACTION, "LOCK_SHOT") == true then
    return false
  end
  --If the "swap shot buff" are on
  if key == KEY_ML and CheckBuff(obj, "Buff_Show_Weapon_Atk") == TRUE then
    DirectCommonEvent(obj, Event_RemoveBuff("Buff_Show_Weapon_Atk")) --Remove the buff
    DirectCommonEvent(obj, Event_TransitionState(Zoom_Shot))
    return true
  end
  if key == KEY_ML and CheckBuff(obj, "Buff_WeaponDelay_Range") == FALSE then
    if CheckExistBulletsInCurrentMagazine(obj, "rweapon") == TRUE then
      DirectCommonEvent(obj, Event_TransitionState(Zoom_Shot))
    else
      DirectCommonEvent(obj, Event_RemoveBuff("CameraZoomIn"))
      if CheckExistBulletsExtra(obj, "rweapon") == TRUE then
        Do_Reload(obj)
      else
        DirectCommonEvent(obj, Event_TransitionState(ShotFailed))
      end
    end
    return true
  end
  return false
end
