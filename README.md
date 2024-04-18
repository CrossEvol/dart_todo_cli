# Intro

After build the native app, use the help command to know usage.
The app will create a hive database under the /tmp directory.

A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

Todo:
- help 
- add (title, priority, desc)
- list (verbose, status)
- remove (index)
- show (index, json, text)
- edit
  - title (index, value)
  - desc (index, value)
  - priority (index, value)
- reset
- done (index, all)
- undone (index, all)

TodoModel {create_at, update_at, title, desc, priority}

# Makefile
## build
```shell
make build 
```
output:
```shell
dart compile exe bin/dart_todo_cli.dart -o todo.exe
Generated: **\todo.exe
```

## reset
```shell
make reset
```
output:
```shell
todo.exe reset && todo.exe add --title=a  && todo.exe add --title=b && todo.exe
add --title=c
Reset Success.
Add Todo#a success.
Add Todo#b success.
Add Todo#c success.
```