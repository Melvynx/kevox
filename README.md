# Kevox Stats bash script

I create this bash script for course in EPSIC, to learn BASH.

This script will:

- Read all file / folder in your project
- Sort file by TYPE (js, ruby, md...)
- Calcuate count of line by TYPE, the median, moyenne, min and max.
- NEXT LEVEL: create a chart in bash

## API

Simple usage:

```
sh kevox.sh -p ./
```

`-p` is for the `path`. The script will check all your path and log the statistiques.

To get the stats into a file you can simply :

```bash
sh kevox.sh -p ./ > output.txt
```

Here is params:

`-d`: to enable the debug. The debug show all log like the tree check.
`-p`: path to check
`-e "js"`: add a custom extensions to the tree checking (by default is `"js" "md" "jsx" "ts" "tsx" "rb" "sh" "txt" "html" "css" "svg" "cs" "ru" "json" "sql" "pdf" "yml" "etl" "rake" "erb" "scss"`)
`-x "node_modules`: add a excludes folder that will ne be check (by default is )

      d) debug=1;;
      p) directories+=${OPTARG};;
      e) extensionsString+=(${OPTARG});;
      x) exclucedDirectories+=(${OPTARG});;
      k) deleteLog=0
