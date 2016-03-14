local mathFloor = math.floor
local setmetatable = setmetatable
local tableInsert = table.insert
local tableRemove = table.remove

module("sorted_set")

local mt = {}
mt.__index = mt

local function searchValue(t, value, compareFunc)
	--  Initialise numbers
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

	if t[insertPoint - 1] == value then
		return insertPoint - 1
	end

	return -insertPoint
end

function mt:insert(item)
	local index = searchValue(self, item, self._compareFunc)
	if index > 0 then
		return false
	end

	tableInsert(self, -index, item)
	return true
end

function mt:contains(item)
	local index = searchValue(self, item, self._compareFunc)
	return index > 0
end

function mt:remove(item)
	local index = searchValue(self, item, self._compareFunc)
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

function new(compareFunc)
	if compareFunc == nil then
		compareFunc = defaultCompare
	end

	local queue = {
		_compareFunc = compareFunc
	}

	setmetatable(queue, mt)

	return queue
end
