#!/bin/bash
# Helper script to ensure tutor commands run with the correct environment/path

# Ensure ~/.local/bin is in PATH if tutor was installed via pip --user
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check if tutor command exists now
if ! command -v tutor &> /dev/null; then
    echo "ERROR: 'tutor' command not found in PATH."
    echo "PATH is currently: $PATH"
    exit 1
fi

# Execute the tutor command passed as arguments
echo "Executing: tutor $*"
tutor "$@"
