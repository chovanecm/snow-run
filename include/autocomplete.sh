function autocomplete {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[@]::$(( ${#COMP_WORDS[@]} - 1 ))}"
    COMPREPLY=($(compgen -W "$(SNOW_AUTOCOMPLETE=1 $prev)" -- "${cur}"))
}
complete -F autocomplete snow