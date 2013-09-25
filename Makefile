all : test test-facade

MAGTFacade.o : MAGTFacade.m MAGTFacade.h MAGT-Prefix.h
	g++ -c -Wall MAGTFacade.m -I ../libgit2/include

MAGTFacadeImpl.o : MAGTFacadeImpl.m MAGTFacadeImpl.h MAGTFacade.h MAGT-Prefix.h
	g++ -c -Wall MAGTFacadeImpl.m -I ../libgit2/include

test-facade.o : test-facade.m MAGTFacadeImpl.h MAGTFacade.h MAGT-Prefix.h
	g++ -c -Wall test-facade.m -I ../libgit2/include

test-facade : MAGTFacadeImpl.o test-facade.o MAGTFacade.o
	g++ -o test-facade MAGTFacadeImpl.o test-facade.o MAGTFacade.o -L ../libgit2/build/ -lgit2 -lz -framework Foundation

test : test.cpp
	g++ -o test -I ../libgit2/include -g -Wall -Wextra -Wno-missing-field-initializers test.cpp -L ../libgit2/build/ -lgit2 -lz
