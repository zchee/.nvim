syntax match yamlTodo contained /\v<(TODO|FIXME|XXX|NOTE)>/

syntax region yamlComment	start="\#" end="$" contains=@yamlSpelling,yamlTodo

hi def link yamlTodo Todo
