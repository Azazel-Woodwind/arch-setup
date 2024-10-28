function distro
    set name (ccat /etc/os-release | grep "PRETTY_NAME" | cut -d= -f2 | tr -d '"')
    set icon ""
    if test $name = "Arch Linux"
        set icon ""
    else if test $name = "Ubuntu"
        set icon ""
    else if test $name = "Fedora"
        set icon "󰣛"
    end
    echo -n "$icon  $name"
end