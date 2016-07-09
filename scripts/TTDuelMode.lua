------------------------------------------
-- DuelMode 0.1 (Unfinished)
-- Created by: MatteO-Matic				
------------------------------------------

------------------------------------------
-- Initialization  	
------------------------------------------
local object = {}
tOld = tOld or {}

object.ModeName = "Duel Mode"
object.bClearZP = true
object.bRunning = false

object.nBigNumber = 9999
object.oFighter1 = nil
object.oFighter2 = nil
object.nFigherIndex = 0

object.cTriggerIdlePlayers = os.clock()
object.nTriggerTickSecond = 3

object.nPrevPlayerCount = 0

------------------------------------------
-- PRE  	
------------------------------------------
PostScriptMessage(1, "Loading: ".. object.ModeName)

------------------------------------------
--   	
------------------------------------------
function TurnOffDuel()
	--ClearDuelBuffs()
	--Restore overrides

	PostScriptMessage(1, "Unloaded: ".. object.ModeName)
end

function TurnIdle(obj)
	TTHostDoState(obj, Ready)
	--[[ So players can run around and spectate	
	local classType = GetPropertyAsString(obj, ClassName)
	 if classType == "SilentAvenger" then
		 TTHostDoBuff(obj, "skill_decoy") --Ivan
	 else
		 TTHostDoBuff(obj, "skill_shadowmeld") --rest
	 end
	TTHostDoBuff(obj, "Buff_Block_KEY_ML")
	TTHostDoBuff(obj, "Buff_Block_KEY_MR")
	TTHostDoBuff(obj, "Buff_Block_Shot")
	TTHostDoBuff(obj, "Buff_Block_Slash")
	TTHostDoBuff(obj, "Buff_Block_Strike")
	TTHostDoBuff(obj, "Buff_Block_Charge")
	TTHostDoBuff(obj, "Inv_Mode")
	]]--
	
end

function TurnFighter(obj)
	if obj ~= nil then
		--PostScriptMessage(5, "FIGHT!!!")
		--[[ So players can run around and spectate	
		local classType = GetPropertyAsString(obj, ClassName)
		if classType == "SilentAvenger" then
			TTHostRemoveBuff(obj, "skill_decoy")
		else
			TTHostRemoveBuff(obj, "skill_shadowmeld")
		end
		
		TTHostRemoveBuff(obj, "Buff_Block_KEY_ML")
		TTHostRemoveBuff(obj, "Buff_Block_KEY_MR")
		TTHostRemoveBuff(obj, "Buff_Block_Shot")
		TTHostRemoveBuff(obj, "Buff_Block_Slash")
		TTHostRemoveBuff(obj, "Buff_Block_Strike")
		TTHostRemoveBuff(obj, "Buff_Block_Charge")
		TTHostRemoveBuff(obj, "Inv_Mode")
		DirectCommonEvent(obj, Event_EnableCollision(false))
	--	DirectCommonEvent(obj, Event_EnableVisible(true, 0, 5000))
		]]
		TTHostDoState(obj, Spawn)
		DirectHostEvent(obj, Event_RecoverHPByItem(object.nBigNumber))
		DirectHostEvent(obj, Event_RecoverAPByItem(object.nBigNumber))
		DirectHostEvent(obj, Event_NotifyRefillExtraBulletByItem(object.nBigNumber))
		DirectHostEvent(obj, Event_RecoverZPByItem(-object.nBigNumber))
	end
end

function DuelWinner(obj)
	PostScriptMessage(5, "Winner")
	TurnFighter(obj) --For the hp/ap/etc reset 
end

function DuelLoser(obj)
	TurnIdle(obj)
end

function GetNextFighter(objWinner)
	local cnt = ObjMgr:PlayerCount()
	--Get next fighter after index
	local newFighter = nil
	if GetRealPlayerCount() >= 2 then -- need atleast 2 players
		repeat
			object.nFigherIndex = object.nFigherIndex+1
			newFighter = ObjMgr:GetPlayerByIndex(object.nFigherIndex%cnt)
		until (IsInGame(newFighter) and objWinner==nil or GetUID(newFighter) ~= GetUID(objWinner))
	else
		PostScriptMessage(5, "Not enough players")
		object.bRunning = false
		--Should turn off or something
	end
	--Set the newFighter global
	if objWinner~=nil then
		if GetUID(object.oFighter1) == GetUID(objWinner) then
			object.oFighter2 = newFighter
		else
			object.oFighter1 = newFighter
		end
	end
	return newFighter
end

function GetRealPlayerCount()
	local cnt = ObjMgr:PlayerCount()
	local player = nil
	local counter = 0
	for i = 0, cnt - 1 do
		player = ObjMgr:GetPlayerByIndex(i)
		if GetPropertyAsString(player, ClassName) ~= "" then
			counter = counter + 1
		end
	end
	return counter
end

function IsInGame(obj)
	if obj == nil then
		return false
	end
	return GetPropertyAsString(obj, ClassName)~= ""
end

function StartDuel()
	if GetRealPlayerCount() >= 2 then -- need atleast 2 players
		--First two fighters
		object.oFighter1 = GetNextFighter(nil)
		object.oFighter2 = GetNextFighter(object.oFighter1)
		
		TurnFighter(object.oFighter1)
		TurnFighter(object.oFighter2)
		
		--other players idle
		local cnt = ObjMgr:PlayerCount()
		for i = 0, cnt - 1 do
			local player = ObjMgr:GetPlayerByIndex(i)
			if GetUID(player) ~= GetUID(object.oFighter2) and GetUID(player) ~= GetUID(object.oFighter1) then
				TurnIdle(player)
			end
		end
		object.bRunning = true
	else
		object.bRunning = false
		PostScriptMessage(5, "No friends? :(")
	end
end

--Include block buffs maiet forgot to add
function IsIgnoreState(obj, class_name, weapon_set_name, state_name)
  local state = State[class_name][weapon_set_name][state_name]
  if state == nil or state.tag == nil then
    return false
  end
  if CheckBuff(obj, "Buff_Block_Shot") == TRUE and state.tag.LOCK_SHOT then
    return true
  end
  if CheckBuff(obj, "Buff_Block_Jump") == TRUE and state.tag.LOCK_JUMP then
    return true
  end
  if CheckBuff(obj, "Buff_Block_AnyAction") == TRUE then
    return true
  end
  return false
end

--------------------------------
-- Override
--------------------------------
function System_BuffUpdate(obj, buffName, RemainTime)
	--Check if someone have the wrong state
	if object.bRunning then
		if os.clock() - object.cTriggerIdlePlayers > object.nTriggerTickSecond then
			object.cTriggerIdlePlayers = os.clock()
			--other players idle
			local cnt = ObjMgr:PlayerCount()
			for i = 0, cnt - 1 do
				local player = ObjMgr:GetPlayerByIndex(i)
				if IsInGame(player) and CheckStateID(player, STATE_LAYER_BEHAVIOR, Ready) == FALSE then --If he is ingame and not in a Ready state
					--Correct the state if it's not a fighter
					if GetUID(player) ~= GetUID(object.oFighter2) and GetUID(player) ~= GetUID(object.oFighter1) then
						TurnIdle(player)
					end
				end
			end
		end
	end

  if buffName == "Inv_Mode" then
    ScriptEffect_GodMode:Update(obj, RemainTime)
    return true
  elseif buffName == "Super_Armor" then
    ScriptEffect_SuperArmor:Update(obj, RemainTime)
    return true
  elseif buffName == "ScriptEffect_WorldItemGrow" then
    ScriptEffect_WorldItemGrow:Update(obj, RemainTime)
    return true
  elseif buffName == "interactive_object" then
    ScriptEffect_InteractiveObjectGrow:Update(obj, RemainTime)
    return true
  elseif buffName == "Burn_Body" then
    return true
  end
  return false
end

function OnDie(victim, attacker, notifyAttackID, isBack)
	if attacker ~= nil then
		DirectHostEvent(attacker, Event_RecoverZP(Const_ZP_Kill))
	end
	if notifyAttackID == Katana_Skill_SonicSlash then
		DirectHostEvent(victim, Event_ModifyState(Die_F, MODIFY_IMMEDIATE))
	elseif isBack == true then
		DirectHostEvent(victim, Event_ModifyState(Die_B, MODIFY_IMMEDIATE))
	else
		DirectHostEvent(victim, Event_ModifyState(Die_F, MODIFY_IMMEDIATE))
	end

	if object.bRunning then
		DuelLoser(victim)
		DuelWinner(attacker)
		local newfight = GetNextFighter(attacker)
		
		TurnFighter(newfight)
	end
	return true
end

--------------------------------
-- POST
--------------------------------
PostScriptMessage(1, "Finished loading: ".. object.ModeName)
--Start mode
StartDuel()