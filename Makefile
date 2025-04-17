.PHONY: all install configure deploy clean help check

# Default target: Run prerequisite checks, install tutor, configure, and deploy
all: check install configure deploy

# Check prerequisites on the management node
check:
	bash scripts/check_prereqs.sh

# Install Tutor CLI and necessary system packages
install: check
	bash scripts/install.sh

# Configure Tutor (config.yml, plugins)
configure: check install
	bash scripts/configure.sh

# Deploy Open edX using Tutor k8s commands
deploy: check configure
	bash scripts/deploy.sh

# Destroy the Open edX deployment (use with caution)
clean: check install
	bash scripts/destroy.sh

# Help information
help:
	@echo "Tutor K3s Deployment Makefile Targets:"
	@echo "  make check      - Verify prerequisites (kubectl, python, pip) on this node"
	@echo "  make install    - Install/Update Tutor CLI and dependencies"
	@echo "  make configure  - Configure Tutor settings (config.yml, plugins)"
	@echo "  make deploy     - Deploy/Update Open edX to the K3s cluster"
	@echo "  make all        - Run check, install, configure, and deploy steps"
	@echo "  make clean      - Destroy the Open edX Kubernetes deployment (CAUTION!)"
	@echo "  make help       - Show this help message"
