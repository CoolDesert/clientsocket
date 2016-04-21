LUALIB_MINGW=-I/usr/local/include -L/usr/local/bin -llua53
SRC=\
socket_lib.c

all :
	echo 'make mingw or make posix or make macosx'

mingw : clientsocket.dll
posix : clientsocket.so
macosx: clientsocket.dylib

clientsocket.so : $(SRC)
	gcc -g -Wall --shared -fPIC -o $@ $^ -lpthread

clientsocket.dll : $(SRC)
	gcc -g -Wall --shared -o $@ $^ $(LUALIB_MINGW) -lpthread -march=native -lws2_32

clientsocket.dylib : $(SRC)
	gcc -g -Wall -bundle -undefined dynamic_lookup -fPIC -o $@ $^ -lpthread

clean :
	rm -rf core.dll core.so core.dylib core.dylib.dSYM
