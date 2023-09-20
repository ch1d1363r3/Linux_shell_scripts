while [[ $operation -ne 5 ]]
do
    echo "----------------------------------------------------------------------------"
    echo "Welcome to the Menu driven Calculator by Tchidi"
    echo "Kindly enter choose the operation you would like to carry out from the menu below"
    echo "1. Add"
    echo "2. Subtract"
    echo "3. Multiply"
    echo "4. Divide"
    echo "5. Quit"
    echo "--------------------------------------------------------------------------------"
    read operation

        if [ $operation -eq 1 ]
        then
            echo "Kindly enter the numeric values for this operation"
            read -p "Number 1:  " Number1
            read -p "Number 2:  " Number2
            Answer=$(( $Number1 + $Number2 ))
            echo " Answer=$Answer"
        elif [ $operation -eq 2 ]
        then
            echo "Kindly enter the numeric values for this operation"
            read -p "Number 1:  " Number1
            read -p "Number 2:  " Number2
            Answer=$(( $Number1 - $Number2 ))
            echo " Answer=$Answer"
        elif [ $operation -eq 3 ]
        then
            echo "Kindly enter the numeric values for this operation"
            read -p "Number 1:  " Number1
            read -p "Number 2:  " Number2
            Answer=$(( $Number1 * $Number2 ))
            echo " Answer=$Answer"
        elif [ $operation -eq 4 ]
        then
            echo "Kindly enter the numeric values for this operation"
            read -p "Number 1:  " Number1
            read -p "Number 2:  " Number2
            Answer=$(( $Number1 / $Number2 ))
            echo " Answer=$Answer"
        elif [ $operation -eq 5 ]
        then
        break       
        else
        echo "Invalid entry, Enter a Number from the Menu below"
        fi
        continue
done
echo "Thank you for using my Calculator, hope you enjoyed it. GoodBye!!!"
