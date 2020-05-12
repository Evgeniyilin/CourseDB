-- Задание 1: Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT users.id, users.name, users.birthday_at
  FROM users
   JOIN orders
     ON users.id = orders.user_id;
    

-- Задание 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT  products.name, catalogs.name catalogs
  FROM products
    LEFT JOIN catalogs
      ON products.catalog_id = catalogs.id;
