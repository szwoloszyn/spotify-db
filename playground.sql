SELECT t.title, t.artist, t.album, s.endtime, t.duration, s.shuffled FROM streams s
JOIN tracks t USING(trackID)
WHERE endtime >= '2022-09-01 03:00:00+02'
  AND endtime <= '2022-09-01 11:00:00+02'
--AND t.artist = 'Jeremy Soule'


SELECT * FROM codyall
    WHERE endtime >= '2026-01-26 20:10:00+02'
      AND endtime <= '2026-01-26 23:00:00+02'