Task 1

evgeniy@evgeniy-System-Product-Name:~$ cat .my.cnf
[client]
user=root
password=987852xxx

Task 3

evgeniy@evgeniy-System-Product-Name:~$ mysqldump example > example.sql
evgeniy@evgeniy-System-Product-Name:~$ mysql -e 'CREATE DATABASE sample'
evgeniy@evgeniy-System-Product-Name:~$ mysql sample < example.sql
evgeniy@evgeniy-System-Product-Name:~$ mysql

mysql> USE sample;
mysql> SHOW TABLES;
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0,00 sec)


