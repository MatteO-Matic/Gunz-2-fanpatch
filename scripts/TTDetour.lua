------------------------------------------
-- TTDetour
-- Injected file / Entry point for all lua things (TTHook.dll loads this file)
-- Created by: MatteO-Matic				
------------------------------------------

-- ttprofiler = loadfile("_tprofiler.lua")
-- ttprofiler()
-- pro = newProfiler()
-- pro:start()

function saveUserData(obj)
	-- GetDefinitionID(obj) returns class
	local outfile = io.open("TTuserdata.txt", "w+")
	for i = 0, 150 do
		if GetPropertyAsInt(obj, i) ~= 0 then
			outfile:write(i .. ":int:	" .. GetPropertyAsInt(obj, i))
			outfile:write("\n")
		elseif GetPropertyAsString(obj, i) ~= "" then
			outfile:write(i .. ":str:	" .. GetPropertyAsString(obj, i))
			outfile:write("\n")
		elseif GetPropertyAsFloat(obj, i) ~= 0 then
			outfile:write(i .. ":flo:	" .. GetPropertyAsFloat(obj, i))
			outfile:write("\n")
		elseif GetPropertyAsVector(obj, i).x ~= 0 or
			GetPropertyAsVector(obj, i).z ~= 0 or
			GetPropertyAsVector(obj, i).y ~= 0 then

			outfile:write(i .. ":veX:	" .. GetPropertyAsVector(obj, i).x)
			outfile:write(" veZ:	" .. GetPropertyAsVector(obj, i).z)
			outfile:write(" veY:	" .. GetPropertyAsVector(obj, i).y)
			outfile:write("\n")
		else
			-- outfile:write(i.. "NAN")
		end
	end
	outfile:close()
end

function TTHostDoStateAllPlayers(ttstate)
	local cnt = ObjMgr:PlayerCount()
	local members = { }

	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		DirectHostEvent(members[i], Event_ModifyState(ttstate, MODIFY_LOOSE))
	end
end

function TTHostDoBuffAllPlayers(ttbuff)
	local cnt = ObjMgr:PlayerCount()
	local members = { }

	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		DirectHostEvent(members[i], Event_ModifyBuff(ttbuff, 9999999))
	end
end

function TTCommonDoStateAllPlayers(ttstate)
	local cnt = ObjMgr:PlayerCount()
	local members = { }
	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		TTCommonDoState(members[i], ttstate)
	end
end

function TTCommonDoBuffAllPlayers(ttbuff)
	local cnt = ObjMgr:PlayerCount()
	local members = { }
	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		TTCommonDoBuff(members[i], ttbuff)
	end
end

function TTCommonDoState(obj, ttstate)
	DirectCommonEvent(obj, Event_TransitionState(ttstate, MODIFY_LOOSE))
end

function TTHostDoState(obj, ttstate)
	DirectHostEvent(obj, Event_ModifyState(ttstate, MODIFY_LOOSE))
end

function TTHostDoBuff(obj, ttbuff)
	DirectHostEvent(obj, Event_ModifyBuff(ttbuff, 9999999))
end

function TTHostRemoveBuff(obj, ttbuff)
	DirectHostEvent(obj, Event_ModifyRemoveBuff(ttbuff))
end

function TTHostRemoveBuffAllPlayers(ttbuff)
	local cnt = ObjMgr:PlayerCount()
	local members = { }
	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		TTHostRemoveBuff(members[i], ttbuff)
	end
end

function TTCommonDoBuff(obj, ttbuff)
	DirectCommonEvent(obj, Event_AddBuff(ttbuff, 9999999))
end

function TTCommonRemoveBuff(obj, ttbuff)
	DirectCommonEvent(obj, Event_RemoveBuff(ttbuff))
end

function TTCommonRemoveBuffAllPlayers(ttbuff)
	local cnt = ObjMgr:PlayerCount()
	local members = { }
	-- All players
	for i = 0, cnt - 1 do
		members[i] = ObjMgr:GetPlayerByIndex(i)
		TTCommonRemoveBuff(members[i], ttbuff)
	end
end

-- Print table funciton
function SaveTableToFile(prefix, a)
	for i, v in pairs(a) do
		if type(v) == "table" then
			-- Filter out everything we don't want to see for a cleaner statefile
			if i ~= "attributes" and i ~= "attributes_update" and i ~= "tag" then
				ttfile:write(prefix .. '.' .. i .. ':Table\n')
			end
			if v ~= a then
				SaveTableToFile(prefix .. "." .. i, v)
			end
		end
	end
	-- ttfile:write("---------------------------\n")
end

local bBerserkEnabled = false
local bAssassinEnabled = false
function foo(obj, key)
	if key == KEY_7 then
		PostScriptMessage(2, "Camera unlocked")
		DirectCommonEvent(obj, Event_EnableLimitDir(true, 0))
	end
	if key == KEY_8 then
		-- Reloads file
		if bAssassinEnabled then
			TurnOffAssassin()
			bAssassinEnabled = false
		else
			ttAssassinMode = loadfile("TTAssassination")
			ttAssassinMode()
			bAssassinEnabled = true
		end
	end
	if key == KEY_9 then
		-- Reloads file
		if bBerserkEnabled then
			TurnOffBerserk()
			bBerserkEnabled = false
		else
			ttBerserkMode = loadfile("TTBerserk")
			ttBerserkMode()
			bBerserkEnabled = true
		end
	end
	if key == KEY_F then
		ttlua = loadfile("TTLua.lua") --for dynamic loading
		ttlua()
	end
	foo2(obj, key)
end
PostScriptMessage(1, "Successful lua hook")
