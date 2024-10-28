function network_traffic
    set isecs 1

    # Default to all interfaces except 'lo'
    set ifaces (cls /sys/class/net/)
    set ifaces (string match -v 'lo' $ifaces)

    # Sanity check polling interval
    if test "$isecs" -lt 1
        echo "$isecs is not a valid polling interval"
        return
    end

    # Function to convert bytes to human-readable format
    function human_readable
        set -l num $argv[1]
        set -l units B K M G T P
        set -l idx 1
        while test $num -ge 1024
            set num (math "$num / 1024")
            set idx (math "$idx + 1")
        end
        printf "%d%s" $num $units[$idx]
    end

    # Take the first reading
    set -l traffic_prev_data
    for iface in $ifaces
        set -l rx_prev (ccat /sys/class/net/$iface/statistics/rx_bytes)
        set -l tx_prev (ccat /sys/class/net/$iface/statistics/tx_bytes)
        set traffic_prev_data $traffic_prev_data $rx_prev $tx_prev
    end

    # Wait for the polling interval
    sleep $isecs

    # Take the second reading
    set -l traffic_curr_data
    for iface in $ifaces
        set -l rx_curr (ccat /sys/class/net/$iface/statistics/rx_bytes)
        set -l tx_curr (ccat /sys/class/net/$iface/statistics/tx_bytes)
        set traffic_curr_data $traffic_curr_data $rx_curr $tx_curr
    end

    # Compute differences
    set -l total_rx 0
    set -l total_tx 0
    for i in (seq 1 2 (count $traffic_prev_data))
        set -l rx_prev $traffic_prev_data[$i]
        set -l tx_prev $traffic_prev_data[(math "$i + 1")]
        set -l rx_curr $traffic_curr_data[$i]
        set -l tx_curr $traffic_curr_data[(math "$i + 1")]

        set -l rx_delta (math "($rx_curr - $rx_prev) / $isecs")
        set -l tx_delta (math "($tx_curr - $tx_prev) / $isecs")

        set total_rx (math "$total_rx + $rx_delta")
        set total_tx (math "$total_tx + $tx_delta")
    end

    # Output the result
    printf '%4s⇣ %4s⇡\n' \
        (human_readable $total_rx) \
        (human_readable $total_tx)
end
