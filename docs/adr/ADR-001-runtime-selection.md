# ADR-001 — Выбор локального inference runtime

## Статус

Принято 13.09.2026 в TASK-002.

## Контекст

Система предназначена для одного пользователя на Windows 11 Pro с AMD Ryzen 7 8845HS, 31,31 GiB RAM и встроенной AMD Radeon 780M. Аудит подтвердил работоспособность Vulkan 1.3, но не обнаружил CUDA, ROCm, CMake или компилятор в `PATH`; пользовательского Linux-дистрибутива WSL также нет.

Runtime должен работать локально, отделять модель от VS Code Agent layer, предоставлять OpenAI-совместимый HTTP API на `localhost`, поддерживать дальнейшую установку одной модели класса 7B–9B и не требовать cloud LLM в штатном сценарии.

Дополнительная read-only проверка TASK-002 обнаружила уже установленный вне репозитория Ollama: `ollama.exe` 0.24.0 находится в `%LOCALAPPDATA%\Programs\Ollama`, процесс запущен и слушает только `127.0.0.1:11434`. В `/api/tags` моделей нет. Эта установка не была создана или изменена задачами проекта.

## Рассмотренные варианты

| Runtime | Windows / Radeon 780M | Локальный API и инструменты | GGUF | Решение |
| --- | --- | --- | --- | --- |
| Ollama | Нативное приложение Windows; официально заявлены AMD Radeon и Vulkan acceleration | OpenAI-совместимый API на `localhost:11434/v1`; поддерживаются tools/function calling | Импорт через `Modelfile` | Выбран |
| `llama.cpp` | В официальных release есть готовая Windows x64/Vulkan сборка; Vulkan уже подтверждён аудитом | `llama-server` работает по умолчанию на `127.0.0.1:8080` и имеет OpenAI-совместимые `/v1/*` endpoints | Нативный формат | Резервный вариант |
| vLLM | Нативный Windows не поддерживается; нужен Linux/WSL либо сторонний fork. AMD-ускорение опирается на ROCm | Есть OpenAI-совместимый server | Не является ориентированным на GGUF путём | Не выбран |

Ollama официально документирует нативную работу на Windows с AMD Radeon, Vulkan acceleration и API на `localhost:11434`. Его OpenAI-совместимый `/v1/chat/completions` поддерживает tools; GGUF-файл можно импортировать через `FROM` в `Modelfile`. [Ollama для Windows](https://docs.ollama.com/windows), [Vulkan support Ollama](https://docs.ollama.com/gpu), [OpenAI compatibility Ollama](https://docs.ollama.com/api/openai-compatibility), [импорт GGUF](https://docs.ollama.com/import)

`llama.cpp` остаётся технически сильным fallback: он документирует лёгкий OpenAI-совместимый HTTP server, Vulkan и integer quantization, а его release содержат Windows x64/Vulkan сборки. Однако он отсутствует на хосте, тогда как Ollama уже установлен, привязан к loopback и отвечает через локальный API. Переход на другой runtime сейчас создал бы лишнюю установку без доказанного выигрыша. [README llama.cpp](https://github.com/ggml-org/llama.cpp), [документация сервера](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md), [release assets llama.cpp](https://github.com/ggml-org/llama.cpp/releases)

vLLM оптимизирован для другого профиля: официальная документация требует Linux, прямо указывает отсутствие нативной поддержки Windows и для AMD использует ROCm. Это не соответствует текущему хосту без Linux-дистрибутива WSL и ROCm toolchain. [Требования vLLM](https://docs.vllm.ai/en/latest/getting_started/installation/gpu/)

## Решение

Основной inference runtime — **Ollama**, работающий локально на `127.0.0.1:11434`.

TASK-003 не должна переустанавливать, удалять или обновлять уже существующий Ollama. Вместо этого она должна подтвердить происхождение и версию бинарного файла, состояние endpoint, путь хранения моделей, параметры запуска и отсутствие cloud configuration; если проверка выявит неисправимый блокер, изменение runtime потребует отдельного ADR. Будущая модель выбирается и скачивается только в TASK-004 и TASK-005.

Agent layer использует только `http://127.0.0.1:11434/v1/`. Нельзя выполнять `ollama signin`, применять cloud-модели или настраивать облачный fallback. Полная фактическая offline-проверка остаётся TASK-011.

Модель, её GGUF-файл, quantization, context size и показатели производительности не выбраны этой задачей. Они относятся соответственно к TASK-004, TASK-005 и TASK-006.

## Последствия

Положительные:

* используется уже работающий локальный endpoint без новой установки;
* выбранный GPU путь соответствует фактически обнаруженному Vulkan;
* OpenAI-совместимый API и tools соответствуют будущему Agent layer;
* при необходимости выбранную GGUF-модель можно явно импортировать, не меняя UI.

Ограничения и риски:

* производительность и стабильность Vulkan на Radeon 780M не измерялись; GPU offload не гарантирован до TASK-006;
* UMA-память встроенной графики не равна дискретной VRAM, поэтому модель, context и параметры выбираются только после установки;
* Ollama имеет cloud-возможности, поэтому конфигурация и используемая модель должны быть проверены в TASK-003 и TASK-011;
* переход на `llama.cpp` или иной runtime требует отдельного ADR и не должен выполняться неявно.

## Проверка решения в следующих задачах

TASK-003 должна подтвердить локальный endpoint, нулевой список моделей, отсутствие cloud configuration и воспроизводимый способ запуска без переустановки. TASK-005 проверит загрузку выбранной модели, а TASK-006 — реальные CPU/Vulkan измерения. При блокирующей несовместимости Vulkan допустимо рассмотреть `llama.cpp` через новый документированный decision point.
