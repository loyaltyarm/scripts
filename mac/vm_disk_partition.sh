#!/bin/sh

GETDISK=$(diskutil list | grep "GB" | grep -v "DeployStudioRuntime" | head -1 | awk '{print $NF}')
echo "$GETDISK"

diskutil partitionDisk "${GETDISK}" GPTFormat HFS+ Macintosh\ HD 100%

exit 0
