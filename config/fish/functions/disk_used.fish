function disk_used
    df -h --total | grep "total" | awk '{printf "%4s", $3}'
end
