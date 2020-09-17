include platform.mk

LUA_CLIB_PATH ?= luaclib
LUA_CLIB = lpeg sproto lfs
LUA_INC ?= lua53/src

CFLAGS = -g -O2 -Wall -I$(LUA_INC) $(MYCFLAGS)

all : luabin \
	$(foreach v, $(LUA_CLIB), $(LUA_CLIB_PATH)/$(v).so)

luabin:
	cd lua53 && $(MAKE) $(PLAT) && \
	mv src/lua ../example/luabin && \
	mv src/luac ../example/luacbin && \
	cd ../

$(LUA_CLIB_PATH) :
	mkdir $(LUA_CLIB_PATH)

$(LUA_CLIB_PATH)/lpeg.so : lpeg/lpcap.c lpeg/lpcode.c lpeg/lpprint.c lpeg/lptree.c lpeg/lpvm.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Ilpeg $^ -o $@

$(LUA_CLIB_PATH)/sproto.so : sproto/sproto.c sproto/lsproto.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Isproto $^ -o $@

$(LUA_CLIB_PATH)/lfs.so : lfs/src/lfs.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Isproto $^ -o $@

clean:
	rm -f $(LUA_CLIB_PATH)/*.so
