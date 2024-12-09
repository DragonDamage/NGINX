# NGINX instruction:

> Установка на Centos:
```bash
yum install epel-release # Скачивание репозитория для модулей nginx
yum install nginx        # Скачивание и установка nginx
service nginx status     # Проверяем статус сервиса
service nginx start      # Стратуем сервис
```

> Установка из исходного кода:
```bash
sudo apt-get upgrade
wget https://nginx.org/download/nginx-1.23.2.tar.gz
tar -zxvf nginx-1.23.2.tar.gz
sudo apt-get install libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev
# далее нужно будет установить зависимости вручную
```

> Установка на Ubuntu:
```bash
sudo apt-get install nginx  # Скачивание и установка nginx
systemctl status nginx      # Проверяем статус сервиса
ls -l /etc/nginx/           # Конфиги nginx
ip -c a                     # Смотрим свой айпишник и вбиваем его на локалхосте в браузере
```

> Command:
```bash
nginx -t                    # Проверка работоспособности nginx
nano /etc/nginx/nginx.conf  # Основной конфигурационный файл nginx 
```
> Nginx configure
```bash
events {}


http {
# инклюд - берём из файла
  include mime.types;

  server {
# какой порт слушаем, имя сервера, папка с внутренностями сайта
    listen 80;
    server_name 192.168.52.131;
    root /home/web/sites/bootstrap;
# обычный префиксный локейшн
    location / {
      return 200 'block location Andrey';
    }
# совпадение или с продолжением (return 200 вернуть ответ на экран)
    location /pages {
      return 200 'block location Andrey';
    }
# точное совпадение
    location = /pages {
      return 200 'block location Andrey';
    }
# приоритетный локейшн отменяющий regex
    location ^~ file.txt {
      return 200 'this is priority location';
    }
# локейшн (regex) регулярка без учета регистра
    location ~* \.(txt|svg|jpg|jpeg|png)$ {
      root /var/www/html;
    }
# локейнш (regex) регулярка с учетом регистра
    location ~ bak\.(TxT|Svg|Jpg|jpeg|png|xml) {
      root /var/www/html;
    }
  }

}

```

```bash
systemctl reload nginx          # Перезагрузить конфиги nginx
systemctl status nginx          # Посмотреть статус сервиса
systemctl restart nginx         # Рестартануть сервис
systemctl start nginx           # Стартануть сервис
--------------------------------------------------------------
sudo apt-get install php-fpm    # Устанавливаем php-fpm
sudo apt-get install php-mysql  # Устанавливаем php-mysql
sudo apt-get install php        # Устанавливаем php
sudo apt-get install php-cgi    # Устанавливаем php-cgi
```
