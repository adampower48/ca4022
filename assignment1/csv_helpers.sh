join() {
  # Joins strings with a tab
  local headers=$1
  for ((i=2;i<=$#;i++))
    do
      printf -v headers '%s\t%s' "$headers" "${!i}"
    done
  echo -e "$headers"
}

create_tsv() {
  # Concat files in folder and add given headers
  local filename=$1
  echo -e "$(join ${@:2})" > $filename.csv
  for part in $(ls $filename)
  do
    cat $filename/$part >> $filename.csv
  done
}

# Example usage:
# create_tsv assignment1/output b c d e f