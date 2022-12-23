DROP TABLE IF EXISTS measurements CASCADE;
DROP TABLE IF EXISTS playlists_content CASCADE;
DROP TABLE IF EXISTS playlists CASCADE;
DROP TABLE IF EXISTS songs_info CASCADE;
DROP TABLE IF EXISTS songs CASCADE;
DROP TABLE IF EXISTS albums CASCADE;
DROP DOMAIN IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS singers CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS users_changelog CASCADE;
DROP TABLE IF EXISTS songs_changelog CASCADE;


CREATE TABLE albums
(
	album_id		serial NOT NULL	PRIMARY KEY,
	album_name		varchar(64) NOT NULL,
	release_date	date NOT NULL DEFAULT CURRENT_DATE,
	image_url		text
);


CREATE DOMAIN Genre 
AS VARCHAR(32)
NOT NULL
CHECK (
	VALUE IN (
		  'rock'
		, 'heavy metal'
		, 'ska'
		, 'classic'
		, 'reggae'
	) 
);




CREATE TABLE IF NOT EXISTS songs
(
	song_id 			serial NOT NULL PRIMARY KEY,
	song_name 			varchar(32) NOT NULL DEFAULT 'untitled',
	song_genre			Genre NOT NULL,
	release_date		date NOT NULL DEFAULT CURRENT_DATE,
	audio_url 			varchar(60), -- на самом деле NOT NULL,
	image_url			varchar(60) -- на самом деле NOT NULL
	
);

------------------------------------------------------------------------
CREATE TABLE users 
(
	user_id serial NOT NULL PRIMARY KEY,
	username VARCHAR(32) NOT NULL DEFAULT 'username', 
	date_of_birth date NOT NULL CHECK (date_part('year',age(date_of_birth)) >= 16), 
	avatar_url	  varchar(60) -- 60
);



CREATE TABLE singers
(
  singer_id serial NOT NULL PRIMARY KEY,		
  nickname VARCHAR(64) NOT NULL		
) INHERITS (users);

--------------------------------------------------------------------------


CREATE TABLE songs_info
(
	singer_id 			int REFERENCES singers(singer_id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	song_id 			int REFERENCES songs(song_id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	album_id			int	REFERENCES albums(album_id)	ON DELETE CASCADE ON UPDATE CASCADE DEFAULT NULL,
	position_in_album	int CHECK ( 
							(album_id IS NOT NULL AND position_in_album > 0) 
						 OR (album_id IS NULL AND position_in_album IS NULL)	
						)	
);

-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS playlists 
(
	playlist_id 	serial 		NOT NULL PRIMARY KEY,
	playlist_name 	varchar(32) NOT NULL DEFAULT 'UNTITLED' CHECK (playlist_name != ''),
	image_url		text
	
);

CREATE TABLE IF NOT EXISTS playlists_content 
(
	owner_id 			int REFERENCES users(user_id) 		  ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	playlist_id 		int REFERENCES playlists(playlist_id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	song_id 			int REFERENCES songs(song_id)		  ON DELETE CASCADE ON UPDATE CASCADE DEFAULT NULL, -- Реализация пустых плейлистов
	number_of_auditions bigint NOT NULL DEFAULT 0 CHECK (number_of_auditions >= 0)
);


--------------------------------------------------------------------------



CREATE TABLE IF NOT EXISTS measurements 
(
	user_id 		int REFERENCES users(user_id) ON DELETE CASCADE, 
	song_id			int	REFERENCES songs(song_id) ON DELETE CASCADE, 
	logdate 		date NOT NULL DEFAULT CURRENT_DATE,
	geolocation		point	-- {latitude, longitude}
) PARTITION BY RANGE(logdate);



-- Секции таблицы measurements с инфой об активности пользователей
-- Каждая секция хранит инфу за месяц
CREATE TABLE measurements_y2022m10 PARTITION OF measurements
FOR VALUES FROM ('2022-10-01') TO ('2022-11-01');
 
CREATE TABLE measurements_y2022m11 PARTITION OF measurements
FOR VALUES FROM ('2022-11-01') TO ('2022-12-01');

 
--------------------------------------------------------------------------
INSERT INTO users (username, date_of_birth) 
VALUES 
	('ortr', date('2001-12-09')),
	('og2', date('2000-02-19')),
	('curry', date('2001-05-16')),
	('peppe', date('1999-03-11'))
;
	
INSERT INTO playlists(playlist_name) 
VALUES
	('mY_co0L_pL@ylist'),
	('AwesomeMusic'),
	('playlist_1')
;

INSERT INTO singers (username, date_of_birth, nickname)
VALUES
	('Serj', '2000-01-01', 'System of a down'),
	('John', '2000-01-01', 'Twenty one pilots'),
	('Bob',  '1945-02-06', 'Bob Marley')
;

INSERT INTO songs (song_name, song_genre)
VALUES
	('Smells like teen spirit', 'rock'),
	('Stairway to heaven', 'rock'),
	('Rape me', 'rock')
;

INSERT INTO albums (album_name)
VALUES 
	('Nevermind'),
	('Toxicity'),
	('Trench'),
	('Bob Marley Legacy: Punky Reggae Party'),
	('BestOf:System of a Down')
;


INSERT INTO songs (song_name, song_genre) 
VALUES
	('Sun is Shining', 'reggae'),
	('Smells like a teen spirit', 'rock'),

	('Prison Song', 	 'heavy metal'),
	('Needles',			 'heavy metal'),
	('Deer Dance',		 'heavy metal'),
	('Jet Pilot',		 'heavy metal'),
	('X', 				 'heavy metal'),
	('Chop Suey!',		 'heavy metal'),
	('Bounce',			 'heavy metal'),
	('Forest',			 'heavy metal'),
	('ATWA', 			 'heavy metal'),
	('Science', 		 'heavy metal'),
	('Shimmy',			 'heavy metal'),
	('Toxicity',		 'heavy metal'),
	('Psycho',			 'heavy metal'),
	('Aerials', 		 'heavy metal'),
	('Arto', 			 'heavy metal'),
	('Protect the land', 'heavy metal'),
	
	('Punky Reggae Party',  'reggae'),
	('Could You Be Loved ', 'reggae'),	
	('Get Up, Stand Up',  	'reggae'),
	('Concrete Jungle',  	'reggae'),	
	('Stop That Train',  	'reggae')

;




-- Заполнить табличку c инфой о песнях
INSERT INTO songs_info (singer_id, song_id, album_id, position_in_album)
VALUES
	(1, 6,  2, 1),
	(1, 7,  2, 2),
	(1, 8,  2, 3),
	(1, 9,  2, 4),
	(1, 10, 2, 5),
	(1, 11, 2, 6),
	(1, 12, 2, 7),
	(1, 13, 2, 8),
	(1, 14, 2, 9),
	(1, 15, 2, 10),
	(1, 16, 2, 11),
	(1, 17, 2, 12),
	(1, 18, 2, 13),
	(1, 19, 2, 14),
	(1, 20, 2, 15),

	(1, 1, NULL, NULL),
	
	(3, 22, 4, 1),
	(3, 23, 4, 2),
	(3, 24, 4, 3),
	(3, 25, 4, 4),
	(3, 26, 4, 5)

;	



INSERT INTO playlists_content (owner_id, playlist_id, song_id, number_of_auditions) 
VALUES 
	(1, 1, 10, 32),
	(1, 1, 13, 45),
	(1, 1, 12, 535),
	(1, 1, 4, 34),
	(2, 2, 1, 231)
;



INSERT INTO  measurements(user_id, song_id, logdate)
VALUES
	(1, 12, date('2022-11-1')),
	(2, 12, date('2022-11-1')),
	(3, 12, date('2022-11-1')),
	(1, 12, date('2022-11-1')),
	(1, 12, date('2022-11-1')),
	(1, 12, date('2022-11-1')),
	(2, 1, 	date('2022-11-1')),
	(2, 1, 	date('2022-11-1')),
	(2, 13, date('2022-11-1'))
;



DROP FUNCTION IF EXISTS AssembleSongsInfo;
CREATE OR REPLACE FUNCTION AssembleSongsInfo()
returns
table (
	singer_id		INTEGER,
	song_id			INTEGER,
	album_id		INTEGER,
	nickname		VARCHAR,
	song_name		VARCHAR,
	song_genre		VARCHAR,
	album_name		VARCHAR
) AS $$
	WITH merged AS (
		SELECT * 
		FROM songs_info 
			LEFT JOIN songs using(song_id) 
			LEFT JOIN singers using(singer_id) 
			LEFT JOIN albums using(album_id)
	) SELECT 
		singer_id,
		song_id,
		album_id,
		nickname,
		song_name,	
		song_genre,	
		album_name
	FROM merged;
$$
LANGUAGE SQL;



DROP FUNCTION IF EXISTS AssemblePlaylistContent;
CREATE FUNCTION AssemblePlaylistContent(id INTEGER) 
RETURNS TABLE (
	playlist_id int,
	song_id int,
	user_id int,
	username varchar,
	song_name varchar
)
AS 
$$
	WITH merged AS (
		SELECT * 
		FROM playlists_content 
			LEFT JOIN users ON playlists_content.owner_id = users.user_id 
			LEFT JOIN songs using(song_id)
			LEFT JOIN playlists USING (playlist_id)
		WHERE playlist_id = id
	)
	SELECT 	
		playlist_id, song_id, user_id, username, song_name
	FROM merged;
$$ 
LANGUAGE SQL;









CREATE OR REPLACE PROCEDURE DeleteSingerSongs(id integer)
AS $$

	with merged AS (
		SELECT * FROM songs_info WHERE songs_info.singer_id=id
 	)
	DELETE FROM songs 
	WHERE songs.song_id IN (SELECT merged.song_id FROM merged);


	WITH merged AS (
		SELECT * FROM songs_info WHERE songs_info.singer_id=id
	) DELETE FROM albums
	WHERE albums.album_id IN (SELECT album_id FROM merged);
	
	DELETE FROM singers WHERE singers.singer_id=id;

$$ LANGUAGE SQL;



CREATE OR REPLACE PROCEDURE DeleteUser(id INT) 
AS $$

	DECLARE 
		entry singers%ROWTYPE;
	BEGIN
		FOR entry IN SELECT * FROM singers WHERE singers.user_id=id
		LOOP
			CALL DeleteSingerSongs(entry.singer_id);
		END LOOP;
	
		DELETE FROM users WHERE users.user_id=id;
	END;

-- 	DECLARE curs CURSOR FOR
-- 			SELECT * FROM singers 
-- 			WHERE singers.user_id=id;
-- 		entry singers%ROWTYPE;
-- 	BEGIN 
-- 		OPEN curs;
-- 		LOOP
-- 			FETCH curs INTO entry;
-- 			EXIT WHEN NOT FOUND;
-- 			CALL DeleteSingerSongs(entry.singer_id);
-- 		END LOOP;
-- 		CLOSE curs;
-- 		DELETE FROM users WHERE users.user_id=id;
-- 	END;
	
$$
LANGUAGE PLPGSQL;


-- CALL DeleteUser(5);
-- SELECT * FROM SONGS;


-- CREATE OR REPLACE FUNCTION process_songs_info_audit()
-- RETURNS TRIGGER
-- AS $$

-- $$
-- LANGUAGE PLPGSQL;

-- CREATE OR REPLACE TRIGGER log_update
-- 	BEFORE UPDATE ON songs_info
-- 	EXECUTE FUNCTION process_songs_info_audit();



CREATE TABLE users_changelog(
	entry_id serial PRIMARY KEY,
	user_id int REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
	logdate date DEFAULT CURRENT_DATE,
	old_name text NOT NULL,
	new_name text NOT NULL
);


CREATE OR REPLACE FUNCTION log_users_update_tg()
RETURNS TRIGGER
AS
$$ 
BEGIN
	INSERT INTO users_changelog(user_id, old_name, new_name) VALUES (NEW.user_id, OLD.username, NEW.username);
	SELECT * FROM users_changelog;
END;
$$
LANGUAGE PLPGSQL;


CREATE TRIGGER log_update
    AFTER UPDATE ON users
    FOR EACH ROW
    WHEN (OLD.username IS DISTINCT FROM NEW.username)
    EXECUTE FUNCTION log_users_update_tg();


CREATE TABLE songs_changelog(
	entry_id serial PRIMARY KEY,
	song_id int REFERENCES songs(song_id) ON DELETE CASCADE ON UPDATE CASCADE,
	logdate date DEFAULT CURRENT_DATE,
	old_songname text NOT NULL,
	new_songname text NOT NULL
);


CREATE OR REPLACE FUNCTION log_songs_update_tg()
RETURNS TRIGGER
AS
$$ 
BEGIN
	INSERT INTO songs_changelog(song_id, old_songname, new_songname) VALUES (NEW.song_id, OLD.song_name, NEW.song_name);
	SELECT * FROM songs_changelog;
END;
$$
LANGUAGE PLPGSQL;


CREATE TRIGGER log_songs_update
    AFTER UPDATE ON songs
    FOR EACH ROW
    WHEN (OLD.song_name IS DISTINCT FROM NEW.song_name)
    EXECUTE FUNCTION  log_songs_update_tg();
	
	
	
	
	
	








CREATE OR REPLACE FUNCTION DeleteUserTGG() 
RETURNS TRIGGER
AS $$
BEGIN
-- 	DECLARE 
-- 		entry singers%ROWTYPE;
-- 	BEGIN
-- 		FOR entry IN SELECT * FROM singers WHERE singers.user_id=OLD.user_id
-- 		LOOP
-- 			CALL DeleteSingerSongs(OLD.user_id);
-- 		END LOOP;
-- 	END;
	CALL DeleteUser(OLD.user_id);
	RETURN NULL;
END;
$$
LANGUAGE PLPGSQL;


	
CREATE  OR REPLACE TRIGGER delete_user
	BEFORE DELETE ON users
	EXECUTE FUNCTION DeleteUserTGG();




DELETE FROM users WHERE users.user_id=5;
-- call DeleteUser(5);
SELECT * FROM songs;






-- WITH DECART AS (SELECT * FROM  songs_info CROSS JOIN songs)
-- SELECT * FROM DECART WHERE song_id  NOT IN (
-- 	SELECT song_id FROM songs_info LEFT JOIN songs USING(song_id)
-- );



-- WITH merged AS (
-- SELECT * FROM AssembleSongsInfo()
-- ) 


-- SELECT * FROM merged CROSS JOIN playlists_content 
-- WHERE merged.song_id NOT IN (
-- 	SELECT song_id FROM playlists_content
-- );

-- SELECT * FROM songs_info INNER JOIN songs USING(song_id);



-- SELECT * FROM songs_info LEFT JOIN songs USING(song_id);


















