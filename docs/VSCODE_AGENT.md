# Выбор VS Code Agent

## Решение

Для Agent layer выбрано официальное расширение **Qwen Code Companion**:

* Marketplace ID: `qwenlm.qwen-code-vscode-ide-companion`;
* проверенная версия: 0.23.3;
* издатель: `qwenlm`;
* статус upstream: Preview/Beta;
* лицензия: Apache-2.0;
* минимальная версия VS Code: 1.96.0.

На хосте используется VS Code 1.137.0. Расширение 0.23.3 установлено через Marketplace и фактически активировано событием `onStartupFinished`; это подтверждено журналом Extension Host. Оно также добавлено в рекомендации workspace.

Официальные источники:

* [Qwen Code: интеграция с VS Code](https://github.com/QwenLM/qwen-code/blob/main/docs/users/integration-vscode.md);
* [Qwen Code Companion в Marketplace](https://marketplace.visualstudio.com/items?itemName=qwenlm.qwen-code-vscode-ide-companion);
* [официальная конфигурация локальных self-hosted моделей](https://qwenlm.github.io/qwen-code-docs/en/users/configuration/model-providers/);
* [инструменты Qwen Code](https://qwenlm.github.io/qwen-code-docs/en/developers/tools/introduction/).

## Почему выбран этот вариант

| Требование | Подтверждение |
| --- | --- |
| Sidebar внутри VS Code | Зарегистрированы Activity Bar container `qwen-code-sidebar` и webview `qwen-code.chatView.sidebar` |
| Agent и workspace context | Bundled Qwen Code получает открытые файлы, cursor/selection и workspace context |
| Native diff | Есть команды accept/close diff и встроенный VS Code diff workflow |
| Чтение и правка файлов | Qwen Code включает file-system tools с контролем workspace |
| Terminal и Python execution | Bundled agent имеет `run_shell_command`; Python будет запускаться в Conda-окружении проекта |
| Локальная модель | Официально поддержан auth type `openai` с self-hosted Ollama `baseUrl` |
| Один готовый продукт | Расширение включает необходимый Qwen Code runtime; отдельное собственное расширение не требуется |

Основной кандидат удовлетворяет обязательным требованиям, поэтому готовая альтернатива не выбиралась. Замена возможна только при фактической несовместимости локального endpoint, tools или notebook workflow на следующих задачах.

## Установка и открытие

```powershell
code --install-extension qwenlm.qwen-code-vscode-ide-companion
```

После установки выполните `Developer: Reload Window`, если значок Qwen не появился. Откройте панель значком Qwen либо командой `Qwen Code: Open` из Command Palette.

## Граница TASK-007

На этой задаче не выполнялись авторизация, onboarding и запрос к модели из sidebar. Файл `~/.qwen/settings.json` отсутствует: cloud provider, cloud API key и cloud fallback не созданы. Локальная цепочка будет настроена в TASK-008 с явным `http://127.0.0.1:11434/v1` и `qwen3-coder:30b`.

До TASK-008 нельзя выбирать предлагаемый по умолчанию `coding-plan`, выполнять вход в Alibaba ModelStudio или начинать чат: это могло бы направить запрос в cloud.

## Известные ограничения

* Расширение имеет статус Preview/Beta; UI и схема настроек могут меняться.
* Локальный Ollama официально поддерживается через OpenAI-совместимый provider, но фактический запрос из sidebar ещё не проверен.
* Наличие file tools не доказывает безопасное изменение `.ipynb`. Notebook должен оставаться открытым в обычном Jupyter UI, а изменения будут проверены через `nbformat`/Jupytext в TASK-009.
* Возможность полной работы без сети после установки проверяется отдельно в TASK-011.
* Для первых интеграционных тестов следует использовать режим с подтверждением изменений, не auto-accept/YOLO.
