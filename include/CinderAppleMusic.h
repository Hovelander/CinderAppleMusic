//
//  CinderAppleMusic.h
//  CinderAppleMusic
//
//

#pragma once

#include "cinder/Cinder.h"
#include "cinder/Surface.h"
#include "cinder/app/cocoa/AppCocoaTouch.h"
#include <MediaPlayer/MediaPlayer.h>
#include <vector>
#include <string>
#include <ostream>

using std::string;
using std::vector;

namespace cinder { namespace AppleMusic {
    
    class Track {
    public:
        
        Track();
        Track(MPMediaItem *media_item);
        ~Track();
        
        string   getTitle();
        string   getAlbumTitle();
        string   getArtist();
        
        uint64_t getAlbumId();
        uint64_t getArtistId();
        uint64_t getItemId();
        
        int      getPlayCount();
        int      getStarRating();
        double   getLength();
        
        Surface getArtwork(const ivec2 &size);
        
        MPMediaItem* getMediaItem(){
            return am_media_item;
        };
        
    protected:
        
        MPMediaItem *am_media_item;
        
    };
    
    typedef std::shared_ptr<Track> TrackRef;
    
    
    class Playlist {
    public:
        
        typedef vector<TrackRef>::iterator Iter;
        
        Playlist();
        Playlist(MPMediaItemCollection *collection);
        ~Playlist();
        
        void pushTrack(TrackRef track);
        void pushTrack(Track *track);
        void popLastTrack(){ am_tracks.pop_back(); };
        
        string   getAlbumTitle();
        string   getArtistName();
        uint64_t getAlbumId();
        uint64_t getArtistId();
        
        TrackRef operator[](const int index){ return am_tracks[index]; };
        TrackRef firstTrack(){ return am_tracks.front(); };
        TrackRef lastTrack(){ return am_tracks.back(); };
        Iter     begin(){ return am_tracks.begin(); };
        Iter     end(){ return am_tracks.end(); };
        size_t   size(){ return am_tracks.size(); };
        
        MPMediaItemCollection* getMediaItemCollection();
        
        vector<TrackRef> am_tracks;
        
    };
    
    typedef std::shared_ptr<Playlist> PlaylistRef;
    
    
    PlaylistRef         getAllTracks();
    PlaylistRef         getAlbum(uint64_t album_id);
    PlaylistRef         getArtist(uint64_t artist_id);
    vector<PlaylistRef> getAlbums();
    vector<PlaylistRef> getAlbumsWithArtist(const string &artist_name);
    vector<PlaylistRef> getArtists();
    
} }
