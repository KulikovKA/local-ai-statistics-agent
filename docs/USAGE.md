# Использование

Выбранный интерфейс агента — боковая панель Qwen Code Companion. После установки или обновления расширения при необходимости выполните `Developer: Reload Window`, затем откройте панель значком Qwen либо командой `Qwen Code: Open`. Основным рабочим документом остаётся `.ipynb`, открытый в Jupyter UI VS Code.

Локальная модель доступна как `qwen3-coder:30b`. Проверка `./scripts/healthcheck.ps1` должна показать endpoint `http://127.0.0.1:11434`, loopback-listener и по одной модели в локальном и OpenAI-совместимом API.

До TASK-008 не проходите onboarding Qwen Code, не выбирайте Coding Plan и не начинайте чат: локальный provider ещё не задан. При последующей настройке используйте только локальный endpoint и context 16K. Выбор расширения описан в [VSCODE_AGENT.md](VSCODE_AGENT.md), параметры модели — в [MODEL_INSTALLATION.md](MODEL_INSTALLATION.md).
