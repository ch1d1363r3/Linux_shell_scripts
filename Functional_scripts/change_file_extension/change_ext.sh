#!/bin/bash
function main(){

    function print_color(){
        case $1 in 
            red) color=$(tput setaf 1);;
            green) color=$(tput setaf 2);;
            yellow) color=$(tput setaf 3);;
            blue) color=$(tput setaf 4);;
            *) color=$(tput setaf 0);;
        esac
        echo -e "${color} $2 $(tput sgr0)"
    }
    print_color "blue" "==================================================================="
    print_color "yellow" "Welcome, you wish to change files with a certain extention ....\t\n Kindly enter the extension you want to change"
    print_color "blue" "==================================================================="
    read ext1
    print_color "blue" "==================================================================="
    print_color "yellow" "Now enter the absolute path where these files are"
    print_color "blue" "==================================================================="
    read path
    print_color "blue" "==================================================================="
    print_color "yellow" "Finally, enter the extension you wish to use as replacement ...."
    print_color "blue" "==================================================================="
    read ext2
    function ext_changer(){
        path_finder=$(ls $path)
        for file in $path_finder
        do
            if [[ $file == *.$ext1 ]]
            then
                new_name=$(echo $file| sed "s|$ext1|$ext2|g")
                mv $path/$file $path/$new_name
            fi
        done
    }
    ext_changer
    print_color "blue" "==================================================================="
    print_color "green" "File Extensions have now been changed successfuly ...."
    print_color "blue" "==================================================================="
}
main