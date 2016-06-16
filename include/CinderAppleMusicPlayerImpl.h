//
//  CinderAppleMusicPlayerImpl.h
//  CinderAppleMusic
//
//

#pragma once

#include "cinder/Function.h"
#include "CinderAppleMusic.h"

#import <MediaPlayer/MediaPlayer.h>

namespace cinder { namespace AppleMusic {
    class Player;
} }

@interface CinderAppleMusicPlayerImpl : NSObject {
@public
    MPMusicPlayerController *am_controller;
    MPMediaLibrary          *am_library;
    MPMediaItem             *am_playing_item;
    
    cinder::AppleMusic::Player    *am_player;
    
    cinder::CallbackMgr<bool(cinder::AppleMusic::Player*)> am_cb_state_change;
    cinder::CallbackMgr<bool(cinder::AppleMusic::Player*)> am_cb_track_change;
    cinder::CallbackMgr<bool(cinder::AppleMusic::Player*)> am_cb_library_change;
}

-(id)init:(cinder::AppleMusic::Player*)player;
-(void)onStateChanged:(NSNotification *)notification;
-(void)onTrackChanged:(NSNotification *)notification;
-(void)onLibraryChanged:(NSNotification *)notification;

@end