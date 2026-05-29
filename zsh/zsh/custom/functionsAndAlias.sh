alias sync-config="cd \$HOME/Projects/dotfiles &&  git-auto-sync w . &"
alias v="env npm_config_registry=http://registry.npmjs.org nvim"

alias lv="lvim"
alias gwl="git worktree list"
alias cd='z'

proxy() {
	port=$1

	export proxy_address="http://127.0.0.1:${port:-7897}"
	export all_proxy=$proxy_address
	export http_proxy=$proxy_address
	export https_proxy=$proxy_address
}

unproxy() {
	unset proxy_address
	unset all_proxy
	unset http_proxy
	unset https_proxy
}
# Git

# Function to clone a specific repository
# Arguments:
#   $1: Repository name
#   $2: Destination path
# Example usage:
# clone_my_repo my-repo /path/to/destination
clone_my_repo() {
	# Check if the required arguments are provided
	if [ -z "$1" ]; then
		echo "Please provide repo name"
		return 1
	fi

	repo_name=$1
	dist_path=$2

	git clone "git@github.com:BilderLoong/${repo_name}.git" "$dist_path"
}

# Make it easy to operate clipboard in macOS.
alias pbc='pbcopy'
alias pbp='pbpaste'

alias gsave='git add . && git commit -m "save"; git pull origin HEAD &&  git push origin HEAD'

# rm_all_nest_node_modules
trash_all_nest_node_modules() {
	directory=${1:-.}
	echo "removing ${directory}"
	find $1 -name 'node_modules' -type d -prune -exec trash -rf '{}' +
}

if [[ $commands[eza] ]]; then
	# general use
	alias ls='eza'                                                         # ls
	alias l='eza -lbF --git'                                               # list, size, type, git
	alias ll='eza -lbGF --git'                                             # long list
	alias llm='eza -lbGF --git --sort=modified'                            # long list, modified date sort
	alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
	alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

	# speciality views
	alias lS='eza -1'                                                      # one column, just names
	alias lt='eza --tree --level=2'                                        # tree
fi
