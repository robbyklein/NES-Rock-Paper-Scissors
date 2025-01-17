#!/bin/bash

# Watch for changes in the src directory and nested folders
watch_files() {
    echo "Watching for changes in 'src' and nested folders..."
    fswatch -o src | while read -r _; do
        echo "Change detected. Rebuilding..."
        build_and_run
    done
}

# Function to build and optionally launch Mesen
build_and_run() {
    echo "Starting build process..."

    # Create the dist directory if it doesn't exist
    if [ ! -d "dist" ]; then
        echo "Creating dist directory..."
        mkdir dist
    fi

    # Remove previously built files
    echo "Cleaning up old build files..."
    rm -f dist/main.o
    rm -f dist/main.nes
    rm -f dist/main.dbg
    echo "Cleanup complete."

    # Start new build
    echo "Assembling..."
    ca65 src/main.asm -o dist/main.o --debug-info
    if [ $? -ne 0 ]; then
        echo "Error during assembly (ca65). Aborting build."
        return
    fi

    echo "Linking..."
    ld65 dist/main.o -o dist/main.nes -C nrom128.cfg --dbgfile dist/main.dbg
    if [ $? -ne 0 ]; then
        echo "Error during linking (ld65). Aborting build."
        return
    fi

    echo "Build complete."

    # Check if Mesen is running and launch if necessary
    if pgrep -x "Mesen" >/dev/null; then
        echo "Mesen is already running."
    else
        echo "Opening ROM in Mesen..."
        "/Applications/Mesen.app/Contents/MacOS/Mesen" dist/main.nes &
    fi
}

# Ensure fswatch is installed
if ! command -v fswatch >/dev/null 2>&1; then
    echo "Error: fswatch is not installed. Install it using 'brew install fswatch'."
    exit 1
fi

# Start watching files for changes
watch_files
