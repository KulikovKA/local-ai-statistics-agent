# TASK-003 — Установка локального runtime

## Цель

Установить runtime, выбранный в TASK-002, и обеспечить управляемый запуск локального OpenAI-совместимого endpoint.

## Контекст

Выбор должен быть зафиксирован ADR.

## Разрешено

Устанавливать выбранный runtime и создавать install/start/stop/healthcheck scripts.

## Запрещено

Скачивать модель до TASK-005.

## Шаги

Установить runtime без модели, настроить привязку к `localhost`, автоматизировать запуск и выполнить healthcheck endpoint. Не устанавливать VS Code AI-расширение.

## Проверки

Проверить старт, остановку, healthcheck и недоступность endpoint извне без явной необходимости.

## Артефакты

Скрипты и инструкция установки.

## Definition of Done

Runtime проверен, документация и статусы обновлены, создан commit.

## Git commit

`feat: install local runtime`

## Следующая задача

TASK-004 — Выбор модели.

## Рекомендуемая модель Codex

GPT-5.6 Terra

## Reasoning effort

Medium
