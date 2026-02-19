# SPOTIFY-DB

## Table of contents
- [What is it](#what-is-it)
- [Database Structure](#database-structure)
- [How To Possess Your Streaming History](#how-to-possess-data)
- [Loading Data](#loading-data)
- [Detailed Description of Each File](#each-file)


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
In order to convert raw data into clean `.csv` files, unzip retrieved `.zip` file and put it in `./data/` directory relative to `process.py` file. Also, you need to create empty `./data/processed-data/` directory **inside** `./data`.
In 6th line of `process.py` file set your username. It is used to identify created `.csv` files during inserting data to the database.

Then, run the script and expect two `tracks_{username},csv` and `streams_{username}.csv` files in earlier created `processed-data` directory.

The data is clean and ready to go.

```
TODO:
how to input into database.
detailed descxription of each file
problems with spotify data - doubles and song duration.
```

