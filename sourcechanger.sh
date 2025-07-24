#!/bin/bash

## remove old copy.
sudo rm -rf /tmp/sourcechanger

## make the new directory we want to use in /tmp
mkdir /tmp/sourcechanger

## to /etc/sourcechanger or bust.
cd /tmp/sourcechanger || exit

## make a one time backup of existing sources.list for later use.
   if [ ! -e "/etc/apt/sources.list-original.bak" ]; then
   sudo cp -f "/etc/apt/sources.list" "/etc/apt/sources.list-original.bak"
   fi

## Assume people are trying more than once.. copy original.bak back.)
   if [ -e "/etc/apt/sources.list-original.bak" ]; then
   sudo cp -f "/etc/apt/sources.list-original.bak" "/etc/apt/sources.list"
   fi

## Grep to make sure the original address is used before proceeding.
   if grep -q "http://deb.debian.org/debian\|https://deb.debian.org/debian\|http://ftp.debian.org/debian\|https://ftp.debian.org/debian" <(head -n 4 "/etc/apt/sources.list-original.bak"); then
  
## Grab the new address.
sudo netselect-apt
#sudo netselect-apt -o /tmp/sourcechanger/sources.list &&

## copy new address and save to file.   
grep -o -m1 'http[s]\?://[^ ]\+' /tmp/sourcechanger/sources.list > /tmp/sourcechanger/sources.txt

## Remove the last / to accommodate both endings used in sources.list (
sed -i 's/.$//' /tmp/sourcechanger/sources.txt

## Replace the old address with the new.
if grep -q "http://deb.debian.org/debian" <(head -n 4 "/etc/apt/sources.list-original.bak"); then
sudo sed -i -e "s/http:\/\/deb.debian.org\/debian/$(sed 's:/:\\/:g' /tmp/sourcechanger/sources.txt)/" /etc/apt/sources.list
elif grep -q "https://deb.debian.org/debian" <(head -n 4 "/etc/apt/sources.list-original.bak"); then
sudo sed -i -e "s/https:\/\/deb.debian.org\/debian/$(sed 's:/:\\/:g' /tmp/sourcechanger/sources.txt)/" /etc/apt/sources.list
elif grep -q "https://ftp.debian.org/debian" <(head -n 4 "/etc/apt/sources.list-original.bak"); then
sudo sed -i -e "s/https:\/\/ftp.debian.org\/debian/$(sed 's:/:\\/:g' /tmp/sourcechanger/sources.txt)/" /etc/apt/sources.list
elif grep -q "http://ftp.debian.org/debian" <(head -n 4 "/etc/apt/sources.list-original.bak"); then
sudo sed -i -e "s/http:\/\/ftp.debian.org\/debian/$(sed 's:/:\\/:g' /tmp/sourcechanger/sources.txt)/" /etc/apt/sources.list
else
echo "Original debian mirrors not found, exiting."
exit 0
fi
## update to check.
if sudo apt-get update -eany; then
echo
echo "Success! Enjoy your new debian mirror."
echo
else
echo
echo "  Something is not quite right - defaulting to original sources.list."
echo
sleep 2
sudo cp -f "/etc/apt/sources.list-original.bak" "/etc/apt/sources.list"
sudo apt update
fi
## if not original
   else
   echo
   echo "Default debian source mirrors not found."
   echo "exiting"
   echo
   rm -rf /tmp/sourcechanger
   fi
## If no internet
else
echo ""
 echo ""
 echo "No Internet connection. Please connect to your internet and try again."
 echo ""
echo ""
fi
