# Declare which targets(task) don't need to generate target-file.
.PHONY: help

##

help: ## Know all commands.
	@echo "Ready For Help..."

build: ## Build the exe
	dart compile exe bin/dart_todo_cli.dart -o todo.exe

gen: ## Generate the options.g.dart
	dart run build_runner build

reset : ## Rest Todo Store
	todo.exe reset && todo.exe add --title=a  && todo.exe add --title=b && todo.exe add --title=c