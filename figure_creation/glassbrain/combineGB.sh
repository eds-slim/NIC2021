#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASEDIR="$DIR/../../.."

OUTDIR="$BASEDIR/derivatives/figures/glassbrain"
if [ ! -d "$OUTDIR" ]; then
	mkdir -p "$OUTDIR"
fi


	for asz in 86 116; do

		INDIR="$BASEDIR/derivatives/NeMo_output/$asz"

		convert  "$INDIR/GBmeanChaCo_coronalfigure_${asz}.tif" \
			-gravity Center -crop 730x600+20+-20 +repage \
			-draw "line 365,0 365,730" \
			-undercolor '#ffc0cb' -gravity north  -pointsize 36 -annotate -100+40 'NoDe' \
			-undercolor '#ffc0cb' -gravity north  -pointsize 36 -annotate +100+40 'ChaCo' \
			cor.png

		convert  "$INDIR/GBmeanChaCo_axialfigure_${asz}.tif" \
			-gravity Center -crop 670x730+-15+0 +repage \
			-trim -rotate -90 -flop\
			-draw "line 240,0 240,730" \
			-undercolor '#ffc0cb' -gravity north  -pointsize 36 -annotate -100+40 'NoDe' \
			-undercolor '#ffc0cb' -gravity north  -pointsize 36 -annotate +100+40 'ChaCo' \
			ax.png


		montage -mode concatenate -tile 2x1 -border 0  -gravity Center \
			-pointsize 50 -label "coronal"  cor.png \
			-label "axial" ax.png \
			"$OUTDIR/GBall_${asz}.png"

		rm ax.png cor.png
	
	done
