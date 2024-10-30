function ram_total
    free -m | awk '/Mem:/ {printf "%4.1f", ($2 / 1000)}'
end
