#!/bin/bash

# Путь к директории с обоями (измените при необходимости)
WALLPAPER_DIR="$HOME/Wallpapers/"

# Файл для хранения PID предыдущего процесса
PID_FILE="/tmp/mpvpaper.pid"

# Проверяем существование директории
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Ошибка: Директория с обоями не найдена: $WALLPAPER_DIR"
    exit 1
fi

# Получаем список всех папок в директории, исключая саму WALLPAPER_DIR
mapfile -t videos < <(find "$WALLPAPER_DIR" -mindepth 1 -maxdepth 1 -type f -printf '%f\n')

if [ ${#videos[@]} -eq 0 ]; then
    echo "Ошибка: В директории не найдено обой"
    exit 1
fi

# Выбираем случайную папку
random_video="${videos[RANDOM % ${#videos[@]}]}"

# Используем имя папки как ID
wallpaper_id="$random_video"

# Если есть предыдущий процесс, убиваем его через 2 секунды
if [ -f "$PID_FILE" ]; then
    old_pid=$(cat "$PID_FILE")
    if ps -p "$old_pid" > /dev/null; then
        (
            sleep 0.3
            # Завершаем всю группу процессов
            kill -- -$old_pid 2>/dev/null
        ) &
    fi
fi

# Запускаем новый процесс в новой группе процессов и сохраняем его PID
setsid mpvpaper -o "no-audio --loop --profile=fast" ALL "$WALLPAPER_DIR""$wallpaper_id" &
new_pid=$!
echo "$new_pid" > "$PID_FILE"

echo "Запущены обои с ID: $wallpaper_id (PID: $new_pid)"
