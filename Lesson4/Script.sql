USE vk;

SELECT * FROM users LIMIT 10;

UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at; 

DESC profiles;

SELECT * FROM profiles LIMIT 10;

DESC messages;

SELECT * FROM messages LIMIT 10;

SELECT COUNT(*) FROM users;

SELECT RAND() ; 

UPDATE messages SET
  from_user_id = FLOOR(1 + RAND() * 100), 
  to_user_id = FLOOR(1 + RAND() * 100);
  
 DESC media;
 
ALTER TABLE media CHANGE size file_size INT NOT NULL;

SELECT * FROM media LIMIT 10;

UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  

CREATE TEMPORARY TABLE exts (name VARCHAR(10));

SELECT * FROM exts;

UPDATE media SET filename = CONCAT('https://dropbox/vk/',
  filename,  
  (SELECT name FROM exts ORDER BY RAND() LIMIT 1)
);

DESC friendship;

SELECT * FROM friendship LIMIT 10;

UPDATE friendship SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);
 
SELECT * FROM friendship_statuses;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
 
UPDATE friendship SET
  status_id = FLOOR(1 + RAND() * 3); 

DESC communities;

SELECT * FROM communities;

TRUNCATE communities;

INSERT INTO `communities` (`id`, `name`) VALUES (1, 'alias');
INSERT INTO `communities` (`id`, `name`) VALUES (2, 'asperiores');
INSERT INTO `communities` (`id`, `name`) VALUES (3, 'at');
INSERT INTO `communities` (`id`, `name`) VALUES (4, 'autem');
INSERT INTO `communities` (`id`, `name`) VALUES (5, 'consectetur');
INSERT INTO `communities` (`id`, `name`) VALUES (6, 'debitis');
INSERT INTO `communities` (`id`, `name`) VALUES (7, 'dolor');
INSERT INTO `communities` (`id`, `name`) VALUES (8, 'dolore');
INSERT INTO `communities` (`id`, `name`) VALUES (9, 'dolorem');
INSERT INTO `communities` (`id`, `name`) VALUES (10, 'doloremque');
INSERT INTO `communities` (`id`, `name`) VALUES (11, 'dolores');
INSERT INTO `communities` (`id`, `name`) VALUES (12, 'ducimus');
INSERT INTO `communities` (`id`, `name`) VALUES (13, 'ea');
INSERT INTO `communities` (`id`, `name`) VALUES (14, 'eos');
INSERT INTO `communities` (`id`, `name`) VALUES (15, 'est');
INSERT INTO `communities` (`id`, `name`) VALUES (16, 'et');
INSERT INTO `communities` (`id`, `name`) VALUES (17, 'hic');
INSERT INTO `communities` (`id`, `name`) VALUES (18, 'in');
INSERT INTO `communities` (`id`, `name`) VALUES (19, 'ipsa');
INSERT INTO `communities` (`id`, `name`) VALUES (20, 'ipsam');


DELETE FROM communities WHERE id > 20;

SELECT * FROM communities_users;

DESC communities_users;

TRUNCATE communities_users 

UPDATE communities_users SET
  community_id = FLOOR(1 + RAND() * 20);

DESC messages;
ALTER TABLE messages MODIFY COLUMN communitie_id  INT UNSIGNED;

DESC messages;
ALTER TABLE messages MODIFY COLUMN to_user_id INT UNSIGNED;

DESC communities;
DESC communities_users;
SELECT * FROM communities_users LIMIT 10;
