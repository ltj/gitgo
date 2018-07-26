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
			if [[ $1 == "comp" ]]; then
			 	open "$final$PRPATH"
			elif [[ $1 == "pr" ]]; then
				branch="$(git rev-parse --abbrev-ref HEAD)"
				open "$final$PRPATH/$branch?expand=1"
			else
			 	open "$final"
			fi
		else
			echo 'Sorry. The current directory is not inside a git work tree'
		fi
	}

	alias ghg='gitgo'
	alias ghc='gitgo comp'
	alias ghp='gitgo pr'

fi
