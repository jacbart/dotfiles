eval "$(bw completion --shell zsh); compdef _bw bw;"

function bp() {
  if [[ $[#] == 0 ]]; then
    bw list items | jq -r '.[].name' | fzf | xargs bw get password
  elif [[ $[#] == 1 ]]; then
    bw get password $1
  else
    echo "only one and less args allowed"
  fi
}

function bn() {
  if [[ $[#] == 0 ]]; then
    bw list items | jq -r '.[].name' | fzf | xargs bw get notes
  elif [[ $[#] == 1 ]]; then
    bw get notes $1
  else
    echo "only one and less args allowed"
  fi
}

function send() {
  if [[ $1 == "clean" ]]; then
    IFS=$'\n' ID_LIST=($(bw send list | jq -r '.[].id'))

    for i in $ID_LIST; do
      bw send delete $i
    done
  else
    bw send --deleteInDays 1 --maxAccessCount 1 --file "$1" | jq -r '.accessUrl'
  fi
}
