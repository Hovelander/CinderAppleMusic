#import "CinderAppleMusicPlayerImpl.h"

#include "CinderAppleMusicPlayer.h"

@implementation CinderAppleMusicPlayerImpl

- (id)init:(cinder::AppleMusic::Player*)player
{
    self = [super init];
    
    am_player = player;
    am_controller = [MPMusicPlayerController systemMusicPlayer];
    am_library = [MPMediaLibrary defaultMediaLibrary];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver: self
           selector: @selector (onStateChanged:)
               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
             object: am_controller];
    
    [nc addObserver: self
           selector: @selector (onTrackChanged:)
               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
             object: am_controller];
    
    [am_controller beginGeneratingPlaybackNotifications];
    
    [nc addObserver: self
           selector: @selector (onLibraryChanged:)
               name: MPMediaLibraryDidChangeNotification
             object: am_library];
    
    [am_library beginGeneratingLibraryChangeNotifications];
    
    return self;
}

/*  DanO  kill this to deal with ARC
- (void)dealloc
{
    [super dealloc];
    // TODO: end generating notifications on m_controller? on library?
    [am_controller dealloc]; // TODO: is this necessary if we aren't the ones allocing iPodMusicPlayer?
}
*/
 
- (void)onStateChanged:(NSNotification *)notification
{
    am_cb_state_change.call(am_player);
}

- (void)onTrackChanged:(NSNotification *)notification
{
    am_cb_track_change.call(am_player);
}

- (void)onLibraryChanged:(NSNotification *)notification
{
    am_cb_library_change.call(am_player);
}

@end
