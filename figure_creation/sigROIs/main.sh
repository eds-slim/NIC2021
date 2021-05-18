#!/bin/bash

export FREESURFER_HOME=/usr/local/freesurfer
export FS_LICENSE=$FREESURFER_HOME/license.txt 
source $FREESURFER_HOME/SetUpFreeSurfer.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASEDIR="$DIR/../../.."


IFS=$'\n' ## allow spaces in file names

INDIR="$BASEDIR/derivatives/surface_maps/$atlas"

SUBJECT=fsaverage	
export SUBJECTS_DIR=/usr/local/freesurfer/subjects/
annot=aparc
atlas=86

source $FREESURFER_HOME/SetUpFreeSurfer.sh
mri_annotation2label --subject $SUBJECT --hemi lh --annotation $annot --border borderfile${atlas}.mgh --outdir ./ --surface inflated


tksurfer $SUBJECT rh pial\
	-labels-under\
	-annot $annot\
	-colortable aparc.annot${atlas}.ctab\
	-tcl script.tcl


convert -alpha remove temp0.tiff -fuzz 10% -trim +repage -bordercolor Black -border 30x30 temp0.png
convert temp0.png \( +clone -fx 'p{0,0}' \)  -compose Difference  -composite   -modulate 100,0  +matte  difference.png
convert difference.png -bordercolor white -border 1x1 -matte -fill none -fuzz 7% -draw 'matte 1,1 floodfill' -shave 1x1 removed_black.png
convert removed_black.png -channel matte -separate  +matte matte.png
convert matte.png -negate -blur 0x1 matte-negated.png
composite -compose CopyOpacity matte.png temp0.png finished.png


## create video of rotating brain
exit
ffmpeg -framerate 25 -f image2 -i $f.rgb/%d-capture.rgb -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p $f.rgb/$f.mp4
