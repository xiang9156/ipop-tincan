TARGET = ipop-tincan
CC = g++
#clang++-3.5 
CFLAGS = -std=c++11 -Wall -fno-rtti -I./include/tap -I./include -D LINUX -D WEBRTC_POSIX
LDIR = -L./lib
LIBS = -lipoptap -lrtc_p2p -lrtc_base -ljsoncpp -lrtc_base_approved -lrtc_xmpp -lrtc_xmllite -lpthread -lfield_trial_default -lexpat -lboringssl -lrt 
#-lboringssl_asm
ODIR=obj
SRCDIR=src
#DEPS = controlleraccess.h peersignalsender.h tincanconnectionmanager.h tincan_utils.h tincanxmppsocket.h wqueue.h xmppnetwork.h
_OBJ = controlleraccess.o tincan.o tincanconnectionmanager.o tincan_utils.o tincanxmppsocket.o xmppnetwork.o

OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: $(SRCDIR)/%.cc
	$(CC) -c -o $@ $< $(CFLAGS)
$(TARGET): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LDIR) $(LIBS)
clean:
	rm -f $(TARGET) $(ODIR)/*.o *~
	

