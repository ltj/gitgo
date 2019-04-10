#!/bin/zsh

if [[ "$OSTYPE" = darwin* ]] || [[ "$OSTYPE" = linux* ]] ; then
	if [[ "command -v open" ]] || [[ "command -v xdg-open" ]] ; then

		function gitgo() {
			local PRPATH="/compare"
			local OPEN
			local EREGEX
			local url
			local finalurl
			local branch

			if [[ "$OSTYPE" = darwin* ]] ; then
				OPEN=open
				EREGEX=-E
			else
				OPEN=xdg-open
				EREGEX=-r
			fi

			if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
				url="$(git remote get-url origin)"
				if [[ $url = *"visualstudio"* ]]; then
					finalurl=$(sed "$EREGEX" -e 's_:_/_' -e 's_([a-z]+)@vs-ssh_https://\1_' -e 's_\.git__' -e 's_v3/__' -e 's_com/[^/]+_com_' -e 's_([^/]+)$_\_git/\1_' <<< "$url")
				else
					if [[ $url = *"https"* ]]; then
						finalurl=$(sed 's_\.git__' <<< "$url")
					else
						finalurl=$(sed -e 's_:_/_' -e 's_git@_https://_' -e 's_\.git__' <<< "$url")
					fi
				fi
				if [[ $1 == "comp" ]]; then
				 	$OPEN "$finalurl$PRPATH"
				elif [[ $1 == "pr" ]]; then
					branch="$(git rev-parse --abbrev-ref HEAD)"
					$OPEN "$finalurl$PRPATH/$branch?expand=1"
				else
				 	$OPEN "$finalurl"
				fi
			else
				echo 'Sorry. The current directory is not inside a git work tree.'
			fi
		}

		alias ghg='gitgo'
		alias ghc='gitgo comp'
		alias ghp='gitgo pr'

	fi
fi
