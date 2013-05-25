#!/bin/sh

find . -name *.asm >> tmp
find . -name *.c >> tmp
find . -name *.cpp >> tmp
find . -name *.h >> tmp
#find . -name *.dpr >> tmp
find . -name *.pas >> tmp
find . -name *.java >> tmp
cat tmp | xargs wc -l
rm -f tmp

