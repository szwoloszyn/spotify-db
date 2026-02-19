-- EXAMPLE QUERIES

-- overall listening time for account history
SELECT format_seconds(SUM(time_played)) AS listening_time FROM streams
WHERE username = 'cody'

-- TOP 10 longest songs in database and who listened to them
SELECT DISTINCT t.title, t.artist, format_seconds(t.duration), s.username AS howLong FROM streams s
JOIN tracks t USING(trackID)
WHERE t.duration IS NOT NULL
ORDER BY format_seconds(t.duration) DESC
LIMIT 20;

-- avarage track length 
SELECT format_seconds(AVG(duration)) FROM tracks

-- median of song length
SELECT 
    percentile_cont(0.5) WITHIN GROUP (ORDER BY duration) AS median_duration
FROM codyall


-- what was going on on this thrusday night?
SELECT title, artist, album, endtime, duration, shuffled FROM codyall
WHERE endtime >= '2022-09-01 00:00:00+02'
  AND endtime <= '2022-09-01 12:00:00+02'

-- overall amount of songs in db
SELECT COUNT(*) FROM tracks


-- most frequently played titles.
SELECT t.title, t.artist, COUNT(s.streamID) AS liczba_przesluchan FROM streams s
JOIN tracks t USING(trackID)
WHERE s.username = 'cody'
GROUP BY t.title, t.artist
ORDER BY COUNT(s.streamID) DESC
LIMIT 20;


-- amount of streams listened grouped by day of week.
SELECT EXTRACT(ISODOW FROM endtime), COUNT(*) FROM codyall
GROUP BY EXTRACT(ISODOW FROM endtime)
ORDER BY EXTRACT(ISODOW FROM endtime)

-- amount of streams listened by Archive, group by albums
SELECT t.album, COUNT(s.streamID) FROM streams s
JOIN tracks t USING(trackID)
where t.artist = 'Archive'
AND s.username = 'cody'
GROUP BY t.album
ORDER BY COUNT(s.streamID) DESC

-- most frequently played songs on specified OS
SELECT s.platform, t.title, t.artist, COUNT(*) FROM streams s
JOIN tracks t USING(trackID)
WHERE s.platform = 'android'
AND s.username = 'cody'
GROUP BY t.title, t.artist, s.platform
ORDER BY COUNT(*) DESC, platform ASC
LIMIT 30;

-- most frequently played albums
SELECT t.album, t.artist, COUNT(s.streamID) FROM streams s
JOIN tracks t USING(trackID)
WHERE s.username = 'cody'
GROUP BY t.album, t.artist
ORDER BY COUNT(s.streamID) DESC
LIMIT 30;

-- songs listens distrubution in top 10 albums
SELECT t.title, t.album, COUNT(s.streamID), t.duration from streams s
JOIN tracks t USING(trackID)
WHERE t.album IN (
	SELECT t.album FROM streams s
	JOIN tracks t USING(trackID)
	Where s.username = 'cody'
	GROUP BY t.album, t.artist
	ORDER BY COUNT(s.streamID) DESC
	LIMIT 10
)
GROUP BY t.title, t.album, t.duration
ORDER BY t.album, COUNT(s.streamID)


-- users count of streams grouped by song of Nirvana group
SELECT  title, album, COUNT(streamID) FROM dhozall
WHERE artist = 'Nirvana'
GROUP BY title, album
ORDER BY count(streamID) DESC


-- codys top songs in 2026 vs dhozs top songs in 2026
(
    SELECT 
        'cody' AS username,       -- Tag the rows!
        t.title, 
        t.artist, 
        COUNT(s.streamID) as plays
    FROM streams s
    JOIN tracks t USING(trackID)
    WHERE endtime >= '2026-01-01 00:10:00+02'
      AND endtime <= '2026-11-30 23:00:00+02'
      AND s.username = 'cody'
    GROUP BY t.title, t.artist
    ORDER BY plays DESC
    LIMIT 10
)
UNION ALL  -- Use ALL to keep duplicates (if both have same song/count) and it's faster
(
    SELECT 
        'dhoz' AS username,       -- Tag the rows!
        t.title, 
        t.artist,
        COUNT(s.streamID) as plays
    FROM streams s
    JOIN tracks t USING(trackID)
    WHERE endtime >= '2026-01-01 00:10:00+02'
      AND endtime <= '2026-11-30 23:00:00+02'
      AND s.username = 'dhoz'
    GROUP BY t.title, t.artist
    ORDER BY plays DESC
    LIMIT 10
)
ORDER BY username, plays DESC;