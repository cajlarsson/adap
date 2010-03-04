default: server client
MAKEFLAGS= -aL/home/TDDB22/lib/TJa/lib/Solaris -aI/home/TDDB22/lib/TJa/src/Solaris -aO/home/TDDB22/lib/TJa/lib/Solaris

clean: 
	./cleaner  *~*.* *.ali *.o client server grafics *~
server:
	gnatmake ${MAKEFLAGS} src/server.adb -o server
client:
	gnatmake ${MAKEFLAGS} src/client.adb -o client
grafics:
	gnatmake ${MAKEFLAGS} src/grafics.adb -o grafics

