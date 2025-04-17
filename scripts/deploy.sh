#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_DIR="${SCRIPT_DIR}/../platform"

echo "=== Running Ansible Playbook: Deploy Open edX via Tutor K8s ==="

cd "${PLATFORM_DIR}"
# Increase verbosity for deployment logs
ansible-playbook site.yml --tags tutor_deploy -v

echo "=== Open edX Deployment/Update Initiated ==="
echo "Monitor pod status using: kubectl get pods -n openedx -w"
