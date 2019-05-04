#!/bin/sh
pwd=$(pwd)
while true; do
    if make ; then
        (cd out && python3 -m http.server) &
    fi
    PID=$!
    echo ">> PID: $PID"
    inotifywait \
        -r \
        -e modify \
        -e attrib \
        -e move \
        -e create \
        -e delete \
        --exclude '.*(#|\.git|logs).*' \
        .
    kill $PID
    echo "================================================"
done
