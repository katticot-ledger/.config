function y
	# Launch yazi, then cd to the directory it quit in (if changed)
	set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	set -l cwd (command cat -- "$tmp")
	if test -n "$cwd" -a "$cwd" != "$PWD"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
