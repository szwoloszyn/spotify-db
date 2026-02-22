SELECT t.title, t.artist, t.album, s.endtime, t.duration, s.shuffled FROM streams s
JOIN tracks t USING(trackID)
WHERE endtime >= '2022-09-01 03:00:00+02'
  AND endtime <= '2022-09-01 11:00:00+02'
--AND t.artist = 'Jeremy Soule'


SELECT title, artist, COUNT(*) FROM codyall
    WHERE endtime >= '2025-01-01 20:10:00+02'
      AND endtime <= '2026-01-01 23:00:00+02'
GROUP BY title, artist
ORDER BY COUNT(*) DESC

SELECT DISTINCT endtime, title, album, artist, format_seconds(COALESCE(duration, 0)) AS czas_trwania, format_seconds(time_played) AS czas_odtw  FROM yodaall
ORDER BY czas_trwania DESC, czas_odtw DESC

SELECT * FROM codyall
WHERE streamID = 6
ORDER BY endtime