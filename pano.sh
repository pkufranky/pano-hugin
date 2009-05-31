#!/bin/sh

# sudo apt-get install hugin-tools
# wget http://debian-multimedia.org/pool/main/a/autopano-sift-c/autopano-sift-c_2.5.0-0.0_i386.deb
# dpkg -i autopano-sift-c_2.5.0-0.0_i386.deb
# wget http://launchpadlibrarian.net/19472301/enblend_3.2%2Bdfsg-1_i386.deb
# dpkg -i enblend_3.2+dfsg-1_i386.deb
# sudo apt-get install graphviz
# sudo cpan install Panotools::Script  

usage() {
	echo "\
  USAGE: $0 <dir>
"
	exit
}

d=$1
test -z "$d" && usage

pushd $d || exit

rm pano.pto pano.jpg *.tif
autopano-sift-c --projection 0,50 pano.pto *.jpg
#autopano-sift-c --refine --align pano.pto pano.pto

ptoclean -v --output pano.pto pano.pto

autooptimiser -a -l -s -o pano.pto pano.pto

# TODO: allow ptovariable to specify anchor
ptovariable --vignetting --response --exposure pano.pto
vig_optimize -o pano.pto pano.pto

nona -z PACKBITS -r ldr -m TIFF_m -o pano pano.pto
enblend --compression 100 -o pano.jpg *.tif
rm *.tif

popd
