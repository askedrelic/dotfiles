#!/bin/sh

screen -X split
screen -X focus down
screen -X screen sh -c "cd $PWD; $SHELL; screen -X remove"
