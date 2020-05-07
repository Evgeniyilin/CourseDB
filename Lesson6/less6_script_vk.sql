-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение.
-- Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
-- 1. Создать все необходимые внешние ключи и диаграмму отношений.
-- 2. Создать и заполнить таблицы лайков и постов.
-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).


-- Задание 1 --------------------------------------------------
DESC communities_users;
   
ALTER TABLE communities_users 
  ADD CONSTRAINT communities_users_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id);
    
DESC posts;

ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id);
   
DESC media_types;

-- ------НАКОСЯЧИЛ---------

ALTER TABLE media 
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media(id); -- моя ошибка

ALTER TABLE media DROP FOREIGN KEY media_media_type_id_fk; -- несработало

ALTER TABLE media DROP COLUMN media_type_id; -- удалил столбец
ALTER TABLE media ADD COLUMN media_type_id INT UNSIGNED NOT NULL AFTER id; -- создал
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3); -- заполнил

SELECT * FROM media_types;
   
-- -------------------------   

-- --- ПОСЛЕ ИСПРАВЛЕНИЙ ПРОДОЛЖИЛ ---------- 

DESC media;

ALTER TABLE media 
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);
 
DESC likes;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_target_type_id_fk 
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);

DESC target_types;

DESC friendship;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

DESC friendship_statuses;

-- Задание 2 --------------------------------------------------

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

SELECT * FROM likes;

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `posts` VALUES ('1','29','2','accusamus','Quis quis qui et tenetur perferendis voluptate consequatur. Officiis tempora itaque perferendis voluptatem. Officiis dolores sunt sit assumenda sit dolores quis fugiat.','26','1975-12-16 09:49:34','2003-01-24 13:14:08'),
('2','92','14','est','A doloribus velit quasi omnis unde itaque. Expedita id quia ipsa molestiae. Et non minus cum ea autem sed. Necessitatibus illum rerum ea in illo.','88','1999-10-06 11:45:58','1982-02-24 06:18:09'),
('3','43','11','velit','Earum velit aut voluptate voluptas enim laudantium voluptates. Minus est quae ea ullam. Id ea aut qui soluta esse ratione et. Sit nobis sit quaerat.','68','2012-11-20 05:00:14','2002-08-31 10:16:52'),
('4','75','17','omnis','Perferendis nam quis earum sed rerum deleniti id. Optio perspiciatis ea atque voluptatibus enim non. Consequuntur odio et et iste explicabo eaque. Suscipit voluptas ut non.','68','2017-03-19 01:32:28','1986-04-29 07:13:50'),
('5','58','8','illo','Ducimus mollitia eum quia qui ipsum. Totam reiciendis nihil odio deleniti. Amet sint ab voluptatem voluptas harum ea rerum.','16','2004-07-01 08:51:34','2003-03-27 18:23:09'),
('6','81','4','quos','Necessitatibus qui nulla inventore qui alias. Quidem enim ipsam dolor velit ipsam veniam impedit. Voluptatibus pariatur voluptatibus dicta minus qui. Est omnis voluptatibus minima numquam dicta sequi reiciendis et. Omnis dignissimos eius impedit corrupti aut modi.','66','2011-10-17 19:03:24','1978-08-30 14:01:03'),
('7','23','16','accusamus','Natus inventore optio est facilis aliquam et. Eius rem quidem sed. Atque iure et autem.','98','2016-01-06 13:16:00','1978-08-02 15:51:05'),
('8','40','19','molestiae','Beatae autem nam laboriosam. Dolores possimus consequatur rerum rerum doloribus. Dolorum facere culpa aut.','40','1973-12-04 10:21:29','1996-11-14 05:10:34'),
('9','88','17','est','Quasi molestiae voluptate velit sequi. Aliquid non voluptas perspiciatis molestiae blanditiis id. Delectus inventore est nam sit veritatis reiciendis est. Excepturi voluptate aperiam porro recusandae voluptates dolorem et.','47','2018-02-10 14:06:33','1977-09-05 04:26:58'),
('10','96','2','atque','Quia culpa perferendis id quia dolor voluptas. Ratione veniam quas sapiente est eum. Fuga neque laboriosam voluptate voluptatem debitis necessitatibus.','77','2014-12-21 14:29:22','2007-06-11 10:13:12'),
('11','81','7','voluptatibus','Dolor distinctio aliquam laudantium atque. Qui beatae non doloribus. Maxime ut voluptates cupiditate autem placeat. Alias rerum vel voluptatum odit vitae. Dicta doloremque et nobis veritatis.','82','2002-12-15 08:15:41','1974-10-09 19:41:15'),
('12','7','6','expedita','Consequatur quam est itaque est blanditiis. Error quibusdam earum dolore sapiente eum. Qui et fugit occaecati voluptatum aut voluptates est. Incidunt quia minus laudantium quaerat nulla ad accusamus harum.','51','2010-08-06 15:15:48','1999-12-21 06:55:05'),
('13','94','14','libero','Aut suscipit debitis sit aut iusto aut. Ut dicta optio quia similique quod voluptatibus error. Qui commodi perspiciatis quisquam voluptas exercitationem dolorem minus. Ut est reprehenderit et doloribus voluptate.','1','2005-10-14 00:19:10','1975-01-21 18:38:06'),
('14','62','9','aspernatur','Maiores rem id et ratione. Delectus ut sunt voluptas dolore numquam. Est quos velit accusamus placeat.','85','2011-05-01 04:38:37','2018-09-17 21:12:08'),
('15','30','1','veniam','Omnis voluptatem nisi numquam quibusdam. Rem perspiciatis architecto eos ipsum earum minima. Dolores ad placeat in quisquam consectetur. Modi aut velit ad est molestiae mollitia tempora magni.','21','1980-05-03 04:34:30','1995-09-13 02:45:03'),
('16','45','17','mollitia','Laudantium et omnis eligendi odit aut rerum est ut. Fugiat accusantium aut molestiae eligendi possimus quia. Tenetur enim nulla a nobis possimus omnis enim. Consequatur ullam asperiores consequatur molestiae.','37','2007-11-26 18:52:34','1999-05-28 11:20:11'),
('17','11','1','quidem','Porro dolorem officia quibusdam tempore illo deserunt tempore. Consequatur eligendi deserunt odit deserunt suscipit recusandae. Est omnis sit in. Nihil ipsa quis odit.','12','1997-02-11 09:05:22','2000-12-28 06:05:14'),
('18','9','9','nostrum','Dolor aut sed minus aliquam ex voluptatem non. Optio impedit nostrum omnis sed. Blanditiis minus officiis vel animi officiis sunt. Eveniet aperiam nihil cumque nemo qui reiciendis nulla.','3','1981-11-26 17:59:39','1992-08-14 09:17:30'),
('19','48','7','numquam','Facere ut assumenda doloribus consequatur molestias et. Excepturi quis dolores aut quia. Qui fuga saepe voluptas ad eveniet necessitatibus. Sed praesentium enim dolores fugiat.','88','1987-08-19 11:16:46','2018-04-05 01:19:06'),
('20','95','6','quisquam','Aspernatur magnam id sequi. Illo dignissimos sit at quidem at. Quidem in quia porro similique eius voluptas.','94','1975-08-06 12:49:24','1989-10-01 04:48:44'),
('21','72','2','et','Ratione nulla nihil sit itaque consequatur et. Quo illum quaerat repudiandae vel molestias culpa non doloribus. Minima qui eligendi ipsum ipsa eos.','29','2006-12-21 06:08:03','2001-01-19 10:28:29'),
('22','53','3','magni','Maxime hic minus illum itaque vel labore. Doloribus soluta recusandae consequatur. Accusamus sapiente qui et modi placeat nulla amet.','56','1998-07-13 20:04:45','2002-07-23 08:30:24'),
('23','4','2','repudiandae','Libero beatae optio possimus. Dolorum est excepturi a provident dolorem consequuntur nesciunt sunt. Aut necessitatibus a facilis dolores.','24','2012-02-25 21:57:15','2003-03-22 03:39:59'),
('24','4','14','omnis','Modi cumque et vitae architecto voluptate voluptas a. Perspiciatis rerum dolores laudantium aut ut. Autem sunt cum aliquam tenetur officia ut. Voluptatem et atque aut laboriosam fugit.','67','1974-10-02 15:51:08','2015-09-29 02:53:41'),
('25','89','20','aut','Aliquam vitae dolores ex ipsum. Voluptas est nihil repellat omnis at deserunt. Vel sunt at est impedit.','68','1971-07-01 18:02:34','2003-11-06 15:53:48'),
('26','10','9','voluptas','Perferendis enim vero quia omnis inventore ab id. Rem autem et quo sit vel aut cumque modi. Nisi ipsum sed ratione et autem non iusto provident. Vitae vitae maxime vero perspiciatis nesciunt.','49','2020-01-02 02:45:45','1989-11-13 17:55:17'),
('27','46','11','rem','Sint rerum ad voluptatem sed. Odio est sint ut distinctio. Atque a aperiam quis magni exercitationem maiores. Voluptate voluptatem est consequatur quia beatae.','52','1983-05-25 12:46:28','2010-07-08 10:55:26'),
('28','58','13','explicabo','Sunt voluptas voluptates consectetur reiciendis dolores. Ab adipisci iste reiciendis deserunt. Quo maiores quia enim possimus.','95','2012-08-17 02:59:17','1988-07-01 19:16:31'),
('29','60','2','distinctio','Autem nobis temporibus dolores unde accusamus. Reprehenderit ipsa deleniti dolorem iste cupiditate voluptate. Aspernatur non id optio vero corrupti.','25','1975-03-09 07:22:06','1978-05-30 04:46:54'),
('30','47','1','et','Aut aut dolores dolores est nisi. Beatae porro beatae dolor. Sed quo ut quidem molestiae omnis et et iure. Animi aliquid cumque dolore suscipit quod repudiandae. Sit ratione nulla est aspernatur vel nobis sunt.','51','1996-07-19 00:56:47','1999-02-06 10:14:17'),
('31','41','16','non','Eveniet quia ipsum est occaecati. Sed enim officiis eius nemo modi animi dolore. In qui dolores tempora minima. Et eveniet eos vitae.','57','1981-05-01 00:05:55','1991-12-09 01:53:18'),
('32','70','6','reprehenderit','Dolorem dolores blanditiis occaecati adipisci. Eligendi vitae nihil occaecati quo rerum dolorum. Non non ad eaque vel sed.','70','1992-06-09 23:07:01','1997-07-29 03:50:13'),
('33','25','7','fuga','Aut voluptas eligendi enim voluptatem cum vero occaecati laborum. Quam molestiae beatae facere optio. Nulla assumenda est magni hic dolorum atque recusandae debitis.','77','2010-07-15 05:50:20','2012-05-07 07:28:20'),
('34','49','8','ea','Qui a rerum earum quisquam. Nobis repellat voluptatibus facere aut natus. Nostrum ea aliquid ipsa velit eos enim. Voluptates enim tempore iusto optio maiores.','46','1995-10-01 11:20:32','1987-10-22 06:29:00'),
('35','16','5','nemo','Nemo fugit enim necessitatibus exercitationem aut et. Molestiae alias esse aut laudantium non quo nemo. Et ut quas qui recusandae magnam a soluta. Quidem enim aut blanditiis aut.','44','1993-10-18 23:39:36','2000-11-02 16:09:26'),
('36','83','7','et','Culpa ut officia cupiditate. Odio sapiente ut autem qui autem consequatur amet. Eos totam architecto qui ea officia error numquam. Et doloribus quod fuga nam quia.','87','1970-07-06 16:08:34','2004-11-20 17:36:21'),
('37','31','16','aspernatur','Velit sint facilis et labore suscipit quas. Dolor nostrum dicta ut necessitatibus aliquam ut ad. Exercitationem autem cum ut maxime. Ab ipsa quis aut ab perspiciatis ut voluptatem.','41','2014-04-12 01:55:38','1985-09-15 19:51:40'),
('38','83','8','aperiam','Saepe omnis error qui incidunt minus. Autem et culpa nostrum quis. Hic et harum facere corrupti qui dolor amet est. Suscipit sint pariatur perspiciatis deserunt fugiat ut blanditiis laudantium.','3','1985-04-09 05:56:49','2015-03-23 14:30:27'),
('39','78','20','aut','Omnis quibusdam architecto labore aut placeat sint. Et porro repellendus quo consequatur. Sint voluptatum accusantium nostrum et laudantium est aliquam.','13','1987-05-08 14:35:10','2007-08-04 07:01:36'),
('40','2','9','aut','Soluta fugit facilis officia cum. Fugit assumenda dolores ut quis optio nostrum officiis. Natus officiis nemo consectetur consequatur ut. Nulla rerum consequatur expedita.','17','1999-05-09 21:11:11','1987-03-28 07:14:02'),
('41','53','17','atque','Aspernatur sunt et placeat. Aut tenetur qui doloribus aliquam ipsam aut facere est. Odit voluptas omnis exercitationem perferendis repellat a veniam.','93','1984-12-01 00:42:08','1981-11-13 16:06:20'),
('42','9','11','minima','Aliquid ullam nobis non minima. Quibusdam atque voluptatem minima quisquam est. Eos aut doloribus soluta officia doloremque.','21','2014-05-23 03:35:42','2009-04-01 03:38:10'),
('43','79','16','fuga','Qui doloribus exercitationem qui consequuntur. Nemo accusamus eum consectetur nihil voluptatem non eum. Minus error quae praesentium deleniti aut rerum.','53','1985-10-05 11:58:48','2011-05-07 19:46:38'),
('44','56','6','corrupti','Rerum aspernatur atque deserunt culpa aut ut voluptatem. Dolorem non non vero unde provident dolorem. Sunt consectetur alias in. Distinctio cupiditate dignissimos magnam corporis.','89','1976-05-30 13:28:32','2009-02-23 00:16:27'),
('45','2','9','ut','Et ut voluptas suscipit. Et amet sunt cupiditate placeat quidem harum. Voluptas ut qui nesciunt tempora et inventore in.','13','2006-04-19 16:56:03','2012-12-27 13:04:45'),
('46','45','6','hic','Repellendus dolorum dicta unde ratione non temporibus sequi. Id quo sed aut nesciunt temporibus distinctio amet. Pariatur totam cumque qui alias porro officiis.','46','2000-06-13 17:58:43','1984-03-24 03:45:08'),
('47','32','12','itaque','Illo ullam cupiditate provident voluptas quis aspernatur qui. Eligendi eaque quisquam voluptas explicabo. Ea aut dolor quae et. Placeat laborum sit velit.','25','2011-06-13 18:43:00','1982-12-15 09:02:30'),
('48','73','8','consequatur','Quasi quis impedit assumenda et error non alias. Illo sed voluptatibus dolorem esse ipsa. Eius quia omnis dolores quis quo. Iusto quis in ea.','61','1989-05-31 22:02:46','1991-02-20 08:27:07'),
('49','75','4','ea','Nihil laudantium aliquid et dignissimos voluptas. Repellendus fugit qui voluptates excepturi. Doloremque veritatis occaecati accusamus.','57','1986-05-21 10:13:12','2013-07-04 10:26:45'),
('50','87','4','sed','Ut nemo dolorem qui quis iure. Amet porro et ipsum voluptatem. Laboriosam voluptates nisi nihil. Voluptatem et fuga culpa.','100','2017-01-31 17:01:27','1977-11-24 10:10:12'),
('51','4','14','id','Sint repellat beatae modi ad deserunt. Omnis excepturi illo quis illum. Dolorem ullam harum repellendus rerum error.','84','2008-01-12 16:50:32','1996-10-23 07:16:18'),
('52','96','16','fuga','Quod illo nobis inventore quae in a est rerum. Voluptatem vel et rerum doloribus nulla enim rem. Voluptas sint est facere deserunt reiciendis. Maiores esse molestias cum sit.','37','1984-11-05 16:44:13','2007-01-23 06:06:19'),
('53','17','12','et','Et quos quo et repellendus. Alias quae quo culpa repudiandae. Tempore asperiores consequuntur magnam error. Qui provident cum eaque ducimus. Et iste sit architecto ut vel est.','15','2003-03-08 14:54:45','2002-03-20 00:56:20'),
('54','69','3','qui','Id incidunt voluptate sit deserunt aut nesciunt quaerat. Et ut illum autem mollitia itaque. Necessitatibus consectetur sapiente ut.','42','2013-09-14 04:53:56','2005-02-02 04:27:22'),
('55','57','3','placeat','Nobis quae libero eius aut in voluptates qui. Dolorum ea optio aut alias aut sed modi. Ea non nesciunt esse ea.','84','2019-08-26 16:20:21','2008-12-07 16:19:50'),
('56','69','12','aut','Facilis dolores quo aut. Autem modi eum cupiditate vel. Impedit quae numquam ipsum amet sunt alias est sint.','9','2011-10-19 18:46:48','1987-10-10 16:37:19'),
('57','15','19','dolores','Voluptatibus pariatur veritatis consectetur qui ut. Facere qui maiores vitae et. Possimus minus ipsum dolorem non dolore veniam. Minus autem sequi ab saepe omnis id.','65','1975-10-21 22:04:32','1970-06-14 08:13:11'),
('58','39','13','a','Occaecati hic ipsa doloribus sed quia dolorem. Officia occaecati laudantium corrupti omnis unde. Ut deserunt et quod placeat. Omnis iste et sapiente.','4','1974-09-03 12:03:48','1978-05-25 18:19:34'),
('59','99','8','incidunt','Alias quam ut accusantium aliquam. Dicta architecto fugiat accusamus consectetur accusantium corporis ullam voluptatum. Illum at magni voluptatum dicta cupiditate doloribus doloribus. Quia non iure dolores voluptate.','20','2006-04-19 09:25:53','1974-08-29 00:29:49'),
('60','56','5','illum','Voluptas et non qui nostrum aliquam debitis doloremque. Voluptatibus accusamus omnis quia facilis suscipit. Omnis magnam et et. Unde est et saepe culpa vero.','37','2016-12-06 01:35:30','1985-02-20 21:19:21'),
('61','55','6','hic','Non pariatur similique quisquam et magnam. Quae quis et aliquid pariatur et. Sit ut cumque quisquam animi nam est.','7','1978-08-13 22:34:56','1979-05-02 20:08:14'),
('62','38','5','unde','Cupiditate exercitationem facere quis enim earum. Vel illo provident sed et exercitationem. Velit voluptas libero id et.','85','1978-04-05 04:19:43','1997-06-02 20:24:14'),
('63','74','8','architecto','Velit omnis odit nam. Cumque atque ut accusamus cupiditate veritatis et. Necessitatibus velit aperiam amet vel placeat.','43','2005-12-25 10:35:27','1973-02-27 03:26:05'),
('64','89','2','praesentium','Asperiores eius dolorum et doloribus. Aut maxime harum iure velit cumque occaecati. Eos laboriosam praesentium nemo ipsum ipsum unde sed. Illo dolorem nobis harum quaerat et aliquam perspiciatis. Vero unde totam corrupti dolor ducimus vitae unde.','55','2018-03-08 11:58:46','1986-08-27 07:01:05'),
('65','30','13','dolorum','Dolorem tenetur voluptatem ut ratione est nam cum. Consequatur necessitatibus vero molestiae sed ut laboriosam. Nam aut perferendis ut. Est saepe numquam et et pariatur.','69','1970-03-27 21:55:49','2018-11-09 23:16:12'),
('66','14','7','molestiae','Sequi iusto quas nihil vero eveniet. A placeat est qui recusandae. Voluptas molestias eum est. Distinctio assumenda tenetur consequatur doloremque ut eum animi quo.','28','1980-07-10 01:51:09','1981-02-08 10:55:19'),
('67','22','10','delectus','Qui non velit eum distinctio. Voluptas temporibus sunt dolorem quas sed. Eum doloremque culpa in consequatur ipsa voluptatem.','18','1993-08-11 21:39:14','1992-02-11 15:49:19'),
('68','87','17','facilis','Repudiandae nesciunt assumenda reprehenderit accusantium. Assumenda aut qui voluptatum possimus aliquid. Sed eos velit nihil. Est dolore fugiat inventore nam quod vel dolor.','81','2000-01-12 12:01:12','2011-08-22 08:45:50'),
('69','90','17','dicta','Minima pariatur maiores possimus facere delectus magnam. Eveniet aut iste et eum architecto voluptatem. Aut excepturi harum necessitatibus. Nihil ex est autem dolorum amet est et.','19','2008-04-02 06:14:23','2015-12-16 13:53:30'),
('70','9','8','ipsa','Soluta earum totam blanditiis enim autem maiores aut. Doloribus repellendus rem est eum voluptatem. Veritatis dignissimos quis rerum ea officia odio excepturi. Natus nisi sunt quas quisquam deleniti. Consequuntur consequuntur earum vero quos sed nam nam.','42','1986-06-12 08:19:26','1981-03-18 15:13:32'),
('71','46','19','aspernatur','Accusantium ut molestiae molestias dolore itaque. Est ea eos similique itaque et modi eveniet. Eum voluptatem ut hic porro numquam et quia tempore.','69','2006-10-05 13:09:57','1978-07-09 11:57:18'),
('72','52','7','facere','Commodi est accusamus cum debitis sunt voluptatem. Fugit velit molestias autem dolore est nisi officiis.','92','1991-04-03 22:35:48','1971-09-21 10:56:00'),
('73','37','1','molestias','Ut quis sunt qui eum. Quam modi corrupti iste dolorem. Quidem nostrum aut eveniet aperiam adipisci et.','30','1993-09-20 18:24:37','2004-06-08 01:50:06'),
('74','79','19','enim','Aut numquam aut sit distinctio eius modi. Voluptatum error minus assumenda est.','37','2009-04-30 07:26:16','2019-07-26 02:21:04'),
('75','34','5','soluta','Quidem sint aliquam voluptatem ea dolorem voluptates consequatur. Quas cumque quam omnis atque necessitatibus. Rerum nihil dolorum qui voluptatem veritatis sed. Reiciendis voluptatem voluptatem ut et et nam et.','1','2001-04-16 06:01:09','2013-03-18 03:05:28'),
('76','2','8','dolore','Et consequatur quibusdam rerum molestias blanditiis reiciendis et. Natus ea sint consequatur itaque exercitationem fuga. Expedita architecto inventore et sapiente minus quia rerum. Quam sunt quaerat corporis saepe doloribus.','33','1986-12-21 18:07:36','1981-08-08 04:23:11'),
('77','30','12','vero','Quos soluta eaque voluptatem vero amet animi ut vero. Quia accusantium rerum consequatur omnis est maiores.','80','1988-03-16 06:30:02','1996-10-30 05:58:02'),
('78','48','9','delectus','Illo ut provident enim modi et ut ut. Voluptatem id ullam occaecati. Nostrum ullam voluptas consectetur rerum.','65','1980-04-24 14:00:41','2000-04-17 18:02:06'),
('79','28','7','quis','Reiciendis eveniet molestiae molestias voluptates iste. Ducimus tempore dolor qui enim. Molestiae iure rerum architecto. Velit expedita veniam unde in voluptatem voluptatem hic eaque. Velit dolore autem vel voluptas est praesentium.','48','1987-11-26 08:29:42','1982-11-19 11:01:21'),
('80','46','9','ut','Sequi quidem quod eos. Ipsum ipsum illo ullam est. Ad amet iste facilis et ut ut voluptatem. A ad modi similique magni.','87','2001-05-25 00:57:05','1979-05-10 05:30:49'),
('81','88','18','architecto','Quo autem autem adipisci impedit nemo. Aut laboriosam nisi itaque quaerat quos et dolor. Vitae molestiae totam laboriosam voluptas.','80','1994-11-15 05:48:20','1977-09-13 08:23:21'),
('82','57','8','perferendis','Est tempora amet cupiditate optio officia. Saepe incidunt esse doloremque quam. Quia cumque explicabo ipsa et consequatur expedita rem.','11','1986-07-29 09:28:11','2018-06-25 14:26:16'),
('83','49','16','porro','Rerum vero autem eum sed dicta id. Cum qui aut quis recusandae. Aperiam dolores aliquid consequatur suscipit enim officiis.','15','1996-04-04 04:58:20','2003-09-04 02:42:20'),
('84','79','11','perspiciatis','Non in quod labore minus non beatae. Fugiat non voluptas omnis et id blanditiis eum. Perspiciatis ducimus ut dolorum at explicabo praesentium aut perspiciatis. Et fugiat deserunt consectetur nostrum sequi distinctio. Aut molestiae iure sit optio.','8','1998-01-13 03:30:27','1984-03-21 00:11:56'),
('85','16','18','iusto','Assumenda omnis ab voluptatibus assumenda rerum perferendis. Dolor temporibus error iure enim ipsa. In ipsa perferendis aperiam ipsam saepe numquam aut.','31','2000-10-06 15:10:00','1981-06-05 15:26:28'),
('86','16','18','laborum','Minus accusantium dolorem at voluptate expedita voluptatibus deserunt. Et mollitia molestias facere voluptas beatae. Provident occaecati necessitatibus fugiat quod voluptatibus non. Culpa commodi perferendis veniam enim aut reiciendis ipsam.','67','1984-12-04 09:44:41','1995-03-25 12:56:36'),
('87','49','4','sunt','Velit et illum nostrum eum quo et aut. Quaerat mollitia totam est eos nostrum deserunt tenetur. Quia quisquam est dolorum magni. Eaque iusto consequuntur necessitatibus aut quae quas fuga esse.','25','1985-06-13 12:50:30','2018-02-10 20:25:35'),
('88','29','14','ea','Error quia dicta eum quod nostrum autem quisquam. Reprehenderit fugiat fugiat libero est illum. Harum necessitatibus non aut et. Earum commodi asperiores possimus quidem sed.','69','1996-12-09 12:53:41','1997-09-29 13:17:41'),
('89','93','19','molestiae','Quo ad et consequatur at amet est quas. Sed minima iste ea suscipit minima ratione aliquid assumenda. Facilis qui hic nemo magnam.','2','1974-06-14 08:51:00','1997-07-17 11:16:50'),
('90','40','8','ipsam','Ut est ratione incidunt tempore magnam quibusdam. Est suscipit optio quasi rem.','44','1996-10-23 21:34:57','1990-02-23 03:24:49'),
('91','27','6','deleniti','Quidem dolor sapiente voluptatem perferendis nesciunt repudiandae dolores et. Voluptas qui provident ea in fugit voluptates accusamus.','31','2001-09-15 19:01:07','2012-10-06 12:55:56'),
('92','6','17','corrupti','Eum laboriosam est est. Est similique sunt omnis similique amet facilis quod. Temporibus optio tenetur inventore nobis. Ipsum nesciunt dicta velit non natus dolorum.','70','1972-11-17 00:34:20','1986-12-24 16:36:49'),
('93','16','7','et','Quidem aspernatur et vel molestiae aliquid praesentium. Excepturi facere voluptatibus sed. Minima tenetur est hic est autem qui quod. Vel nemo alias quisquam consequuntur dolor qui.','45','2019-07-27 19:17:04','2007-04-13 03:42:59'),
('94','31','3','dolor','Sapiente incidunt aliquam iste ipsa quas ratione vel. Officiis rerum et expedita praesentium. Dolor voluptatem atque voluptatem sit. Accusamus pariatur ex animi.','99','1977-01-26 16:38:17','1997-12-08 16:41:36'),
('95','39','6','vel','Voluptatibus tempora accusantium explicabo quod id libero excepturi. Expedita ut asperiores porro accusantium aliquam qui. Ex est placeat quas odio recusandae pariatur suscipit rerum. Fuga occaecati maxime quae eos.','86','1997-10-11 11:49:50','2019-01-12 16:18:06'),
('96','70','9','itaque','Optio corporis libero pariatur placeat. Sunt sunt qui dolores ea sunt. Eius voluptatem enim incidunt cupiditate ad autem veritatis distinctio. Id vitae cupiditate nisi repudiandae soluta ducimus.','75','2013-04-09 01:35:35','2015-04-12 20:57:12'),
('97','37','19','ex','Velit qui aspernatur similique dolores est. Eos soluta id reiciendis aut quo dolor. Quo quo fugiat dolorem quasi fugit. Maxime quia repellendus aliquam animi.','94','2005-04-18 14:53:14','1976-07-09 13:30:17'),
('98','62','4','quas','Rerum sapiente et quia assumenda autem eveniet ea. Consequatur fugit qui placeat enim.','59','1994-07-26 00:38:25','1973-02-16 19:35:02'),
('99','30','3','eius','Officia optio porro voluptatem tempora quia iste nemo. Eum nisi ab a minus vel. Totam et voluptates dicta aperiam.','52','1983-06-01 10:31:33','2002-06-20 00:53:47'),
('100','32','11','quis','Et harum placeat facilis qui quisquam praesentium velit. Repellendus aut incidunt cupiditate veritatis. Aperiam vero qui ab sint ducimus saepe. In omnis cupiditate odit voluptates.','92','1993-02-16 21:01:56','1989-10-24 12:47:45'),
('101','76','16','consectetur','Illum odit eos animi quam. Praesentium cumque consequatur fuga laboriosam. Ipsa explicabo quaerat quia. Iusto laborum architecto hic officia asperiores quis.','19','1991-11-10 01:22:00','1997-10-04 07:00:35'),
('102','7','17','qui','Quae qui perspiciatis dolor ut non sint. Porro rerum corporis aspernatur nihil quia maiores. Ducimus qui explicabo sunt et voluptatem error ut. Iure veritatis fuga fuga nam aut. Et repellendus enim veniam dolorum laboriosam sunt quia voluptatum.','3','1996-07-03 09:06:16','1999-07-04 15:09:59'),
('103','76','20','aliquid','Cumque doloribus repellat suscipit voluptate quos ut. Deserunt ipsa dolorum corporis consequatur ut. Expedita suscipit cumque est totam aliquam dolorem.','36','1998-03-09 02:08:01','1992-12-17 14:08:39'),
('104','21','6','recusandae','Ut quas repellendus maiores eos porro aliquid. Possimus qui odio officiis dolor sequi. Vel delectus aut dolores rerum et quidem. Mollitia distinctio id velit maxime placeat qui earum.','46','1984-08-24 18:52:50','2007-07-11 02:05:42'),
('105','20','14','autem','Laborum libero ut hic aut error aut. Reprehenderit non sed consequatur et consectetur ut ad quidem. Inventore facere eum eligendi est qui. Sint in impedit libero officia.','72','1972-03-25 14:46:15','1983-04-24 10:12:07'),
('106','5','8','pariatur','Quae occaecati et consequatur et ratione. Provident quibusdam asperiores suscipit debitis repellat est repudiandae sunt. Ea atque sit animi provident impedit cumque.','13','2016-06-21 02:15:13','2007-02-28 02:00:29'),
('107','80','15','tenetur','Perferendis error laborum dolor dolores consequatur. Possimus error minima provident. Veniam temporibus ad impedit sunt porro. Placeat sit eum voluptatibus neque sit.','3','2007-07-20 12:23:25','2000-12-07 02:51:57'),
('108','74','7','et','Vel quibusdam dolorum voluptatibus voluptatem est fugiat sed. Sed animi culpa exercitationem magni at vero. Sit enim provident quaerat sit. Dolorem ea sequi laboriosam aliquam illo provident nisi.','21','2009-08-02 20:16:26','1995-10-30 02:56:20'),
('109','32','13','adipisci','Nemo voluptatem aut placeat quibusdam ab animi esse. Repellat quis recusandae corporis adipisci aut officia voluptatibus. Excepturi minus ratione inventore quod sequi mollitia labore. Rerum corrupti dolorem omnis et quis sed eum.','32','1998-06-11 22:23:40','2000-12-09 18:00:01'),
('110','84','19','quia','Necessitatibus facilis voluptatem repellendus magnam perspiciatis provident. Illum repellendus deserunt cum asperiores doloribus et officiis. Nostrum sequi amet dolorem porro fugiat sequi et.','82','2020-02-14 13:43:55','1989-02-12 00:37:03'),
('111','76','15','exercitationem','Rerum quia est magni omnis alias perferendis. Harum inventore adipisci similique et. Corrupti id omnis magnam quam est qui quae. Placeat provident tenetur ut harum necessitatibus.','59','2019-01-21 22:33:37','1987-05-24 01:01:42'),
('112','94','16','dignissimos','Qui quasi officiis vero nostrum beatae laudantium ex. Assumenda dolor in ut non soluta autem. Officia blanditiis assumenda quis exercitationem deleniti qui ab.','41','1970-01-31 15:08:11','1997-06-22 08:48:45'),
('113','97','11','culpa','Repellendus perspiciatis enim enim qui in nobis dignissimos. Odio quia ullam nemo maiores nihil. Et libero rem ut beatae est tenetur sint itaque. Ex necessitatibus reprehenderit enim quis nihil ipsum omnis et.','39','2005-10-20 11:36:22','2015-03-30 02:09:01'),
('114','32','15','nihil','Et neque expedita et et quis eos. Autem et cum nemo sed sed culpa. Ut sapiente autem sunt similique ratione quos iure. Nisi dolor doloremque quos qui.','67','2000-09-05 06:10:28','1991-10-08 03:03:28'),
('115','77','19','et','Sint consequuntur dicta et nostrum. Cumque esse voluptatem sunt nemo veritatis. Perspiciatis enim id eaque alias. Mollitia aspernatur molestias in et aut.','34','1981-03-10 02:51:27','1993-02-28 07:41:46'),
('116','48','20','laudantium','Distinctio ea vel voluptas est. Eveniet ut dolor explicabo dolor rem sunt. Architecto sapiente dolorum est et deleniti sit sapiente. Assumenda fugit omnis ut quisquam vel rerum aliquid. Doloremque minus numquam qui ut est ab.','70','2013-04-26 01:03:41','1973-08-20 18:47:04'),
('117','61','16','dolor','Dolor perferendis ullam et architecto. Sit placeat reprehenderit quis quia autem est voluptatem. Dolores quisquam ullam minus modi laudantium nihil. Ut distinctio eum sed quo. Unde eaque officia dolores optio cumque reiciendis eius est.','43','2007-11-23 06:24:16','1990-06-12 22:13:24'),
('118','64','10','mollitia','Qui molestiae laudantium mollitia optio. Odio eum occaecati debitis numquam optio explicabo. Sunt neque pariatur nostrum similique natus.','77','1988-01-27 13:45:27','1986-11-24 10:29:53'),
('119','84','17','velit','Quis illum consequatur voluptatem quo qui. Reprehenderit quae beatae sed ut fuga animi hic.','41','1974-07-07 10:13:44','2019-04-20 22:20:44'),
('120','16','13','voluptatem','Reiciendis saepe ad nihil cumque in error. Est quo voluptatem et occaecati. Facilis eos earum voluptatem necessitatibus qui sapiente eius aperiam.','35','1978-10-04 22:21:37','1989-01-28 20:41:11'),
('121','97','9','a','Aut vel qui quia vero et ratione velit quasi. Hic eos sunt placeat beatae id placeat aut. Omnis id laboriosam provident aliquam sit architecto. Consequatur vero et eum doloremque voluptatem.','6','1987-06-02 23:53:32','1996-07-25 18:35:05'),
('122','55','7','eum','Esse reprehenderit autem quo provident. Maxime vitae est quis non. Cumque aperiam qui labore debitis mollitia.','82','1990-10-07 13:37:14','2019-02-10 21:56:52'),
('123','95','6','omnis','Cumque repudiandae quam recusandae aut sed. Nesciunt libero non unde corrupti. Veritatis praesentium eius fuga eligendi placeat ut eius.','34','2007-09-01 14:06:37','2008-05-31 20:16:10'),
('124','33','13','hic','Officia itaque et pariatur. Aut in nobis et id est repellat. Voluptatem consequatur ut molestiae consectetur facilis quidem ratione. Explicabo quia dolorum quasi eligendi incidunt impedit sed. Sapiente et asperiores fuga labore.','6','2005-01-22 19:04:32','1981-12-26 04:17:07'),
('125','100','8','impedit','Ab dolor porro hic consequatur quia. Sit consequatur laborum magni consequatur repudiandae rerum temporibus.','98','1980-04-05 23:31:54','1971-03-12 16:34:43'),
('126','33','18','sequi','Id modi asperiores qui praesentium odio. Ut magnam aliquid odio officia. Suscipit corrupti reiciendis possimus ipsam illo aut nemo. Et eos explicabo qui laborum impedit.','94','1976-04-20 00:31:12','2003-11-25 16:43:25'),
('127','3','10','voluptates','Assumenda impedit impedit nam voluptatum. Recusandae doloremque non possimus. Officia corporis molestias molestiae quia adipisci ea. Neque dolor voluptate rem.','70','2017-08-20 22:31:39','1971-01-29 04:01:10'),
('128','46','2','corrupti','Vitae mollitia blanditiis aut ipsum occaecati voluptatibus fuga. Pariatur ipsum dolorem harum quaerat ea in. Quas eius quo sed eum et cum.','20','1970-12-05 08:40:06','1985-01-29 23:17:57'),
('129','22','19','nisi','Qui qui non laborum vel quos qui. Repellat reiciendis fuga est repellat alias quas non. Amet doloremque et et.','1','2013-06-18 13:23:19','1989-02-03 20:49:55'),
('130','62','2','repellendus','Aperiam vel blanditiis ut deleniti recusandae. Officiis voluptatem rerum sed molestiae asperiores iure. Dolor minus neque architecto saepe. Voluptate velit voluptas repudiandae eum eos.','66','1984-10-16 01:33:36','2015-05-26 07:36:03'),
('131','97','2','ea','Sit sit ullam in laborum corrupti illo. Voluptatibus soluta et sed et aspernatur. Nam vitae quod temporibus pariatur. Ut sit dignissimos necessitatibus autem.','6','2014-07-29 04:26:01','1977-02-05 03:56:17'),
('132','2','12','aperiam','Perferendis rerum ex sapiente nostrum. Dolor eius nisi corporis. Eius recusandae sit corporis ratione sit.','39','1990-03-21 14:23:25','2005-02-08 13:51:39'),
('133','84','11','fugit','Sapiente temporibus voluptatem culpa ratione quis magni. Aut ratione nihil est aliquam. Doloribus rem eaque et aut accusamus eveniet corrupti.','69','1990-08-15 14:14:31','1976-01-31 02:19:40'),
('134','17','18','perferendis','Soluta sint ratione numquam provident et quos. Mollitia odit vel maxime eum. Et eos autem quo quae culpa. Vitae non quia velit ea. Eaque velit recusandae corporis minima magni.','30','2008-02-07 00:46:46','1983-09-25 07:59:17'),
('135','23','18','repellat','Rerum ipsa ut sit molestiae dignissimos nulla. Rerum dolor molestiae rem. Eaque sit non aut quis. Nihil quis modi aut enim maiores excepturi qui tenetur.','68','2013-10-04 14:36:44','2006-09-25 20:29:14'),
('136','20','4','nesciunt','Ut assumenda unde tempora aliquid hic rem ut. Laudantium maiores ullam illo sequi eum ut et occaecati. Laborum ad voluptatum iste sapiente voluptas voluptas ullam. Dolorem veniam deleniti beatae voluptatum voluptatem temporibus rerum.','54','1988-05-11 05:50:43','2017-01-28 05:52:26'),
('137','13','5','non','Est enim odio alias quo. Consequuntur eum ut voluptas ullam. Nobis pariatur architecto cumque. Ab eum necessitatibus rerum beatae aut omnis ipsa.','100','1990-05-26 17:24:19','1988-04-03 14:10:49'),
('138','83','14','ratione','Eum minima praesentium molestias. Aut consequatur aspernatur modi consequatur. Et consequatur maxime quae quos. Veritatis explicabo tempora delectus ea totam dolore fugiat.','10','1993-05-02 18:21:45','2011-03-01 16:44:25'),
('139','2','18','ut','Alias unde consequatur et. Quo suscipit delectus voluptas. Necessitatibus accusantium similique quia ut.','3','2006-07-13 17:48:19','1996-08-30 13:44:12'),
('140','2','11','accusamus','Sunt qui quasi vel rerum est quibusdam ut a. Magnam amet rerum voluptatem quaerat. Qui nam ipsam ipsa.','11','1978-09-29 10:00:40','2001-06-23 12:51:36'),
('141','67','10','dolor','Est ut hic quam consequatur nulla veritatis numquam. Optio est culpa consequatur in aut odit. Nostrum eveniet iure in corporis eligendi officiis et voluptas.','17','1988-05-09 15:27:06','2008-05-16 14:42:31'),
('142','73','10','maiores','Ea hic quidem quisquam magni. Optio eligendi eum quia in sint sequi. Officiis quam iure placeat id omnis qui atque.','76','2005-11-21 04:27:04','1985-07-27 03:37:52'),
('143','12','7','rem','Debitis ut praesentium quis voluptatem dicta quia vitae. Suscipit et ut id placeat. Aut similique pariatur inventore occaecati.','31','2013-04-06 22:57:07','2013-10-20 07:34:40'),
('144','80','10','asperiores','Ut saepe et doloribus harum. Fugiat voluptatem reprehenderit provident minus aut. Sed nemo suscipit quia animi laboriosam optio repellendus.','18','2013-02-09 14:04:59','2011-01-26 09:53:03'),
('145','10','15','hic','Odio dolores ratione autem incidunt. Et et voluptate ipsam explicabo eaque. Sed inventore et debitis.','5','2019-07-06 16:07:37','1978-03-19 11:11:04'),
('146','77','19','possimus','Accusantium velit magni sed aperiam ut eos. Dolorum voluptatem sed amet quas. Sit culpa id tempora odit est maiores. Voluptates fugiat nulla aut odio.','24','2013-04-14 14:03:43','2018-04-12 19:23:07'),
('147','31','1','nostrum','Hic illum blanditiis voluptate saepe molestias ipsam optio. Dolorum voluptates voluptas repellendus quo. Id aut qui amet eos.','46','1984-02-16 02:25:31','2010-11-28 08:23:58'),
('148','30','18','alias','Provident nihil modi eligendi dolor. Inventore ea soluta cumque illum. Ut asperiores culpa eligendi cupiditate et sunt architecto voluptates.','13','1983-08-03 02:18:17','2004-05-29 09:44:31'),
('149','39','18','ut','Suscipit quasi fugiat temporibus harum omnis ipsum dolores. Assumenda blanditiis similique exercitationem veritatis aut voluptatum laudantium. Excepturi error accusantium ab sit placeat sequi. Sed aspernatur adipisci culpa ut et eaque cupiditate.','1','1998-12-04 14:28:22','1985-10-10 07:42:11'),
('150','42','18','qui','Beatae a quaerat ipsam quis aspernatur quis autem. Sunt consequatur doloremque fuga et enim. In quidem quos unde quis et. Voluptatum eum cumque esse beatae aut qui.','52','1997-03-28 01:49:39','1983-03-16 10:45:12'),
('151','53','12','delectus','Quis rerum assumenda ducimus velit sequi. Magnam ab ipsam ipsam et nulla iste sunt. Unde corporis aut non est. Ratione omnis quia repellendus eveniet.','100','2020-02-05 02:47:19','1981-12-04 14:33:34'),
('152','69','6','enim','Tenetur vel possimus sint quia tenetur possimus. Vero nostrum officiis et reprehenderit rem ratione omnis.','49','2007-04-01 02:37:14','2000-11-24 11:38:05'),
('153','44','8','eius','Quis eum iste quae est eos iure. Ut qui ut officia quia labore assumenda. Ut sed ea quo sapiente recusandae est culpa. Voluptatibus aliquam recusandae labore.','82','1991-01-06 13:05:06','2003-08-01 21:49:57'),
('154','75','4','aut','Dolorum temporibus vel rerum et. Molestias voluptatem est reiciendis velit et. Quidem ut sit quo voluptates quia qui quae non.','31','1997-04-26 10:59:51','1971-11-11 16:27:57'),
('155','92','6','quia','Laboriosam odio dolor non. Iure consectetur et exercitationem sint. Autem officia et aliquam ipsa velit distinctio dolores. Minima est odio officiis voluptatibus fugit.','2','2012-05-22 03:21:32','2009-08-10 05:29:25'),
('156','97','1','tenetur','Atque esse odit alias illo. Et autem placeat similique molestiae voluptas cupiditate repudiandae aspernatur. Soluta atque et molestias qui sequi omnis. Repellendus omnis tempore corporis quam aut.','92','2012-05-19 19:37:30','1985-01-04 01:51:53'),
('157','20','7','ut','Nesciunt ipsa modi minus eum dolorem. Vitae dolorum corporis facere quia qui et. Ut dolorum ut in vitae aut rem.','95','1995-04-13 22:11:49','2012-07-22 01:22:52'),
('158','66','13','nesciunt','Voluptatem cumque rerum cum adipisci ipsam enim. Quisquam id quia non repudiandae vel. Et impedit maxime quia nesciunt.','80','2005-12-21 16:33:18','2003-05-20 14:57:49'),
('159','78','1','est','Sequi eum possimus vero saepe velit sint. Vel dolor asperiores in sapiente ad velit. Omnis fugiat quisquam quos veritatis.','67','1999-06-21 05:41:35','2016-05-14 05:27:58'),
('160','79','9','excepturi','Tempora sunt non enim architecto illum ipsa repudiandae. Beatae ratione non molestias qui sit dolores inventore. Recusandae qui aut ut aut accusamus perspiciatis.','55','2005-04-06 05:02:31','1989-08-24 15:58:09'),
('161','30','20','officia','Sed facere autem natus a aut. Blanditiis eum et aut voluptate iure. Ut totam quos totam placeat est.','10','1979-11-07 21:53:27','1977-11-14 09:52:49'),
('162','29','13','corporis','Et vel maiores suscipit expedita iure. Alias voluptas hic distinctio incidunt. Soluta velit deserunt quidem aperiam aperiam dolores rerum. Fugiat rem consequuntur corrupti voluptates.','38','2013-06-02 00:05:49','1995-06-07 21:17:27'),
('163','78','2','delectus','Aspernatur non voluptas neque eos magni quas rem. Voluptas consequatur voluptas repellendus totam neque facere aut. Ut est architecto eum iste eum eum voluptatibus.','76','2005-11-15 19:00:30','1993-08-05 03:35:35'),
('164','59','17','non','Laborum incidunt ut saepe accusantium quisquam maxime. Sunt corrupti harum aperiam soluta voluptas sed voluptate. At tenetur qui placeat a consectetur. Reiciendis dolores delectus dolorem doloremque esse.','94','2020-01-15 14:36:45','1990-08-31 19:07:17'),
('165','89','15','rerum','Et odio dolorem necessitatibus totam. Modi eos excepturi soluta facilis. Minus perspiciatis a eos fugiat eaque pariatur repellat. Sed consequatur molestiae sapiente nemo quis aut ad.','22','1986-07-02 22:18:21','1996-07-12 12:54:35'),
('166','90','15','eum','Incidunt natus cupiditate error ut cum. Aut similique numquam voluptatibus hic alias perspiciatis nostrum deserunt. Eos sed explicabo ipsa et. Harum temporibus qui tenetur consequatur qui beatae non. Eligendi dolores veniam exercitationem.','26','1999-09-08 13:15:39','2019-01-27 08:42:13'),
('167','82','18','ea','Vel quos sequi dolore beatae adipisci. Non est et perferendis et. Nam repudiandae quod labore rerum incidunt rem. Voluptatem blanditiis fuga veritatis numquam debitis eum. Ut qui nulla culpa molestias qui provident.','60','1996-06-22 17:55:36','1991-12-20 10:58:54'),
('168','77','11','quod','Blanditiis aperiam earum blanditiis architecto. Fugit impedit at a iure inventore. Aut quia soluta dolorum necessitatibus est numquam consequuntur. In velit aut eaque odio. Laborum quo et ut itaque.','24','2007-01-12 18:25:03','2011-09-23 05:19:08'),
('169','57','7','ea','Quas nostrum exercitationem sunt esse facere minus qui. Fugiat dolorem ab quia tenetur. Fugiat iusto enim nihil culpa voluptatum. Aut at et harum ut.','26','1989-03-17 04:44:01','1991-08-06 11:18:31'),
('170','23','3','sunt','Quia ad sit excepturi qui et. Non facilis neque iusto eius illo neque inventore fugit. Dignissimos non laborum est dolor et quis. Aliquam ipsum voluptate incidunt ex veniam.','70','2013-02-23 00:14:36','1978-01-13 16:15:12'),
('171','78','9','et','Est quaerat fuga autem quae et sit. Accusamus inventore temporibus ut alias natus esse aliquid. Harum et aut vero officiis omnis illum.','65','1989-08-23 20:43:11','1992-08-19 04:34:17'),
('172','87','14','aliquid','Commodi consequatur sit et vitae. Tenetur similique fugiat velit. Inventore fugit harum quos consequatur incidunt laboriosam. Corrupti quam neque cupiditate natus consequatur mollitia.','29','1978-04-06 21:33:49','1991-04-01 13:54:51'),
('173','24','10','aliquid','Debitis modi rerum consectetur reprehenderit. Voluptatem minus recusandae eum. Vero quos sunt voluptatem vel omnis est voluptatem.','37','1989-09-09 14:55:32','2014-07-05 17:16:05'),
('174','100','1','id','Reiciendis in pariatur quo rem. Quod omnis atque expedita doloribus. Porro inventore eius qui ipsam sunt numquam. Iste inventore qui dolorum quaerat sunt aspernatur aperiam.','18','1982-07-31 00:31:29','1990-11-19 09:30:40'),
('175','94','19','tenetur','Dignissimos dolores maiores illum. Enim architecto totam aut eveniet.','92','1989-10-04 01:21:57','1976-03-14 16:12:05'),
('176','15','17','culpa','Optio impedit asperiores labore magnam vitae sit adipisci. Velit nihil labore facere omnis illum rerum. Aut ut et et repellendus adipisci atque voluptatem. Aut dignissimos ipsam velit saepe cum est fuga.','62','1980-03-02 23:33:51','2018-01-22 19:05:11'),
('177','40','13','saepe','Labore veniam fugiat occaecati et mollitia. Adipisci vitae excepturi explicabo suscipit quo deleniti voluptas. Rerum consequatur error sed est dolor et mollitia.','52','2019-02-11 02:55:02','2001-12-11 07:31:04'),
('178','99','9','aliquid','Vel at officiis magnam commodi et. Dolores tempora atque aut voluptas asperiores dolor quia. Est rerum cum voluptatem ducimus ipsa omnis. Autem quia distinctio laboriosam dignissimos earum magnam et sit.','7','2007-06-01 09:21:34','2008-12-12 03:37:29'),
('179','22','20','reiciendis','Velit et minus aperiam adipisci voluptas dignissimos. Ut ipsam fugiat sint earum totam nobis. Aut odit soluta sit at deserunt accusamus.','39','1980-09-18 09:34:15','2005-09-22 18:36:08'),
('180','48','4','consectetur','Nam veritatis voluptate aut. Voluptas enim commodi voluptatum dignissimos blanditiis reiciendis corrupti. Labore similique libero non in ut quisquam architecto. Veritatis atque pariatur nulla ad molestias aut.','50','2003-01-06 15:24:30','1976-11-13 04:58:51'),
('181','17','20','reprehenderit','Eum deleniti quidem repudiandae doloribus soluta iure id. Eveniet laudantium modi quasi aut mollitia magni autem. Illum voluptate expedita ratione et excepturi officiis alias. Et aut eos velit aut est vero.','90','1998-04-03 17:31:03','1981-01-16 02:50:57'),
('182','82','17','saepe','Nulla est impedit voluptas. Est itaque doloribus eveniet eligendi. Id sed laborum nesciunt dolorem in magnam ex sunt. Aperiam nemo est vitae reprehenderit sapiente sit. Odio possimus voluptatem quis odio veritatis voluptatibus voluptas odit.','59','2014-02-13 11:57:35','2003-12-16 20:42:08'),
('183','10','2','occaecati','Facilis excepturi debitis voluptas autem amet nulla odit. Consequatur quisquam laudantium doloremque natus possimus error voluptas. Saepe earum rerum ipsa tempore molestias quo.','5','1998-12-13 22:24:28','2000-06-14 08:18:56'),
('184','47','2','voluptas','Et vel dolor aspernatur officia rem quo exercitationem. Qui voluptate adipisci in est.','10','2007-06-11 01:21:17','1987-03-27 20:51:46'),
('185','65','1','tempora','Sunt molestias dignissimos et qui est. Vero fugiat voluptatem et enim quasi minus. Tempora et iste ab explicabo aut dolore aut. Et itaque iure voluptas qui ipsum ut.','3','1978-07-26 07:37:31','1973-07-15 07:45:53'),
('186','56','3','iste','Omnis corrupti provident eveniet consequatur dolor praesentium. Exercitationem ducimus nisi aspernatur velit consectetur inventore. Enim esse unde ut rerum.','85','1999-04-18 23:31:02','1975-01-23 13:55:03'),
('187','18','11','quod','Laborum debitis voluptas labore cum consequatur voluptatem laudantium. Id voluptatem ut ducimus ipsam quo. Nisi aut ut sit qui sit ratione voluptate. Vero est qui aperiam consequuntur enim et assumenda quo.','50','2002-04-11 14:43:24','1990-04-25 17:18:00'),
('188','70','11','perspiciatis','Ex consectetur magnam nihil. Voluptatem veniam a non quis et adipisci quis. Quasi et voluptatem aliquam quas est consequuntur aut. Omnis incidunt cupiditate eum culpa.','91','1986-02-16 04:40:21','1971-03-24 02:04:16'),
('189','77','15','laborum','Magnam laudantium deleniti voluptas. Ratione voluptatem aut minima in. Illo ipsam incidunt quos et ut ut maxime. Est dolorem dolores molestiae rem qui est dolore sed.','88','1974-02-23 09:05:20','1974-01-03 16:53:48'),
('190','15','5','ipsam','Vel rerum id debitis voluptas qui enim at. Numquam iusto non magni odio corporis voluptates pariatur ad. Sunt explicabo iure aperiam quibusdam error quos rerum.','7','1983-12-29 04:01:46','1984-03-05 18:40:57'),
('191','64','8','in','Dolores ad ut quibusdam aliquid dignissimos expedita consequuntur. Ad error ut velit maiores dolores et. Libero natus voluptatem et et voluptatibus debitis eum. Doloremque tempore id in neque. Qui laudantium et id ad.','3','2007-01-10 17:49:28','1990-05-30 06:40:51'),
('192','54','4','vitae','Ad fuga impedit qui asperiores. Eos ut impedit et quia. Est eos error odit nobis possimus similique cupiditate quasi.','87','2004-08-29 21:45:06','2013-05-27 06:51:54'),
('193','12','6','a','Labore consequuntur quam accusantium. Quia minus enim excepturi voluptatum placeat distinctio. In similique aliquam consequuntur rem.','94','1983-12-15 11:42:28','1970-09-30 01:15:02'),
('194','17','16','possimus','Vel qui quos et id. Quo iure optio aspernatur consequuntur. Sed veritatis laudantium quia a repellendus ducimus. Illo est maiores illo odit quos amet omnis magnam.','1','1973-09-23 16:23:59','1994-09-18 04:18:07'),
('195','26','8','dolorem','Qui quis ea vel laborum earum eius. Dolor voluptatum voluptas quos voluptatem neque. Aut qui harum quo perspiciatis.','1','1985-08-08 00:17:10','2009-01-28 04:16:18'),
('196','28','20','praesentium','Ducimus molestias velit voluptate. Iste quis rerum eum perspiciatis.','15','2015-01-07 03:34:51','2014-05-19 09:31:23'),
('197','13','3','sit','Perspiciatis id qui ut. Dolorum autem in delectus cupiditate. Quia deserunt assumenda et deleniti voluptas voluptates illum. Labore impedit accusamus esse deserunt. Molestiae iste repudiandae id est sunt doloribus.','69','2009-04-06 22:18:38','1982-04-10 08:51:08'),
('198','62','17','consequatur','Quidem recusandae non et inventore qui adipisci enim. Ea ut voluptatem aut. Qui ut hic est et.','21','1975-02-08 17:32:54','2001-04-15 09:37:07'),
('199','53','12','necessitatibus','Impedit qui illum qui sit. Iste quia eius perferendis aut enim ea. Eligendi vel natus beatae possimus et aut omnis.','96','1976-03-03 08:15:20','1974-12-10 14:25:58'),
('200','40','15','est','Culpa architecto amet molestiae id et earum numquam. Voluptates est dolore placeat quos. Ea impedit dignissimos nihil similique illo. Harum aut vel velit et. Error accusamus quis amet ducimus debitis consequatur et.','17','2011-09-04 10:31:41','1982-11-13 16:12:43'),
('201','46','8','sequi','Quis excepturi suscipit sint facere ut ullam. Et nihil mollitia accusantium vel ratione iusto. Dolor praesentium autem consequuntur ut natus eaque.','55','1992-01-21 18:15:12','1974-11-05 07:21:03'),
('202','49','19','et','Eaque minus possimus corrupti beatae cum voluptatum architecto. Vitae perspiciatis facilis et ea. Doloremque debitis error eveniet a omnis voluptatem molestiae.','75','1971-10-01 04:07:27','2012-06-21 16:44:36'),
('203','36','1','accusamus','Dolor nam itaque magnam ut. Nam qui et dolorem praesentium hic. Numquam praesentium reprehenderit accusamus dignissimos quidem sint.','4','1986-05-24 10:07:58','1981-07-06 19:34:40'),
('204','29','4','officiis','At praesentium autem sed quos. Architecto eum omnis aliquam asperiores aperiam ut cumque. Ipsa dolorum est reiciendis quis id saepe minima sed. Laboriosam unde nihil molestiae occaecati ad rem distinctio.','80','1978-09-01 18:03:49','1971-07-04 06:22:33'),
('205','29','9','rem','Iste accusamus ad est dicta quis aperiam. Recusandae est non perferendis nostrum voluptas. Aut exercitationem sequi et reiciendis ipsum.','19','1972-12-21 02:54:41','1994-12-30 02:03:54'),
('206','29','15','id','Vitae ratione et est ipsa itaque aperiam. Quasi et magnam numquam praesentium. Aut voluptatibus et velit eos culpa praesentium rem.','15','2005-09-25 00:40:20','2012-09-11 02:31:20'),
('207','44','17','rem','Omnis quia placeat molestias porro. Eveniet alias veritatis ea et recusandae. In et aut animi totam omnis est nihil.','28','2020-03-26 16:05:39','2002-09-07 02:51:54'),
('208','12','10','sint','Iste quis libero aut maxime. Voluptatum veritatis aliquid rerum dolor. Veritatis quas debitis perspiciatis est sed architecto.','10','1971-01-04 21:54:35','1970-05-28 05:30:08'),
('209','33','20','necessitatibus','Sit consequuntur consequatur sed sed repellat ratione. Fugiat modi quae qui officia. Eum eius et enim quo sit quia illum delectus.','69','1988-12-16 11:46:58','2007-11-07 17:13:26'),
('210','28','8','vel','Aut animi ut quia odio. Cumque assumenda ad suscipit quis unde labore corrupti. Natus quo aut velit et. Architecto vel ut sunt et repellat voluptate.','42','1987-03-29 07:16:10','1984-03-16 21:42:49'),
('211','45','17','et','Quod reiciendis explicabo eligendi hic est. Architecto vel non consequatur vel asperiores iure. Doloremque et maxime veniam quod sunt ex. Ipsum ipsam et quia recusandae.','80','2001-10-25 19:08:47','1998-08-16 19:55:33'),
('212','100','7','libero','Nihil cum cupiditate minima quae. Fugit id pariatur dolorum alias nihil. Et animi enim odio amet quaerat.','71','2013-09-14 01:28:42','1999-12-26 15:04:41'),
('213','74','14','explicabo','Debitis quo laborum quia praesentium sit sint. Tempora vitae maiores sint accusantium corporis. Repudiandae ducimus ut sed magnam suscipit.','73','1975-04-04 15:07:15','1993-03-04 18:35:20'),
('214','77','20','explicabo','Ipsum doloribus natus a deleniti sunt reiciendis laboriosam minus. Rerum id in aut. Eligendi et optio ipsam sunt nam facilis voluptatem.','91','2001-05-06 12:16:05','1986-02-12 00:54:24'),
('215','56','5','vero','Ratione asperiores id mollitia magni voluptatem. Assumenda ipsum sint doloremque explicabo.','35','1999-11-26 00:24:43','2018-09-22 10:45:22'),
('216','75','11','sequi','Laborum non est quidem hic voluptatem non. Dolor nisi sint nam qui earum dolores voluptatem. Iusto corrupti consectetur velit quibusdam exercitationem ut sed.','6','1997-11-28 08:03:09','2000-09-06 10:18:35'),
('217','89','20','sint','Et eligendi odio non rem quisquam et repudiandae placeat. Unde fugit dignissimos ad eligendi a dolorem dignissimos. Qui et labore dolor autem delectus laudantium quos. Magnam et quia ea ipsum quae molestiae.','90','1978-11-26 15:08:59','2015-12-19 08:19:49'),
('218','16','2','deleniti','Dolores ut magni vel sunt qui voluptatem aliquam. Quam aspernatur minima sit nihil dignissimos. Iste quis provident et eum aut quis.','35','1975-06-23 00:07:57','2019-09-07 05:03:36'),
('219','26','9','debitis','Labore voluptate saepe voluptas voluptas et ut non. Magni nihil itaque minima sit eos at est. Temporibus eum unde neque minima sed ab. Optio distinctio sint quisquam.','33','1983-05-26 19:04:21','1977-01-10 23:56:52'),
('220','95','14','earum','Et consectetur ab ut possimus voluptates ut ea. Illum at vero dolore sunt hic est. Deserunt vitae voluptas saepe tempora.','69','1990-05-11 01:42:10','1993-04-16 04:16:30'),
('221','37','3','recusandae','Odit culpa voluptatibus dignissimos eius sit. Iusto soluta expedita voluptate molestiae maiores consequatur.','52','1981-05-16 09:02:59','2006-07-18 04:56:26'),
('222','16','3','ea','Nisi aut expedita eaque reprehenderit repellendus a sapiente. Nihil iure itaque quod. Quae et expedita saepe et repellendus. Repellendus suscipit aliquam minus facilis omnis eligendi sed. Vel est repudiandae sunt aut et sit maiores.','84','2001-05-03 23:40:43','1978-06-27 03:50:43'),
('223','86','17','delectus','Alias a sunt delectus non cumque nesciunt ea. Veritatis voluptatem nobis occaecati repudiandae molestiae temporibus eaque. Dolorem vitae cumque illum sint. Molestiae similique perferendis ea repudiandae aperiam ut.','50','1976-08-03 11:12:54','2004-04-03 09:28:34'),
('224','58','13','facere','Adipisci omnis ratione voluptas ut in voluptatem. Dignissimos occaecati iure exercitationem id commodi non. Amet perferendis nostrum aperiam vel consequatur saepe.','45','2015-12-30 09:08:52','2013-07-23 00:28:47'),
('225','49','4','in','Doloremque et eum autem ipsam nisi. Voluptas esse sequi ad quibusdam dolorum omnis qui. Quod adipisci aut ipsa est. Accusamus vel est et.','69','1991-03-19 22:07:40','1971-05-04 12:41:58'),
('226','84','19','explicabo','Fugit amet qui repellat nam in. Rerum ex est perspiciatis modi nam. Unde laudantium sint quo et aut voluptatum fugiat ab.','21','2006-08-14 22:55:04','1970-02-28 08:30:50'),
('227','90','17','est','Voluptates quibusdam reprehenderit ea mollitia placeat ut. Quaerat ut facilis suscipit dicta occaecati deserunt. Non architecto eum omnis voluptatem. Est eaque laudantium quia voluptatem pariatur minus.','17','2007-06-25 17:42:30','2012-05-12 15:39:39'),
('228','80','20','facere','Soluta aliquam deserunt rerum et eos dignissimos. Error iure non esse consequatur fugiat sequi. Mollitia vel laudantium maxime enim rerum.','25','1978-07-30 02:49:52','2007-06-25 10:40:05'),
('229','14','5','sit','Quibusdam eum quia magni consectetur. Optio sed aperiam accusamus quo dolores accusantium. Molestiae id enim enim cumque quia libero odio consequuntur.','65','2002-04-04 00:13:18','2002-01-21 18:55:17'),
('230','46','4','sed','Minus unde minus at corrupti optio dolorem et. Laborum enim maxime voluptatem nostrum animi pariatur. Vero sint porro et vero molestiae est. Voluptatem similique soluta sed vel provident quo.','33','2000-06-10 03:32:26','1982-10-16 10:41:17'),
('231','15','11','inventore','Officiis facilis vero impedit maxime debitis hic. Excepturi ullam ab quia facilis et. Dignissimos omnis ipsum occaecati voluptatibus incidunt. Occaecati voluptas maxime impedit voluptatem tempore earum ullam dolor.','45','2000-04-20 10:17:22','2004-01-26 13:34:26'),
('232','67','14','aut','Aut omnis unde tempore beatae commodi. Culpa illum et ipsa ex iste. Et assumenda eos repellat maiores. Ratione porro nesciunt quibusdam.','56','2003-10-08 19:22:08','1974-09-29 23:44:20'),
('233','50','11','hic','Enim consequatur ut iste. Quos in tempora vel quos error. Saepe sed eius voluptatem asperiores qui sequi ut.','41','1985-01-18 14:29:06','2012-11-01 20:22:26'),
('234','99','3','delectus','Nemo unde illum incidunt enim. Rerum id cum velit possimus inventore autem dolorum. Doloremque qui laudantium libero enim corrupti iure ut. Aut corrupti iste quis aut.','2','1997-12-27 11:42:43','1983-11-04 21:57:40'),
('235','44','13','sint','Qui fugiat voluptatem dolorum atque ducimus similique modi. Quaerat qui facere explicabo sapiente voluptatibus.','20','2005-07-16 22:11:10','1974-12-22 08:47:19'),
('236','13','9','voluptate','Recusandae occaecati dolor aut quidem. Sit assumenda aperiam tempore. Maiores voluptatem eligendi eaque voluptas voluptate.','12','2009-08-30 05:39:51','1991-09-10 07:54:54'),
('237','33','7','occaecati','Dolore eum necessitatibus ad iste atque vel nostrum. Nostrum sit consectetur velit facere pariatur dolorem culpa. Harum in est odio fugit quibusdam molestias. Dolores nobis rerum rerum nihil.','93','2018-01-15 08:57:29','1980-12-02 06:44:28'),
('238','50','3','quo','Error autem laboriosam sint consequatur odit est. Inventore autem laudantium doloremque dolor sint. Et doloremque non deserunt. Quod odio aut magnam cum.','89','2013-08-22 10:23:33','2004-01-24 09:57:08'),
('239','75','6','voluptatibus','Ut similique quia id numquam vel quia molestiae. Distinctio et expedita fuga soluta ratione. Ea omnis quo dolorum.','12','2015-08-01 06:42:22','2005-05-06 10:19:05'),
('240','39','15','sint','Quis delectus atque et quidem architecto ipsum. Dolore enim veniam nemo veniam eligendi aut. Minima dolor facilis aut quaerat.','29','1991-05-21 03:07:34','1997-03-30 00:28:27'),
('241','71','18','dolore','Sed consectetur nostrum soluta. Dolor ipsum doloribus libero soluta natus. Sunt voluptas ut doloribus dolor excepturi omnis ad.','82','2008-01-11 11:19:32','1979-09-01 11:00:56'),
('242','16','11','et','Modi fuga tempora quae voluptatem voluptas saepe harum cupiditate. Rem perferendis hic totam modi similique veniam et. Nesciunt dolore distinctio at suscipit. Alias ut laboriosam consequatur nobis.','50','1991-09-23 03:08:34','1986-11-11 00:03:21'),
('243','72','1','officia','Necessitatibus illum laudantium rerum quisquam velit ut. Explicabo qui veniam deleniti sed numquam mollitia. Non cum expedita voluptatum ratione est. Odit optio suscipit necessitatibus dolorem tenetur tempora. Tempora ipsam nisi maxime molestiae et illo.','4','2011-12-25 12:23:20','2003-09-08 01:36:23'),
('244','12','1','animi','Aspernatur tenetur veritatis praesentium rerum. Perspiciatis fuga distinctio laborum doloremque expedita. Quas occaecati reprehenderit voluptate amet quibusdam saepe. Non officia ullam quae iure. Et mollitia voluptas fuga sit.','16','2004-05-07 06:37:02','1976-10-25 15:12:35'),
('245','14','10','perferendis','Sunt ducimus nemo amet labore. Alias saepe a aut rerum quos. Amet dolore et fugit eaque.','76','1972-12-30 21:57:51','1980-03-29 15:52:23'),
('246','33','12','officia','Quidem soluta earum quaerat fugit laudantium ut. Consequuntur quos dolorem error est corrupti ut. Ab maxime praesentium qui sint et.','21','1993-12-09 10:45:09','1995-06-23 18:36:59'),
('247','44','19','illo','Cum quia hic officia debitis. Voluptatem accusantium perferendis quae aperiam quia fuga. Minus excepturi fuga hic error. Minus at deleniti qui deleniti qui ipsa aut.','55','1993-04-15 00:32:53','2001-12-17 14:39:38'),
('248','36','9','nulla','Laborum pariatur commodi mollitia ea blanditiis libero accusantium. Sunt accusamus saepe odit eum et. Quaerat praesentium et saepe deserunt.','68','2004-01-03 03:00:15','2000-06-20 05:12:28'),
('249','25','3','quisquam','Omnis dolores repudiandae aut doloribus reiciendis suscipit et. Quos harum aut ratione at voluptatem reiciendis. Nemo reprehenderit est inventore ea quo. Et itaque rerum asperiores culpa.','94','2000-01-08 04:00:50','1971-12-22 18:36:22'),
('250','37','11','vitae','Est nihil debitis expedita omnis minima. Et blanditiis laboriosam accusantium nam non assumenda est. Doloremque asperiores et dicta perspiciatis. Adipisci expedita et et error libero ipsa. Possimus rerum magnam quia.','67','2000-11-19 11:04:19','1974-05-28 12:24:19'),
('251','65','5','assumenda','Nesciunt corrupti asperiores sint ut unde distinctio rerum. Magni natus autem nihil aperiam eum voluptatem. Reprehenderit natus molestias recusandae ut harum accusamus quam. Vel veniam fugiat dolores.','55','2003-02-03 20:30:54','1970-04-24 20:30:45'),
('252','46','8','id','Aut libero repellendus ipsam debitis repellat vel officia autem. Ipsum esse et qui ipsa facilis. Eum voluptatem quidem velit ut.','9','2008-01-23 22:54:47','2019-12-25 15:29:01'),
('253','96','3','distinctio','Aut non repudiandae enim et animi dignissimos. Beatae ducimus tempora reprehenderit quia et. Enim veniam ex aut natus distinctio vel corporis dignissimos. Minima alias commodi voluptas repudiandae saepe in explicabo.','12','1992-06-04 20:24:23','2009-11-08 05:08:33'),
('254','100','5','aut','Assumenda amet deleniti officia eos dolores eius. Voluptatum dolor temporibus recusandae voluptatem. Dignissimos sint quam deleniti nesciunt. Recusandae earum autem qui unde corrupti ab.','14','1982-02-02 18:59:37','2009-01-05 21:54:33'),
('255','15','7','quae','Quis id distinctio eveniet autem architecto. Deserunt est reiciendis accusamus ut quae. Libero reprehenderit necessitatibus exercitationem enim in. Quaerat ex voluptatem laboriosam nisi.','59','2011-07-20 15:31:53','1970-03-30 08:13:00'),
('256','91','14','qui','Laborum aut velit consequuntur incidunt sit officiis. Sunt ducimus veniam maxime optio saepe est. Beatae reprehenderit quia voluptatem cumque recusandae quas. Qui dolores sunt tempore.','17','1998-10-16 14:20:37','1972-01-20 03:45:08'),
('257','11','3','nihil','Inventore provident sunt mollitia ut. Maiores temporibus ipsam non qui. Qui et aut rerum molestiae.','8','1984-04-26 17:10:20','1970-04-22 19:25:57'),
('258','65','10','et','Ad asperiores a molestiae quos. Qui nesciunt non praesentium placeat tempore nam a. Illo corrupti nihil sed et fuga laborum. Eveniet enim delectus nostrum nam.','48','2007-09-06 07:53:47','2002-02-08 15:30:42'),
('259','32','15','sit','Alias nemo labore officia sed. Illo rerum qui eum numquam corporis. Omnis hic facilis sit et ducimus laborum. Adipisci rerum iusto ad harum eveniet adipisci eius est.','63','1976-01-28 12:39:23','1986-09-17 20:21:24'),
('260','26','2','eum','Et sapiente non incidunt in. Nobis quo ex nobis enim blanditiis doloribus. Sit sunt qui suscipit.','16','1987-05-15 20:16:27','1981-03-17 07:00:37'),
('261','93','15','ipsum','Quisquam odio delectus placeat recusandae officia qui eos veniam. Deserunt consequatur qui temporibus et. Voluptatem accusantium est harum tempore cumque similique nemo.','40','2018-10-11 03:24:00','1988-12-03 04:26:03'),
('262','47','4','quaerat','Odio et molestias adipisci. Quo cumque ex inventore ex. Quia maiores autem et quis. Ut nihil sunt odio qui facilis.','79','1989-10-25 02:19:28','1973-10-26 17:43:01'),
('263','55','3','dolor','Doloribus ea fugit dolorem corporis. Consequatur aliquid odio dignissimos eligendi ipsam eaque alias alias.','90','1975-12-08 09:31:03','1986-06-14 02:09:32'),
('264','67','3','a','Aliquid consectetur aut distinctio. Voluptatem nemo quasi consequatur. Quam voluptatem dolorem temporibus omnis qui.','11','1972-11-21 19:23:14','1985-10-01 02:58:55'),
('265','80','6','impedit','Id ea maiores vitae quae facere culpa. Omnis dicta autem corrupti ipsa. Ipsum dolorem omnis harum tempora minus quia dolorem. Omnis omnis quia nihil eos autem.','46','1980-10-22 21:42:13','1978-07-09 05:50:26'),
('266','39','4','repellendus','Qui velit amet quam aliquam possimus cum voluptas eligendi. Itaque omnis nemo ut. Molestiae quod amet rem consequatur.','14','2003-07-16 04:08:26','2019-07-11 07:35:22'),
('267','55','6','inventore','Minima in autem asperiores pariatur veniam soluta. Dolore nisi sint atque voluptatem quis aut consequatur nostrum. Numquam est expedita facilis vel.','24','1983-05-13 06:45:49','2014-05-21 20:35:57'),
('268','63','19','est','Voluptatem dolore voluptas excepturi id unde beatae. Sed dolores ut beatae neque. Culpa hic et quia commodi.','71','2012-12-11 23:28:06','1983-03-05 02:13:39'),
('269','10','5','est','Amet sed excepturi quibusdam adipisci est vero nihil. Perferendis qui officiis veritatis odit nobis. Consequatur laborum architecto incidunt velit. Eum in consequuntur impedit amet.','42','2006-12-25 17:07:20','1987-04-08 15:15:15'),
('270','73','11','quasi','Voluptates voluptatum id sit repellat. Maxime quos velit molestiae vel. Cumque odio eaque ducimus sint maiores. Est assumenda nihil dicta.','49','1982-12-18 21:10:12','2000-09-04 16:24:15'),
('271','88','9','ipsam','Quam et ut nesciunt repellendus dignissimos nam. Repudiandae libero voluptatem non occaecati veniam tempore eum. Corporis omnis sit consequatur dolor hic ut.','21','2013-11-13 01:15:53','2007-09-01 18:37:20'),
('272','28','18','et','Voluptatum asperiores molestiae occaecati iusto maxime distinctio. Voluptatum minus recusandae facere quo sit libero vel. Nihil sed quidem saepe labore repudiandae vel voluptatem.','38','1994-10-05 00:47:23','1986-02-22 02:33:12'),
('273','6','9','fuga','Consequatur nisi fugit veritatis earum explicabo. Et et neque perspiciatis illo. Quis explicabo repellat non corrupti et veniam.','52','2011-12-07 02:38:27','2001-03-15 23:21:10'),
('274','95','3','quas','Eligendi cupiditate repellendus recusandae excepturi est quibusdam. Facere suscipit et voluptas et corrupti quibusdam. Aliquam natus molestias aut et ut placeat blanditiis qui. Perferendis sit quis commodi voluptas.','64','1983-06-22 00:03:33','1977-08-12 09:55:40'),
('275','6','19','aut','Soluta qui soluta nemo quam ut exercitationem. Officia ut deserunt odit. Sed rerum qui voluptate autem sint.','91','1976-04-16 07:39:18','1989-11-26 08:01:11'),
('276','52','6','eum','Vel aut reprehenderit minus doloremque. Ullam est et et qui quisquam necessitatibus explicabo optio. Id repellendus eos omnis qui aliquid minima modi qui. Et eligendi quis unde in et nobis ut.','9','2007-10-02 10:09:15','1985-08-14 03:38:32'),
('277','65','17','id','Natus dolores voluptate laudantium et cumque. Nisi et perspiciatis ducimus eum saepe.','37','1988-07-12 20:54:04','2011-05-17 12:42:14'),
('278','89','9','voluptas','Odit laudantium omnis nihil odio quas nam. Commodi dolore temporibus accusantium dolor. Officia non minima commodi nihil ipsa.','29','1987-08-03 20:54:47','2001-12-04 20:44:37'),
('279','59','11','vel','Rerum accusamus amet porro molestiae et tempora enim molestiae. Sed et et veniam id voluptatum sequi. Totam deleniti adipisci eligendi animi est.','54','1983-11-09 19:43:06','1978-06-19 04:52:31'),
('280','100','6','error','Sit sunt sapiente rerum modi. Molestiae adipisci modi fuga et. Quas et vel a consequatur sequi. Molestias aperiam a sint quas commodi. Vel aspernatur cupiditate officiis incidunt aut unde blanditiis aliquam.','5','2006-10-30 02:29:25','1971-06-27 07:41:17'),
('281','49','3','est','Consequatur ea pariatur aperiam totam. Sed distinctio provident harum consectetur et iure. Facilis et ut ad modi aperiam placeat soluta.','48','2004-11-11 07:53:48','1977-03-21 14:41:15'),
('282','69','9','voluptas','Accusantium pariatur ratione veritatis qui perferendis aliquid. Rerum sint architecto sint odit culpa. Quaerat molestias provident earum molestiae maxime omnis.','37','2001-08-26 03:06:23','2005-02-07 01:36:11'),
('283','7','10','ut','Excepturi sit voluptas repellat cupiditate. Vel illo et a et dolorum vero atque. Voluptatem assumenda itaque voluptatem est asperiores nesciunt architecto.','82','1984-06-16 03:48:58','2020-03-18 14:52:31'),
('284','58','9','asperiores','Similique et harum a qui sequi corporis. Iure nisi laborum possimus et qui explicabo enim. Occaecati non est repellat error animi.','93','1995-06-30 13:51:41','1987-12-31 14:01:35'),
('285','21','10','magni','Non ea quisquam aut velit aut. Fugit qui nostrum recusandae eligendi praesentium est. Voluptatem delectus in consequatur non. Natus repudiandae eveniet minus quae.','83','2005-04-29 00:08:49','1999-05-03 05:07:44'),
('286','12','20','dolor','Adipisci odio ab minima placeat. Perferendis harum ut molestias corrupti occaecati deleniti dolorum. Laudantium quod quasi error et quos voluptate. Praesentium magnam aut totam et alias.','11','2006-09-22 05:42:50','1993-11-26 05:45:08'),
('287','20','13','dicta','Est rem numquam sunt nulla nesciunt dolorum. Eos quae dolorum cumque labore. Officiis optio id nobis molestiae. Error culpa nihil sed non.','94','1986-05-31 20:48:55','1998-09-30 10:20:47'),
('288','56','11','occaecati','Inventore eaque ut sit adipisci accusantium. Et a culpa qui minus ea. Rem et blanditiis consequatur amet error quaerat. Cum perferendis neque corporis provident debitis est.','39','1993-08-05 18:59:09','2018-10-21 01:40:34'),
('289','85','3','sed','Corporis quidem tenetur impedit molestiae perspiciatis. Nesciunt molestias voluptas quisquam quidem. Deserunt qui minima quas neque et dolorum nemo numquam.','94','2008-02-15 09:12:45','1993-06-13 18:08:25'),
('290','39','3','earum','Doloribus id perspiciatis ratione dicta ratione laborum dolorem. In impedit rerum et eum.','21','1995-04-11 06:00:12','2006-09-01 09:33:06'),
('291','43','13','sit','Aliquid et id eos corrupti. Neque voluptatem rerum sint omnis ut voluptatum ea. Officiis officia qui eos perspiciatis.','35','1973-01-19 00:33:10','1991-03-28 02:41:04'),
('292','90','6','aut','Odio incidunt velit alias. Repellat odio esse officia. Rerum adipisci quisquam alias. Tempore repellat similique eum cupiditate quibusdam vitae sapiente. Dolore modi ratione voluptatem provident et fugiat.','77','1991-02-28 23:30:03','1984-01-15 18:04:47'),
('293','27','8','inventore','Rerum magni dolorem culpa rerum ad est. Eum itaque repellat iure necessitatibus.','24','1976-02-07 17:59:17','2015-02-15 07:33:04'),
('294','8','19','et','Dolor est in numquam ut. Laudantium odit repudiandae enim illo non suscipit atque. Debitis earum sed voluptatem sint quas.','67','2004-12-17 12:23:33','1976-11-14 02:33:33'),
('295','100','3','nisi','Cupiditate aut rerum hic autem occaecati aut. Quasi et nihil accusantium. Non excepturi vel atque iusto eaque ut earum. Neque et recusandae commodi corrupti quis minus.','15','1975-11-16 23:45:39','2003-11-01 22:24:12'),
('296','83','6','dolor','Non laboriosam officia eveniet sint nobis nihil odit molestias. Et quia sapiente aut non similique nam error repellat. Beatae enim in vitae voluptas animi ea. Dignissimos commodi qui temporibus quis cumque a alias.','15','2010-05-31 07:01:58','1988-12-05 03:01:32'),
('297','93','9','quisquam','Voluptatibus in voluptatem qui dignissimos. Quasi totam quo inventore quos maxime distinctio. Maxime aperiam exercitationem ex et veniam perspiciatis architecto quo.','80','2007-08-20 08:30:48','2008-08-22 00:45:58'),
('298','87','1','tenetur','Voluptas sit quo quidem ut consequuntur fuga quos. Culpa accusamus omnis illo consequatur molestias inventore. Nihil aut voluptatibus aut.','33','2013-05-20 05:02:13','1970-09-23 14:50:11'),
('299','25','18','eius','Rerum repellat aut voluptatibus consequatur similique. In nemo sequi dolorum fuga. Est ut incidunt vero aut nihil eaque. Molestiae nesciunt quam ab eum quaerat.','45','2000-02-19 17:22:24','1989-09-22 17:35:30'),
('300','19','5','voluptatem','Aliquam rerum perspiciatis in delectus incidunt corrupti odio. Illo id eos aut consequatur reiciendis ut.','58','2007-07-01 05:23:10','2005-02-26 06:59:09'); 

UPDATE posts SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;   

SELECT * FROM posts;

-- Задание 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

SELECT user_id, COUNT(*) AS likes 
  FROM likes 
    WHERE user_id IN (SELECT user_id FROM profiles ORDER BY birthday DESC)
    AND target_type_id = (SELECT id FROM target_types WHERE name = 'users')
    GROUP BY user_id LIMIT 10;
  
-- Задание 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
  (SELECT gender FROM profiles p WHERE p.user_id = l.user_id ) AS gender,
  COUNT(*) likes
FROM likes l
  GROUP BY gender
  ORDER BY likes DESC
  LIMIT 1;
 
-- Задание 5. Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

-- КРИТЕРИИ: Найти общую сумму количества написанных постов, написанных сообщений, поставленных лайков. Чем больше сумма, тем активнее юзер.

SELECT
  id,
  -- Сумма количеств всех видов активностей: 
  ((IF((SELECT COUNT(*) FROM likes l GROUP BY user_id HAVING l.user_id = u.id) > 0, (SELECT COUNT(*) FROM likes l GROUP BY user_id HAVING l.user_id = u.id), 0)) + -- Количество лайков юзера
  (IF((SELECT COUNT(*) FROM messages m GROUP BY from_user_id HAVING m.from_user_id = u.id) > 0, (SELECT COUNT(*) FROM messages m GROUP BY from_user_id HAVING m.from_user_id = u.id), 0)) + -- Количество сообщений, отправленных юзером
  (IF((SELECT COUNT(*) FROM posts p GROUP BY user_id HAVING p.user_id = u.id) > 0, (SELECT COUNT(*) FROM posts p GROUP BY user_id HAVING p.user_id = u.id), 0))) AS summa -- Количество постов, созданных юзером
FROM
  users u
ORDER BY summa LIMIT 10;



