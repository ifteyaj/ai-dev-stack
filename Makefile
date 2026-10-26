.PHONY: install check doctor update new uninstall test status

install:
	@./scripts/install.sh --with-opencode --with-settings
check:
	@./scripts/check-harness.sh && ./scripts/test-harness.sh && shellcheck -S warning scripts/*.sh config/hooks/*.sh tests/*.sh
doctor:
	@./scripts/doctor.sh $(P)
update:
	@./scripts/update.sh --dry-run && ./scripts/update.sh
new:
	@./scripts/new-project.sh $(DIR) $(NAME)
uninstall:
	@./scripts/uninstall.sh
test:
	@./scripts/test-harness.sh
status:
	@./scripts/status.sh
changelog-check:
	@./scripts/check-changelog.sh