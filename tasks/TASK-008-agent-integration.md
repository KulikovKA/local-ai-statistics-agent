# TASK-008 — Интеграция локального endpoint

## Цель

Настроить выбранный VS Code Agent для работы только с `localhost` OpenAI-совместимым endpoint выбранного runtime и модели.

## Контекст

TASK-003 установила runtime, TASK-005 — модель, TASK-007 выбрала готовую VS Code-интеграцию. Пользователь продолжает работать через sidebar, а не через CLI. Конфигурация не должна смешивать Agent layer, inference layer и model layer.

## Разрешено

Настраивать конфигурацию выбранного готового расширения, локальный endpoint, имя модели и минимальные параметры доступа к workspace.

## Запрещено

Использовать cloud LLM, API-ключи облачных провайдеров, скрытый fallback или создавать собственное VS Code-расширение.

## Шаги

Настроить цепочку `VS Code sidebar → localhost → local runtime → local model`. Выполнить диагностический запрос из sidebar и подтвердить, что он обслужен локальным endpoint. Документировать конфигурацию без секретов.

## Проверки

Проверить адрес endpoint, ответ выбранной модели, отсутствие cloud provider в конфигурации и сохранность normal VS Code/Jupyter workflow.

## Артефакты

Конфигурация без секретов и инструкция локального подключения.

## Definition of Done

Sidebar фактически обращается к выбранной локальной модели через `localhost`, результаты и ограничения задокументированы, статусы обновлены и создан commit.

## Git commit

`feat: connect vscode agent to local endpoint`

## Следующая задача

TASK-009 — Интеграция notebook с агентом.

## Рекомендуемая модель Codex

GPT-5.6 Sol

## Reasoning effort

Medium
