function git_added_lines
    set diff (git -C $argv[1] diff --shortstat)
    if test -z $diff
        echo 0
        return
    end

    set opts (string split "," $diff)
    set first (string trim $opts[2])
    if string match -q "*insertion*" $first
        set num (string split " " $first)[1]
        echo $num
    else
        echo 0
    end
end

function git_deleted_lines
    set diff (git -C $argv[1] diff --shortstat)
    if test -z $diff
        echo 0
        return
    end

    set opts (string split "," $diff)
    if test (count $opts) -eq 3
        echo (string split " " $opts[3])[2]
    else
        if string match -q "*deletion*" $opts[2]
            echo (string split " " $opts[2])[2]
        else
            echo 0
        end
    end
end

function git_untracked
    git -C $argv[1] ls-files --others --exclude-standard | wc -l
end

function git_status_counts
    echo (math "$(git -C $argv[1] diff --name-only | wc -l) + $(git -C $argv[1] diff --cached --name-only | wc -l) + $(git -C $argv[1] ls-files --others --exclude-standard | wc -l) + $(git -C $argv[1] stash list | wc -l)")
end

function git_line_changes
    echo (git -C $argv[1] diff --shortstat | awk '{added += $4; deleted += $6} END {print added + deleted}')
end



function git_staged
    echo (git -C $argv[1] diff --cached --name-only | wc -l)
end

function git_stashed
    echo (git -C $argv[1] stash list | wc -l)
end

function git_modified
    echo (git -C $argv[1] diff --name-only --diff-filter=M | wc -l)
end

function git_renamed
    echo (git -C $argv[1] diff --name-only --diff-filter=R | wc -l)
end

function git_conflicted
    echo (git -C $argv[1] diff --name-only --diff-filter=U | wc -l)
end

function git_deleted
    echo (git -C $argv[1] diff --name-only --diff-filter=D | wc -l)
end

function git_host
    if set remote_url (git -C $argv[1] ls-remote --get-url)
        set domain (string split ":" $remote_url)[1]
        set host (string split "@" $domain)[2]

        if string match -q "*github*" $host
            set GIT_REMOTE_SYMBOL ""
        else if string match -q "*gitlab*" $host
            set GIT_REMOTE_SYMBOL ""
        else if string match -q "*bitbucket*" $host
            set GIT_REMOTE_SYMBOL ""
        else if string match -q "*git*" $host
            set GIT_REMOTE_SYMBOL ""
        end

        echo "$GIT_REMOTE_SYMBOL $host"
    else
        echo " localhost"
    end
end

function truncate_path
    set full_path $argv[1]
    set home_prefix (string replace -r "^$HOME" "~" $full_path)
    
    set -l shortened_path
    for dir in (string split "/" $home_prefix)
        if test "$dir" = (string split "/" $home_prefix)[-1]
            set shortened_path "$shortened_path$dir"
        else
            set shortened_path "$shortened_path"(string sub -l 1 $dir)"/"
        end
    end

    echo $shortened_path
end