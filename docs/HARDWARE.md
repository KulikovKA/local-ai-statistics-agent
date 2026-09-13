# Оборудование

## Сведения об аудите

Аудит выполнен 13.09.2026 в 14:46:33 (UTC+03:00) штатными read-only командами Windows. Ничего не устанавливалось и не обновлялось.

## Операционная система и процессор

| Параметр | Фактическое значение |
| --- | --- |
| ОС | Microsoft Windows 11 Pro, 64-bit |
| Версия / build | 10.0.26200 / 26200 |
| CPU | AMD Ryzen 7 8845HS w/ Radeon 780M Graphics |
| Ядра / логические процессоры | 8 / 16 |
| Оперативная память | 31,31 GiB |

## Графика и драйверы

| Устройство | Драйвер | Дата драйвера | Наблюдение |
| --- | --- | --- | --- |
| AMD Radeon 780M Graphics | 31.0.22042.4001 | 14.05.2024 | Встроенный GPU; Vulkan определяет его как `INTEGRATED_GPU` |
| Honor Virtual Display Device | 1.0.23.2 | 17.05.2024 | Виртуальное display-устройство, не рассматривается как compute GPU |

`Win32_VideoController` сообщает для Radeon 780M только 0,5 GiB `AdapterRAM`; для UMA-встроенной графики это не является надёжной величиной доступной общей памяти. Дискретный GPU не обнаружен.

`vulkaninfo --summary` успешно нашёл AMD Radeon 780M: Vulkan Instance Version 1.3.301, API устройства 1.3.262, драйвер — AMD proprietary driver (`23.20.42.04 (LLPC)`). Во время запроса были предупреждения Vulkan loader о registry manifest и эмуляции структуры surface capabilities; устройство всё равно было перечислено. Работоспособность конкретного inference runtime этим аудитом не подтверждается.

## Накопитель

| Устройство | Тип | Размер | Свободно на C: | Состояние |
| --- | --- | --- | --- | --- |
| WD PC SN560 SDDPNQE-1T00-1036 | SSD | 953,87 GiB | 275,29 GiB из 952,58 GiB | Healthy / OK |

## WSL и контейнеры

`wsl.exe` доступен. В списке WSL найден только дистрибутив `docker-desktop`, остановленный, версии 2; пользовательский Linux-дистрибутив в выводе не обнаружен.

Docker CLI доступен: клиент 29.2.1. Docker daemon на момент проверки не запущен: соединение с `dockerDesktopLinuxEngine` не установлено.

## Инструменты

| Инструмент | Фактический статус |
| --- | --- |
| Vulkan | Доступен: `vulkaninfo.exe`; Radeon 780M перечисляется |
| CUDA | `nvidia-smi` и `nvcc` не найдены |
| ROCm | `rocm-smi` не найден |
| CMake | Не найден в `PATH` |
| MSVC `cl` | Не найден в `PATH` |
| GCC | Не найден в `PATH` |
| Git | Доступен, 2.53.0.windows.1 |
| GitHub CLI | `gh` не найден |
| VS Code | Доступен, 1.137.0, x64 |
| Docker | CLI доступен, daemon остановлен |
| Conda | Не найден в `PATH` текущей PowerShell-сессии |

В VS Code присутствуют расширения Python и Jupyter: `ms-python.python`, `ms-python.vscode-pylance`, `ms-python.debugpy`, а также `ms-toolsai.jupyter` и связанные Jupyter-расширения. AI-расширения в рамках этого аудита не устанавливались и не выбирались.

## Влияние на следующие задачи

Следующая задача должна сравнить зрелые local runtime с учётом Windows, встроенной AMD Radeon 780M, подтверждённой доступности Vulkan и отсутствия CUDA/ROCm toolchain в `PATH`. Этот отчёт не выбирает runtime, модель или VS Code Agent и не заменяет их фактическое тестирование.

## Использованные read-only команды

`Get-CimInstance Win32_OperatingSystem`, `Win32_Processor`, `Win32_ComputerSystem`, `Win32_VideoController`, `Win32_PnPSignedDriver`, `Win32_LogicalDisk`, `Get-PhysicalDisk`; `wsl --status`, `wsl -l -v`; `vulkaninfo --summary`; проверки `nvidia-smi`, `nvcc`, `rocm-smi`, `cmake`, `cl`, `gcc`, `git`, `gh`, `code`, `docker` и `conda`.
