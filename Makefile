.PHONY: help deploy bootstrap configure check reset-host security-check hardening hardening-check


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
	@echo "  make security-check - Validate server security baseline"
	@echo "  make reset-host   - Remove old SSH fingerprint"
	@echo "  make hardening       - Base security + Docker (без мониторинга)"
	@echo "  make hardening-check - Dry-run hardening"
	@echo ""


deploy:
	@echo "=== Bootstrap access ==="

	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/bootstrap.yml \
	ansible/playbooks/bootstrap-user.yml

	@echo "=== Configure server ==="

	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/production.yml \
	ansible/playbooks/server.yml

bootstrap:
	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/production.yml \
	ansible/playbooks/server.yml


configure:
	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/production.yml \
	ansible/playbooks/server.yml


check:
	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/production.yml \
	--check \
	ansible/playbooks/server.yml


reset-host:
	ssh-keygen -R 135.106.137.157

security-check:
	ansible-playbook \
	--vault-password-file .vault_pass \
	-i ansible/inventory/production.yml \
	ansible/playbooks/security-check.yml

hardening:
	@echo "=== Bootstrap deploy user ==="
	ansible-playbook \
		--vault-password-file .vault_pass \
		-i ansible/inventory/bootstrap.yml \
		ansible/playbooks/bootstrap-user.yml

	@echo "=== Hardening server ==="
	ansible-playbook \
		--vault-password-file .vault_pass \
		-i ansible/inventory/production.yml \
		ansible/playbooks/hardening.yml

hardening-check:
	ansible-playbook \
		--vault-password-file .vault_pass \
		-i ansible/inventory/production.yml \
		ansible/playbooks/hardening.yml \
		--check