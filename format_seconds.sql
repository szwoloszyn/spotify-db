CREATE OR REPLACE FUNCTION format_seconds(seconds NUMERIC)
RETURNS TEXT AS $$
DECLARE
	hours INTEGER;
	mins INTEGER;
	secs INTEGER;
BEGIN
	IF seconds IS NULL THEN
		RETURN NULL;
	END IF;

	hours := (seconds / 3600);
	mins := ((seconds % 3600) / 60);
	secs := (seconds % 60);

	RETURN hours || 'h ' ||
		lpad(mins::text, 2, '0') || 'm ' ||
		lpad(secs::text, 2, '0') || 's ';
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;
		
