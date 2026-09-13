# Local AI Statistics Agent

Локальный проект для поэтапного создания офлайн AI coding agent в VS Code с приоритетом Python, Jupyter и статистического анализа.

## Быстрый старт

После установки Conda создайте окружение командой `conda env create -f environment.yml`, затем активируйте его: `conda activate local-ai-statistics`.

## Принципы

Работа выполняется ровно по одной задаче за сессию. Статус и следующий шаг находятся в `PROJECT_STATE.md`, подробный план — в `TASKS.md`.

## Jupyter

Рабочий формат ноутбуков — синхронизированная пара `analysis.py` в формате percent и `analysis.ipynb`. Ячейка кода начинается с `# %%`, Markdown-ячейка — с `# %% [markdown]`. Синхронизация: `jupytext --set-formats ipynb,py:percent analysis.ipynb`.
