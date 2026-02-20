CREATE OR REPLACE FUNCTION IMPORT_USER_STREAMS(
    username TEXT,
    tracks_path TEXT,
    streams_path TEXT
) RETURNS void AS $$
BEGIN

	CREATE TEMP TABLE tracks_staging AS 
	SELECT * FROM tracks WITH NO DATA;
	EXECUTE format('COPY tracks_staging(trackID, title, artist, album, duration) 
	FROM %L WITH (FORMAT csv, HEADER, DELIMITER '','', NULL '''')', tracks_path);

	INSERT INTO tracks
	SELECT * FROM tracks_staging
	ON CONFLICT (trackID) 
	DO NOTHING;

	DROP TABLE tracks_staging;

	EXECUTE format('ALTER TABLE streams ALTER COLUMN username SET DEFAULT %L', username);

	EXECUTE format('COPY streams(endtime, time_played, trackID, platform, skipped, shuffled) 
	FROM %L WITH (FORMAT csv, HEADER, DELIMITER '','', NULL '''')', streams_path);

	ALTER TABLE streams ALTER COLUMN username DROP DEFAULT;

END;
$$ LANGUAGE PLPGSQL;