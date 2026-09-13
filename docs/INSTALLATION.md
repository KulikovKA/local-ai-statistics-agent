# Установка

Воспроизводимое окружение описано в `environment.yml`. После установки Conda выполните `conda env create -f environment.yml` и `conda activate local-ai-statistics`.

## Локальный runtime

Внешняя установка Ollama уже обнаружена и проверена: `ollama.exe` сообщает версию 0.24.0, а локальный endpoint работает на `http://127.0.0.1:11434`. TASK-003 не переустанавливала и не обновляла Ollama. В TASK-005 установлен единственный локальный тег `qwen3-coder:30b`; его digest, лицензия и параметры зафиксированы в [MODEL_INSTALLATION.md](MODEL_INSTALLATION.md).

Проверить endpoint можно из корня проекта:

```powershell
.\scripts\healthcheck.ps1
```

`start-local-agent.ps1` сначала проверяет существующий endpoint и не изменяет его. Если endpoint отсутствует, скрипт запускает только новый процесс, принадлежащий проекту, с `OLLAMA_HOST=127.0.0.1:11434` и `OLLAMA_NO_CLOUD=1`. Его PID хранится вне репозитория в `%LOCALAPPDATA%\local-ai-statistics-agent\ollama.pid`; только такой процесс может быть остановлен `stop-local-agent.ps1`.

```powershell
.\scripts\start-local-agent.ps1
.\scripts\healthcheck.ps1
.\scripts\stop-local-agent.ps1
```

Не выполняйте `ollama signin` и не выбирайте cloud-модели. Полная проверка offline-режима и отсутствие cloud fallback запланированы в TASK-011.

## VS Code Agent

TASK-007 выбрала официальное расширение Qwen Code Companion. Установка:

```powershell
code --install-extension qwenlm.qwen-code-vscode-ide-companion
```

Проверенная версия — 0.23.3. До настройки локального provider в TASK-008 не проходите cloud-onboarding и не выбирайте Coding Plan. Причины выбора и ограничения описаны в [VSCODE_AGENT.md](VSCODE_AGENT.md).
