#!/bin/bash

set -o pipefail

script_name=`basename "$0"`

if [ $# -ne 1 ]
then
    echo "usage: $script_name <xml_file>"
    exit 1
fi

xml_file=$1

sed 's/\r//g' "$xml_file" | awk '
function print_line(indent, line)
{
    for (i = 0; i < indent; ++i) {
        printf(" ");
    }
    printf("%s\r\n", line);
}

BEGIN{
    indent = 0;
    indent2 = 0;
}

/^(\s*)$/ {
    printf("\r\n");
    next;
}

# <!--
/^(\s*)<!--.*$/ {
    printf("%s\r\n", $0);
    next;
}

# <tag/>
match($0, /^(\s*)(<\w+.*\/>.*)$/, m) {
    print_line(indent * 2, m[2]);
    indent2 = 0;
    next;
}

# <tag>
match($0, /^(\s*)(<\w+.*>.*)$/, m) {
    print_line(indent * 2, m[2]);
    indent += 1;
    next;
}

# <tag
match($0, /^(\s*)(<\w+)(.*)$/, m) {
    print_line(indent * 2, m[2] m[3]);
    indent2 = indent * 2 + length(m[2]) + 1;
    indent += 1;
    next;
}

# </tag>
match($0, /^(\s*)(<\/\w+.*>.*)$/, m) {
    indent -= 1;
    print_line(indent * 2, m[2]);
    next;
}

# />
match($0, /^(\s*)([^<]*\/>.*)$/, m) {
    indent -= 1;
    print_line(indent2, m[2]);
    next;
}

match($0, /^(\s*)(.*)$/, m) {
    print_line(indent2, m[2]);
    next;
}

{
    printf("%s\r\n", $0);
}
' > "$xml_file.bak"
if [ $? -ne 0 ]; then exit 1; fi

vim -e -s -c ':set nobomb' -c ':set fenc=utf-8' -c ':wq' "$xml_file.bak"
if [ $? -ne 0 ]; then exit 1; fi

mv "$xml_file.bak" "$xml_file"
if [ $? -ne 0 ]; then exit 1; fi

exit 0
