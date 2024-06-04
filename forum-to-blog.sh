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

# Simple program to convert a BBCode post to an HTML post
# Usually used to convert a post from the International Simutrans Forum / Steam News to a Simutrans Blog post
# It takes a file where the post is written in bbcode, and convert that very same file to html
# TODO: revisar si el width de las imágenes realmente es necesario...

FILE=$1

# convert links
sed -i 's/\[url="/<a href="/g' $FILE
sed -i 's/\[url=/<a href="/g' $FILE
sed -i 's/\[\/url\]/<\/a>/g' $FILE

# convert images
sed -i 's/\[img\]/<img src="/g' $FILE
sed -i 's/\[\/img\]/" width="800">/g' $FILE

# convert lists
sed -i 's/\[list\]/<ul>/g' $FILE
sed -i 's/\[\/list\]/<\/ul>/g' $FILE
sed -i 's/\[\/olist\]/<\/ol>/g' $FILE
sed -i 's/\[olist\]/<ol>/g' $FILE
sed -i 's/\[\*\]/<li>/g' $FILE
#sed -i 's/\[\/list\]/</ul>/g' $FILE

# convert headers
sed -i 's/\[h1]/<h1>/g' $FILE
sed -i 's/\[\/h1\]/<\/h1>/g' $FILE
sed -i 's/\[h2]/<h2>/g' $FILE
sed -i 's/\[\/h2\]/<\/h2>/g' $FILE
sed -i 's/\[h3]/<h3>/g' $FILE
sed -i 's/\[\/h3\]/<\/h3>/g' $FILE

# convert bold
sed -i 's/\[b]/<b>/g' $FILE
sed -i 's/\[\/b\]/<\/b>/g' $FILE

# convert cursive
sed -i 's/\[i]/<i>/g' $FILE
sed -i 's/\[\/i\]/<\/i>/g' $FILE

# convert underline
sed -i 's/\[u]/<u>/g' $FILE
sed -i 's/\[\/u\]/<\/u>/g' $FILE

# remove quotes
sed -i 's/\[quote\]/"/g' $FILE
sed -i 's/\[\/quote\]/"/g' $FILE

sed -i 's/\"]/">/g' $FILE
sed -i 's/\]/">/g' $FILE
