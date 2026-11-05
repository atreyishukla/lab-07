result=0

for i in {1..4}; do
    folder="Testcase${i}Diff"
    correct=1
    count=0

    for file in Testcase$i/*.1.txt
    do
        other="${file%.1.txt}.2.txt"
        name=$(basename "$file" .1.txt)
        output="$folder/${name}Diff.txt"

        if cmp -s "$file" "$other"
        then
            [ -e "$output" ] && correct=0
        else
            count=$((count + 1))

            if [ ! -f "$output" ] || ! cmp -s <(diff -u "$file" "$other" | tail -n +3) <(tail -n +3 "$output")
            then
                correct=0
            fi
        fi
    done

    if [ "$count" -eq 0 ]
    then
        [ -e "$folder" ] && correct=0
    elif [ ! -d "$folder" ]
    then
        correct=0
    else
        files=$(find "$folder" -mindepth 1 | wc -l)
        [ "$files" -ne "$count" ] && correct=0
    fi

    if [ "$correct" -eq 1 ]
    then
        echo "Testcase$i: PASS"
    else
        echo "Testcase$i: FAIL"
        result=1
    fi
done

exit "$result"
