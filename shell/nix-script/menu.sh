#! /usr/bin/env nix-shell
#! nix-shell env.nix -i bash --pure

function choose_from_menu() {
  local prompt="$1" outvar="$2"
  shift
  shift
  local options=("$@") cur=0 count=${#options[@]} index=0
  local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
  printf "$prompt\n"
  while true
  do
    # list all options (option list is zero-based)
    index=0 
    for o in "${options[@]}"
    do
      if [ "$index" == "$cur" ]; then
        echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
      else
        echo "  $o"
      fi
      index=$(( $index + 1 ))
    done
    read -s -n3 key # wait for user to key in arrows or ENTER
    if [[ $key == $esc[A ]]; then # up arrow
      cur=$(( $cur - 1 ))
      [ "$cur" -lt 0 ] && cur=0
    elif [[ $key == $esc[B ]]; then # down arrow
      cur=$(( $cur + 1 ))
      [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
    elif [[ $key == "" ]]; then # nothing, i.e the read delimiter - ENTER
      break
    fi
    echo -en "\e[${count}A" # go up to the beginning to re-render
  done
  # export the selection to the requested output variable
  printf -v $outvar "${options[$cur]}"
}

if [ -f "env.pem" ]; then
  echo "Decrypt ENV file before continuing"
  export AGE="DECRYPT ENV"
elif [ -f "env" ]; then
  export AGE="encrypt env"
else
  echo "no env or env.pem detected in $(pwd)/"
  exit 0
fi

selections=(
  "$AGE"
  "init"
  "show terraform"
  "plan terraform"
  "apply terraform"
  "ansible setup server"
  "destroy terraform"
)

# Run choose from menu function
choose_from_menu "run command:" selected_choice "${selections[@]}"

# Switch case for menu selection
case ${selected_choice} in
  "DECRYPT ENV")
    age -d -i $HOME/.ssh/id_gitpersonal env.pem > env
    rm env.pem
  ;;
  "encrypt env")
    age -a -R $HOME/.ssh/id_gitpersonal.pub env > env.pem
    rm env
  ;;
  "init")
    terraform init -var="do_token=${DO_TOKEN}" -backend-config="access_key=${SPACE_ACCESS_KEY}" -backend-config="secret_key=${SPACE_SECRET_KEY}"
    ansible-galaxy install nvjacobo.caddy
  ;;
  "show terraform")
    terraform show -json | jless
  ;;
  "plan terraform")
    terraform plan -var="do_token=${DO_TOKEN}"
  ;;
  "apply terraform")
    terraform apply -var="do_token=${DO_TOKEN}"
  ;;
  "ansible setup server")
    ansible-playbook setup-server.yml
  ;;
  "destroy terraform")
    terraform destroy -var="do_token=${DO_TOKEN}"
  ;;
esac
