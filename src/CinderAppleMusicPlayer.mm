#include "CinderAppleMusicPlayer.h"

namespace cinder { namespace AppleMusic {
    
    
    Player::Player()
    {
        am_pod = [[CinderAppleMusicPlayerImpl alloc] init: this];
    }

    Player::~Player()
    {
//  DanO kill this to deal with ARC       [m_pod dealloc];
    }
    
    //void Player::play( TrackRef track )
    //{
    //	[am_pod->am_controller stop];
    //	am_pod->am_controller.nowPlayingItem = track->getMediaItem();
    //	[am_pod->am_controller play];
    //}
    
    void Player::play( PlaylistRef playlist, const int index )
    {
        MPMediaItemCollection *collection = playlist->getMediaItemCollection();
        
        [am_pod->am_controller stop];
        [am_pod->am_controller setQueueWithItemCollection: collection];
        
        if(index > 0 && index < playlist->size())
            am_pod->am_controller.nowPlayingItem = [[collection items] objectAtIndex: index];
        
        [am_pod->am_controller play];
    }
    
    void Player::play( PlaylistRef playlist )
    {
        play(playlist, 0);
    }
    
    void Player::play()
    {
        [am_pod->am_controller play];
    }
    void Player::pause()
    {
        [am_pod->am_controller pause];
    }
    void Player::stop()
    {
        [am_pod->am_controller stop];
    }
    
    
    void Player::setPlayheadTime(double time)
    {
        am_pod->am_controller.currentPlaybackTime = time;
    }
    double Player::getPlayheadTime()
    {
        return am_pod->am_controller.currentPlaybackTime;
    }
    
    
    void Player::skipNext()
    {
        [am_pod->am_controller skipToNextItem];
    }
    
    void Player::skipPrev()
    {
        [am_pod->am_controller skipToPreviousItem];
    }
    
    
    void Player::setShuffleSongs()
    {
        [am_pod->am_controller setShuffleMode: MPMusicShuffleModeSongs];
    }
    void Player::setShuffleAlbums()
    {
        [am_pod->am_controller setShuffleMode: MPMusicShuffleModeAlbums];
    }
    void Player::setShuffleOff()
    {
        [am_pod->am_controller setShuffleMode: MPMusicShuffleModeOff];
    }
    
    bool Player::hasPlayingTrack()
    {
        return am_pod->am_controller.nowPlayingItem != Nil;
    }
    
    TrackRef Player::getPlayingTrack()
    {
        return TrackRef(new Track(am_pod->am_controller.nowPlayingItem));
    }
    
    Player::State Player::getPlayState()
    {
        return State(am_pod->am_controller.playbackState);
    }
    
    
} }
