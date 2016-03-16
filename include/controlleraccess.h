/*
 * ipop-tincan
 * Copyright 2015, University of Florida
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
*/

#ifndef TINCAN_CONTROLLERACCESS_H_
#define TINCAN_CONTROLLERACCESS_H_
#pragma once
#include <stdint.h>
#include "webrtc/base/socketaddress.h"
#include "webrtc/p2p/base/basicpacketsocketfactory.h"
#include "webrtc/base/logging.h"

#include "peersignalsender.h"
#include "xmppnetwork.h"
#include "tincanconnectionmanager.h"

namespace tincan {
//port is configurable via argument to tincan.
extern int kUdpPort;

class ControllerAccess : public PeerSignalSenderInterface,
                         public sigslot::has_slots<> {
 public:
  ControllerAccess(TinCanConnectionManager& manager, XmppNetwork& network,
         rtc::BasicPacketSocketFactory* packet_factory,
         thread_opts_t* opts);

  // Inherited from PeerSignalSenderInterface
  virtual void SendToPeer(int overlay_id, const std::string& uid,
                          const std::string& data, const std::string& type);

  // Signal handler for PacketSenderInterface
  virtual void HandlePacket(rtc::AsyncPacketSocket* socket,
      const char* data, size_t len, const rtc::SocketAddress& addr,
      const rtc::PacketTime& ptime);

  virtual void ProcessIPPacket(rtc::AsyncPacketSocket* socket,
      const char* data, size_t len, const rtc::SocketAddress& addr);

 private:
  void SendTo(const char* pv, size_t cb,
              const rtc::SocketAddress& addr);
  void SendState(const std::string& uid, bool get_stats,
                 const rtc::SocketAddress& addr);

  thread_opts_t* opts_;
  XmppNetwork& network_;
  TinCanConnectionManager& manager_;
  rtc::SocketAddress remote_addr_;
  rtc::scoped_ptr<rtc::AsyncPacketSocket> socket_;
  rtc::scoped_ptr<rtc::AsyncPacketSocket> socket6_;
  rtc::Thread *signal_thread_;
  rtc::PacketOptions packet_options_;
};

}  // namespace tincan

#endif  // TINCAN_CONTROLLERACCESS_H_

