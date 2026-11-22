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