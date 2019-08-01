SHELL_SCRIPT=sh
BREW=brew cask
HAMMERSPEEN=hammerspoon

deps:
	make deps-install
	make deps-init-env
deps-install:
	$(BREW) install $(HAMMERSPEEN)
deps-remove:
	$(BREW) remove $(HAMMERSPEEN)
deps-init-env:
	$(SHELL_SCRIPT) app/init_env.sh
run:
	make run-copy-requirements
	make run-copy-lua
run-copy-requirements:
	$(SHELL_SCRIPT) app/copy_requirements.sh
run-copy-lua:
	$(SHELL_SCRIPT) app/copy_lua.sh
reload-hammerspoon:
	hs -c "hs.console.reload()"
remove:
	make deps-remove
