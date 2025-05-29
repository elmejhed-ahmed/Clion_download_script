#!/bin/bash

PATH_DIR="$HOME/goinfre"
LINK="https://download-cdn.jetbrains.com/cpp/CLion-2025.1.1.tar.gz"
F_PATH="CLion-2025.1.1.tar.gz"
EXTRACT_DIR="clion-2025.1.1"
LOGFILE="$PATH_DIR/install.log"

# ✅ Ultra-light spinner (0.5s refresh, low CPU)
spinner() {
    local pid=$1
    local chars='-\|/'
    local i=0
    tput civis
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r⏳ Please wait... %c" "${chars:$i:1}"
        sleep 0.5
    done
    tput cnorm
    printf "\r✅ Done!               \n"
}

# ✅ Download and extract in virtual subprocess
install_clion() {
    (
        curl -sSL "$LINK" -o "$PATH_DIR/$F_PATH"
        tar -xf "$PATH_DIR/$F_PATH" -C "$PATH_DIR"
        rm -f "$PATH_DIR/$F_PATH"
        rm -f "$LOGFILE"
    ) > "$LOGFILE" 2>&1
}

# ✅ Setup logic
if [ -d "$PATH_DIR/$EXTRACT_DIR" ]; then
    echo "✅ CLion already installed at: $PATH_DIR/$EXTRACT_DIR"
elif [ -f "$PATH_DIR/$F_PATH" ]; then
    echo "📦 Extracting CLion..."
    (
        tar -xf "$PATH_DIR/$F_PATH" -C "$PATH_DIR"
        rm -f "$PATH_DIR/$F_PATH"
        rm -f "$LOGFILE"
    ) > "$LOGFILE" 2>&1 &
    spinner $!
    echo "✅ Extracted to $PATH_DIR/$EXTRACT_DIR"
else
    echo "🌐 Downloading and extracting CLion..."
    install_clion &
    spinner $!
    echo "✅ Installed to $PATH_DIR/$EXTRACT_DIR"
fi

