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