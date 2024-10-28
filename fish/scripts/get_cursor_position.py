import os

def get_cursor_position():
    with os.popen("tput u7 > /dev/tty; read -sdR CURPOS < /dev/tty; echo ${CURPOS#*[}") as stream:
        response = stream.read().strip()
    if response:
        rows, cols = map(int, response.split(';'))
        return rows, cols

row, col = get_cursor_position()
print(f"{row - 1} {col - 1}")
