# Jupyter и Jupytext

Ноутбук ведётся как пара `analysis.py` и `analysis.ipynb`. Источником удобного для редактирования кода служит файл Python с разделителями `# %%`; Jupytext синхронизирует его с обычным `.ipynb`, который открывается в VS Code.

Для новой пары используйте `jupytext --set-formats ipynb,py:percent analysis.ipynb`. После изменения любого файла синхронизируйте пару через Jupytext и проверяйте изменения в Git.
