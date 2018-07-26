#!/bin/zsh

PRPATH="/compare"

if [[ "$OSTYPE" = darwin* ]] ; then

	function gitgo() {
		if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
			url="$(git remote get-url origin)"
			if [[ $url = *"https"* ]]; then
				final=$(sed 's_\.git__' <<< "$url")
			else
				final=$(sed -e 's_:_/_' -e 's_git@_https://_' -e 's_\.git__' <<< "$url")
			fi
			if [[ $1 == "pr" ]]; then
			 	open "$final$PRPATH"
			 else
			 	open "$final"
			fi
		else
			echo 'Sorry. The current directory is not inside a git work tree'
		fi
	}

	alias ghg='gitgo'
	alias ghp='gitgo pr'

fi
