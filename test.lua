local csocket = require "clientsocket"
csocket.init()

local sockets = {}

local fd = csocket.listen("127.0.0.1:8888")
sockets[fd] = {}

local result = {}
while true do
	for i = 1, csocket.poll(result,1000) do
		local v = result[i]
		local c = sockets[v[1]]
		if c then
			if type(v[3]) == "string" then
				-- accept: listen fd, new fd , ip
				local listen_fd,new_fd,ip = v[1],v[2],v[3]
				print("accept:",listen_fd,new_fd,ip)
				sockets[new_fd] = {}
			else
				-- forward: fd , size , message
				local fd,size,message = v[1],v[2],v[3]
				--local data = csocket.pop(v[1], size)
				sockets[fd].buffer = csocket.push(sockets[fd].buffer,message,size)
				--local line = csocket.readline(sockets[fd].buffer,"\n",true)
				local line = csocket.pop(sockets[fd].buffer,size)
				print("recv:",line)
				local sz,msg = csocket.sendpack("world")
				csocket.send(fd,sz,msg)
			end
		else
			print("error!!!!")
			csocket.freepack(v[3])
		end
	end
end