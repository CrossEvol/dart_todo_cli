# Declare which targets(task) don't need to generate target-file.
.PHONY: help

##

help: ## Know all commands.
	@echo "Ready For Help..."

build: ## Build the exe
	dart compile exe bin/dart_todo_cli.dart -o todo.exe