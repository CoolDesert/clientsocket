local csocket = require "clientsocket"
csocket.init()

local sockets = {}

local fd = csocket.connect("127.0.0.1","8888")
sockets[fd] = {}

local result = {}
while true do
	local sz,msg = csocket.sendpack("hello")
	csocket.send(fd,sz,msg)
	for i = 1, csocket.poll(result,1000) do
		local v = result[i]
		local c = sockets[v[1]]
		if c then
			if type(v[3]) == "string" then
				-- accept: listen fd, new fd , ip
				print("accept:",v[1],v[2],v[3])
				sockets[v[2]] = {}
			else
				-- forward: fd , size , message
				local fd,size,message = v[1],v[2],v[3]
				--local data = csocket.pop(v[1], size)
				sockets[fd].buffer = csocket.push(sockets[fd].buffer,message,size)
				--local line = csocket.readline(sockets[fd].buffer,"\n",true)
				local line = csocket.pop(sockets[fd].buffer,size)
				print("recv:",line)
			end
		else
			print("error!!!!")
			csocket.freepack(v[3])
		end
	end
end