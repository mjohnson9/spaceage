local ipairs = ipairs
local setmetatable = setmetatable
local tableInsert = table.insert
local tableRemove = table.remove

module("plifo")

local mt = {}
mt.__index = mt

function mt:insert(item)
	if self:contains(item) then
		return
	end

	for i, v in ipairs(self) do
		if self._compareFunc(item, v) then -- returns true if item < v
			tableInsert(self, i, item)
			return
		end
	end

	tableInsert(self, item) -- if we got here, the item failed to insert because it should be the last in the list
end

function mt:contains(item)
	for _, v in ipairs(self) do
		if v == item then
			return true
		end
	end

	return false
end

function mt:remove(item)
	for i in ipairs(self) do
		if self[i] == item then
			tableRemove(self, i)
			return
		end
	end
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
