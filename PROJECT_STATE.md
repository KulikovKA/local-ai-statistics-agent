# Состояние проекта

## Текущая задача

TASK-008 — Интеграция локального endpoint.

## Завершённые задачи

TASK-000 — Bootstrap проекта.

TASK-001 — Аудит оборудования.

TASK-002 — Выбор локального runtime.

TASK-003 — Установка локального runtime.

TASK-004 — Выбор локальной модели.

TASK-005 — Установка модели.

TASK-006 — Benchmark локальной модели.

TASK-007 — Выбор VS Code Agent.

## Техническое состояние

Созданы структура проекта, Conda-окружение `local-ai-statistics` и Jupyter kernel. Проверены Python 3.12.14, импорт базовых библиотек, Jupyter, Jupytext и smoke test без GUI. Локальная модель установлена и проверена; VS Code AI-расширение ещё не устанавливалось.

TASK-001 зафиксировала Windows 11 Pro build 26200, AMD Ryzen 7 8845HS (8 ядер / 16 логических процессоров), 31,31 GiB RAM, встроенную AMD Radeon 780M с рабочим перечислением Vulkan 1.3 и 275,29 GiB свободного места на SSD. CUDA, ROCm, CMake и компиляторы не найдены в `PATH`; Docker CLI установлен, но daemon остановлен. Полные фактические данные — в `docs/HARDWARE.md`.

## Принятые решения

Основное окружение называется `local-ai-statistics`, целевая версия Python — 3.12. Главный пользовательский интерфейс — обычный `.ipynb` в Jupyter UI VS Code. Для Agent layer выбрано и установлено официальное расширение Qwen Code Companion 0.23.3; его sidebar располагается рядом с notebook.

Слои целевой архитектуры: VS Code / Jupyter UI, Qwen Code Agent, локальный OpenAI-совместимый API, локальный runtime, локальная модель и Conda execution environment. `nbformat` и Jupytext — внутренние механизмы безопасного изменения notebook; парный `.py` не является основным интерфейсом пользователя.

Для Inference layer выбран Ollama. TASK-003 подтвердила существующие `ollama.exe` 0.24.0, `ollama serve`, loopback endpoint `127.0.0.1:11434` и успешные `/api/version`, `/api/tags`, `/v1/models`; список локальных моделей пуст. Созданы безопасные launchers, не затрагивающие существующий процесс. `llama.cpp` сохранён как документированный fallback; vLLM не выбран из-за отсутствия нативной поддержки Windows и зависимости от Linux/WSL для этого хоста.

TASK-004 выбрала Qwen3-Coder-30B-A3B-Instruct в официальном Ollama-варианте `qwen3-coder:30b`: Q4_K_M, около 19 GB, начальный context 16K и fallback 8K. Модель имеет 30,5B total / 3,3B active parameters; Qwen2.5-Coder 7B и 14B остаются только baselines и не скачиваются.

TASK-005 установила единственный выбранный артефакт `qwen3-coder:30b` (18 556 700 761 bytes, Q4_K_M, digest `sha256:06c1097efce0431c2045fe7b2e5108366e43bee1b4603a7aded8f21689e90bca`, Apache-2.0). Локальные `/api/tags` и `/v1/models` видят одну модель. `POST /api/chat` на loopback с `num_ctx=16384` успешно выполнил tool call; в момент проверки backend был `100% CPU`, а runner использовал 17,14 GiB working set / 18,73 GiB private memory. Скорость и устойчивость context — предмет TASK-006.

TASK-006 измерила `qwen3-coder:30b` через локальный `/api/generate` в cold start: 4K, 8K и 16K успешно завершились. При 16K получены 8,507 с load, 64,017 ток/с prompt, 19,084 ток/с generation, 18,862 GiB peak working set и 19,415 GiB peak private memory; исходные данные и методика — в `docs/BENCHMARKS.md`. Модель работает на CPU; Vulkan/offload не наблюдался. 16K принят как начальный рабочий context для короткого запроса, fallback остаётся 8K; заполненный context и многошаговый agent loop ещё не проверены.

TASK-007 выбрала официальный Qwen Code Companion (`qwenlm.qwen-code-vscode-ide-companion`) 0.23.3. Расширение установлено, активировано VS Code и подтверждённо регистрирует sidebar, workspace/file context и native diff-команды; bundled Qwen Code имеет file и shell tools. `~/.qwen/settings.json` ещё не создан, cloud-onboarding не выполнялся, endpoint не настроен. Локальный provider настраивается только в TASK-008.

## Известные проблемы и блокеры

Qwen Code Companion имеет статус Preview/Beta. Фактический запрос из sidebar к Ollama, безопасная работа с notebook и полный agent loop ещё не проверены. Qwen3-Coder-30B-A3B работает на CPU, а не Vulkan. У существующего startup-процесса Ollama не подтверждён `OLLAMA_NO_CLOUD=1`; полная фактическая offline-изоляция остаётся TASK-011.

## Следующая задача

TASK-008 — Интеграция локального endpoint.
