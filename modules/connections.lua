local Connection = {}
Connection.__index = Connection

function Connection.new(signal, func)
	local self = {
		signal = signal,
		func = func,
	}
	setmetatable(self, Connection)
	return self
end

function Connection:disconnect()
	if self.signal then
		self.signal.connections[self.func] = nil
		self.signal = nil
		self.func = nil
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = {
		connections = {},
	}
	setmetatable(self, Signal)
	return self
end

function Signal:fire(...)
	local copy = {}
	for func in pairs(self.connections) do
		table.insert(copy, func)
	end

	for _, func in pairs(copy) do
		task.spawn(func, ...)
	end
end

function Signal:connect(func)
	self.connections[func] = true
	return Connection.new(self, func)
end

function Signal:wait()
	local thread = coroutine.running()
	self.connections[thread] = true
	local result = table.pack(coroutine.yield())
	self.connections[thread] = nil
	return table.unpack(result)
end

return Signal
