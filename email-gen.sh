#!/bin/bash

echo "Generating email"

echo "What is the date of the recap?"

read date

file="Meeting Recap - $date"

echo "Hey Pulsites!\n" > "$file"
echo -n "How would you like to begin?"
echo ""

echo "Press ctrl-d to finish"
cat >> "$file"

echo $input >> "$file"
echo ""
echo "==================================================\n" >> "$file"
echo "What We Did\n" >> "$file"

echo "What did we do today?"

cat >> "$file"

echo ""
echo "==================================================\n" >> "$file"
echo "Agenda\n" >> "$file"

echo "What is your agenda for the next meeting?"

cat >> $file

echo "==================================================\n" >> "$file"
echo "Notes\n" >> "$file"

echo "Signature?"

cat >> $file

echo "Would you like to view the file? [y,n]"
read response
if ["response"="y"]; then
    cat response
fi
