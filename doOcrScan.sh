#!/bin/bash
set -e

mountVolume='\\192.168.178.70\Documents'
mountPath="/mnt/synology"
ocrOutputDir="processed"
unprocessedPdfDir="unprocessed"

#sudo mount -t drvfs $mountVolume $mountPath
pushd "$mountPath/$unprocessedPdfDir"

echo "Processing pdfs"
mkdir -pv $ocrOutputDir

for f in *.{pdf,PDF}
do
	if [ -f "$f" ]
	then
		echo "Processing $f";
		ocrmypdf $f "$ocrOutputDir/$f"
	fi
done

echo "OCR done. Moving files now..."
pushd $ocrOutputDir
for f in *{.pdf,PDF}
do
	if [ -f "$f" ]
	then
		echo "moving file $f to correct location"
		yearMonthPath=$(echo "$f" | cut -d'_' -f 1 | sed 's/^\([0-9]\{4\}\)\([0-9]\{2\}\).*/\1\/\2\//g')
		finalPath="$mountPath/$yearMonthPath"
		echo "Final Path is: $finalPath"
		mkdir -pv $finalPath
		mv $f "$finalPath"

	fi
done
popd
rmdir $ocrOutputDir

popd

echo "Done, now exiting..."
#sudo umount $mountPath