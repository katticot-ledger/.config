function scpkeita --description 'Copy directory to keita@72.62.46.79'
    if test (count $argv) -eq 0
        echo "Usage: scpkeita <directory>"
        return 1
    end

    set dir $argv[1]

    if not test -e $dir
        echo "Error: Directory '$dir' does not exist"
        return 1
    end

    scp -r $dir keita@72.62.46.79:
end
