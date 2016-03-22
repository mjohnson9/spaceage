if hook.IsSpaceAge then return end -- Don't reload this

local ErrorNoHalt = ErrorNoHalt
local gmod = gmod
local ipairs = ipairs
local isfunction = isfunction
local isstring = isstring
local IsValid = IsValid
local pairs = pairs
local unpack = unpack
local debugTraceback = debug.traceback

local sorted_set = require("sorted_set")

local oldHooks = hook.GetTable()

module("hook")

IsSpaceAge = true

local hooks = {}

local function hookEquals(a, b)
	if a == nil or b == nil then
		return false
	end

	return a.name == b.name
end

local function hookCompare(a, b)
	return a.name < b.name
end

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()
	ErrorNoHalt("hook.GetTable is slow. Don't use it.\n" .. debugTraceback() .. "\n")

	local retVal = {}

	for hookName, hookTable in pairs(hooks) do
		local newHookTable = {}
		retVal[hookName] = newHookTable

		for _, hookData in ipairs(hookTable) do
			newHookTable[hookData.name] = hookData.func
		end
	end

	return retVal
end

--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add(event_name, name, func)
	if not isfunction(func) then return end
	if not isstring(event_name) then return end

	local hookTable = hooks[event_name]

	if hookTable == nil then
		hookTable = sorted_set.new(hookCompare, hookEquals)
		hooks[event_name] = hookTable
	end

	hookTable:replace({name = name, func = func})
end

--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove(event_name, name)
	if not isstring(event_name) then
		return
	end

	if hooks[event_name] == nil then
		return
	end

	hooks[event_name]:remove({name = name})
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Run(name, ...)
	return Call(name, gmod and gmod.GetGamemode() or nil, ...)
end

local function hasReturnVal(t)
	for _, v in ipairs(t) do
		if v ~= nil then
			return true
		end
	end

	return false
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Call(name, gm, ...)
	--
	-- Run hooks
	--
	local hookTable = hooks[name]

	if hookTable ~= nil then
		for _, v in ipairs(hookTable) do
			local retVal

			if isstring(v.name) then
				--
				-- If it's a string, it's cool
				--
				retVal = {v.func(...)}
			else
				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if IsValid(v.name) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					retVal = {v.func(v.name, ...)}
				else
					--
					-- If the object has become invalid - remove it
					--
					hookTable:remove({name = v.name})
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if hasReturnVal(retVal) then
				return unpack(retVal)
			end
		end
	end

	--
	-- Call the gamemode function
	--
	if not gm then
		return
	end

	local gamemodeFunction = gm[name]
	if gamemodeFunction == nil then
		return
	end

	return gamemodeFunction(gm, ...)
end


for hookName, hookTable in pairs(oldHooks) do
	for addName, func in pairs(hookTable) do
		Add(hookName, addName, func)
	end
end
