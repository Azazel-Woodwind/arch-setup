function disk_usage
    set used_bytes (df --total | grep "total" | awk '{print $3}')
    set total_bytes (df --total | grep "total" | awk '{print $2}')
    set disk_usage (math "($used_bytes / $total_bytes) * 100")
    set rounded (math round $disk_usage)
    echo $rounded
end
