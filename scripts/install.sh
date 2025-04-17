#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_DIR="${SCRIPT_DIR}/../platform"

echo "=== Running Ansible Playbook: Install Prerequisites (Tutor CLI, etc.) ==="

# Ensure ansible-playbook is available, try to install if missing (best effort)
if ! command -v ansible-playbook &> /dev/null; then
    echo "Ansible not found, attempting to install..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y ansible python3-pip git
    elif command -v yum &> /dev/null; then
        sudo yum install -y ansible python3-pip git
    else
        echo "Warning: Cannot automatically install ansible. Please install it manually."
        # Attempt to install ansible via pip if python3-pip is present
        if python3 -m pip --version &> /dev/null; then
             echo "Attempting pip install ansible..."
             python3 -m pip install --user ansible
             # Add ~/.local/bin to PATH for this session if needed
             if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                export PATH="$HOME/.local/bin:$PATH"
                echo "Temporarily added $HOME/.local/bin to PATH"
             fi
             if ! command -v ansible-playbook &> /dev/null; then
                 echo "ERROR: Failed to install ansible via pip."
                 exit 1
             fi
        else
            echo "ERROR: Cannot install ansible. Please install python3-pip and ansible."
            exit 1
        fi
    fi
fi


cd "${PLATFORM_DIR}"
ansible-playbook site.yml --tags tutor_prereqs

echo "=== Prerequisite Installation Completed ==="

# Source .bashrc again in case PATH was updated by pip user install
if [[ -f ~/.bashrc ]]; then
   source ~/.bashrc
   echo "Sourced ~/.bashrc to update PATH if necessary."
fi
