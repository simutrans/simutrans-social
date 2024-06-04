#!/bin/bash
#
# Copyright (c) 2024 Roberto Michán Sánchez (Roboron) <roboron@simutrans.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# Program to generate patch notes from SVN revision messages.
# It takes three arguments:
#   -p <number>: Previous revision number (i.e. Previous stable release revision number).
#   -c <number>: Current revision number (i.e. Previous stable release revision number). Default to HEAD.
#   -f: Include fixes.
# It will generate a text file formated with BBCode, suited for the International Simutrans Forum / Steam News.
# You can later use forum-to-blog.sh to generate an HTML blog post suited for the Simutrans Blog.

PREV="";
CURRENT=HEAD;
WITH_FIXES=false;

while getopts 'p:c:f' opt; do
        case "$opt" in
                p)
                        PREV="$OPTARG"
                        ;;
                c)
                        CURRENT="$OPTARG"
                        ;;
                f)
                        WITH_FIXES=true
                        ;;
                ?|h)
                        echo "Usage: $(basename $0) [-p previous revision] [-c current revision] [-f]"
                        exit 1
        esac
done

if [ "$PREV" == "" ]
then
        echo "Usage $(basename $0) [-p previous revision] [-c current revision] [-f]"
        exit 1
fi

echo -e "[h2]Highlights of this version[/h2]\n\n" >> patch-notes.txt
echo -e "[list]\n" >> patch-notes.txt
echo -e "[*]\n" >> patch-notes.txt
echo -e "[/list]\n" >> patch-notes.txt

echo -e "[h2]Paksets updated on Steam[/h2]\n\n" >> patch-notes.txt
echo -e "[list]\n" >> patch-notes.txt
echo -e "[*]\n" >> patch-notes.txt
echo -e "[/list]\n" >> patch-notes.txt

echo -e "[h2]Paksets updated outside Steam[/h2]\n\n" >> patch-notes.txt
echo -e "[list]\n" >> patch-notes.txt
echo -e "[*]\n" >> patch-notes.txt
echo -e "[/list]\n" >> patch-notes.txt

echo -e "[h2]Full changelog[/h2]\n" >> patch-notes.txt
echo -e "Here's the full list of changes since the last version.\n" >> patch-notes.txt
echo -e "[b]Added[/b]\n" >> patch-notes.txt
echo -e "[quote][list]\n" >> patch-notes.txt
svn log -r $CURRENT:$PREV | grep ADD | grep -v sqa | grep -v CODE | sed "s/.*ADD[^ ]\?/[*]/g" >> patch-notes.txt
echo -e "[/list][/quote]\n" >> patch-notes.txt
echo -e "[b]Changed[/b]\n" >> patch-notes.txt
echo -e "[quote][list]\n" >> patch-notes.txt
svn log -r $CURRENT:$PREV | grep CHG | grep -v sqa | grep -v CODE | sed "s/.*CHG[^ ]\?/[*]/g" >> patch-notes.txt
echo -e "[/list][/quote]\n" >> patch-notes.txt


# too long to be displayed fully usually
if [ "$WITH_FIXES" = true ]
then
        echo -e "[b]Fixed[/b]" >> patch-notes.txt
        echo -e "[quote][list]\n" >> patch-notes.txt
        svn log -r $CURRENT:$PREV | grep FIX | grep -v sqa | grep -v CODE | sed "s/.*FIX[^ ]\?/[*]/g" >> patch-notes.txt
        echo -e "[/list][/quote]\n" >> patch-notes.txt
fi

# por si acaso
sed -i "s/.*: /[*] /g" patch-notes.txt
sed -i "s/ADD//g" patch-notes.txt
sed -i "s/CHG//g" patch-notes.txt
sed -i "s/FIX//g" patch-notes.txt
