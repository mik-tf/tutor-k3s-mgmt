#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_DIR="${SCRIPT_DIR}/../platform"

echo "=== Running Ansible Playbook: Configure Tutor ==="

cd "${PLATFORM_DIR}"
ansible-playbook site.yml --tags tutor_config

echo "=== Tutor Configuration Completed ==="
