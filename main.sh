#! /bin/sh -x

usage() {
    echo "Usage: $0 <kanji>"
    exit 1
}

single() {
    tmp_dir=$(mktemp -d -t kj-XXXXXXXXXX)
    codepoint="$(/codepoint.py $char)"
    src_file="$codepoint.svg"
    cp /kanjivg/kanji/$src_file $tmp_dir/$src_file
    python kanimaji.py $tmp_dir/$src_file
    cp $tmp_dir/${codepoint}_anim.gif /out/$char.gif
    rm -rf $tmp_dir
}

char_list() {
    file="/in/data.txt"
    while IFS= read line
    do
        tmp_dir=$(mktemp -d -t kj-XXXXXXXXXX)
        codepoint="$(/codepoint.py $line)"
        src_file="$codepoint.svg"
        cp /kanjivg/kanji/$src_file $tmp_dir/$src_file
        python kanimaji.py $tmp_dir/$src_file
        cp $tmp_dir/${codepoint}_anim.gif /out/$line.gif
        rm -rf $tmp_dir
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
