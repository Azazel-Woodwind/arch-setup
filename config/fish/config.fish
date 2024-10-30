if status --is-interactive
    if not test -n "$TMUX"
        tmux new-session -As main
    end
    set -x STARSHIP_CONFIG ~/.config/starship.toml
    starship init fish | source
    neofetch --colors 5 1 5 5 4 5 --color_blocks off
else
    return
end

set -g UPPER_DASH "▔"
set -g LOWER_DASH "▁"

function dashed_separator
    set length $argv[1]
    set place_below $argv[2]
    if test (count $argv) -eq 2
        set dash $LOWER_DASH
    else
        set dash $UPPER_DASH
    end

    if test (math $length % 4) -eq 0
        set placed_dash 1
    else
        set placed_dash 0
    end
    set output ""
    while test (string length -- $output) -lt $length
        if test $placed_dash -eq 1
            set output "$output "
            set placed_dash 0
        else
            set output "$output$dash"
            if test (math $length % 2) -eq 0; and test (string length -- $output) -eq (math $length / 2)
                set output "$output$dash"
            end
            set placed_dash 1
        end
    end

    echo -n $output
end

set -g commands_no_delimiters "cd" "clear" "refresh" "code" "rm" "cp" "mv" "mkdir" "wget" "htop" "btop" "top" "bash" "fish" "exit" "logout" "su" "sudo" "reboot"
set -g START_DELIMITER_TEXT "START"
set -g END_DELIMITER_TEXT "END"
set -g TOP_LEFT_DELIMITER_TEXT "╒"
set -g TOP_RIGHT_DELIMITER_TEXT "╕"
set -g BOTTOM_LEFT_DELIMITER_TEXT "╘"
set -g BOTTOM_RIGHT_DELIMITER_TEXT "╛"
set -g MIDDLE_DELIMITER_TEXT "═"

function write_delimiter
    if test (count $argv) -ne 5
        return
    end

    set text $argv[1]
    set start $argv[2]
    set fill $argv[3]
    set end $argv[4]
    set total_length (math min $argv[5],$COLUMNS)

    set text_length (string length -- $text)
    if test (math "($total_length - $text_length) % 2") -eq 1
        set total_length (math "$total_length - 1")
    end
    set padding_length (math "($total_length - $text_length) / 2 - 2")

    set_color cyan
    if test $text = $END_DELIMITER_TEXT
        echo " $(dashed_separator (math $total_length - 2) 1) "
    end
    printf "%s" $start
    printf "%s %s %s" \
        (printf "%*s" $padding_length | sed "s/ /$fill/g") \
        $text \
        (printf "%*s" $padding_length | sed "s/ /$fill/g")
    printf "%s\n" $end
    if test $text = $START_DELIMITER_TEXT
        echo " $(dashed_separator (math $total_length - 2)) "
    end
    set_color normal
end

function undo_aliases
    set command $argv
    set n (string length -- $command)
    set commands (python ~/.config/fish/scripts/find_fish_commands.py $command)
    set next_command_index 1
    set res ""
    set next_command_indices $commands[$next_command_index]
    set opts (string split ';' $next_command_indices)
    set start $opts[1]
    set end $opts[2]
    set candidate_alias ""
    set using_alias 0
    for i in (seq $n)
        set char (string sub -s $i -l 1 -- $command)
        if test $i -lt (math "$start + 1"); or test $i -gt (math "$end + 1")
            set res "$res$char"
        else if test $i -le (math "$end + 1")
            set candidate_alias "$candidate_alias$char"
        end

        if test $i -eq (math "$end + 1")
            if not test (functions -D -- "$candidate_alias") = "n/a"
                set definition (functions --no-details -- "$candidate_alias")
                if set real (string match -r -- "--wraps=(\w+|'[^']*')\s" $definition)[2]
                    set trimmed (string trim -c "'" $real)
                    set real $trimmed
                    set res "$res$real"
                    set using_alias 1
                end
            else
                set res "$res$candidate_alias"
            end

            set candidate_alias ""

            set next_command_index (math $next_command_index + 1)
            if test $next_command_index -le (count $commands)
                set next_command_indices $commands[$next_command_index]
                set opts (string split ';' $next_command_indices)
                set start $opts[1]
                set end $opts[2]
            end
        end
    end

    echo $res
    echo $using_alias
end

function fish_preexec --on-event fish_preexec

    set res (undo_aliases $argv)

    if test $res[2] -eq 1
        # Print in italic grey
        echo -en "\e[3m" 
        set_color 555555
        echo "> $res[1]"
        echo -en "\e[23m"
        set_color normal
    end

    # If the command is in the list of commands that don't need delimiters, don't print them
    if contains (string split ' ' $argv)[1] $commands_no_delimiters
        set -g printed_delimiter 0
        return
    end
    set -g printed_delimiter 1

    write_delimiter $START_DELIMITER_TEXT $TOP_LEFT_DELIMITER_TEXT $MIDDLE_DELIMITER_TEXT $TOP_RIGHT_DELIMITER_TEXT 100
end

function exit_code_icon
    set exit_code $argv[1]
    if test $exit_code -eq 0
        set_color green
        echo -n ""
    else
        set_color red
        if test $exit_code -eq 126 # not executable
            echo -n ""
        else if test $exit_code -eq 127 # command not found
            echo -n "󰦀"
        else if test $exit_code -gt 128 # terminated by signal
            echo -n "󱐌"
        else
            echo -n ""
        end
    end

    set_color normal
end

function exit_code_meaning
    set exit_code $argv[1]
    if test $exit_code -eq 0
        set_color green
        echo -n "SUCCESS"
    else
        set_color red
        if test $exit_code -eq 126 # not executable
            echo -n "NOT EXECUTABLE"
        else if test $exit_code -eq 127 # command not found
            echo -n "NOT FOUND"
        else if test $exit_code -gt 128 # terminated by signal
            echo -n (fish_status_to_signal $exit_code) "($exit_code)"
        else
            echo -n "ERROR"
        end
    end

    set_color normal
end

function contained_stdout
    if not test -n "$TMUX"
        return 0
    end
    
    python ~/.config/fish/scripts/get_cursor_position.py > /tmp/cursor_position.txt
    set cursor_position (ccat /tmp/cursor_position.txt)
    set col (string split ' ' $cursor_position)[2]
    if not test $col -eq 0
        return 0
    end
    
    set row (string split ' ' $cursor_position)[1]
    set prev_row (math $row - 1)
    set char_above (tmux capture-pane -pS $prev_row -E $prev_row | awk '{print substr($0,2,3)}')

    not string match -q -- "*$UPPER_DASH*" = $char_above
end

function fish_postexec --on-event fish_postexec
    set last_pipestatus $pipestatus
    set last_command_duration $CMD_DURATION

    if test $printed_delimiter -eq 1
        if not contained_stdout
            echo -en "\e[3m"
            write_delimiter "─── No Stdout ───" " " " " " " 100
            echo -en "\e[23m"
        else
            set cursor_position (ccat /tmp/cursor_position.txt)
            set col (string split ' ' $cursor_position)[2]
            if not test $col -eq 0
                echo
            end
        end
        write_delimiter $END_DELIMITER_TEXT $BOTTOM_LEFT_DELIMITER_TEXT $MIDDLE_DELIMITER_TEXT $BOTTOM_RIGHT_DELIMITER_TEXT 100
    end

    set statuses
    for last_status in $last_pipestatus
        set icon (exit_code_icon $last_status)
        set meaning (exit_code_meaning $last_status)
        set -a statuses "$icon $meaning"
    end

    echo -n "$(string join " | " $statuses)"
    if test $last_command_duration -ge 500
        set secs (math $last_command_duration / 1000)
        echo -n " ~ took "
        set_color yellow
        printf "%.1fms" $secs
    end
    echo
end

alias wget 'wget -c'
alias htop btop
alias ls "eza -l --no-permissions --no-user --no-time --icons --group-directories-first --header"
alias cat 'bat -f --style="header,header-filesize,grid,numbers,snip"'
alias grep "ugrep --color=auto -F"

# Get fastest mirrors
alias mirrors 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'

functions -e z
function z
    set dir (__z -l | fzf --height 40% --layout reverse --info inline --nth 2.. --no-sort --query "$argv" --bind 'enter:become:echo {2..}')
    if test -n "$dir"
        cd $dir
    end
end

fzf --fish | source

function fish_user_key_bindings
    bind --preset -e \b
    bind -e \b
    bind --preset -e \cw
    bind \b backward-kill-word

    bind --preset -e \ca
    bind --preset -e \cu
    bind \cA\b backward-kill-line

    bind --preset -e \ck
    bind --preset -e \e\x7f
    bind \e\b kill-word
    bind \cA\e\b kill-line

    bind \ez 'commandline -r "z $(commandline)"; commandline -f execute'
end
