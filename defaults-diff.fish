#!/usr/bin/env fish

argparse --name=defaults-diff h/help a/only-after -- $argv

if set -q _flag_help
    echo -e "Usage:\t$(basename (status -f)) [OPTIONS]"
    echo -e ""
    echo -e "Options:"
    echo -e "   -a, --only-after   Don't update the before plist"
    echo -e "   -h, --help         Show this message"
    exit 0
end

function main
    if not type -q opendiff
        echo "Could not find opendiff. Is Xcode installed and set up?"
        exit 1
    end

    set plist $argv[1]

    set before "/tmp/defaults.before"
    set after "/tmp/defaults.after"

    if not set -q _flag_only_after
        defaults read $plist >"$before"
        if test $status -gt 0
            exit 1
        end
    end
    read -n 1 -p "echo 'Make your changes and then hit [enter]:'"
    defaults read $plist >"$after"

    opendiff "$before" "$after"
end

main $argv
