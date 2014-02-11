# Function for opening Marked.app to preview markdown files.
function marked() {
  if [ -z "$1" ]
  then
    open -a marked.app $1
  else
    open -a marked.app
  fi
}
