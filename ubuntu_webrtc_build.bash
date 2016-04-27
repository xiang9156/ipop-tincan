#!/bin/bash

cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sudo apt-get update -y
sudo apt-get install default-jdk pkg-config git subversion make gcc g++ python -y
sudo apt-get install libexpat1-dev libgtk2.0-dev libnss3-dev libssl-dev -y

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=`pwd`/depot_tools:"$PATH"

mkdir webrtc-checkout
cd webrtc-checkout
fetch --nohooks webrtc

cd src
git branch -r
read -p "Enter the full name of branch that you want to build(e.g. branch-heads/50): " BRANCH
if [ ! -z "$BRANCH" ]; then
  git checkout $BRANCH
fi

# Download source code of WebRTC
gclient sync

# Extract header files to dir /include
mkdir include
mkdir include/json
mkdir include/webrtc
mkdir include/webrtc/base
mkdir include/webrtc/libjingle
mkdir include/webrtc/libjingle/xmpp
mkdir include/webrtc/libjingle/xmllite
mkdir include/webrtc/p2p
mkdir include/webrtc/p2p/client
mkdir include/webrtc/p2p/base
mkdir include/webrtc/system_wrappers
mkdir include/third_party/
mkdir include/third_party/jsoncpp
mkdir include/third_party/jsoncpp/source/
mkdir include/third_party/jsoncpp/overrides/
mkdir include/third_party/jsoncpp/source/include/
mkdir include/third_party/jsoncpp/source/include/json/
mkdir include/third_party/jsoncpp/overrides/include/
mkdir include/third_party/jsoncpp/overrides/include/json/

cp ./webrtc/*.h ./include/webrtc/
cp ./third_party/jsoncpp/source/include/json/*.h ./include/json
cp ./third_party/jsoncpp/overrides/include/json/*.h ./include/json
cp ./webrtc/base/*.h ./include/webrtc/base
cp ./webrtc/libjingle/xmpp/*.h ./include/webrtc/libjingle/xmpp
cp ./webrtc/libjingle/xmllite/*.h ./include/webrtc/libjingle/xmllite
cp ./webrtc/p2p/client/*.h ./include/webrtc/p2p/client
cp ./webrtc/p2p/base/*.h ./include/webrtc/p2p/base
cp ./third_party/jsoncpp/source/include/json/*.h ./include/third_party/jsoncpp/source/include/json/
cp ./third_party/jsoncpp/overrides/include/json/*.h ./include/third_party/jsoncpp/overrides/include/json/

echo "Start Building Release Mode!"
# Build Release mode
ninja -C out/Release

# Extract release static libraries to dir /Release_lib
mkdir Release_lib
ar -t ./out/Release/obj/chromium/src/third_party/boringssl/libboringssl.a | xargs ar -rcs Release_lib/libboringssl.a
ar -t ./out/Release/obj/webrtc/system_wrappers/libfield_trial_default.a | xargs ar -rcs Release_lib/libfield_trial_default.a
ar -t ./out/Release/obj/chromium/src/third_party/jsoncpp/libjsoncpp.a | xargs ar -rcs Release_lib/libjsoncpp.a
ar -t ./out/Release/obj/webrtc/base/librtc_base.a | xargs ar -rcs Release_lib/librtc_base.a
ar -t ./out/Release/obj/webrtc/base/librtc_base_approved.a | xargs ar -rcs Release_lib/librtc_base_approved.a
ar -t ./out/Release/obj/webrtc/p2p/librtc_p2p.a | xargs ar -rcs Release_lib/librtc_p2p.a
ar -t ./out/Release/obj/webrtc/libjingle/xmllite/librtc_xmllite.a | xargs ar -rcs Release_lib/librtc_xmllite.a
ar -t ./out/Release/obj/webrtc/libjingle/xmpp/librtc_xmpp.a | xargs ar -rcs Release_lib/librtc_xmpp.a
ar -t ./out/Release/obj/chromium/src/third_party/boringssl/libboringssl_asm.a | xargs ar -rcs Release_lib/libboringssl_asm.a

read -p "Do you want to build Debug mode? (Y/N): " REPLY
if [ -z "$REPLY" ] || [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exit"
  exit 0
fi

echo "Start Building Debug Mode!"
# Build Debug mode
ninja -C out/Debug

# Extract debug static libraries to dir /Debug_lib
mkdir Debug_lib
ar -t ./out/Debug/obj/chromium/src/third_party/boringssl/libboringssl.a | xargs ar -rcs Debug_lib/libboringssl.a
ar -t ./out/Debug/obj/webrtc/system_wrappers/libfield_trial_default.a | xargs ar -rcs Debug_lib/libfield_trial_default.a
ar -t ./out/Debug/obj/chromium/src/third_party/jsoncpp/libjsoncpp.a | xargs ar -rcs Debug_lib/libjsoncpp.a
ar -t ./out/Debug/obj/webrtc/base/librtc_base.a | xargs ar -rcs Debug_lib/librtc_base.a
ar -t ./out/Debug/obj/webrtc/base/librtc_base_approved.a | xargs ar -rcs Debug_lib/librtc_base_approved.a
ar -t ./out/Debug/obj/webrtc/p2p/librtc_p2p.a | xargs ar -rcs Debug_lib/librtc_p2p.a
ar -t ./out/Debug/obj/webrtc/libjingle/xmllite/librtc_xmllite.a | xargs ar -rcs Debug_lib/librtc_xmllite.a
ar -t ./out/Debug/obj/webrtc/libjingle/xmpp/librtc_xmpp.a | xargs ar -rcs Debug_lib/librtc_xmpp.a
ar -t ./out/Debug/obj/chromium/src/third_party/boringssl/libboringssl_asm.a | xargs ar -rcs Debug_lib/libboringssl_asm.a

