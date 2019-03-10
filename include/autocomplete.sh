function autocomplete {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    # All but last word:
    #prev="${COMP_WORDS[@]::$(( ${#COMP_WORDS[@]} - 1 ))}"
    prev="${COMP_WORDS[@]::$(( ${#COMP_WORDS[@]} - 0 ))}"
    COMPREPLY=($(compgen -W "$(SNOW_AUTOCOMPLETE=1 $prev)" -- "${cur}"))
}
complete -F autocomplete snow