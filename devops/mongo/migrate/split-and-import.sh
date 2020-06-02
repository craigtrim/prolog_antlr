#!/bin/bash

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z $1 ]
then
    echo "Usage: $0 file_to_split_and_import"
    exit 1
fi

if [ -z $TARGET_URL ]
then
    echo '$TARGET_URL needs to be defined with the url to connect to the target mongodb instance'
    exit 1
else
    TARGET_URL="$(echo $TARGET_URL | sed -e 's/ibmclouddb/cendant/g')"
fi

# You may tune this...
lines_per_file=1000
workers=2

collection=$(basename "$1" .json)
prefix=${here}/fragments/
mkdir -p ${prefix}
rm -f ${prefix}*

split -l $lines_per_file $1 $prefix
while : ; do
    pending_fragments=$( shopt -s nullglob ; set -- ${prefix}* ; echo $#)
    processed_fragments=0
    if (( pending_fragments==0 ))
    then
        echo "Done!"
        break
    else
        echo "Processing $pending_fragments files..."
    fi
    for fragment in ${prefix}*
    do
        processed_fragments=$((++processed_fragments))
        echo "importing ${fragment}. File ${processed_fragments} of ${pending_fragments}"
        mongoimport --collection=$collection --mode=upsert --numInsertionWorkers=${workers} --writeConcern='{w: 1, j: false}' --uri="$TARGET_URL" --ssl --sslAllowInvalidCertificates --file=${fragment}
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo "mongoimport attempt failed."
        else
            echo "Done with ${fragment}"
            rm ${fragment}
            echo "We have $( shopt -s nullglob ; set -- ${prefix}* ; echo $# ) files to go"
        fi
    done
done

function count_for_collection() {
    mongo "${@:2}" --eval "db.$1.stats()" \
     | grep '"count"' \
     | sed "s/[^0-9]//g"
}
count_lines=$(sed '/^\s*$/d' $1 | wc -l | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
count_target=$(count_for_collection $collection "$TARGET_URL" --ssl --sslAllowInvalidCertificates )
echo "Collection ${collection} has ${count_target} documents. The json file has ${count_lines} lines"
