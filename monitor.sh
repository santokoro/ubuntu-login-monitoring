#!/bin/bash
echo "$(date): запуск мониторинга" >> ~/monitoring/log.txt

AUTH_LOG="/var/log/auth.log"
STATE_FILE="$HOME/monitoring/last_position.txt"

# Если файла состояния нет — создаём
if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

LAST_POS=$(cat "$STATE_FILE")
CURRENT_POS=$(stat -c%s "$AUTH_LOG")

# Если файл не изменился — выходим
if [ "$CURRENT_POS" -eq "$LAST_POS" ]; then
    exit 0
fi

# Читаем только новые строки
NEW_LINES=$(tail -c +$((LAST_POS+1)) "$AUTH_LOG")

# Фильтруем только настоящие входы
NEW_LOGINS=$(echo "$NEW_LINES" | grep "login:session" | grep "session opened for user")

# Если входов нет — выходим
if [ -z "$NEW_LOGINS" ]; then
    echo "$CURRENT_POS" > "$STATE_FILE"
    exit 0
fi

# Отправляем сообщение
/home/santoro/monitoring/send.py "$NEW_LOGINS"

# Сохраняем новую позицию
echo "$CURRENT_POS" > "$STATE_FILE"
