# Tutor K3s Deployment for Open edX

This repository automates the deployment of Open edX using Tutor's Kubernetes mode (`tutor k8s`) onto an *existing* K3s cluster provisioned by the `tfgrid-k3s` project.

**This repository must be cloned and executed on the management node provisioned by `tfgrid-k3s`.**

## Overview

This project uses Ansible, running locally on the management node, to:
1.  Install the Tutor CLI.
2.  Configure Tutor settings (domain names, plugins, etc.).
3.  Deploy Open edX resources to the connected K3s cluster using `tutor k8s` commands.

## Prerequisites

*   You must be logged into the **management node** created by the `tfgrid-k3s` project.
*   The management node must have functional `kubectl` access to the K3s cluster.
*   Required tools (`python3`, `pip`) should be present (the `install` step attempts to ensure this).
*   Internet access is required for downloading Tutor and container images.

## Quick Start

1.  **SSH into your management node:**
    ```bash
    # From the machine where you ran tfgrid-k3s make:
    make connect-management # (From within the tfgrid-k3s directory)
    # Or manually:
    ssh root@<management-node-ip>
    ```

2.  **Clone this repository on the management node:**
    ```bash
    git clone <your-tutor-k3s-repo-url>
    cd tutor-k3s
    ```

3.  **Configure Deployment Variables:**
    *   Edit `platform/inventory.ini` to set your desired Open edX domain names and other configurations. Pay close attention to the `[local:vars]` section.
    ```ini
    # Example platform/inventory.ini [local:vars]
    lms_host: "learn.mydomain.com"
    cms_host: "studio.mydomain.com"
    tutor_version: "17.0.3" # Specify Tutor version
    # Add other Tutor config variables as needed
    account_email: "admin@mydomain.com" # For Let's Encrypt
    enable_https: true
    # Required plugins (k8s is essential)
    tutor_plugins_required:
      - name: k8s
        enabled: true
    # Optional plugins
    #  - name: discovery
    #    enabled: true
    #  - name: ecommerce
    #    enabled: true
    #  - name: notes
    #    enabled: true
    ```

4.  **Run the Full Deployment:**
    ```bash
    make
    ```
    This will:
    *   Check prerequisites (`make check`)
    *   Install Tutor (`make install`)
    *   Configure Tutor (`make configure`)
    *   Deploy Open edX (`make deploy`)

5.  **Accessing Open edX:**
    *   After deployment, you need to configure DNS records for your specified `lms_host` and `cms_host` to point to the external IP address of the Kubernetes Ingress controller service. Find this IP by running (on the management node):
        ```bash
        kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
        # Or if using MetalLB with a specific IP range: check MetalLB resources
        ```
    *   Once DNS propagates, you should be able to access your Open edX platform via the configured domain names.

## Makefile Targets

*   `make check`: Verify prerequisites.
*   `make install`: Install Tutor CLI.
*   `make configure`: Apply Tutor configuration.
*   `make deploy`: Deploy/upgrade Open edX.
*   `make all`: Run check -> install -> configure -> deploy.
*   `make clean`: **DANGER!** Destroys the Open edX deployment using `tutor k8s destroy`. This removes pods, services, volumes, etc.
*   `make help`: Display available targets.

## Project Structure

```
tutor-k3s/
├── platform/        # Ansible configuration
│   ├── ansible.cfg  # Local Ansible settings
│   ├── inventory.ini  # Host (localhost) and variables
│   ├── roles/       # Ansible roles for each step
│   └── site.yml      # Main playbook orchestrating roles
├── scripts/         # Shell script wrappers for Makefile targets
├── Makefile         # Main entry point
└── README.md        # This file
```

## Customization

*   **Tutor Configuration:** Adjust variables in `platform/inventory.ini` and the template `platform/roles/tutor_config/templates/config.yml.j2`.
*   **Tutor Plugins:** Modify `tutor_plugins_required` and add optional plugins in `platform/inventory.ini`.
*   **Tutor Patches:** Place patch files in `platform/files/patches/` and reference them in `platform/inventory.ini` using Tutor's patching mechanism variables if needed.

## Troubleshooting

*   Ensure `kubectl get nodes` runs successfully from the management node.
*   Check pod statuses: `kubectl get pods -n openedx`.
*   View logs of specific pods: `kubectl logs -n openedx <pod-name>`.
*   Check Tutor logs: Tutor commands executed via Ansible will output logs to the console.
*   Consult the official Tutor documentation: [docs.tutor.edly.io](https://docs.tutor.edly.io/)
