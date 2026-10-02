echo "Running the init.sh - Create Databases "

cat > /tmp/db.sql <<EOF
  
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';

-- changing the mysql root password.
ALTER USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- piwigo
CREATE DATABASE dbpiwigo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'usrpt'@'localhost' IDENTIFIED BY '${USER_PIWIGO_PASSWORD}';
CREATE USER 'usrpt'@'%' IDENTIFIED BY '${USER_PIWIGO_PASSWORD}';
GRANT ALL PRIVILEGES ON dbpiwigo.* TO 'usrpt'@'%';
FLUSH PRIVILEGES;

-- wordpress
CREATE DATABASE dbwp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'usrwp'@'localhost' IDENTIFIED BY '${USER_WP_PASSWORD}';
CREATE USER 'usrwp'@'%' IDENTIFIED BY '${USER_WP_PASSWORD}';
GRANT ALL PRIVILEGES ON dbwp.* TO 'usrwp'@'%';
FLUSH PRIVILEGES;

-- webtrees
CREATE DATABASE dbwt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
CREATE USER 'usrwt'@'localhost' IDENTIFIED BY '${USER_WT_PASSWORD}';
CREATE USER 'usrwt'@'%' IDENTIFIED BY '${USER_WT_PASSWORD}';
GRANT ALL PRIVILEGES ON dbwt.* TO 'usrwt'@'%';
FLUSH PRIVILEGES;

-- roundcubemail
CREATE DATABASE dbrcm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'usrrcm'@'localhost' IDENTIFIED BY '${USER_RCM_PASSWORD}';
CREATE USER 'usrrcm'@'%' IDENTIFIED BY '${USER_RCM_PASSWORD}';
GRANT ALL PRIVILEGES ON dbrcm.* TO 'usrrcm'@'%';
FLUSH PRIVILEGES;
  
EOF

mysql -uroot  < /tmp/db.sql
