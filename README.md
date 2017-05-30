# deamon
service for linux

Поместить deamon.sh в /etc/init.d

Дать право на выполнение chmod +x deamon.sh

Добавить в автозагрузку
chckonfig --add deamon.sh
chkconfig --level 35 deamon on
