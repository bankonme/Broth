#!/bin/bash
# The chroot include folder is under SVN.
# To make a clean injection in the chroot we remove the .svn

LS="/bin/ls"
RM="/bin/rm"

# Clean the root folder
echo "removing .svn from /"
"${RM}" -rf /.svn

# Selective cleaning
for i in $("${LS}")
do
	echo "removing .svn from /$i"
	find "/$i" -name ".svn" -exec rm -rf {} \; > /dev/null 2>&1
done
