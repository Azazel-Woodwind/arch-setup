function ram_usage
    set ram_used (free -m | awk '/Mem:/ {print $3}')
    set ram_total (free -m | awk '/Mem:/ {print $2}')
    set ram_usage (math "($(ram_used) / $(ram_total)) * 100")
    set rounded (math round $ram_usage)
    echo $rounded
end
