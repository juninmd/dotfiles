# Mysql

## Reset MYSQL

```shell

sudo mysql -u root

DROP USER 'root'@'localhost';

CREATE USER 'root'@'%' IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SELECT User,Host FROM mysql.user;

mysql -u root
```
