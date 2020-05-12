-- ������� 1: ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.

SELECT users.id, users.name, users.birthday_at
  FROM users
   JOIN orders
     ON users.id = orders.user_id;
    

-- ������� 2. �������� ������ ������� products � �������� catalogs, ������� ������������� ������.

SELECT  products.name, catalogs.name catalogs
  FROM products
    LEFT JOIN catalogs
      ON products.catalog_id = catalogs.id;
