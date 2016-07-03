------------------------------------------
-- Assassination mode 0.1
-- Created by: MatteO-Matic				
------------------------------------------

------------------------------------------
-- Initialization  	
------------------------------------------
local object = { }
tOld = tOld or { }

object.ModeName = "Assassination mode"
object.LeaderBlue = nil
object.LeaderRed = nil
object.nLeaderBuffDuration = 99999999
object.tLeaderBuffs = {
    "red_flag",
    "Leader"
}


------------------------------------------
-- PRE  	
------------------------------------------
PostScriptMessage(1, "Loading: " .. object.ModeName)


function ClearLeaderBuffs()
    for k, v in pairs(object.tLeaderBuffs) do
        TTHostRemoveBuffAllPlayers(v)
    end
end
ClearLeaderBuffs() -- Clear the buffs when the script is loaded

------------------------------------------
--   	
------------------------------------------
function TurnOffAssassin()
    ClearLeaderBuffs()
    -- Restore overrides
    OnDie = tOld.OnDieOld
    System_BuffUpdate = tOld.System_BuffUpdateOld
    Round_Initialize = tOld.Round_InitializeOld
    System_BuffEnd = tOld.System_BuffEndOld

    PostScriptMessage(1, "Unloaded: " .. object.ModeName)
end

function AddLeaderBuffs(obj)
    for k, v in pairs(object.tLeaderBuffs) do
        DirectHostEvent(obj, Event_ModifyBuff(v, object.nLeaderBuffDuration))
    end
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
    return GetPropertyAsString(obj, ClassName) ~= ""
end

--------------------------------
-- Override
--------------------------------
local function OnDieOverride(victim, attacker, notifyAttackID, isBack)
    tOld.OnDieOld(victim, attacker, notifyAttackID, isBack)
    if victim ~= nil then
        -- Winner
        if object.LeaderBlue == GetUID(victim) then
            -- Kill all blue players
            local cnt = ObjMgr:PlayerCount()
            for i = 0, cnt - 1 do
                local player = ObjMgr:GetPlayerByIndex(i)
                if IsInGame(player) and GetPropertyAsInt(player, TeamType) == TEAM_BLUE then
                    DirectHostEvent(player, Event_ApplyDamage_NoAttacker(500))
                end
            end
        end
        if object.LeaderRed == GetUID(victim) then
            -- Kill all red players
            local cnt = ObjMgr:PlayerCount()
            for i = 0, cnt - 1 do
                local player = ObjMgr:GetPlayerByIndex(i)
                if IsInGame(player) and GetPropertyAsInt(player, TeamType) == TEAM_RED then
                    DirectHostEvent(player, Event_ApplyDamage_NoAttacker(500))
                end
            end
        end
    end
    return true
end
tOld.OnDieOld = tOld.OnDieOld or OnDie
OnDie = OnDieOverride

local function System_BuffEndOverride(obj, buffName)
    local bUpdateBuff = tOld.System_BuffEndOld(obj, buffName)
    if buffName == "Leader" then
        local color = vec(0, 0, 0)
        UpdatePostEffectEdge(obj, color)
        return true
    end
    return bUpdateBuff
end
tOld.System_BuffEndOld = tOld.System_BuffEndOld or System_BuffEnd
System_BuffEnd = System_BuffEndOverride

local function System_BuffUpdateOverride(obj, buffName, RemainTime)
    local bUpdateBuff = tOld.System_BuffUpdateOld(obj, buffName, RemainTime)
    if buffName == "Leader" then
        local color
        if GetPropertyAsInt(obj, TeamType) == TEAM_BLUE then
            color = vec(0, 0, 5)
        elseif GetPropertyAsInt(obj, TeamType) == TEAM_RED then
            color = vec(5, 0, 0)
        end
        UpdatePostEffectEdge(obj, color)
        --   DirectCommonEvent(obj, Event_PlayEffect("base", "Bip01 Spine2", "COM_STA_ZPMax_Sub", true, false))
        return true
    end
    return bUpdateBuff
end
tOld.System_BuffUpdateOld = tOld.System_BuffUpdateOld or System_BuffUpdate
System_BuffUpdate = System_BuffUpdateOverride

function GetTeamCount(team)
    local cnt = ObjMgr:PlayerCount()
    local count = 0
    for i = 0, cnt - 1 do
        local player = ObjMgr:GetPlayerByIndex(i)
        if GetPropertyAsInt(player, TeamType) == team then
            count = count + 1
        end
    end
    return count
end

local function Round_InitializeOverride(roundCount)
    tOld.Round_InitializeOld(roundCount)
    ClearLeaderBuffs()
    -- Select next leaders
    local cnt = ObjMgr:PlayerCount()
    local newLeader = nil
    object.LeaderRed = nil
    object.LeaderBlue = nil
    -- need atleast 2 players
    if GetRealPlayerCount() >= 2 then
        -- Get for red team
        if GetTeamCount(TEAM_RED) >= 1 then
            repeat
                local rand = math.random(0, cnt - 1)
                newLeader = ObjMgr:GetPlayerByIndex(rand)
            until (IsInGame(newLeader) and GetPropertyAsInt(newLeader, TeamType) == TEAM_RED)
            object.LeaderRed = newLeader
            AddLeaderBuffs(object.LeaderRed)
        else
            PostScriptMessage(5, "Not enough red players")
        end
        -- Get for blue team
        if GetTeamCount(TEAM_RED) >= 1 then
            repeat
                local rand = math.random(0, cnt - 1)
                newLeader = ObjMgr:GetPlayerByIndex(rand)
            until (IsInGame(newLeader) and GetPropertyAsInt(newLeader, TeamType) == TEAM_BLUE)
            object.LeaderBlue = newLeader
            AddLeaderBuffs(object.LeaderBlue)
        else
            PostScriptMessage(5, "Not enough blue players")
        end
    else
        PostScriptMessage(5, "Not enough players")
    end
end
tOld.Round_InitializeOld = tOld.Round_InitializeOld or Round_Initialize
Round_Initialize = Round_InitializeOverride



--------------------------------
-- POST
--------------------------------
PostScriptMessage(1, "Finished loading: " .. object.ModeName)
