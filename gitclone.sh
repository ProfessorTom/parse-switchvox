#!/bin/sh
set -x
mv ~/parse-switchvox ~/temp.dir
git clone http://github.com/novationsys/parse-switchvox.git
if [ ! -d $HOME/parse-switchvox ]; then
echo Clone failed. Restoring old source
mv ~/temp.dir ~/parse-switchvox
exit -1
fi
# copy is good - copy the file to apache
# one file that is being copied is the file that is being run to
# create the copies, so we won't be able to overwrite it.
mv /var/www/cgi-bin /var/www/cgi-bin.old
mkdir /var/www/cgi-bin
cp ~/parse-switchvox/*.pl /var/www/cgi-bin/
# remove the old copy
if [ ! -f /var/www/cgi-bin/parse-switchvox.pl ]; then
echo Copy failed. Restoring old scripts.
rm -rf /var/www/cgi-bin
mv /var/www/cgi-bin.old /var/www/cgi-bin
exit -1
fi
# clean up old copies of everything
rm -rf /var/www/cgi-bin.old
rm -rf ~/temp.dir
chgrp -R cgibin /var/www/cgi-bin
