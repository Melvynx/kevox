#!/bin/zsh
# ###
# 15.03.20
# Melvyn Malherbe

if [[ $# -ne 1 ]]; then
  echo "Please add the directory."
  exit 1
fi

# try if something exist
if [[ ! -d "$1" ]]; then
  echo "Err: Directory not exist."
  echo "---"
  echo "Usage: cmd /directory"
  exit 1
fi

# directory=("${directory[@]:1}") // remove first element
directories=("$1")

exclucedDirectories=("build" "node_modules" "dist" "three.js-master" "tmp" "bin" "release" "Release" "debug" "Debug" "PublishProfiles")

# ! STAT
fileCount=0

rm log.txt
while [ ${#directories[@]} -gt 0 ]; do
  echo "BOUCLE START ${#directories[@]}"
  echo "BOUCLE WITH VALUE: ${directories[0]}"

  # https://stackoverflow.com/questions/26769493/how-do-i-loop-through-a-directory-path-stored-in-a-variable
  for file in ${directories[0]}/*; do
    if [[ -f ${file} ]]; then
      echo "FILE: ${file}"

      extension=$(echo $file | rev | cut -d '.' -f 1 | rev)

      countFile=$(echo $(wc -l $file) | cut -d ' ' -f 1)
      echo "$extension $(( $countFile + 1 )) $file" >> log.txt
        
      (( fileCount++ ))
    elif [[ -d ${file} ]]; then
      echo "DIRECTORY: $file"

      folderName=$(echo $file | rev | cut -d '/' -f 1 | rev)  

      isExclude=$(echo ${exclucedDirectories[@]} | grep -o "$folderName" | wc -w)

      if [[ $isExclude -eq 0 ]]; then
        directories+=($file)
      else
        echo "I just exclude: $folderName"
      fi
    else
      echo "UNKNOWN: $file"
    fi
    
  done

  directories=("${directories[@]:1}")
done

extensionsString=("js" "md" "jsx" "ts" "tsx" "rb" "sh" "txt" "html" "css" "svg" "cs")

## now loop through the above array
for i in "${extensionsString[@]}"
do
  $(grep "$i " log.txt > $i.txt)
  total=()

  while read p; do
    count=$(echo $p | tr -dc '0-9')
    total+=($count)
  done < $i.txt

  totalLength=${#total[@]}

  if [[ $totalLength -eq 0 ]]; then
    echo "DESTROY $totalLength ${total[@]} $i"
    rm "$i.txt"
    continue
  fi

  sum=0
  for y in ${total[@]}; do
    sum=$(($sum+$y))  
  done

  min=${total[0]}
  for y in ${total[@]}; do
    if [[ $y -lt $min ]]; then
      min=$y
    fi
  done

  max=0
  for y in ${total[@]}; do
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
      med=$(( (${total[index]} + ${total[index + 1]}) / 2))
    fi
  fi

  echo ""
  echo "---------- $i ----------" 
  echo "Total lines: $sum"
  echo "Minimum lines file: $min"
  echo "Maximum lines file: $max"
  echo "Moyenne lines file: $moy"
  echo "Mediane lines file: $med"
  echo "---------- $i ----------" 

  # or do whatever with individual element of the array
  # TODO: mediane marche pas
  rm "$i.txt"
done

echo ""
echo "---------- END ----------"
echo "File count: $fileCount"

# ###
# end of shell script
# ###