#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_DIR="${SCRIPT_DIR}/../platform"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!! WARNING: This will destroy your Open edX Kubernetes deployment! !!!"
echo "!!! This includes pods, services, volumes (data loss!), etc.       !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
read -p "Are you absolutely sure you want to proceed? (Type 'yes' to confirm): " confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo "=== Running Ansible Playbook: Destroy Open edX K8s Deployment ==="

cd "${PLATFORM_DIR}"
ansible-playbook site.yml --tags tutor_destroy -v

echo "=== Open edX Destruction Initiated ==="
