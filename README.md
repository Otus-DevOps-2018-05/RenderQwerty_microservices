 # Homework 16 - gitlab-ci-1
 - Для упрощения возможных будущих задач по деплою хостов опишем поднятия инстансов с предустановленным docker & docker-compose в виде кода:
   - В каталоге gitlab-deploy/packer два шаблона пакера для деплоя инстансов. В `gitlab-ci/packer/docker-host.json` и `gitlab-ci/ansible/docker-host.yml` описываем создание gcloud инстанса и провижининга docker в него.
   - Поднимем через скрипт `gitlab-ci/deploy_docker.sh` новый инстанс с предустановленным docker. 
 - Опишем провижин omnibus инсталляции gitlab в виде [роли](https://github.com/RenderQwerty/ansible-galaxy-gitlab) и запустим через плейбук `gitlab-deploy/ansible/gitlab-host.yml`
   - Также описываем провижин gitlab-runner'a - `gitlab-ci/ansible/playbooks/gitlab-runner.yml`
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
