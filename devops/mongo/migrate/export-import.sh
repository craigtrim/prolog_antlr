#!/bin/bash

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output=${here}/output
mkdir -p $output
echo $here

collection_list='ingest.txt'

if [ -z $ORIGIN_URL ]
then
    echo '$ORIGIN_URL needs to be defined with the url to connect to the origin mongodb instance'
    exit 1
fi
if [ -z $TARGET_URL ]
then
    echo '$TARGET_URL needs to be defined with the url to connect to the target mongodb instance'
    exit 1
else
    TARGET_URL="$(echo $TARGET_URL | sed -e 's/ibmclouddb/cendant/g')"
fi

function count_for_collection() {
    mongo "${@:2}" --eval "db.$1.stats()" \
     | grep '"count"' \
     | sed "s/[^0-9]//g"
}

while read collection; do
    collection="${collection%,}"
    collection="${collection%\"}"
    collection="${collection#\"}"
    collection_file=${output}/${collection}.json

    count_origin=$(count_for_collection $collection "$ORIGIN_URL" )
    echo "Collection ${collection} has ${count_origin} documents in origin"
    count_target=$(count_for_collection $collection "$TARGET_URL" --ssl --sslAllowInvalidCertificates )
    echo "Collection ${collection} has ${count_target} documents in target"
    [[ -z "${count_origin}" ]] && count_origin=0
    [[ -z "${count_target}" ]] && count_target=0

    if [ $count_target -eq  $count_origin ]; then
        continue
    fi

    if [ -f $collection_file ]; then
        count_lines=$(sed '/^\s*$/d' $collection_file | wc -l | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        echo "${collection_file} has ${count_lines} lines"
        if (( $count_origin ==  $count_lines )); then
            echo "Not exporting again ${collection}"
        else
            if [ $count_origin -ne 0 ]; then
                echo "(would be) Removing old file because it has $count_lines non empty lines and we have $count_origin records"
                rm $collection_file
            fi
        fi
    fi
    if [ ! -f $collection_file ]; then
        mongoexport --collection=$collection --uri="$ORIGIN_URL" --out=${collection_file} --jsonFormat=canonical
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo "mongoexport failed"
        fi
    fi

    max_retries=8
    sleep_time=10
    workers=4
    # {1..$max_retries} does not work.
    for i in $(eval echo "{1..$max_retries}"); do
        echo "mongoimport attempt number $i"
        mongoimport --collection=$collection --mode=upsert --numInsertionWorkers=${workers} --writeConcern='{w: 1, j: false}' --uri="$TARGET_URL" --ssl --sslAllowInvalidCertificates --file=${collection_file}
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo "mongoimport attempt $i for $collection failed."
            if [ $i -ne $max_retries ]; then
                echo "I'll wait $sleep_time before retrying"
                sleep $sleep_time
            else
                echo "Failed $i times importing $collection"
            fi
        else
            break
        fi
    done
done < $collection_list
