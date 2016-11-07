--Kill all
cTriggerDmg = os.clock()
function System_OnUpdateState(obj, elapsedTime)
	if os.clock() - cTriggerDmg > 0.1 then
		cTriggerDmg=os.clock()
		local myself = ObjMgr:GetCurrentPlayer()
		for i = 0, 500 do
			local enm = ObjMgr:FindByUID(i)
			if ObjMgr:IsFriend(enm, myself)==false then
				DirectHostEvent(enm, Event_AddAssistDamage(myself, 100))
				DirectHostEvent(enm, Event_ApplyDamage(myself, 100))
			end
		end
	end
  if CheckTag(obj, STATE_LAYER_BEHAVIOR, "GOD_MODE") == true then
    ScriptEffect_GodMode:Update(obj, elapsedTime)
  end
  if GetSuperArmorLevel(obj, STATE_LAYER_BEHAVIOR) > 1 then
    ScriptEffect_SuperArmor:Update(obj, elapsedTime)
  end
end