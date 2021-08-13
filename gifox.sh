#!/bin/zsh
# ###
# 01.06.20
# Melvyn Malherbe

# todo: avoid take number in foldername / file
echo $1 $2

if [[ -z $1 ]]; then
  echo "Err ! Missing 1er argument"
  echo "script.sh path_to_test path_to_move extensions"
  exit 1
fi

if [[ -z $2 ]]; then
  echo "Err ! Missing 2th argument"
  echo "script.sh path_to_test path_to_move extensions"
  exit 1
fi

if [[ -z $3 ]]; then
  echo "Err ! Missing 3th argument"
  echo "script.sh path_to_test path_to_move extensions"
  exit 1
fi

# important variables
exclucedDirectories=("build" "node_modules" "dist" "tmp" "bin" "release" "Release" "debug" "Debug" "PublishProfiles" "gartic" $3)
extensionsString=($3)
directories=($1)
fileCount=0
debug=0
deleteLog=1

# check flags
while getopts dkp:e:x: opts; do
   case ${opts} in
      d) debug=1;;
      k) deleteLog=0
   esac
done

# while directories is not empty
while [ ${#directories[@]} -gt 0 ]; do
  # https://stackoverflow.com/questions/26769493/how-do-i-loop-through-a-directory-path-stored-in-a-variable
  for file in ${directories[0]}/*; do
    if [[ -f ${file} ]]; then
      echo "FIND FILE: $file"

      extension=$(echo $file | rev | cut -d '.' -f 1 | rev)

      needMove=$(echo ${extensionsString[@]} | grep -o "\<${extension}\>" | wc -w)
      echo $needMove "for $file"
      if [[ $needMove -eq 1 ]]; then
        fileWithoutSpace=$(echo "$file" | sed 's/ /\\ /g')
        mv -- "$fileWithoutSpace" "$2"
        (( fileCount++ ))

        echo "MOVE : $file in $2"
      fi
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

echo ""
echo "---------- END ----------"
echo "Moved files count: $fileCount"

# ###
# end of shell script
# ###