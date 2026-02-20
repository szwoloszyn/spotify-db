# SPOTIFY-DB

## Table of contents
- [What is it](#what-is-it)
- [Database Structure](#database-structure)
- [How To Possess Your Streaming History](#how-to-possess-your-streaming-history)
- [Loading Data](#loading-data)
- [Detailed Description of Each File](#detailed-description-of-each-file)
- [Potential Problems With Data](#potential-problems-with-data)


## What is it

**Spotify-DB** is a local `PostgreSQL-based` analytics database project created to store and query personal Spotify streaming history.
Detailed description of how the data is being processed and stored in the database can be found [here](#each-file).
The project was created using following software:
- `PostgreSQL 17`
- `Python 3.13`
- Following **Python** packages:
    - `Pandas 2.2.3`
    - `json`
    - `pathlib`
    - `statistics`

All work was done on `Debian GNU/Linux 13 (trixie)` Operating System.

## Database Structure
The database architecture separates data into two primary tables:
- `tracks` - every unique song mentioned in any user's streaming history
- `streams` - detailed streaming history for each user whose data was inserted into the database.

Detailed tables description can be found in **[init.sql](./init.sql)** file.

Besides that, database comes with custom function for converting integer seconds to `HHhMMmSSs` text which is pretty convenient in time-related queries.

## How To Possess Your Streaming History
To populate this database, you must request your *"Extended Streaming History"* directly from Spotify. Note that the standard *"Account Data"* export only contains the last year of data and lacks detailed timestamps. Spotify states that processing this request can take up to 30 days (but for me it was 2 days :) ).

**Steps to request data:**
1. Log in to your Spotify account.
2. Go to **Account Settings** > **Account Privacy**
3. Scroll down to the very end of the page to **Download Your Data** section.
4. Request **Extend Streaming History** data package.
5. Confirm the request on your E-Mail account.

The data is delivered into your E-Mail as a link to download a `.zip` file. It will contain multiple `Audio_*.json` files. Amount of these files ranges based on how extensive the account's history is.

## Loading Data
In order to convert raw data into clean `.csv` files, unzip retrieved `.zip` file and put it in `./data/` directory relative to [`process.py`](./process.py) file. Also, you need to create empty `./data/processed-data/` directory **inside** `./data`.
In 6th line of [`process.py`](./process.py) file set your username. It is used to identify created `.csv` files during inserting data to the database.

Then, run the script and expect two `tracks_{username},csv` and `streams_{username}.csv` files in earlier created `processed-data` directory.

The data is clean and ready to go.

Lastly, you need to create `PostgreSQL` database. In order to finish the setup, run [`init.sql`](./init.sql) file. Tables described in previous section will be created.
[`import-user-streams.sql`](./import-user-streams.sql) file contains function definition which allows easy inserting new users' data to the database. File [`load-users.sql`](./load-users.sql) demonstrates example: inserting two users and creates views for each user that makes querying much easier. You can find example queries in [`queries.sql`](./queries.sql) file.


## Detailed Description of Each File

- [`process.py`](./process.py) - transforms raw `.json` file obtained from spotify into db-readable `.csv` files.

- [`init.sql`](./init.sql) - creates database schema.

- [`import-user-streams.sql`](./import-user-streams.sql) - function to easen inserting new data to the database. It takes 3 arguments:
    - *username* **TEXT** - username
    - *track_path* **TEXT** - path to `tracks.csv` file.
    - *streams_path* **TEXT** - path to `streams.csv` file.
and returns void.

- [`load-users.sql`](./load-users.sql) - a practical example script that executes the function defined above. Moreover it creates two Views (JOINS of two tables) for each inserted user.

- [`format-seconds.sql`](./format_seconds.sql) - function that converts raw time in seconds to pretty `HHhMMmSSs` text. It is helpful in queries that manipulates with songs duration or stream time_played. It takes one argument:
    - *seconds* **NUMERIC** - time in seconds
    and returns time in aforementioned TEXT format.

- [`queries.sql`](./queries.sql) - Example, fun queries for the database.

- [`playground.sql`](./playground.sql) - Just me toying around.

## Potential Problems With Data

1. The raw data export (obtained from Spotify) occasionally contains multiple records with the exact same **timestamps** (an anomaly on Spotify's end). The processing script handles it by keeping only the first occurence and dropping the duplicates. Therefore, be aware of minor loss of data.
<br></br>
1. The exact **duration** of each song is not explictely provided in Spotify's data, so it is impossible to scrape true song length with 100% certainty because there is no data describing whether a user did not "skip forward" or rewind the progress bar by a few seconds.
Therefore, I decided on following strategy:
```
For each unique track:
    - If the stream has flag "skipped" = True, do not use its "time_played" value.
    - If the stream flag "reason_end" has any other value than "trackdone" or
    "endplay", also skip this occurence.
    - Else, save "time_played" for this stream.

Finally, for each song, set "duration" as:
    - The median of "time_played" across all valid streams if 
    the song was played more than 2 times in the account history.
    - The maximum of "time_played" if it was played once or twice.
```

This strategy mostly proves successful (based on a few manual tests) - I think the avarage stream is when listening the song from start to the end, therefore median effectively filters any outliers, so it seemed just right.

Nevertheless there are scenarios in which the song duration will **not** be true.