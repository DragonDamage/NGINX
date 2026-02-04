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

# Полноценный пример NGINX на практике
#### 1. Дерево
`bogatyrevam@domain@server_name`

Директория `/nginx`

Команда: `$ tree`
```bash
.
├── conf.d
│   └── default.conf
├── default.conf
├── dockerfile
├── invader.js
└── ssl
    ├── server_name.crt
    ├── server_name.crt.pfx
    ├── server_name.key
    └── server_name.key_without
```

#### 2. Dockerfile
```bash
$ cat nginx/dockerfile
```
```dockerfile
FROM registry.ru/front:{version}

COPY invader.js /app/static/static/js/invader.js

RUN sed -i 's|</body>|<script src="/static/js/invader.js"></script></body>|' /app/static/index.html
```

#### 3. Основной конфиг
```nginx
upstream appconversation {
      server {service}:{port};
}
upstream appback {
      server {service}:{port};
}
upstream authenticator {
      server {service}:{port};
}
upstream authz {
      server {service}:{port};
}
upstream trdparty {
      server {service}:{port};
}

server {
   listen 8080;
   server_name {server_name};
   return 301 https://$host$request_uri;
   location = /test-service {
   return 200 "OK-/test-service";
}
  location =/service-import {
    return 200 "OK-/test-service";
  }
  location =/service-import/ {
    return 200 "OK-/test-service";
  }

server {
   listen 443 default_server ssl;
   server_name {server_name.ru};
   ssl_certificate /etc/nginx/ssl/{server_name}.crt;
   ssl_certificate_key /etc/nginx/ssl/{server_name}.key_without;
   client_header_buffer_size 5120k;
   large_client_header_buffers 16 5120k;
   charset UTF-8;
   log_not_found off;
   access_log /dev/stdout combined;
   error_log /dev/stderr warn;
   root /app/static;
   index index.html;
   location /static {
     if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Credentials' true;
        add_header 'Access-Control-Allow-Origin' $http_origin;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain; charset=utf-8';
        add_header 'Content-Length' 0;
        return 204;
     }
      root /app/static/;
      expires 1y;
      add_header Cache-Control "public";
      access_log off;
   }

   location / {
      if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Credentials' true;
        add_header 'Access-Control-Allow-Origin' $http_origin;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain; charset=utf-8';
        add_header 'Content-Length' 0;
        return 204;
       }
      root /app/static/;
      autoindex off;
      try_files $uri $uri$args $uri$args/ /index.html;
      add_header Cache-Control "no-store, no-cache, must-revalidate";
   }

   location /minio {
        proxy_pass http://minio:9000;
   }

   location /api/{authenticator} {
     proxy_read_timeout 600;
     proxy_connect_timeout 600;
     proxy_send_timeout 600;
     send_timeout 600;
     proxy_pass  http://authenticator;
     proxy_set_header X-Forwarded-For $remote_addr;
     proxy_set_header X-Request-ID $request_id;
     add_header X-Request-ID $request_id;
   }
}
```

#### 4. invader.js
```js
function bindReady(handler){
    var called = false
    function ready() {
        if (called) return
        called = true
        handler()
    }
    if ( document.addEventListener ) {
        document.addEventListener( "DOMContentLoaded", function(){
            ready()
        }, false )
    } else if ( document.attachEvent ) {
        if ( document.documentElement.doScroll && window == window.top ) {
            function tryScroll(){
                if (called) return
                if (!document.body) return
                try {
                    document.documentElement.doScroll("left")
                    ready()
                } catch(e) {
                    setTimeout(tryScroll, 0)
                }
            }
            tryScroll()
        }
        document.attachEvent("onreadystatechange", function(){
            if ( document.readyState === "complete" ) {
                ready()
            }
        })
    }

    if (window.addEventListener)
        window.addEventListener('load', ready, false)
    else if (window.attachEvent)
        window.attachEvent('onload', ready)
    /*  else  // use this 'else' statement for very old browsers :)
        window.onload=ready
    */
}

readyList = []
function onReady(handler) {
    if (!readyList.length) {
        bindReady(function() {
            for(var i=0; i<readyList.length; i++) {
                readyList[i]()
            }
        })
    }
    readyList.push(handler)
}

onReady(function() {
//window.onload = function () {
    function getUserDataSuffixIfExists() {
        function utf8_to_b64(str) {
            return window.btoa(unescape(encodeURIComponent(str)));
        }
        var querySuffix = "?user_data_b64=";
        var maybeUserData = localStorage.getItem("taxmonUserId");
        if (null == maybeUserData) {
            return "";
        }
        var userDataB64 = utf8_to_b64(JSON.stringify(maybeUserData, null, " "));
        return querySuffix + encodeURIComponent(userDataB64);
    }
    function getPrefixLocation() {
                var currentLocation = window.location.toString();
                var locaParts = currentLocation.split('/');
                return locaParts[0] + '/' + locaParts[1] + '/' + locaParts[2];
    }
    function waitElemAndMakeCallback() {
        var elem = document.querySelectorAll("a[href='/xml-import']")[0];
        if ('undefined' == typeof elem) {
            setTimeout(waitElemAndMakeCallback, 200);
            return false;
        }
        elem.onclick = function () {
            window.location.replace(getPrefixLocation() + '/xml-import/Default/Landing' + getUserDataSuffixIfExists());
        };
    }
    waitElemAndMakeCallback();
});
```
