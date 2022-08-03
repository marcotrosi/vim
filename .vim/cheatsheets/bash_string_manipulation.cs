# String Length

    ${#string}
    expr length $string
    expr "$string" : '.*'

# Length of Matching Substring at Beginning of String

    expr match "$string" '$substring'
    expr "$string" : '$substring'

# Index

    expr index $string $substring

# Substring Extraction

    ${string:position}

If the `$string` parameter is `"*"` or `"@"`, then this extracts the positional parameters, starting at $position.

    ${string:position:length}

Extracts `$length` characters of substring from `$string` at `$position`.

# Is it possible to index from the right end of the string?

    echo ${stringZ:-4}

Defaults to full string, as in ${parameter:-default}.
However ...

    echo ${stringZ:(-4)}
    echo ${stringZ: -4}

Now, it works.
Parentheses or added space "escape" the position parameter.

If the `$string` parameter is `"*"` or `"@"`, then this extracts a maximum of `$length` positional parameters, starting at `$position`.

    echo ${*:2}          Echoes second and following positional parameters.
    echo ${@:2}          Same as above.
    echo ${*:2:3}        Echoes three positional parameters, starting at second.

    expr substr $string $position $length

Extracts `$length` characters from `$string` starting at `$position`.

    expr match "$string" '\($substring\)'

Extracts `$substring` at beginning of `$string`, where `$substring` is a regular expression.

    expr "$string" : '\($substring\)'

Extracts `$substring` at beginning of `$string`, where `$substring` is a regular expression.

    expr match "$string" '.*\($substring\)'

Extracts `$substring` at end of `$string`, where `$substring` is a regular expression.

    expr "$string" : '.*\($substring\)'

Extracts `$substring` at end of `$string,` where `$substring` is a regular expression.

# Substring Removal

    ${string#substring}

Deletes shortest match of `$substring` from front of `$string`.

    ${string##substring}

Deletes longest match of `$substring` from front of `$string`.

    ${string%substring}

Deletes shortest match of `$substring` from back of `$string`.

    ${string%%substring}

Deletes longest match of `$substring` from back of `$string`.

# Substring Replacement

    ${string/substring/replacement}

Replace first match of `$substring` with `$replacement`.

    ${string//substring/replacement}

Replace all matches of `$substring` with `$replacement`.

    ${string/#substring/replacement}

If `$substring` matches front end of `$string`, substitute `$replacement` for `$substring`.

    ${string/%substring/replacement}

If `$substring` matches back end of `$string`, substitute `$replacement` for `$substring`.

# vim: ft=markdown fdm=marker fmr=<<<,>>>
