CC = g++
FLAGS = -g -Wno-deprecated
LIB = -L/usr/local/
INC = -I/usr/local/

# Testing for OSX vs Linux
OS = $(shell uname -s)

ifeq ($(OS), Darwin)
	FW = -framework OpenGL -lglfw -lglew
else
	FW = -lGL
endif

all:
	$(CC) $(FLAGS) $(LIB) $(INC) -o openGLp ogl.cpp $(FW)

clean:
	rm -f openGLp
	rm -rf *.dSYM/
