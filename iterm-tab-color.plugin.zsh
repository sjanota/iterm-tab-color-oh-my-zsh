tcConfigFilePath="$(dirname "$0")/.tc-config"
$(dirname "$0")/get_current_bg_color.sh
defaultBg=$(cat /tmp/color)
rm /tmp/color

function directory_tab_color() {
  try_set_tab_color "kubecontext:$(kubectl config current-context)"
}

function try_set_tab_color() {
  if [[ -n $(grep ${1}= $tcConfigFilePath) ]]; then
    color=$(grep ${1}= $tcConfigFilePath | awk -F= '{print $2}')
    iterm_tab_color "$color"
    return 0
  else
    iterm_tab_color
  fi
}

function iterm_tab_color() {
  if [ $# -eq 0 ]; then
    echo -ne "\033]4;-2;${defaultBg}\a"
    return 0
  elif [ $# -eq 1 ]; then
    if ( [[ $1 == \#* ]] ); then
      # If single argument starts with '#', skip first character to find hex value
      RED_HEX=${1:1:2}
      GREEN_HEX=${1:3:2}
      BLUE_HEX=${1:5:2}
    else
      # If single argument doesn't start with '#', assume it's hex value
      RED_HEX=${1:0:2}
      GREEN_HEX=${1:2:2}
      BLUE_HEX=${1:4:2}
    fi
    echo -ne "\033]4;-2;rgb:$RED_HEX/$GREEN_HEX/$BLUE_HEX\a"
    return 0
  fi
}

alias tc='iterm_tab_color'
precmd_functions=(${precmd_functions[@]} "directory_tab_color")