SELECT import_user_streams('cody', '/tmp/tracks_cody.csv', '/tmp/streams_cody.csv');
SELECT import_user_streams('dhoz', '/tmp/tracks_dhoz.csv', '/tmp/streams_dhoz.csv');

CREATE OR REPLACE VIEW codyall AS
SELECT 
	*
FROM streams s
JOIN tracks t USING (trackID)
WHERE s.username = 'cody';


CREATE OR REPLACE VIEW dhozall AS
SELECT 
	*
FROM streams s
JOIN tracks t USING (trackID)
WHERE s.username = 'dhoz';

	-- s.streamID,
 --    s.endtime,
	-- s.time_played,
	-- s.trackID,
	-- s.platform,
 --    s.username,
 --    t.artist,
 --    t.title,
 --    t.album,
	-- t.duration

-- DEPRACATED VERSION OF MY CODE:


-- CREATE TEMP TABLE tracks_staging AS 
-- SELECT * FROM tracks WITH NO DATA;

-- COPY tracks_staging(trackID, title, artist, album, duration)
-- FROM '/tmp/tracks_dhoz.csv'
-- WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '');

-- INSERT INTO tracks
-- SELECT * FROM tracks_staging
-- ON CONFLICT (trackID) 
-- DO NOTHING;

-- DROP TABLE tracks_staging;

-- ALTER TABLE streams 
-- ALTER COLUMN username SET DEFAULT 'dhoz';

-- COPY streams(endtime, time_played, trackID, platform, skipped, shuffled)
-- FROM '/tmp/streams_dhoz.csv'
-- WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '');

-- ALTER TABLE streams
-- ALTER COLUMN username DROP DEFAULT;