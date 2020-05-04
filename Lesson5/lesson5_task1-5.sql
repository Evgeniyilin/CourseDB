-- Задание 1

UPDATE
  users 
SET
  created_at = NOW(),
  updated_at = NOW();
  
-- Задание 2

SELECT
  STR_TO_DATE('20.10.2017 8:10', '%d.%m.%Y %k:%i') datatime; -- Тест

DROP TABLE IF EXISTS test_users;
CREATE TABLE test_users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
);

INSERT INTO test_users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2017 8:10', '20.10.2017 8:10');

SELECT * FROM test_users;
 
UPDATE
  test_users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'), 
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

SELECT * FROM test_users;
 
DESC test_users;
 
ALTER TABLE
  test_users
MODIFY
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
 
ALTER TABLE
  test_users
MODIFY  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESC test_users;

DROP TABLE IF EXISTS test_users;

-- Задание 3 
-- В таблице складских запасов storehouses_products в поле 
-- value могут встречаться самые разные цифры: 0, если товар закончился 
-- и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке 
-- увеличения значения value. Однако, нулевые запасы должны выводиться в конце, 
-- после всех записей.

SELECT * FROM storehouses_products;

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);

SELECT
  *
FROM 
  storehouses_products
ORDER BY
  IF (value > 0, 0, 1),
  value;

-- Так и не понял, где мы такому научились в 5 уроке. Смысл, ПРИМЕРНО понял в разборе ДЗ.
-- На самом деле синтаксис ORDER BY не совсем ясен,
-- С конструкцией IF и ее условиями понятно,
-- а вот потом ",value" дает результат, но совсем не очевидный и в разборе не сильно объяснено.
-- Пробовал без ",value", нулевые значения всё равно в конце, хотя в разборе сказано что именно 
-- эта часть кода отвечает за нулевые значения в конце сортировки...

 
