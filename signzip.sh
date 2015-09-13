#!/bin/bash
# This script calls the signapk.jar file to sign a flashable update.zip
# Colour variables
red='tput setaf 1'		# red
green='tput setaf 2'            # green
yellow='tput setaf 3'		# yellow
blue='tput setaf 4'		# blue
violet='tput setaf 5'           # violet
lblue='tput setaf 6'		# lightblue
grey='tput setaf 7'		# grey
white='tput setaf 10'		# white
normal='tput sgr0'		# normal
if [ ! $1 ]
then
$red
echo -e "No input file defined!"
$normal
echo -e "Usage: signzip [FILENAME]"
else
echo -e "Signing zip..."
sleep 2
java -jar signapk.jar testkey.x509.pem testkey.pk8 $1 "signed_"$1
md5sum "signed_"$1 > "signed_"$1.md5sum
$lblue
echo -e "Package completed: "signed_"$1 "
$normal
fi

