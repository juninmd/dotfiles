# Mysql

## Reset MYSQL

```shell
sudo apt update
sudo apt install mysql-server

--

sudo mysql -u root

use mysql

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SELECT User,Host FROM mysql.user;

```
