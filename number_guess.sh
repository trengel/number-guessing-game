#!/bin/bash

SECRET_NUMBER=$((1 + RANDOM % 1000))
echo -n "Enter your username: "; read USERNAME
echo $USERNAME
