function ram_used
    free -m | awk '/Mem:/ {printf "%4.1f", ($3 / 1000)}'
end
