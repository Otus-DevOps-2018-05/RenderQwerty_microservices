 # Homework 19 - monitoring-2
  #### Основное задание
  - Т.к. мы разделили сервисы приложения и сервисы мониторинга на разные compose файлы, то необходимо создать общие сети вручную и отметить их как 'external' в файлах docker-compose:
    -   ```docker network create --subnet 10.0.2.0/24 backend && docker network create --subnet 10.0.1.0/24 frontend```
  ### Задания со *:
  #### В Makefile добавлены новые сервисы
  #### Добавить сбор метрик, отдаваемых докер демоном в prometheus:
   - Думал как лучше сделать, чтобы достучатся до хоста из контейнера с прометеем. Решил сделать ещё одну сеть, в которой явно задал адрес gateway:    
      - ``` docker network create --subnet 10.0.3.0/30 --gateway 10.0.3.1 hostnet ```
      
        Эту сеть добавляем как external в docker-compose-monitoring.yml и подключаем к контейнеру с прометеем. Также необходимо добавить правило файрвола, которое разрешает подключение к хосту c интерфейса сети hostnet - ``` sudo firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 4 -i br-14d3a37d8190 -j ACCEPT && sudo firewall-cmd --reload ```

        В /etc/docker/daemon.json задаём адрес интерфейса в созданной сети, на котором будет доступен просмотр метрик - 10.0.3.1  (чтобы порт был доступен только для одной сети )
  #### Сбор метрик через telegraf
   - Изначально поднял контейнер с telegraf и забирал метрики в прометей, но не нашёл нормальных дашбордов для графаны в такой связке. Потому добавил ещё контейнер с influxdb, в которую telegraf отправляет метрики. И в графане подключил influxdb как datasource. Дашборд положил в 'monitoring/grafana/dashboards/docker-metrics-per-container.json'

 # Homework 18 - monitoring-1
 #### Основное задание
 - [Ссылка на Dockerhub](https://hub.docker.com/r/jaels/)
  ### Задания со *:
  #### Мониторинг mongodb через экспортер:
  - Нашёл в сети и форкнул к себе [проект с эскпортером](https://github.com/RenderQwerty/docker-mongodb-exporter)
    Настроил [автобилд в Docker Hub](https://hub.docker.com/r/jaels/docker-mongodb-exporter/) и подключил контейнер в docker/docker-compose.yml
  #### Blackbox мониторинг через cloudprober:
  - Сделал [кастомный образ](https://hub.docker.com/r/jaels/cloudprober/) с [своим конфигом](https://github.com/RenderQwerty/cloudprober/blob/master/cloudprober.cfg).
  Хотелось бы большего, но документация на этот проект отсутсвует чуть менее, чем полностью.

 # Homework 17 - gitlab-ci-2
  ### Задание со * - в процессе, будет доработано позже
```Для того, чтобы обеспечить доступ к динамически созданным окружениям из gitlab, понадобится DNS сервер, на котором будут автоматически создаваться A записи для новых инстансов.
        1. Создаём зону: gcloud dns --project=docker-123456 managed-zones create express42 --description=For\ homeworks --dns-name=fisakov.ppl33-35.com.
        2. Добавляем A запись для gitlab сервера:
          2.1 gcloud dns --project=docker-211515 record-sets transaction start --zone=express42
          2.2 gcloud dns --project=docker-211515 record-sets transaction add 35.204.88.22 --name=gitlab.fisakov.ppl33-35.com. --ttl=300 --type=A --zone=express42
          2.3 gcloud dns --project=docker-211515 record-sets transaction execute --zone=express42
```
 # Homework 16 - gitlab-ci-1
 - Для упрощения возможных будущих задач по деплою хостов опишем инстансы с предустановленными docker и docker-compose в виде кода:
   - В каталоге gitlab-deploy/packer два шаблона пакера для деплоя инстансов. В `gitlab-ci/packer/docker-host.json` и `gitlab-ci/ansible/playbooks/packer_docker-host.yml` описываем создание gcloud инстанса и провижининга docker в него.
   - Поднимем через скрипт `gitlab-ci/deploy_docker.sh` новый инстанс с предустановленным docker (создаём для этого отдельную внутренюю сеть и назначаем инстансу статический ip, это понадобится для доп. дз). 
      - Опишем провижин omnibus инсталляции gitlab в виде [роли](https://github.com/RenderQwerty/ansible-galaxy-gitlab) и деплоим через плейбук `gitlab-deploy/ansible/gitlab-host.yml` на вышесозданный хост. 

 ### Задание со *
Продумайте автоматизацию развертывания и регистрации Gitlab CI Runner.
  - Тут можно пойти несколькими вариантами:
      1. Частично ручная выкатака нового инстанса с раннером через любую утилиту ( gcloud, terraform, etc... ).
      2. Использовать автоскейлинг через раннер с docker+machine executor'ом, который будет спавнить новые раннеры.
      3. Использовать instance groups с автоскейлингом по ресурсам.

    Дабы секономить время, пойду по первому варианту:
      - Снова используем ранее подготовленный образ с предустановленным docker'ом и ансиблом как базовый и создаём инстанс, которому в качестве стартап скрипта передаём команду загрузки ansible плейбука с инструкциями по развёртыванию gitlab раннера - `gitlab-ci/deploy_runner.sh`. Сам плейбук тоже разместим в отдельном config репозитории на этом gitlab сервере. Через этот-же startup скрипт локально (по отношению к свежесозданному инстансу) выполняется ansible плейбук ([пример](https://gist.github.com/RenderQwerty/54e89b953edb2b4b4c041a1d69ea4169)) и стартует docker контейнер с раннером, который регистрируется на сервере gitlab.

Настройте интеграцию вашего Pipeline с тестовым Slack-чатом, который вы использовали ранее.
  - [Ссылка](https://devops-team-otus.slack.com/messages/CB46XSULT) на slack канал с нотификациями от gitlab
 # Homework 15 - docker-4
 - Задание 1: указал в .env файле композа используемые версии образов и проброшенный порт веб-сервиса. Также задал стандартные значения переменных, которые будут использоваться в том случае, если отсутсвует .env файл. 
 - Имя контейнера в docker-compose по умолчанию генерируется из имени каталога, в котором размещён docker-compose.yml, имени сервиса и постфикса с кол-вом инстансов одного сервиса. Изменить префикс имени можно, задав значение переменной `COMPOSE_PROJECT_NAME` или через флаг `-p`. Имя контейнера можно переопределить через параметр `container_name: someName`. Но в таком случае, контейнер будет именоваться без префикса COMPOSE_PROJECT_NAME. Это может добавить смуты и посеять панику в том случае, если на сервере запущено множетсво контейнеров из разных compose проектов. Чтобы этого избежать и не потерять привязки к COMPOSE_PROJECT_NAME в том случае, если всё-таки по каким-то неизвестным необходимо указать кастомное имя контейнера вместо имени сервиса, то можно в docker-compose.yml сгенерировать `containter_name` из переменной COMPOSE_PROJECT_NAME + myCustomName: `container_name: "${COMPOSE_PROJECT_NAME}_myCustomName"`.
 ### Задание со *
 Создайте docker-compose.override.yml для reddit проекта, который позволит:
   - Изменять код каждого из приложений, не выполняя сборку образа
      - Описал в docker-compose.override.yml переопределение entrypoint для puma приложений, чтобы запустить их с флагами debug & worker
   - Запускать puma для руби приложений в дебаг режиме с двумя воркерами (флаги --debug и -w 2)
      - Убрал из Dockerfil'ов приложений шаг с копированием кода приложений, чтобы подключать его через mount. Определил bind-mounts в docker-compose.override.yml.

 # Homework 14 - docker-3
 ### Задание со * 
   -
      Запускаем контейнеры с другими алиасами и переопределяем переменные окружения при запуске контейнера:
```
          docker run -d --network=reddit --network-alias=db mongo:latest
          docker run -d --network=reddit --network-alias=post1 \
            -e "POST_DATABASE_HOST=db" \
            jaels/post:1.0

          docker run -d --network=reddit --network-alias=comment1 \
            -e "COMMENT_DATABASE_HOST=db" \
            jaels/comment:1.0

          docker run -d --network=reddit -p 9292:9292 \
            -e "POST_SERVICE_HOST=post1" \
            -e "COMMENT_SERVICE_HOST=comment1" \
            jaels/ui:1.0
```
  - С образом alpine (ui/Dockerfile.1) получилось получилось уменьшить размер ui c 397 до 219 MB.

 # Homework 13 - docker-2
 - В случае запуска docker контейнера с аргументом `--pid host` мы запускаем контейнер в неймспейсе нашей локальной машины, и таким образом предоставляем процессам внутри контейнера доступ к процессам хоста. 
  ### Задание со * 
 - В директорию `docker-monolith` добавлены шаблоны инфраструктуры для gcloud проекта 'docker'. (Дальнейшие инструкции выполняются относительно каталога docker-monolith).
   - Cкриптом `config/gcloud.sh` добавляем в метаданные нового проекта публичный ключ пользователя и создаём правило firewall, разрешающее входящие подключения по ssh для провижинеров packer.
   - Из каталога ansible загружаем зависимые роли `ansible-galaxy install -r environments/stage/requirements.yml`
   - Собираем через packer и ansible provisioner образ с установленным docker и необходимым python модулем: `packer build -var-file=packer/variables.json packer/docker-host.json`.
   - С помощью terraform создаём пул инстансов (кол-во которых определяется переменной `instance_count`) на основе ранее собранного образа и добавляем правило пересылки.
 - Итого у меня получилось 2 плейбука: `packer_docker-host.yml` для сборки пакером инстанса с установленным docker и `docker-host.yml`, который запускает контейнер из нашего образа с докерхаба. Отдельный плейбук для установки докера на чистый поднятый инстанс уже не стал делать ( т.к. он всё равно бы отличался от плейбука `docker-host.yml` только вызовом роли установки docker и python модуля).

 # Homework 12 - docker-1
 - Установлен docker и протестирован его успешный запуск
 - Разобраны методы управления состоянием и статусом контейнеров.
 ### Задание со *
 - Добавил в docker-monolith/docker-1.log описание разницы между контейнером и образом.
