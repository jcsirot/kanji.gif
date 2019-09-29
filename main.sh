#! /bin/sh -e

usage() {
    echo "Usage: $0 [-a] <kanji>"
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
    if [ $a_flag = "true" ]; then
        python kanimaji.py $tmp_dir/$src_file
        cp $tmp_dir/${codepoint}_anim.gif /out/$c.gif
    else
        python kanistatic.py $tmp_dir/$src_file
        cp $tmp_dir/${codepoint}.png /out/$c.png
    fi
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

print_usage() {
  printf "Usage: ..."
}

a_flag=''

while getopts 'ah' flag; do
  case "${flag}" in
    a) a_flag='true' ;;
    h) usage
       exit 1 ;;
  esac
done

shift $((OPTIND-1))
char=$@

if [ -z $char ]; then
    usage
elif [ $char = "-" ]; then
    char_list
else
    single
fi
