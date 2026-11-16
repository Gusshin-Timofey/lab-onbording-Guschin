# Лабораторная работа № 2. Моделирование процессов разработки ПО
**Выполнил:** Иванов Иван Иванович  
**Группа:** ИВТ-21  
**Вариант:** 4 (Выбор облачной платформы для стартапа: Yandex Cloud, Selectel, Timeweb Cloud)  
**Ссылка на репозиторий:** https://github.com

---

## 1. Описание модулей и листинг кода

### Модуль 1: Выбор технологий (`chapter1.bat`)
Реализует анкетирование по параметрам MVP стартапа (бюджет, стратегия масштабирования, квалификация команды, сроки). Использует `choice` для считывания ответов и `set /a` для подсчёта баллов профиля.

@echo off
chcp 65001 > nul
title Модуль 1: Выбор облачной платформы для стартапа

set score_yc=0
set score_sel=0
set score_tw=0

echo ========================================================
echo   МОДУЛЬ 1: ВЫБОР ОБЛАЧНОЙ ПЛАТФОРМЫ ДЛЯ СТАРТАПА
echo ========================================================
echo Контекст: MVP веб-приложения с ростом нагрузки.
echo Кандидаты: Yandex Cloud, Selectel, Timeweb Cloud.
echo.

echo Вопрос 1: Какой бюджет заложен на инфраструктуру на этапе MVP?
echo 1. Минимальный (нужен быстрый и дешевый старт без переплат)
echo 2. Средний (оптимальное соотношение цены и выделенных ресурсов)
echo 3. Гибкий (есть грант/инвестиции, важны управляемые PaaS-сервисы)
choice /c 123 /n /m "Выберите вариант (1-3): "
if errorlevel==3 set /a score_yc+=15
if errorlevel==2 set /a score_sel+=15
if errorlevel==1 set /a score_tw+=15
echo.

echo Вопрос 2: Как планируется масштабировать приложение при росте нагрузки?
echo 1. Автоматически через Managed Kubernetes, Serverless и облачные БД
echo 2. Гибридно: облачные серверы + выделенное железо (Bare Metal) под БД
echo 3. Вертикально: простое увеличение тарифа VDS/VPS в пару кликов
choice /c 123 /n /m "Выберите вариант (1-3): "
if errorlevel==3 set /a score_tw+=15
if errorlevel==2 set /a score_sel+=15
if errorlevel==1 set /a score_yc+=15
echo.

echo Вопрос 3: Какая квалификация у команды в вопросах DevOps и администрирования?
echo 1. Начальная (нужна максимально простая панель управления и готовые образы)
echo 2. Средняя (умеем настраивать сети, балансировщики и S3-хранилища)
echo 3. Высокая (готовы работать с Terraform, IAM-ролями и микросервисами)
choice /c 123 /n /m "Выберите вариант (1-3): "
if errorlevel==3 set /a score_yc+=10
if errorlevel==2 set /a score_sel+=10
if errorlevel==1 set /a score_tw+=10
echo.

echo Вопрос 4: Какие сроки запуска первой версии (MVP)?
echo 1. Срочно (запустить за 1 день с минимальными настройками)
echo 2. 1-2 недели (требуется настройка отказоустойчивого кластера)
choice /c 12 /n /m "Выберите вариант (1-2): "
if errorlevel==2 (
    set /a score_yc+=10
    set /a score_sel+=10
)
if errorlevel==1 (
    set /a score_tw+=10
)
echo.

echo --------------------------------------------------------
echo Итоговые баллы профиля проекта:
echo   Yandex Cloud  : %score_yc%
echo   Selectel      : %score_sel%
echo   Timeweb Cloud : %score_tw%
echo --------------------------------------------------------

set "rec_cloud=Timeweb Cloud"
set max_score=%score_tw%

if %score_sel% gtr %max_score% (
    set "rec_cloud=Selectel"
    set max_score=%score_sel%
)
if %score_yc% gtr %max_score% (
    set "rec_cloud=Yandex Cloud"
    set max_score=%score_yc%
)

echo РЕКОМЕНДАЦИЯ МОДУЛЯ 1: %rec_cloud%
echo ========================================================
echo.
if "%1" neq "auto" pause


### Модуль 2: Инспекция кода (`chapter2.bat`)
Моделирует Code Review 4 фрагментов Python-кода, связанных с облачной инфраструктурой (S3, автоскейлинг, PostgreSQL, CDN). Определяет процент точности и присваивает грейд (`Junior`, `Middle`, `Senior`).

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


### Модуль 3: Сравнительный анализ WSM (`chapter3.bat`)
Реализует метод взвешенной суммы: проверяет сумму весов (`100`), принимает оценки альтернатив (1–5), рассчитывает итоговый балл по формуле $S = \sum(W \times X)$ и выводит таблицу решений.

@echo off
chcp 65001 > nul
title Модуль 3: Сравнительный анализ облачных платформ (WSM)

:input_weights
cls
echo ========================================================
echo   МОДУЛЬ 3: СРАВНИТЕЛЬНЫЙ АНАЛИЗ ПЛАТФОРМ (МЕТОД WSM)
echo ========================================================
echo Назначьте веса критериям в процентах (сумма должна быть равна 100):
echo.
set /p w1="Вес критерия 1 (Стоимость владения для MVP): "
set /p w2="Вес критерия 2 (Масштабируемость и Managed-сервисы): "
set /p w3="Вес критерия 3 (Простота старта и качество поддержки): "

set /a total_weight=w1+w2+w3
if %total_weight% neq 100 (
    echo.
    echo [ОШИБКА] Сумма весов равна %total_weight%, а должна быть 100! Повторите ввод.
    pause
    goto input_weights
)

echo.
echo Оцените каждую облачную платформу по шкале от 1 до 5:
echo --- 1. Yandex Cloud ---
set /p yc_1="Оценка Yandex Cloud по критерию 1 (Стоимость): "
set /p yc_2="Оценка Yandex Cloud по критерию 2 (Масштабируемость): "
set /p yc_3="Оценка Yandex Cloud по критерию 3 (Простота/Поддержка): "

echo.
echo --- 2. Selectel ---
set /p sel_1="Оценка Selectel по критерию 1 (Стоимость): "
set /p sel_2="Оценка Selectel по критерию 2 (Масштабируемость): "
set /p sel_3="Оценка Selectel по критерию 3 (Простота/Поддержка): "

echo.
echo --- 3. Timeweb Cloud ---
set /p tw_1="Оценка Timeweb Cloud по критерию 1 (Стоимость): "
set /p tw_2="Оценка Timeweb Cloud по критерию 2 (Масштабируемость): "
set /p tw_3="Оценка Timeweb Cloud по критерию 3 (Простота/Поддержка): "

set /a score_wsm_yc=yc_1*w1 + yc_2*w2 + yc_3*w3
set /a score_wsm_sel=sel_1*w1 + sel_2*w2 + sel_3*w3
set /a score_wsm_tw=tw_1*w1 + tw_2*w2 + tw_3*w3

echo.
echo =====================================================================
echo                        МАТРИЦА РЕШЕНИЙ (WSM)
echo =====================================================================
echo Критерий                      ^| Вес ^| Yandex Cloud ^| Selectel ^| Timeweb
echo ---------------------------------------------------------------------
echo 1. Стоимость владения         ^| %w1%  ^|      %yc_1%       ^|    %sel_1%     ^|    %tw_1%
echo 2. Масштабируемость           ^| %w2%  ^|      %yc_2%       ^|    %sel_2%     ^|    %tw_2%
echo 3. Простота и поддержка       ^| %w3%  ^|      %yc_3%       ^|    %sel_3%     ^|    %tw_3%
echo ---------------------------------------------------------------------
echo ИТОГО (взвешенный балл)       ^| 100 ^|     %score_wsm_yc%      ^|   %score_wsm_sel%    ^|   %score_wsm_tw%
echo =====================================================================

set "wsm_winner=Yandex Cloud"
set max_wsm=%score_wsm_yc%

if %score_wsm_sel% gtr %max_wsm% (
    set "wsm_winner=Selectel"
    set max_wsm=%score_wsm_sel%
)
if %score_wsm_tw% gtr %max_wsm% (
    set "wsm_winner=Timeweb Cloud"
    set max_wsm=%score_wsm_tw%
)

echo.
echo ПОБЕДИТЕЛЬ СРАВНИТЕЛЬНОГО АНАЛИЗА: %wsm_winner% (%max_wsm% баллов)
echo =====================================================================
echo.
if "%1" neq "auto" pause


### Модуль 4: Главный интеграционный файл (`lab_system.bat`)
Предоставляет консольное меню и связывает модули через команду `call`. В режиме сквозного прохождения (пункт 4) формирует итоговый отчёт в консоли и записывает его в `report.txt`.

@echo off
chcp 65001 > nul
title Система моделирования процессов разработки ПО (Вариант 4)

:menu
cls
echo ========================================================
echo   СИСТЕМА МОДЕЛИРОВАНИЯ ПРОЦЕССОВ РАЗРАБОТКИ ПО
echo   Вариант 4: Выбор облачной платформы для стартапа
echo ========================================================
echo.
echo   1. Модуль выбора технологий (chapter1.bat)
echo   2. Модуль инспекции кода (chapter2.bat)
echo   3. Модуль сравнительного анализа (chapter3.bat)
echo   4. Запустить все модули последовательно
echo   5. Выход
echo.
echo ========================================================
set /p choice="Ваш выбор (1-5): "

if "%choice%"=="1" (
    cls
    call chapter1.bat
    goto menu
)
if "%choice%"=="2" (
    cls
    call chapter2.bat
    goto menu
)
if "%choice%"=="3" (
    cls
    call chapter3.bat
    goto menu
)
if "%choice%"=="4" (
    cls
    call chapter1.bat auto
    cls
    call chapter2.bat auto
    cls
    call chapter3.bat auto
    cls
    echo ========================================================
    echo             ИТОГОВЫЙ ОТЧЕТ СИСТЕМЫ (ВАРИАНТ 4)
    echo ========================================================
    echo Дата и время формирования: %DATE% %TIME%
    echo.
    echo 1. Рекомендация по выбору облачной платформы: %rec_cloud%
    echo 2. Уровень ревьюера (точность %percentage%%%): %reviewer_level%
    echo 3. Победитель сравнительного анализа (WSM): %wsm_winner% (%max_wsm% баллов)
    echo ========================================================

    (
        echo ========================================================
        echo             ИТОГОВЫЙ ОТЧЕТ СИСТЕМЫ (ВАРИАНТ 4)
        echo ========================================================
        echo Дата и время формирования: %DATE% %TIME%
        echo Предметная область: Выбор облачной платформы для стартапа
        echo Кандидаты: Yandex Cloud, Selectel, Timeweb Cloud
        echo.
        echo 1. Модуль выбора технологий:
        echo    Рекомендуемая платформа: %rec_cloud%
        echo    Баллы профиля: Yandex Cloud=%score_yc%, Selectel=%score_sel%, Timeweb Cloud=%score_tw%
        echo.
        echo 2. Модуль инспекции кода:
        echo    Правильных ответов: %correct% из %total% ^(точность %percentage%%%^)
        echo    Набрано очков: %points%
        echo    Присвоенный уровень: %reviewer_level%
        echo.
        echo 3. Модуль сравнительного анализа ^(WSM^):
        echo    Победитель анализа: %wsm_winner% ^(%max_wsm% баллов^)
        echo    Итоговые баллы: Yandex Cloud=%score_wsm_yc%, Selectel=%score_wsm_sel%, Timeweb Cloud=%score_wsm_tw%
        echo ========================================================
    ) > report.txt

    echo.
    echo [OK] Сводный отчёт успешно сохранён в файл report.txt
    echo.
    pause
    goto menu
)
if "%choice%"=="5" exit
goto menu


---

## 2. Скриншоты работы системы
*(Загрузите скриншоты в папку `screenshots/` репозитория и вставьте ссылки)*
1. Работа `chapter1.bat`: `<img width="1272" height="747" alt="chapter1" src="https://github.com/user-attachments/assets/1fecc2c4-9738-4cc8-84dc-718ac1b56052" />`
2. Работа `chapter2.bat`: `<img width="840" height="1029" alt="chapter2" src="https://github.com/user-attachments/assets/eee3be19-a886-47ed-9f11-6203d96de954" />`
3. Работа `chapter3.bat`: `<img width="1112" height="681" alt="chapter3" src="https://github.com/user-attachments/assets/e3fe3d70-15d6-49a8-9450-2f8f9f238b2c" />`
4. Главное меню `МЕНЮ.lab_system.bat`: `<img width="693" height="438" alt="image" src="https://github.com/user-attachments/assets/8a3be946-e29d-45ec-84d8-a0e748c68108" />`
5. Сквозной запуск (пункт 4) и итоговый отчёт: `<img width="912" height="854" alt="lab_system" src="https://github.com/user-attachments/assets/744a70ae-d9f9-4b97-86ee-101d8f7a76f9" />`

---

## 3. Результаты работы и выводы
* **Вопросы и диалоги:** в первом модуле оценивались бюджет стартапа, модель масштабирования под нагрузкой, уровень DevOps и сроки запуска. Во втором проверялись навыки поиска дефектов (отсутствие `try/except`, магические числа, утечка соединения с БД, мёртвое присваивание). В третьем задавались веса критериев и баллы платформ.
* **Сформированные рекомендации:** при ориентации на минимальный бюджет и быстрый запуск MVP система рекомендует `Timeweb Cloud`, при фокусе на автоматическое масштабирование и PaaS-сервисы — `Yandex Cloud`.
* **Итоговый отчёт:** корректно агрегирует результаты всех трёх этапов в единую сводку и сохраняет её в `report.txt`.
* **Впечатления от работы:** пакетные файлы Windows позволяют быстро создавать консольные прототипы систем поддержки принятия решений без установки сторонних компиляторов, хотя требуют аккуратной работы с кодировкой UTF-8 и экранированием спецсимволов (`^|`, `^>`).

---

## 4. Инструкция по запуску для пользователя
1. Скачайте все `.bat`-файлы (`lab_system.bat`, `chapter1.bat`, `chapter2.bat`, `chapter3.bat`) в одну папку на компьютере с ОС Windows.
2. Запустите файл `lab_system.bat` двойным кликом левой кнопки мыши.
3. Выберите нужный модуль (`1`–`3`) или нажмите `4` для полного прохождения всех этапов и генерации файла `report.txt`.
