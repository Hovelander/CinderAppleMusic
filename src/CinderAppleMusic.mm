#include "CinderAppleMusic.h"

namespace cinder { namespace AppleMusic {
    
    
    // TRACK
    
    Track::Track()
    {
    }
    Track::Track(MPMediaItem *media_item)
    {
//  DanO kill this to deal with ARC      m_media_item = [media_item retain];
    }
    Track::~Track()
    {
    }
    
    string Track::getTitle()
    {
        return string([[am_media_item valueForProperty: MPMediaItemPropertyTitle] UTF8String]);
    }
    string Track::getAlbumTitle()
    {
        return string([[am_media_item valueForProperty: MPMediaItemPropertyAlbumTitle] UTF8String]);
    }
    string Track::getArtist()
    {
        return string([[am_media_item valueForProperty: MPMediaItemPropertyArtist] UTF8String]);
    }
    
    uint64_t Track::getAlbumId()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyAlbumPersistentID] longLongValue];
    }
    uint64_t Track::getArtistId()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyArtistPersistentID] longLongValue];
    }
    uint64_t Track::getItemId()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyPersistentID] longLongValue];
    }
    
    int Track::getPlayCount()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyPlayCount] intValue];
    }
    int Track::getStarRating()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyRating] intValue];
    }
    
    double Track::getLength()
    {
        return [[am_media_item valueForProperty: MPMediaItemPropertyPlaybackDuration] doubleValue];
    }

    Surface Track::getArtwork(const ivec2 &size)
    {
        MPMediaItemArtwork *artwork = [am_media_item valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artwork_img = [artwork imageWithSize: CGSizeMake(size.x, size.y)];
        
        if(artwork_img)
           return cocoa::convertUiImage(artwork_img, true);    <----  DanO killing troublemaker for now
      else
            return Surface();
    }


    
    // PLAYLIST
    
    Playlist::Playlist()
    {
    }
    Playlist::Playlist(MPMediaItemCollection *media_collection)
    {
        NSArray *items = [media_collection items];
        for(MPMediaItem *item in items){
            pushTrack(new Track(item));
        }
    }
    Playlist::~Playlist()
    {
    }
    
    void Playlist::pushTrack(TrackRef track)
    {
        am_tracks.push_back(track);
    }
    void Playlist::pushTrack(Track *track)
    {
        am_tracks.push_back(TrackRef(track));
    }
    
    string Playlist::getAlbumTitle()
    {
        MPMediaItem *item = [getMediaItemCollection() representativeItem];
        return string([[item valueForProperty: MPMediaItemPropertyAlbumTitle] UTF8String]);
    }
    
    string Playlist::getArtistName()
    {
        MPMediaItem *item = [getMediaItemCollection() representativeItem];
        return string([[item valueForProperty: MPMediaItemPropertyArtist] UTF8String]);
    }
    
    uint64_t Playlist::getAlbumId()
    {
        MPMediaItem *item = [getMediaItemCollection() representativeItem];
        return [[item valueForProperty: MPMediaItemPropertyAlbumPersistentID] longLongValue];
    }
    
    uint64_t Playlist::getArtistId()
    {
        MPMediaItem *item = [getMediaItemCollection() representativeItem];
        return [[item valueForProperty: MPMediaItemPropertyArtistPersistentID] longLongValue];
    }
    
    
    MPMediaItemCollection* Playlist::getMediaItemCollection()
    {
        NSMutableArray *items = [NSMutableArray array];
        for(Iter it = am_tracks.begin(); it != am_tracks.end(); ++it){
            [items addObject: (*it)->getMediaItem()];
        }
        return [MPMediaItemCollection collectionWithItems:items];
    }
    
    // AppleMusic
    
    PlaylistRef getAllTracks()
    {
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        MPMediaItemCollection *tracks = [MPMediaItemCollection collectionWithItems: [query items]];
        
        return PlaylistRef(new Playlist(tracks));
    }
    
    PlaylistRef getAlbum(uint64_t album_id)
    {
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSNumber numberWithInteger: MPMediaTypeMusic]
                                    forProperty: MPMediaItemPropertyMediaType
                                    ]];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSNumber numberWithUnsignedLongLong: album_id]
                                    forProperty: MPMediaItemPropertyAlbumPersistentID
                                    ]];
        MPMediaItemCollection *tracks = [MPMediaItemCollection collectionWithItems: [query items]];
        
        return PlaylistRef(new Playlist(tracks));
    }
    
    vector<PlaylistRef> getAlbums()
    {
        MPMediaQuery *query = [MPMediaQuery albumsQuery];
        
        vector<PlaylistRef> albums;
        
        NSArray *query_groups = [query collections];
        for(MPMediaItemCollection *group in query_groups){
            PlaylistRef album = PlaylistRef(new Playlist(group));
            albums.push_back(album);
        }
        
        return albums;
    }
    
    vector<PlaylistRef> getAlbumsWithArtist(const string &artist_name)
    {
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSNumber numberWithInteger: MPMediaTypeMusic]
                                    forProperty: MPMediaItemPropertyMediaType
                                    ]];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSString stringWithUTF8String: artist_name.c_str()]
                                    forProperty: MPMediaItemPropertyArtist
                                    ]];
        [query setGroupingType: MPMediaGroupingAlbum];
        
        vector<PlaylistRef> albums;
        
        NSArray *query_groups = [query collections];
        for(MPMediaItemCollection *group in query_groups){
            PlaylistRef album = PlaylistRef(new Playlist(group));
            albums.push_back(album);
        }
        
        return albums;
    }
    
    PlaylistRef getArtist(uint64_t artist_id)
    {
        MPMediaQuery *query = [[MPMediaQuery alloc] init];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSNumber numberWithInteger: MPMediaTypeMusic]
                                    forProperty: MPMediaItemPropertyMediaType
                                    ]];
        [query addFilterPredicate: [MPMediaPropertyPredicate
                                    predicateWithValue: [NSNumber numberWithUnsignedLongLong: artist_id]
                                    forProperty: MPMediaItemPropertyArtistPersistentID
                                    ]];
        MPMediaItemCollection *group = [MPMediaItemCollection collectionWithItems: [query items]];
        
        return PlaylistRef(new Playlist(group));
    }
    
    vector<PlaylistRef> getArtists()
    {
        MPMediaQuery *query = [MPMediaQuery artistsQuery];
        
        vector<PlaylistRef> artists;
        
        NSArray *query_groups = [query collections];
        for(MPMediaItemCollection *group in query_groups){
            PlaylistRef artist = PlaylistRef(new Playlist(group));
            artists.push_back(artist);
        }
        
        return artists;
    }
    
} }
