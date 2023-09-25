#!/bin/bash
function print_color(){
    case $1 in 
    red) color=$(tput setaf 1) ;;
    green) color=$(tput setaf 2);;
    yellow) color=$(tput setaf 3);;
    blue) color=$(tput setaf 4);;
    esac
    echo -e "${color} $2 $(tput sgr0)"
}

function compute(){

        case $1 in 
            1)  echo "Kindly enter the numeric values for this operation"
                read -p "Number 1:  " Number1
                read -p "Number 2:  " Number2
                Answer=$(( $Number1 + $Number2 ))
                echo " Answer=$Answer";;
            2)  echo "Kindly enter the numeric values for this operation"
                read -p "Number 1:  " Number1
                read -p "Number 2:  " Number2
                Answer=$(( $Number1 - $Number2 ))
                echo " Answer=$Answer" ;;
            3)  echo "Kindly enter the numeric values for this operation"
                read -p "Number 1:  " Number1
                read -p "Number 2:  " Number2
                Answer=$(( $Number1 * $Number2 ))
                echo " Answer=$Answer" ;;
            4)  echo "Kindly enter the numeric values for this operation"
                read -p "Number 1:  " Number1
                read -p "Number 2:  " Number2
                Answer=$(( $Number1 / $Number2 ))
                echo " Answer=$Answer" ;;
            5)  echo "Thank you for your time, Goodbye" ;;
            *)  echo "Invalid entry, Enter a Number from the Menu below" continue
        esac
   
}
function main(){
    while [[ $operator -ne 5 ]]
    do
        print_color "yellow" " _____________________________________________________________________"
        print_color "green" " _____________________________________________________________________"
        print_color "red" " Welcome To The Great Calculator Powered by Tchidi "
        print_color "green" " _____________________________________________________________________"
        print_color "yellow" " _____________________________________________________________________"
        echo " What operation would you like to carry out "
        print_color "blue" "1. Add \n 2. Subtract \n 3. Multiply \n 4. Divide \n 5. Quit\n"
        read operator
        compute "$operator"
    done
}
main