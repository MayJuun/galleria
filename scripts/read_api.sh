#!/bin/bash

fileString=`cat galleria/bin/assets/api.dart | xargs | tr -d ' '`

variables=(fhirDevUrl fhirStageUrl fhirProdUrl)
values=()
for i in ${!variables[@]}; do
    tempValue=`echo $fileString | sed -e "s/.*${variables[$i]}=//" | sed -e 's/;.*//'`
    if [ "$tempValue" = "" ]
    then
        values+=("")
    else 
        values+=(`echo $fileString | sed -e "s/.*${variables[$i]}=//" | sed -e 's/;.*//'`)
    fi
done

fhirDevUrl="${values[0]}"
fhirStageUrl="${values[1]}"
fhirProdUrl="${values[2]}"

# echo $fhirDevUrl
# echo $fhirStageUrl
# echo $fhirProdUrl