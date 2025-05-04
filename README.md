# Домашнее задание к занятию 1 «Disaster recovery и Keepalived» - `Иншаков Владимир`

### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

------

### Решение 1

Скриншоты:

![Screen1](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen1_1.png)
![Screen2](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen1_2.png)

Доработанная схема для CPT:
(https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/files/Exercise1.pkt)



### Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

### Решение 2

Отслеживать состояние и переключения в работе Master <-> Bacup буду при помощи утилиты journalctl.
Начальное состояние и настройка IP адресов представлена на первом скриншоте.

Скриншоты:

![Screen1](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_1.png)
![Screen2](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_2.png)
![Screen3](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_3.png)
![Screen4](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_4.png)
![Screen5](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_5.png)
![Screen6](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_6.png)
![Screen7](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/screenshots/Screen2_7.png)


Файл скрипта для проверки доступности порта web-сервера и файла index.html на основной машине (192.168.1.133):
[script](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/files/script_exercise2.sh)

```
#!/bin/bash
nc -z 192.168.1.133 80 && test -f /var/www/html/index.nginx-debian.html
```

Конфигурационный файл для сервиса keepalived:
[config file](https://github.com/MrVanG0gh/Netology_sflt_01/blob/main/files/keepalived.conf)


```
vrrp_script check_script {
        script  "/home/van/script_exercise2.sh"
        interval 3 # 3 sec interval
        fall 2 # 2 times to match before switching
        rise 2 # 2 times to match before switching back
}

vrrp_instance VI_1 {
        state MASTER
        interface ens160
        virtual_router_id 222
        priority 255
        advert_int 1

        virtual_ipaddress {
              192.168.1.222/24
        }
        track_script {
                check_script
        }
}

```
