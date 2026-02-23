# If you want to use this config on a new PC, add this to the config.fish:
# source <path_to_this_file>

# Use Fish's built-in path management instead of Bash-style exports
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# Only run this stuff if we are actually in an interactive terminal 
if status is-interactive
    
    # Fish way of doing conditional default assignment
    if test -z "$GOBIN"
        # Check if 'go' exists before running go env
        if type -q go
            set -gx GOBIN (go env GOPATH)/bin
        end
    end

    # SSH setup 
    ssh-add ~/.ssh/id_rsa 2>/dev/null

    # Clear terminal on startup
    clear

    # Custom Prompt
    function fish_prompt
        set_color red
        echo -n $USER
        set_color normal
        echo -n '@'
        set_color blue
        echo -n (prompt_hostname)
        echo -n ' '
        set_color yellow
        echo -n (prompt_pwd)
        set_color normal
        echo -n ' % '
    end

    # Environment variables
    set -gx CLICOLOR 1
    set -gx LSCOLORS gxfxcxdxbxegedabagacad
    set -gx VIMINIT 'source ~/gitrepos/configs/vim/.vimrc'

    # Aliases 
    alias ls="ls --color=auto"
    alias lS="ls -a --color=auto"
    alias lsa="ls -a --color=auto"
    alias lsl="ls -l --color=auto"
    alias lsal="ls -a -l --color=auto"
    alias lsL="ls -a -l --color=auto"
    alias clr="clear"
    alias kube="kubectl"

    # Override cd command to always print files
    function cd
        builtin cd $argv; and lsa
    end

    # Add cds command for quiet directory changing
    function cds
        builtin cd $argv
    end

end # End of interactive block

# --- PATH Modifications ---

# pipx
fish_add_path ~/.local/bin

# Go setup - checking if go exists prevents errors on fresh OS installs
if type -q go
    set -gx GOROOT (go env GOROOT)
    if test -n "$GOROOT"
        fish_add_path $GOROOT/bin
    end

    set -gx GOPATH (go env GOPATH)
    if test -n "$GOPATH"
        fish_add_path $GOPATH/bin
    end
end