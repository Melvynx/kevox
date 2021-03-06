#!/bin/zsh
# ###
# 01.06.20
# Melvyn Malherbe

# todo: avoid take number in foldername / file

# check 1 argument is provided
if [[ $# -lt 1 ]]; then
  echo "Err: Please add the directory."
  exit 1
fi

# important variables
exclucedDirectories=("build" "node_modules" "dist" "tmp" "bin" "release" "Release" "debug" "Debug" "PublishProfiles")
extensionsString=("js" "md" "jsx" "ts" "tsx" "rb" "sh" "txt" "html" "css" "svg" "cs" "ru" "json" "sql" "pdf" "yml" "etl" "rake" "erb" "scss")
directories=()
fileCount=0
debug=0
deleteLog=1

# check flags
while getopts dkp:e:x: opts; do
   case ${opts} in
      d) debug=1;;
      p) directories+=${OPTARG};;
      e) extensionsString+=(${OPTARG});;
      x) exclucedDirectories+=(${OPTARG});;
      k) deleteLog=0
   esac
done

function debugEcho {
  if [[ $debug -eq 1 ]]; then
    echo "Debug: " $@
  fi
}

# try if something exist
if [[ ! -d "${directories[0]}" ]]; then
  echo "Err: Directory not exist."
  echo "---"
  echo "Usage: cmd /directory"
  exit 1
fi

if [[ -f log.txt ]]; then
  rm log.txt
fi

# while directories is not empty
while [ ${#directories[@]} -gt 0 ]; do
  # https://stackoverflow.com/questions/26769493/how-do-i-loop-through-a-directory-path-stored-in-a-variable
  for file in ${directories[0]}/*; do
    if [[ -f ${file} ]]; then
      debugEcho "FIND FILE: $file"

      extension=$(echo $file | rev | cut -d '.' -f 1 | rev)

      lineCount=$(echo $(wc -l $file) | cut -d ' ' -f 1)
      echo "- $extension $(( $lineCount + 1 )) $file" >> log.txt

      (( fileCount++ ))
    elif [[ -d ${file} ]]; then
      debugEcho "DIRECTORY: $file"

      folderName=$(echo $file | rev | cut -d '/' -f 1 | rev)  

      isExclude=$(echo ${exclucedDirectories[@]} | grep -o "$folderName" | wc -w)

      if [[ $isExclude -eq 0 ]]; then
        directories+=($file)
      else
        debugEcho "I just exclude: $folderName"
      fi
    else
      debugEcho "UNKNOWN: $file"
    fi
  done

  directories=("${directories[@]:1}")
done

## now loop through the above array
for i in "${extensionsString[@]}"; do
  # create file with only matching extensions files
  $(grep "\- $i " log.txt > $i.txt)
  totalUnsorted=()

  while read p; do
    # get number from string
    # ex: "js 15 x/p/12/troup1.js" -> 15
    count=$(echo $p | awk -F'[^0-9]+' '{ print $2 }')
    totalUnsorted+=($count)
  done < $i.txt

  total=($( printf "%s\n" "${totalUnsorted[@]}" | sort -n ))
  totalLength=${#total[@]}

  if [[ $totalLength -eq 0 ]]; then
    debugEcho "DESTROY $totalLength ${total[@]} $i"
    rm "$i.txt"
    continue
  fi

  sum=0
  min=${total[0]}
  max=0
  for y in ${total[@]}; do
    sum=$(($sum+$y))

    if [[ $y -lt $min ]]; then
      min=$y
    fi

    if [[ $y -gt $max ]]; then
      max=$y
    fi
  done

  moy=$(($sum / $totalLength))

  med=0

  index=$(($totalLength / 2))
  if (( $totalLength % 2 )); then
    med=${total[$index]}
  else
    if [[ $totalLength -eq 2 ]]; then
      med=${total[index]}
    else
      med=$(( (${total[index - 1]} + ${total[index]}) / 2))
    fi
  fi

  echo ""
  echo "---------- $i ----------" 
  echo "Total lines: $sum"
  echo "Total files: $totalLength"
  echo "Minimum lines: $min"
  echo "Maximum lines: $max"
  echo "Moyenne lines: $moy"
  echo "Mediane lines: $med"
  echo "---------- $i ----------" 

  rm "$i.txt"
done

echo ""
echo "---------- END ----------"
echo "File count: $fileCount"

if [[ $deleteLog -eq 1 ]]; then
  rm log.txt
fi

# ###
# end of shell script
# ###