# TASK-005 — Установка модели

## Цель

Скачать только утверждённую `qwen3-coder:30b` в Q4_K_M через локальный Ollama.

## Контекст

Выбор берётся исключительно из TASK-004: Qwen3-Coder-30B-A3B-Instruct, официальный Ollama tag `qwen3-coder:30b`, начальный context 16K и fallback 8K при memory pressure.

## Разрешено

Скачать одну выбранную модель, проверить metadata/digest и создать локальную конфигурацию с `num_ctx=16384`, если это требуется Ollama для фиксированного context.

## Запрещено

Скачивать baseline-модели, cloud-варианты или несколько quantization.

## Шаги

Получить `qwen3-coder:30b`, проверить Q4_K_M, размер, digest, Apache-2.0 metadata, локальную загрузку, tools и отсутствие cloud fallback. При нехватке RAM уменьшить context до 8192, не заменяя модель молча.

## Проверки

Проверить модель локальным запросом и простым tool call через Ollama на `127.0.0.1:11434`, зафиксировать фактический backend/processor и resident RAM без benchmark-выводов.

## Артефакты

Инструкция без добавления весов в Git.

## Definition of Done

Модель доступна runtime, документация и статусы обновлены, создан commit.

## Git commit

`feat: install selected model`

## Следующая задача

TASK-006 — Бенчмарк.

## Рекомендуемая модель Codex

GPT-5.6 Terra

## Reasoning effort

Medium
