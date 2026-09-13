# TASK-008 — Интеграция agent

## Цель

Проверить полный цикл read → reason → edit → execute → observe → fix → execute again.

## Контекст

Это ключевая функциональная проверка локального agent.

## Разрешено

Создавать безопасные тестовые файлы и выполнять Python-код.

## Запрещено

Использовать cloud LLM как скрытый fallback.

## Шаги

Выполнить воспроизводимый сценарий исправления кода с traceback.

## Проверки

Зафиксировать наблюдаемые результаты каждого этапа.

## Артефакты

Тестовый сценарий и отчёт.

## Definition of Done

Полный цикл фактически подтверждён, статусы обновлены, создан commit.

## Git commit

`test: validate agent integration loop`

## Следующая задача

TASK-009 — Offline validation.

## Рекомендуемая модель Codex

GPT-5.6 Sol

## Reasoning effort

High
