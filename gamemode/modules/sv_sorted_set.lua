local mathFloor = math.floor
local setmetatable = setmetatable
local tableInsert = table.insert
local tableRemove = table.remove

module("sorted_set")

local mt = {}
mt.__index = mt

local function searchValue(t, value, compareFunc, equalFunc)
	--  Initialize numbers
	local first, last, middle, add = 1, #t, 1, 0
	-- Get insert position
	while first <= last do
		-- calculate middle
		middle = mathFloor((first + last) / 2)
		-- compare
		if compareFunc(value, t[middle]) then
			last, add = middle - 1, 0
		else
			first, add = middle + 1, 1
		end
	end

	local insertPoint = middle + add

	if equalFunc(t[insertPoint - 1], value) then
		return insertPoint - 1
	end

	return -insertPoint
end

function mt:insert(item)
	local index = searchValue(self, item, self._compareFunc, self._equalFunc)
	if index > 0 then
		return false
	end

	tableInsert(self, -index, item)
	return true
end

function mt:replace(item)
	local index = searchValue(self, item, self._compareFunc, self._equalFunc)
	if index > 0 then
		self[index] = item
		return
	end

	tableInsert(self, -index, item)
end

function mt:contains(item)
	local index = searchValue(self, item, self._compareFunc, self._equalFunc)
	return index > 0
end

function mt:remove(item)
	local index = searchValue(self, item, self._compareFunc, self._equalFunc)
	if index <= 0 then
		return false
	end

	tableRemove(self, index)
	return true
end

function mt:clear()
	for i = #self, 1, -1 do
		tableRemove(self, i)
	end
end

local function defaultCompare(a1, a2)
	return a1 < a2
end

local function defaultEqual(a1, a2)
	return a1 == a2
end

---
-- Creates a new sorted set
-- @param compareFunc a comparison function of the signature function(a, b) -- it should return true whenever a is less than b
-- @return a sorted set
local function new(compareFunc, equalFunc)
	if compareFunc == nil then
		compareFunc = defaultCompare
	end
	if equalFunc == nil then
		equalFunc = defaultEqual
	end

	local queue = {
		_compareFunc = compareFunc,
		_equalFunc = equalFunc,
	}

	setmetatable(queue, mt)

	return queue
end

return {
	new = new
}
