# Установка локальной модели

## Установленный артефакт

На этом компьютере через локальный Ollama установлен единственный выбранный артефакт:

| Поле | Фактическое значение |
| --- | --- |
| Тег | `qwen3-coder:30b` |
| Digest | `sha256:06c1097efce0431c2045fe7b2e5108366e43bee1b4603a7aded8f21689e90bca` |
| Размер в локальном хранилище | 18 556 700 761 bytes (в `ollama list` — 18 GB) |
| Архитектура | `qwen3moe` |
| Параметры | 30,5B |
| Quantization | Q4_K_M |
| Лицензия в metadata | Apache-2.0 |
| Возможности | completion, tools |

Веса хранятся в пользовательском хранилище Ollama, а не в Git. В репозиторий не добавляются GGUF-файлы, blobs или другие данные модели.

## Проверка установки

```powershell
ollama list
ollama show qwen3-coder:30b --verbose
.\scripts\healthcheck.ps1
```

На момент установки `healthcheck.ps1` подтвердил локальный endpoint `http://127.0.0.1:11434`, loopback-listener и по одной модели в `/api/tags` и `/v1/models`.

## Рабочий context

Модель имеет нативный максимум 262 144 токена, но проект начинает с 16 384. Для этого параметр нужно передавать в каждом запросе к Ollama:

```json
{
  "model": "qwen3-coder:30b",
  "options": { "num_ctx": 16384 }
}
```

Проверка TASK-005 через `POST /api/chat` с этим параметром показала `CONTEXT 16384` в `ollama ps` и успешный tool call. Обычная загруженная сессия Ollama после этого может отображать свой default context 4096; это не отменяет параметры конкретного запроса. При memory pressure используйте только `num_ctx=8192`, не скачивая и не подменяя модель.

## Фактическая загрузка

Во время короткого локального tool call 13 сентября 2026 года `ollama ps` показал `100% CPU`, `CONTEXT 16384` и 20 GB model size. Процесс runner (`ollama`, PID меняется при запуске) занял 17,14 GiB working set и 18,73 GiB private memory. Vulkan/offload на Radeon 780M в этой проверке не использовался.

Это не benchmark: load duration, prompt processing, generation speed и устойчивость 8K/16K будут измерены отдельно в TASK-006.

## Локальность

Запросы TASK-005 отправлялись только на `127.0.0.1:11434`; использован тег без суффикса cloud. Это подтверждает локальный inference path для проверки, но полная offline-изоляция текущего процесса Ollama остаётся предметом TASK-011.
