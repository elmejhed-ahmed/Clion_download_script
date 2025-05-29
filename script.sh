#!/bin/bash

PATH_DIR="$HOME/goinfre"
LINK="https://download-cdn.jetbrains.com/cpp/CLion-2025.1.1.tar.gz"
F_PATH="CLion-2025.1.1.tar.gz"
EXTRACT_DIR="clion-2025.1.1"
LOGFILE="$PATH_DIR/install.log"

spinner() {
    local pid=$1
    local spin='-\|/'
    local i=0
    tput civis   # hide cursor
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\rDownloading... %c" "${spin:$i:1}"
        sleep 0.1
    done
    tput cnorm   # show cursor
    printf "\rDone!           \n"
}

silent_extract() {
    tar -xvf "$PATH_DIR/$F_PATH" -C "$PATH_DIR" > "$LOGFILE" 2>&1
}

silent_download() {
    curl -L "$LINK" -o "$PATH_DIR/$F_PATH" > "$LOGFILE" 2>&1
}

if [ -d "$PATH_DIR/$EXTRACT_DIR" ]; then
    echo "✅ Directory already exists: $EXTRACT_DIR"
elif [ -f "$PATH_DIR/$F_PATH" ]; then
    echo "📦 Archive found. Extracting..."
    silent_extract &
    pid=$!
    spinner $pid
    wait $pid
    echo "✅ Extraction complete."
else
    echo "🌐 Downloading CLion..."
    silent_download &
    pid=$!
    spinner $pid
    wait $pid
    echo "✅ Download complete."

    echo "📦 Extracting CLion..."
    silent_extract &
    pid=$!
    spinner $pid
    wait $pid
    echo "✅ Extraction complete."
fi
