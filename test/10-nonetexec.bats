#!/usr/bin/env bats

export PATH="$PWD:$PATH"

@test "process does not access network" {
    run nonetexec echo ok
    cat << EOF
--- output
$output
--- output
EOF

    [ "$status" -eq 0 ]
    [ "$output" = "ok" ]
}

@test "process accesses network" {
    run nonetexec nc 1.1.1.1 80
    cat << EOF
--- output
$output
--- output
EOF

    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}
