#!/bin/bash
for username in	sandeep.rawat 

do
    userdel -r $username
done

for username in robert developer
do
    passwd -l $username
done