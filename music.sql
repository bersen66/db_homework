DROP TABLE IF EXISTS owners_to_playlists CASCADE;
DROP TABLE IF EXISTS playlists_content CASCADE;
DROP TABLE IF EXISTS playlists CASCADE;
DROP TABLE IF EXISTS singer_to_song CASCADE;
DROP TABLE IF EXISTS songs CASCADE;
DROP TABLE IF EXISTS albums CASCADE;
DROP DOMAIN IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS singers CASCADE;
--DROP TABLE IF EXISTS redactors;
DROP TABLE IF EXISTS users CASCADE;




CREATE TABLE albums
(
	album_id		serial NOT NULL	PRIMARY KEY,
	album_name		text NOT NULL DEFAULT 'untitled',
	release_date	date NOT NULL DEFAULT CURRENT_DATE
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
	song_name 			text NOT NULL DEFAULT 'untitled',
	number_of_auditions bigint NOT NULL DEFAULT 0 CHECK (number_of_auditions >= 0),
	song_genre			Genre,
	release_date		date NOT NULL DEFAULT CURRENT_DATE,
	album_id			int	REFERENCES albums(album_id)	DEFAULT NULL,
	position_in_album	int CHECK ( 
							(album_id IS NOT NULL AND position_in_album > 0) 
						 OR (album_id IS NULL AND position_in_album IS NULL)	
						)
);

------------------------------------------------------------------------
CREATE TABLE users 
(
	user_id serial NOT NULL PRIMARY KEY,
	username VARCHAR(30) NOT NULL DEFAULT 'username',
	date_of_birth date NOT NULL CHECK (date_part('year',age(date_of_birth)) >= 16)
);

CREATE TABLE singers
(
  singer_id serial NOT NULL PRIMARY KEY,		
  nickname VARCHAR(60) NOT NULL
) INHERITS (users);

-- CREATE TABLE redactors
-- (
--   redactor_id serial NOT NULL PRIMARY KEY,	
--   nickname VARCHAR(60) NOT NULL	
-- ) INHERITS (users);

--------------------------------------------------------------------------


CREATE TABLE singer_to_song 
(
	singer_id 	int REFERENCES singers(singer_id) NOT NULL,
	song_id 	int REFERENCES songs(song_id) NOT NULL
);

-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS playlists 
(
	playlist_id 	serial 		NOT NULL PRIMARY KEY,
	playlist_name 	varchar(30) NOT NULL DEFAULT 'UNTITLED' CHECK (playlist_name != '')
);

CREATE TABLE IF NOT EXISTS playlists_content 
(
	owner_id 	int REFERENCES users(user_id) NOT NULL,
	playlist_id int REFERENCES playlists(playlist_id) NOT NULL,
	song_id 	int REFERENCES songs(song_id) DEFAULT NULL -- Реализация пустых плейлистов
);



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
	('playlist_1');

INSERT INTO singers (username, date_of_birth, nickname)
VALUES
	('Serj', '2000-01-01', 'System of a down'),
	('John', '2000-01-01', 'Twenty one pilots'),
	('Bob',  '1945-02-06', 'Bob Marley')
;



-- INSERT INTO redactors(username, date_of_birth, nickname) VALUES
-- 	('Anton', '1967-03-25', 'GURU'),
-- 	('Bill', '1988-06-15', 'OG')
-- ;

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
	('Bob Marley Legacy: Punky Reggae Party')
;

INSERT INTO songs (song_name, album_id, position_in_album, number_of_auditions, song_genre) 
VALUES
	('Sun is Shining', 1, 3, 231, 'reggae'),
	('Smells like a teen spirit', 1, 4, 321, 'rock')
;



INSERT INTO songs (song_name, album_id, position_in_album, number_of_auditions, song_genre) 
VALUES
	('Prison Song', 		2,	 	1,		 1000, 		'heavy metal'),
	('Needles',				2,	 	2,		 1000, 		'heavy metal'),
	('Deer Dance',			2,	 	3,		 1000, 		'heavy metal'),
	('Jet Pilot',			2,	 	4,		 1000, 		'heavy metal'),
	('X', 					2,	 	5,		 1000, 		'heavy metal'),
	('Chop Suey!',			2,	 	6,		 1000, 		'heavy metal'),
	('Bounce',				2,	 	7,		 1000, 		'heavy metal'),
	('Forest',				2,	 	8,		 1000, 		'heavy metal'),
	('ATWA', 				2, 	 	9, 	 	 1000, 		'heavy metal'),
	('Science', 			2,	 	10,	 	 1000, 		'heavy metal'),
	('Shimmy',				2,	 	11,	 	 1000, 		'heavy metal'),
	('Toxicity',			2,	 	12,	 	 1000, 		'heavy metal'),
	('Psycho',				2,	 	13,	 	 1000, 		'heavy metal'),
	('Aerials', 			2, 	 	14, 	 1000, 		'heavy metal'),
	('Arto', 				2, 	 	15, 	 1000, 		'heavy metal'),
	('Protect the land',	NULL, 	NULL,    1012321, 	'heavy metal'),
	
	('Punky Reggae Party',  	4,      1,       500,        'reggae'),
	('Could You Be Loved ',  	4,      2,       321,        'reggae'),	
	('Get Up, Stand Up',  		4,      3,       32132,      'reggae'),
	('Concrete Jungle',  		4,      4,       456654,     'reggae'),	
	('Stop That Train',  		4,      5,       134245,     'reggae')

;




-- Все песни из предыдущего INSERT-a исполнили System of a down
INSERT INTO singer_to_song 
VALUES
	(1, 6),
	(1, 7),
	(1, 8),
	(1, 9),
	(1, 10),
	(1, 11),
	(1, 12),
	(1, 13),
	(1, 14),
	(1, 15),
	(1, 16),
	(1, 17),
	(1, 18),
	(1, 19),
	(1, 20),
	(1, 21),
	
	(3, 22),
	(3, 23),
	(3, 24),
	(3, 25),
	(3, 26)
;	



INSERT INTO playlists_content (owner_id, playlist_id, song_id) 
VALUES 
	(1, 1, 1),
	(1, 1, 3),
	(1, 1, 3),
	(1, 1, 4),
	(2, 2, 1)
;


-- Вывод содержимого плейлистов
-- WITH added_owners_info AS (
-- 	SELECT * FROM playlists_content LEFT JOIN users ON users.user_id=playlists_content.owner_id
-- ), added_songs_info AS (
-- 	SELECT * FROM added_owners_info LEFT JOIN songs ON added_owners_info.song_id=songs.song_id
-- ), extended_playlists_content AS (
-- 	SELECT * FROM added_songs_info LEFT JOIN playlists ON added_songs_info.playlist_id=playlists.playlist_id
-- )
-- SELECT username, playlist_name, song_name FROM extended_playlists_content;



-- INSERT INTO playlists_content (owner_id, playlist_id, song_id) VALUES
-- 	(1, )
-- ;

-- Построить более содержательную вспомогательную таблицу, 
-- по singer_to_song
-- WITH singers_resolved AS (
-- 	SELECT * 
-- 	FROM singer_to_song 
-- 	LEFT JOIN singers 
-- 	ON singer_to_song.singer_id=singers.singer_id
-- ), singers_and_songs_info AS (
-- 	SELECT *
-- 	FROM singers_resolved LEFT JOIN songs
-- 	ON singers_resolved.song_id=songs.song_id
-- ), with_albums_info AS ( -- присоединить инфу об альбомах. Можно выкинуть лишнюю таблицу
-- 	SELECT *
-- 	FROM singers_and_songs_info LEFT JOIN albums
-- 	ON singers_and_songs_info.album_id=albums.album_id
-- )
-- SELECT nickname, song_name, album_name FROM with_albums_info;



-- Посчитать количество прослушиваний альбома Toxicity
-- WITH singers_resolved AS (
-- 	SELECT * 
-- 	FROM singer_to_song 
-- 	LEFT JOIN singers 
-- 	ON singer_to_song.singer_id=singers.singer_id
-- ), singers_and_songs_info AS (
-- 	SELECT *
-- 	FROM singers_resolved LEFT JOIN songs
-- 	ON singers_resolved.song_id=songs.song_id
-- ), with_albums_info AS ( -- присоединить инфу об альбомах. Можно выкинуть лишнюю таблицу
-- 	SELECT *
-- 	FROM singers_and_songs_info LEFT JOIN albums
-- 	ON singers_and_songs_info.album_id=albums.album_id
-- )
-- SELECT SUM(number_of_auditions) AS total_auditions
-- FROM with_albums_info
-- WHERE album_name='Toxicity'
-- GROUP BY album_name;


-- Попытка в JOIN
-- SELECT songs.song_name, albums.album_name, songs.song_genre
-- FROM songs 
-- LEFT JOIN albums ON songs.album_id = albums.album_id;




-- Вывести альбом
-- SELECT albums_info.position_in_album, albums_info.song_name 
-- FROM 
-- 	(SELECT * FROM songs RIGHT JOIN albums ON songs.album_id = albums.album_id) albums_info
-- WHERE 
-- 	albums_info.album_name='Nevermind'
-- ORDER BY albums_info.position_in_album;


-- Количество прослушиваний альбома
-- SELECT SUM(number_of_auditions)
-- FROM 
-- 	(SELECT * FROM songs RIGHT JOIN albums ON songs.album_id = albums.album_id) albums_info
-- WHERE 
-- 	albums_info.album_name='Nevermind'


-- SELECT * FROM users;
-- SELECT * FROM singers;
-- SELECT * FROM redactors;
-- SELECT * FROM songs;

