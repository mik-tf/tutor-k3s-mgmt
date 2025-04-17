#!/bin/bash
set -e

echo "=== Checking Prerequisites on Management Node ==="
errors=0

# Check kubectl
echo -n "Checking for kubectl... "
if command -v kubectl &> /dev/null; then
    echo "Found: $(command -v kubectl)"
    echo -n "Checking kubectl connection to cluster... "
    if kubectl get nodes > /dev/null; then
        echo "OK"
    else
        echo "FAILED! Cannot connect to K3s cluster via kubectl."
        echo "Ensure tfgrid-k3s deployment completed and kubeconfig is correct (~/.kube/config)."
        errors=$((errors + 1))
    fi
else
    echo "NOT FOUND! kubectl is required."
    errors=$((errors + 1))
fi

# Check python3
echo -n "Checking for python3... "
if command -v python3 &> /dev/null; then
    echo "Found: $(command -v python3) - $(python3 --version)"
else
    echo "NOT FOUND! python3 is required."
    errors=$((errors + 1))
fi

# Check pip3
echo -n "Checking for pip3... "
if python3 -m pip --version &> /dev/null; then
    echo "Found: $(python3 -m pip --version)"
else
    # Attempt to find pip associated with python3 directly
    if command -v pip3 &> /dev/null; then
        echo "Found: $(command -v pip3) - $(pip3 --version)"
    else
         echo "NOT FOUND! python3-pip is likely required (will be installed by 'make install')."
         # Not counting as error yet, as install step handles it
    fi
fi

# Check git
echo -n "Checking for git... "
if command -v git &> /dev/null; then
    echo "Found: $(command -v git)"
else
    echo "NOT FOUND! git is required (will be installed by 'make install')."
     # Not counting as error yet, as install step handles it
fi


# Check Ansible (optional, but good to know)
echo -n "Checking for ansible-playbook... "
if command -v ansible-playbook &> /dev/null; then
    echo "Found: $(command -v ansible-playbook)"
else
    echo "NOT FOUND! Ansible is required (will be installed by 'make install')."
     # Not counting as error yet, as install step handles it
fi


if [ $errors -gt 0 ]; then
    echo "--------------------------------------------------"
    echo "ERROR: Prerequisite checks failed. Please resolve the issues above."
    exit 1
else
    echo "--------------------------------------------------"
    echo "Prerequisites check passed (or issues will be addressed by 'make install')."
fi
