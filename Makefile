.PHONY: help deploy bootstrap configure check reset-host


help:
	@echo ""
	@echo "SDAHub Platform"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make deploy       - Full server deployment"
	@echo "  make bootstrap    - Create deploy user"
	@echo "  make configure    - Configure existing server"
	@echo "  make check        - Ansible dry run"
	@echo "  make reset-host   - Remove old SSH fingerprint"
	@echo ""


deploy:
	@echo "=== Bootstrap access ==="

	ansible-playbook \
	-i ansible/inventory/bootstrap.yml \
	ansible/playbooks/bootstrap-user.yml

	@echo "=== Configure server ==="

	ansible-playbook \
	-i ansible/inventory/production.yml \
	ansible/playbooks/server.yml


bootstrap:
	ansible-playbook \
	-i ansible/inventory/bootstrap.yml \
	ansible/playbooks/bootstrap-user.yml


configure:
	ansible-playbook \
	-i ansible/inventory/production.yml \
	ansible/playbooks/server.yml


check:
	ansible-playbook \
	-i ansible/inventory/production.yml \
	--check \
	ansible/playbooks/server.yml


reset-host:
	ssh-keygen -R 135.106.137.157