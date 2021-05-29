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

exclucedDirectories=("build", "node_modules", "dist", "three.js-master")

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

echo "---------- END ----------"
echo "File count: $fileCount"


echo "Array size ${#extensions[@]}"

for key in ${!extensions[@]}; do
    echo "/$key/ :${extensions[key]}:"
done


# ###
# end of shell script
# ###