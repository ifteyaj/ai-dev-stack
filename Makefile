.PHONY: install check doctor update new uninstall

install:
	@./scripts/install.sh --with-opencode --with-settings
check:
	@./scripts/check-harness.sh && shellcheck scripts/*.sh
doctor:
	@./scripts/doctor.sh $(P)
update:
	@./scripts/update.sh --dry-run && ./scripts/update.sh
new:
	@./scripts/new-project.sh $(DIR) $(NAME)
uninstall:
	@./scripts/uninstall.sh