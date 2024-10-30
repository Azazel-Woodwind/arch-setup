function disk_total
    df -h --total | grep "total" | awk '{printf "%4s", $2}'
end
