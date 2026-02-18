
DROP TABLE IF EXISTS streams;
DROP TABLE IF EXISTS tracks;
DROP TYPE IF EXISTS OS;
CREATE TABLE tracks (
	trackID TEXT PRIMARY KEY,
	title TEXT NOT NULL,
	artist TEXT NOT NULL,
	album TEXT NOT NULL,
	duration INT,
	CONSTRAINT positive_duration 
	CHECK(duration > 0)
);

CREATE TYPE OS AS ENUM (
	'linux',
	'windows',
	'android',
	'apple',
	'tizen'
);

CREATE TABLE streams (
	streamID SERIAL PRIMARY KEY,
	endtime TIMESTAMPTZ NOT NULL,
	time_played INTEGER NOT NULL,
	trackID TEXT NOT NULL,
	platform OS NOT NULL,
	skipped BOOLEAN NOT NULL,
	shuffled BOOLEAN NOT NULL,
	FOREIGN KEY(trackID) REFERENCES tracks(trackID)
);

ALTER TABLE streams ADD COLUMN username VARCHAR(15) NOT NULL; -- DEFAULT 'cody';



-- ALTER TABLE streams
-- ADD CONSTRAINT unique_stream_per_user 
-- UNIQUE (endtime, username);

-- COPY tracks(trackID, title, artist, album, duration)
-- FROM '/tmp/tracks_cody.csv'
-- WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '');


-- COPY streams(endtime, time_played, trackID, platform, skipped, shuffled)
-- FROM '/tmp/streams_cody.csv'
-- WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '');


-- ALTER TABLE streams ALTER COLUMN username DROP DEFAULT;
