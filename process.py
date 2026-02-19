import pandas as pd
import json
from pathlib import Path
import statistics

### USERNAME !
username = 'dhoz'

# path to input files:
directory = Path(f'./data/{username}/')

platforms = ['linux', 'windows', 'android', 'apple', 'tizen']

## FOR PEACE OF MY SOUL
title = "master_metadata_track_name"
album = "master_metadata_album_album_name"
artist = "master_metadata_album_artist_name"
trackID = "spotify_track_uri"
## FOR PEACE OF MY SOUL


tracks = {}
streams = []
times = {}

for file in directory.iterdir():
    if ".json" not in file.name:
        continue
    
    with open(str(directory) + "/" + file.name, "r", encoding="utf-8") as f:
        raw = json.load(f)

    for item in raw:
        if item[trackID] == None:
            continue
        item[trackID] = item[artist] + ";" + item[title] + ";" + item[album]
        tid = item[trackID]
        
        playtime = item["ms_played"]
        if item["skipped"] == True:
            playtime = None
        elif item["reason_end"] not in ("trackdone", "endplay"):
            playtime = None
        elif playtime <= 30000:
            playtime = None

        if playtime is not None:
            if tid not in times:
                times[tid] = [playtime]
            else:
                times[tid].append(playtime)


        if item[trackID] not in tracks:
            # creating track if didnt exist
            track = {
                "trackID" : item[trackID],
                "title" : item[title],
                "artist" : item[artist],
                "album" : item[album],
                "duration" : playtime
            }
            tracks[tid] = track

        # updating playtime if track existed
        else:
            if playtime is not None:
                current_stored = tracks[tid]["duration"]
                if current_stored is None:
                    tracks[tid]["duration"] = playtime
                else:
                    tracks[tid]["duration"] = max(playtime, tracks[tid]["duration"])



        #### skipping stream if it lasted 30secs or less.
        if item['ms_played'] <= 30000:
            continue

        platform = None
        for plt in platforms:
            if plt in item["platform"].lower():
                platform = plt

        stream = {
            "endtime" : item["ts"],
            "time_played" : item["ms_played"],
            "trackID" : item[trackID],
            "platform" : platform,
            "skipped" : item["skipped"],
            "shuffled" : item["shuffle"]
        }
        streams.append(stream)



for tid, time in times.items():
    if len(time) < 3:
        times[tid] = max(time)
    else:
        times[tid] = statistics.median(time)


tracks_df = pd.DataFrame(list(tracks.values()))

# adjusting duration
tracks_df['duration'] = tracks_df["trackID"].map(times)

# converting msec to sec
tracks_df['duration'] = (tracks_df['duration'] / 1000).round().astype('Int64')

tracks_df.to_csv(f'./data/processed-data/tracks_{username}.csv',
                index = False,
                header = True,
                sep=',',
                na_rep='',
                encoding='utf-8'
)


streams_df = pd.DataFrame(streams)

streams_df = streams_df.sort_values(by=['endtime'])

# removing duplicates - spotify bug with some song with the same timestamp...
duplicate_mask = streams_df.duplicated(subset=['endtime'], keep='first')
dropped_rows = streams_df[duplicate_mask]
streams_df = streams_df.drop_duplicates(subset=['endtime'], keep='first')

streams_df['endtime'] = pd.to_datetime(streams_df['endtime'])

# converting msec to sec once again
streams_df['time_played'] = (streams_df['time_played'] / 1000).round().astype('Int64')

streams_df.to_csv(f'./data/processed-data/streams_{username}.csv',
                index = False,
                header = True,
                sep=',',
                na_rep='',
                encoding='utf-8'
                )

print(len(tracks))
print(len(streams))
