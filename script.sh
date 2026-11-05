for i in {1..4}; do
    folder="Testcase${i}Diff"
    rm -rf "$folder"

    for file in Testcase$i/*.1.txt
    do
        other="${file%.1.txt}.2.txt"
        name=$(basename "$file" .1.txt)

        if ! cmp -s "$file" "$other"
        then
            mkdir -p "$folder"
            diff -u "$file" "$other" > "$folder/${name}Diff.txt"
        fi
    done
done
