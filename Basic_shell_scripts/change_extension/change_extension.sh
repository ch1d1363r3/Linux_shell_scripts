for file in $(ls path)
do
        if [[ $file = *.ext1 ]]
                then
                new_name=$(echo $file| sed 's/ext1/ext2/g')
                mv path/$file path/$new_name
        fi
done