default: server client
server:
	gnatmake src/server.adb -o server
client:
	gnatmake src/client.adb -o client
