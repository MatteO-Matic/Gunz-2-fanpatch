------------------------------------------
-- BerserkerMode
-- Created by: MatteO-Matic
-- Version 1.2.0.1				
------------------------------------------

------------------------------------------
-- Initialization  	
------------------------------------------
local object = {}
tOld = tOld or {}

object.ModeName = "Berserker mode"
object.bAllowFullZP = false
object.bAllVsBerserker = false
object.nMaxZP = 700
object.nZerkHPKill = 40
object.nZerkAPKill = 40
object.nZerkBulletKill = 50
object.nZerkZPKill = 1000
object.nZerkID = nil
object.nZerkDuration = 98888885
object.nZerkDmgMultiplier = 2.0
object.cTriggerDmg = os.clock()
object.nTriggerTickSecond = 2
object.nTriggerDamageHPAmount = 15
object.tBerserkBuffs = {
							"red_flag", 
							"Super_Armor"}


------------------------------------------
-- PRE  	
------------------------------------------
PostScriptMessage(1, "Loading: ".. object.ModeName)


function ClearBerserkerBuffs()
	for k,v in pairs(object.tBerserkBuffs) do 
		TTHostRemoveBuffAllPlayers(v)
	end
end
ClearBerserkerBuffs() --Clear the buffs when the script is loaded

------------------------------------------
--   	
------------------------------------------
function TurnOffBerserk()
	ClearBerserkerBuffs()

	--Restore overrides
	OnDie = tOld.OnDieOld
	System_BuffUpdate = tOld.System_BuffUpdateOld
 	OnHitHandler_DummyStyle = tOld.OnHitHandler_DummyStyleOld
	OnHitHandler_ExplosionStyle = tOld.OnHitHandler_ExplosionStyleOld
	OnHitHandler_ExplosiveShotStyle = tOld.OnHitHandler_ExplosiveShotStyleOld
	OnHitHandler_RadialStyle = tOld.OnHitHandler_RadialStyleOld
	OnHitHandler_SingleShotStyle = tOld.OnHitHandler_SingleShotStyleOld
	OnHitHandler_SpreadShotStyle = tOld.OnHitHandler_SpreadShotStyleOld

	PostScriptMessage(1, "Unloaded: ".. object.ModeName)
end

function AddBerserkerBuffs(obj)
	for k,v in pairs(object.tBerserkBuffs) do 
		DirectHostEvent(obj, Event_ModifyBuff(v, object.nZerkDuration))
	end
end

local function BerserkerApplyDamage(victim, attacker, notifyAttackID)
	if GetUID(attacker) == object.nZerkID then --If berserker apply some more damage
		local mod = GetDamageRatio(victim, attacker, notifyAttackID)
		mod = mod* (object.nZerkDmgMultiplier-1) --(-1)removes already done damage
		DirectHostEvent(victim, Event_ApplyDamageByAttackItem(attacker, mod))
	end
end


--------------------------------
-- Override
--------------------------------
local function OnDieOverride(victim, attacker, notifyAttackID, isBack)
	tOld.OnDieOld(victim, attacker, notifyAttackID, isBack)
	if attacker ~= nil then
		--Berserker death
		if object.nZerkID == nil or object.nZerkID == GetUID(victim) then
			object.nZerkID = GetUID(attacker)
		end
		--Berserker kill
		if GetUID(attacker) == object.nZerkID then
			DirectHostEvent(attacker, Event_RecoverHPByItem(object.nZerkHPKill))
			DirectHostEvent(attacker, Event_RecoverAPByItem(object.nZerkAPKill))
			DirectHostEvent(attacker, Event_NotifyRefillExtraBulletByItem(object.nZerkBulletKill))
			DirectHostEvent(attacker, Event_RecoverZPByItem(object.nZerkZPKill))
			AddBerserkerBuffs(attacker)
			
			
			if object.bAllVsBerserker then
				local cnt = ObjMgr:PlayerCount()
				local members = {}
				--All players
				for i = 0, cnt - 1 do
					members[i] = ObjMgr:GetPlayerByIndex(i)
					SetPropertyAsInt(members[i], TeamType, 1)
				end
				SetPropertyAsInt(attacker, TeamType, 2)
			end
		end
	end
	return true
end
tOld.OnDieOld = tOld.OnDieOld or OnDie
OnDie = OnDieOverride

local function System_BuffUpdateOverride(obj, buffName, RemainTime)
	local bUpdateBuff = tOld.System_BuffUpdateOld(obj, buffName, RemainTime)
	if object.bAllowFullZP == false then
		if GetPropertyAsFloat(obj, CurrentZP)>object.nMaxZP then
			SetPropertyAsFloat(obj, CurrentZP, object.nMaxZP)
		end
	end

	if os.clock() - object.cTriggerDmg > object.nTriggerTickSecond then
		if GetUID(obj) == object.nZerkID then
			object.cTriggerDmg = os.clock()
			if GetPropertyAsFloat(obj, CurrentHP) >  object.nTriggerDamageHPAmount then
				DirectHostEvent(obj, Event_ApplyDamage_NoAttacker(object.nTriggerDamageHPAmount))
			else
				--SetPropertyAsFloat(obj, CurrentHP, 1) --Don't work.
				local sethp = GetPropertyAsFloat(obj, CurrentHP) -1;
				DirectHostEvent(obj, Event_ApplyDamage_NoAttacker(sethp)) --Almost magical eh?
			end
		end
	end
	return bUpdateBuff
end
tOld.System_BuffUpdateOld = tOld.System_BuffUpdateOld or System_BuffUpdate
System_BuffUpdate = System_BuffUpdateOverride


--------------------------------
-- Override hithandle
--------------------------------
local function OnHitHandler_DummyStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base
	local bOnHit = tOld.OnHitHandler_DummyStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_DummyStyleOld = tOld.OnHitHandler_DummyStyleOld or OnHitHandler_DummyStyle
OnHitHandler_DummyStyle = OnHitHandler_DummyStyleOverride

local function OnHitHandler_ExplosionStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base
	local bOnHit = tOld.OnHitHandler_ExplosionStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_ExplosionStyleOld = tOld.OnHitHandler_ExplosionStyleOld or OnHitHandler_ExplosionStyle
OnHitHandler_ExplosionStyle = OnHitHandler_ExplosionStyleOverride

local function OnHitHandler_ExplosiveShotStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base
	local bOnHit = tOld.OnHitHandler_ExplosiveShotStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_ExplosiveShotStyleOld = tOld.OnHitHandler_ExplosiveShotStyleOld or OnHitHandler_ExplosiveShotStyle
OnHitHandler_ExplosiveShotStyle = OnHitHandler_ExplosiveShotStyleOverride

local function OnHitHandler_RadialStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base
	local bOnHit = tOld.OnHitHandler_RadialStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_RadialStyleOld = tOld.OnHitHandler_RadialStyleOld or OnHitHandler_RadialStyle
OnHitHandler_RadialStyle = OnHitHandler_RadialStyleOverride

local function OnHitHandler_SingleShotStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base
	local bOnHit = tOld.OnHitHandler_SingleShotStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_SingleShotStyleOld = tOld.OnHitHandler_SingleShotStyleOld or OnHitHandler_SingleShotStyle
OnHitHandler_SingleShotStyle = OnHitHandler_SingleShotStyleOverride


local function OnHitHandler_SpreadShotStyleOverride(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	--Normal hit damage is applied in base call
	local bOnHit = tOld.OnHitHandler_SpreadShotStyleOld(victim, attacker, notifyAttackID, attackItemID, bFront, guardRange)
	if bOnHit==true then
		BerserkerApplyDamage(victim, attacker,notifyAttackID)
	end
	return bOnHit
end
tOld.OnHitHandler_SpreadShotStyleOld = tOld.OnHitHandler_SpreadShotStyleOld or OnHitHandler_SpreadShotStyle
OnHitHandler_SpreadShotStyle = OnHitHandler_SpreadShotStyleOverride


--------------------------------
-- POST
--------------------------------
PostScriptMessage(1, "Finished loading: ".. object.ModeName)
