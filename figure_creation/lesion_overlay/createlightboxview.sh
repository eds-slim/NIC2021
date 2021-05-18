#!/bin/bash
render_fsl () {
fsleyes \
render --outfile "$6" --size 800 600 \
--scene lightbox \
--worldLoc -0.00005340576171875 -18.00005340576172 21.99994659423828 \
--displaySpace "$1" \
--zaxis $2 \
--sliceSpacing $3 \
--zrange $4 $5 \
--ncols 9 --nrows 2 \
--bgColour 0.0 0.0 0.0 \
--fgColour 1.0 1.0 1.0 \
--cursorColour 0.0 1.0 0.0 \
--showColourBar \
--colourBarLocation top \
--colourBarLabelSide top-left \
--colourBarSize 100.0 \
--hideCursor \
--labelSize 12 \
--performance 3 \
--movieSync /usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz \
--name "MNI152_T1_1mm" \
--overlayType volume \
--alpha 100.0 \
--brightness 50.0 \
--contrast 50.0 \
--cmap greyscale \
--negativeCmap greyscale \
--displayRange 0.0 9999.0 \
--clippingRange 0.0 10098.99 \
--gamma 0.0 \
--cmapResolution 256 \
--interpolation none \
--numSteps 100 \
--blendFactor 0.1 \
--smoothing 0 \
--resolution 100 \
--numInnerSteps 10 \
--clipMode intersection \
--volume 0 "$1" \
--name "${1%%.*}" \
--overlayType volume \
--alpha 100.0 \
--brightness 50.0 \
--contrast 50.0 \
--cmap brain_colours_blackbdy \
--negativeCmap greyscale \
--displayRange $7 25.0 \
--clippingRange $7 53.53 \
--gamma 0.0 \
--cmapResolution 256 \
--interpolation none \
--numSteps 100 \
--blendFactor 0.1 \
--smoothing 0 \
--resolution 100 \
--numInnerSteps 10 \
--clipMode intersection \
--volume 0
}