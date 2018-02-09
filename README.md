# deamon
service for linux

Поместить deamon в /etc/init.d

Дать право на выполнение:
`chmod +x deamon.sh`

Добавить в автозагрузку RedHat:
```
chckonfig --add deamon.sh
chkconfig --level 35 deamon on
```

Добавить в автозагрузку Debian
```
update-rc.d deamon defaults 90
```

Запустить:
`/etc/init.d/deamon start`

---

Запуск сервиса:
```
mv /tmp/app.service /etc/systemd/system/app.service
systemctl start app
systemctl enable app
```
