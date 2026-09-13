# TASK-001 — Hardware audit

## Цель

Зафиксировать фактические ОС, CPU, RAM, GPU, драйверы и доступные инструменты.

## Контекст

Данные нужны для выбора runtime; установка ПО запрещена.

## Разрешено

Только read-only проверки Windows, WSL2, Vulkan, ROCm, CUDA, CMake, компиляторов, Git, gh, VS Code и Docker.

## Запрещено

Устанавливать или обновлять программы и драйверы.

## Шаги

Собрать фактический аудит и записать его в `docs/HARDWARE.md`.

## Проверки

Повторить ключевые команды и проверить полноту отчёта.

## Артефакты

Обновлённый `docs/HARDWARE.md`.

## Definition of Done

Аудит основан на фактическом выводе команд, статусы обновлены и создан commit.

## Git commit

`docs: add hardware audit`

## Следующая задача

TASK-002 — Runtime selection.

## Рекомендуемая модель Codex

GPT-5.6 Terra

## Reasoning effort

Low
