NGINX instruction:

Установка на Centos:
yum install epel-release
yum install nginx
service nginx status
service nginx start

Установка из исходного кода:
sudo apt-get upgrade
wget https://nginx.org/download/nginx-1.23.2.tar.gz
tar -zxvf nginx-1.23.2.tar.gz
sudo apt-get install libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev
... # далее нужно будет установить зависимости вручную

Ubuntu:
sudo apt-get install nginx  # установка
systemctl status nginx  # проверить статус
ls -l /etc/nginx/  # конфиги nginx
ip -c a  # смотрим свой айпишник и вбиваем его на локалхосте в браузере


Command:
nginx -t  # проверка nginx
cat /etc/nginx/nginx.conf  # конфиги
sudo nano nginx.conf

# Nginx configure

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


systemctl reload nginx   # перезагрузить каонфиги nginx
systemctl status nginx   # посмотреть статус сервиса
systemctl restart nginx  # рестартануть сервис
systemctl start nginx    # стартануть сервис

sudo apt-get install php-fpm    # устанавливаем php-fpm
sudo apt-get install php-mysql  # устанавливаем php-mysql
sudo apt-get install php        # устанавливаем php
sudo apt-get install php-cgi    # устанавливаем php-cgi

