@echo off
chcp 65001 > nul
title Модуль 2: Инспекция облачного кода (Code Review)

set correct=0
set points=0
set total=4

echo ========================================================
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА (ОБЛАЧНАЯ ИНФРАСТРУКТУРА)
echo ========================================================
echo За каждый правильный ответ: +10 очков. За ошибку: -5 очков.
echo.

echo --- Фрагмент 1 (Загрузка бэкапа в Object Storage S3) ---
echo 10: def upload_backup(bucket_name, file_path):
echo 11:     s3_client = boto3.client('s3')
echo 12:     s3_client.upload_file(file_path, bucket_name, 'backup.tar.gz')
echo 13:     return True
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число
echo 2. Отсутствие обработки ошибок (нет try/except при сбое сети или API)
echo 3. Неинициализированная переменная
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel==3 goto f1_wrong
if errorlevel==2 goto f1_right
if errorlevel==1 goto f1_wrong

:f1_right
echo [+] Верно! Сетевой запрос в облако может упасть с ошибкой ClientError.
set /a correct+=1
set /a points+=10
goto f2

:f1_wrong
echo [-] Неверно. Правильный ответ: 2 (отсутствие обработки ошибок).
set /a points-=5

:f2
echo.
echo --- Фрагмент 2 (Автомасштабирование инстансов стартапа) ---
echo 20: def check_scaling(cpu_load, current_nodes):
echo 21:     if cpu_load ^> 78.5 and current_nodes ^< 12:
echo 22:         provision_new_vm(flavor="s2.medium")
echo 23:         return True
echo 24:     return False
echo.
echo Какой дефект здесь скрыт?
echo 1. Магические числа (78.5 и 12 зашиты в логику без констант)
echo 2. Утечка ресурса
echo 3. Мёртвое присваивание
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel==3 goto f2_wrong
if errorlevel==2 goto f2_wrong
if errorlevel==1 goto f2_right

:f2_right
echo [+] Верно! Порог CPU (78.5) и лимит нод (12) нужно вынести в конфиг.
set /a correct+=1
set /a points+=10
goto f3

:f2_wrong
echo [-] Неверно. Правильный ответ: 1 (магические числа).
set /a points-=5

:f3
echo.
echo --- Фрагмент 3 (Подключение к облачной БД PostgreSQL) ---
echo 30: def fetch_active_users(dsn):
echo 31:     conn = psycopg2.connect(dsn)
echo 32:     cursor = conn.cursor()
echo 33:     cursor.execute("SELECT count(*) FROM users WHERE active=true")
echo 34:     return cursor.fetchone()
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная
echo 2. Утечка ресурса (соединение с облачной БД не закрывается)
echo 3. Магическое число
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel==3 goto f3_wrong
if errorlevel==2 goto f3_right
if errorlevel==1 goto f3_wrong

:f3_right
echo [+] Верно! Без conn.close() или блока with исчерпается лимит подключений.
set /a correct+=1
set /a points+=10
goto f4

:f3_wrong
echo [-] Неверно. Правильный ответ: 2 (утечка ресурса).
set /a points-=5

:f4
echo.
echo --- Фрагмент 4 (Расчет стоимости трафика CDN) ---
echo 40: def calc_cdn_cost(gb_used, price_per_gb):
echo 41:     base_fee = 500
echo 42:     total = gb_used * price_per_gb
echo 43:     return total
echo.
echo Какой дефект здесь скрыт?
echo 1. Утечка ресурса
echo 2. Отсутствие обработки ошибок
echo 3. Мёртвое присваивание (переменная base_fee объявлена, но не используется)
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel==3 goto f4_right
if errorlevel==2 goto f4_wrong
if errorlevel==1 goto f4_wrong

:f4_right
echo [+] Верно! Переменная base_fee объявлена, но нигде не участвует в расчёте.
set /a correct+=1
set /a points+=10
goto report2

:f4_wrong
echo [-] Неверно. Правильный ответ: 3 (мёртвое присваивание).
set /a points-=5

:report2
if %points% lss 0 set points=0
set /a percentage=correct*100/total

if %percentage% geq 75 (
    set "reviewer_level=Senior Reviewer"
) else if %percentage% geq 50 (
    set "reviewer_level=Middle Reviewer"
) else (
    set "reviewer_level=Junior Reviewer"
)

echo.
echo ========================================================
echo   ИТОГОВЫЙ ОТЧЕТ МОДУЛЯ 2 (CODE REVIEW)
echo ========================================================
echo Просмотрено фрагментов : %total%
echo Правильных ответов     : %correct% из %total%
echo Набрано очков          : %points%
echo Точность               : %percentage%%%
echo Уровень ревьюера       : %reviewer_level%
echo ========================================================
echo.
if "%1" neq "auto" pause