#!/bin/bash

# This is for running a set of Singular file automatically

echo "Start Time: (Note: Following MSTs are not considering daylight saving)"
zdump MST
echo "------------------------------------------------------------------"
Singular RH33bit.sing
sleep 2
echo "Time after finishing task 33:"
zdump MST
echo "------------------------------------------------------------------"
Singular RH51bit.sing
sleep 2
echo "Time after finishing task 51:"
zdump MST
echo "------------------------------------------------------------------"
Singular RH65bit.sing
sleep 2
echo "Time after finishing task 65:"
zdump MST
echo "------------------------------------------------------------------"
Singular RH81bit.sing
sleep 2
echo "Time after finishing task 81:"
zdump MST
echo "------------------------------------------------------------------"
Singular RH89bit.sing
sleep 2
echo "Time after finishing task 89:"
zdump MST