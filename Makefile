default: server client
clean: 
	./cleaner  *~*.* *.ali *.o client server *~
server:
	gnatmake src/server.adb -o server
client:
	gnatmake src/client.adb -o client

