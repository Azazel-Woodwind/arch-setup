function h
    echo "Commandline Shortcuts:"
    echo "  - `CTRL + backspace` - Delete the word before the cursor"
    echo "  - `CTRL + ALT + backspace` - Delete the word after the cursor"
    echo "  - `CTRL + a + backspace` - Delete from cursor to the beginning of the line"
    echo "  - `CTRL + a + ALT + backspace` - Delete from cursor to the end of the line (note the order of the keys)"
    echo "  - `CTRL + x` - Copy commandline buffer"
    echo "  - `CTRL + z` - Undo"
    echo

    echo "Utility Shortcuts:"
    echo "  - `CTRL + r` - Interactive search through command history"
    echo "  - `CTRL + l` - Clear the screen"
    echo "  - `ALT + c` - Interactive cd"
    echo "  - `ALT + z` - Interactive jump to any recently visited directories"
    echo

    echo "Utility functions:"
    echo "  - `help_me` - Show this help message"
    echo "  - `gcb BRANCH` - Interactively checkout to a branch using fzf"
    echo " - `fish_key_reader` - Find the binding for a specific key/s"
    echo

    echo "Tmux Commands:"
    echo "  - `PREFIX ~ h` - Split the window horizontally"
    echo "  - `PREFIX ~ v` - Split the window vertically"
    echo "  - `PREFIX ~ CTRL + c` - Enter copy mode"
    echo "  - `PREFIX ~ CTRL + I (Shift + I)` - Install plugins"
    echo "  - `PREFIX ~ ALT + u` - Uninstall plugins"
    echo "  - `PREFIX ~ U (Shift + U)` - Update plugins"
    echo "  - `PREFIX ~ CTRL + u` - Search for a URL to open"
    echo "  - `PREFIX ~ x` - Kill the current pane"
    echo "  - `PREFIX ~ CTRL + w` - Kill the current window"
    echo "  - `SHIFT + <ARROW-KEY>` - Navigate between panes"
    echo "  - `CTRL + SHIFT + <ARROW-KEY>` - Navigate between windows"
    echo "  - `PREFIX ~ CTRL + n` - New window"
    echo "  - `PREFIX ~ z` - Toggle zoom on the current pane"
    echo "  - `PREFIX ~ CTRL + space` - Interactive predictive copy text from the terminal"
    echo "  - `PREFIX ~ j` - Quickly jump cursor to somewhere on screen by char"
    echo "  - `PREFIX ~ f` - Fast copy something on screen"
    echo "  - `PREFIX ~ O (Shift + O)` - Interactively manage tmux sessions"
    echo "  - `PREFIX ~ TAB` - Open directory tree"
    echo "  - `PREFIX ~ F (Shift + F)` - Open interactive Tmux menu (sainnhe/tmux-fzf)"
    echo "  - `PREFIX ~ \\` - Open interactive Tmux menu (jaclu/tmux-menus)"
    echo "  - `PREFIX ~ p` - Open tome of useful commands (laktak/tome)"
    echo "  - `CTRL + f` - Search in copy mode"
    echo

    echo "NOTE:"
    echo "  - PREFIX is `CTRL-space`"
    echo "  - If the command following the prefix begins with CTRL, you don't need to lift your finger off the CTRL key"
end
