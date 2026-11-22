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