#! /bin/sh -e

usage() {
    echo "Usage: $0 <kanji>"
    exit 1
}

generate() {
    c=$(echo $1 | xargs)
    tmp_dir=$(mktemp -d -t kj-XXXXXXXXXX)
    codepoint="$(/codepoint.py $c)"
    src_file="$codepoint.svg"
    if [ ! -f "/kanjivg/kanji/$src_file" ]; then
        echo "\"$c\" could not be found in the character database"
        exit 1
    fi
    cp /kanjivg/kanji/$src_file $tmp_dir/$src_file
    python kanimaji.py $tmp_dir/$src_file
    cp $tmp_dir/${codepoint}_anim.gif /out/$c.gif
    rm -rf $tmp_dir
}

single() {
    generate $char
}

char_list() {
    file="/in/data.txt"
    while IFS= read line
    do
        generate $line
    done <"$file"
}

char="$1"

if [ -z $char ]; then
    usage
elif [ $char = "-" ]; then
    char_list
else
    single
fi
