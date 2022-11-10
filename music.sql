DROP TABLE IF EXISTS measurements CASCADE;
DROP TABLE IF EXISTS playlists_content CASCADE;
DROP TABLE IF EXISTS playlists CASCADE;
DROP TABLE IF EXISTS songs_info CASCADE;
DROP TABLE IF EXISTS songs CASCADE;
DROP TABLE IF EXISTS albums CASCADE;
DROP DOMAIN IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS singers CASCADE;
DROP TABLE IF EXISTS users CASCADE;



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
	singer_id 			int REFERENCES singers(singer_id) NOT NULL,
	song_id 			int REFERENCES songs(song_id) NOT NULL,
	album_id			int	REFERENCES albums(album_id)	DEFAULT NULL,
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
	owner_id 			int REFERENCES users(user_id) NOT NULL,
	playlist_id 		int REFERENCES playlists(playlist_id) NOT NULL,
	song_id 			int REFERENCES songs(song_id) DEFAULT NULL, -- Реализация пустых плейлистов
	number_of_auditions bigint NOT NULL DEFAULT 0 CHECK (number_of_auditions >= 0)
);


--------------------------------------------------------------------------



CREATE TABLE IF NOT EXISTS measurements 
(
	user_id 		int REFERENCES users(user_id) NOT NULL,
	song_id			int REFERENCES songs(song_id) NOT NULL,
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
	
	
	(1, 16, 5, 1),
	(1, 20, NULL, NULL),
	
	(3, 22, 4, 1),
	(3, 23, 4, 2),
	(3, 24, 4, 3),
	(3, 25, 4, 4),
	(3, 26, 4, 5),
	(3, 1, NULL, NULL)
;	



INSERT INTO playlists_content (owner_id, playlist_id, song_id, number_of_auditions) 
VALUES 
	(1, 1, 1, 32),
	(1, 1, 3, 45),
	(1, 1, 2, 535),
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

-- Самые популярные жанры пользователя
-- WITH users_activity AS (
-- 	SELECT user_id, songs.song_id, logdate, song_name, song_genre
-- 	FROM measurements_y2022m11 as m LEFT JOIN songs ON m.song_id=songs.song_id
-- )
-- SELECT COUNT(1) as audnum , SONG_GENRE
-- FROM users_activity
-- where user_id=2
-- GROUP BY song_genre
-- ORDER BY audnum DESC;



WITH users_activity AS (
	SELECT user_id, songs.song_id, logdate, song_name, song_genre
	FROM measurements_y2022m11 as m LEFT JOIN songs ON m.song_id=songs.song_id
)
SELECT COUNT(1) as audnum , song_name
FROM users_activity
GROUP BY song_name
ORDER BY audnum  DESC;



















