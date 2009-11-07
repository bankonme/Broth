#!/bin/bash  
# broth/stock/chroot_local-hooks/75-pdrc_gen.sh
# this script generates the .pdrc file
# it takes the pdrc_template.txt plus the results of a find command
# to assemble the final .pdrc

FIND=/usr/bin/find
PDRC=/etc/skel/.pdrc

# Run the script only if Pd is installed
# (Prevent liveCD build failure if Pd is not in the package list)

if [ -d /usr/lib/pd/extra/ ]; then
	
	# template starts
	echo "-stderr" > $PDRC
	echo "-jack" >> $PDRC
	echo "" >> $PDRC
	echo "-lib zexy" >> $PDRC
	echo "-lib iemlib1:iemlib2:iem_mp3:iem_t3_lib" >> $PDRC
	echo "-lib iemmatrix" >> $PDRC
	echo "-lib Gem" >> $PDRC
	echo "-lib gridflow" >> $PDRC
	echo "-lib pdp" >> $PDRC
	echo "-lib pidip" >> $PDRC
	echo "-lib gem2pdp" >> $PDRC
	echo "-lib creb" >> $PDRC
	echo "-lib lua" >> $PDRC
	echo "" >> $PDRC
	# template ends

	${FIND} /usr/lib/pd/extra/ -type d -exec echo "-path {}" >> $PDRC \;

fi

