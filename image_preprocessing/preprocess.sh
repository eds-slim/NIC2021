#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASEDIR="$DIR/../../"


export FSLOUTPUTTYPE=NIFTI_GZ

# Preprocess lesion masks, i.e. crop
# use semaphore idiom for parallelisation
# https://unix.stackexchange.com/a/216475/369230

############################
############################
open_sem(){
	mkfifo pipe-$$
	exec 3<>pipe-$$
	rm pipe-$$
	local i=$1
	for((;i>0;i--)); do
		printf %s 000 >&3
	done
}
run_with_lock(){
	local x
	read -u 3 -n 3 x && ((0==x)) || exit $x
	(
		( "$@"; )
		printf '%.3d' $? >&3
	)&
}
############################
############################

function crop {
	f=$1
	echo $f
	gunzip "$deriv"/"$f"
	g=$(basename $f)
	g=${g%%.*}

	fslroi "$deriv/${g}.nii" "$deriv/${g}_cropped.nii" 0 181 0 217 0 181
	gunzip "$deriv/${g}_cropped.nii"
	rm "$deriv/${g}.nii"
	mv "$deriv/${g}_cropped.nii" "$deriv/${g}.nii"
}

N=8
cnt=0
open_sem $N


	orig="$BASEDIR"/lesionmasks/original
	deriv="$BASEDIR"/lesionmasks/derivatives

	rm -rf "$deriv"
	mkdir -p "$deriv"
	cp -r "$orig"/* "$deriv"

	for f in $(ls "$deriv"); do
		run_with_lock crop "$f" 
		pids[${cnt}]=$!
		cnt=$[cnt+1]
	done


# wait for all pids
for pid in ${pids[*]}; do
	wait $pid
done
