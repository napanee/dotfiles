#!/bin/bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode

SPACE=(
  background.color=$COLOR_BRAND
  background.height=18
  background.padding_right=0
  background.padding_left=0
  icon.padding_right=5
  icon.padding_left=5
  label.drawing=off
)

setup_screen() {
  local screen=$1
  local start_space=$2
  local end_space=$3

  for i in $(seq $start_space $end_space); do
    create_space_item $screen $i
  done
}

create_space_item() {
  local screen=$1
  local index=$2
  local item_name="m${screen}_space_${index}"

  local item=(
    "${SPACE[@]}"
    icon="${SPACE_ICONS_DEFAULT[$((index-1))]}"
    display=$screen
    click_script="aerospace workspace $index"
    script="$PLUGIN_DIR/aerospace_spaces.sh $screen $index"
  )

  sketchybar --add item "$item_name" left \
             --set "$item_name" "${item[@]}" \
             --subscribe "$item_name" aerospace_workspace_change
}

create_bracket() {
  local screen=$1
  local start_space=$2
  local end_space=$3
  local bracket_spaces=()

  for i in $(seq $start_space $end_space); do
    bracket_spaces+=("m${screen}_space_${i}")
  done

  sketchybar --add item "m${screen}_${start_space}_bracket_separator_left" left \
             --set "m${screen}_${start_space}_bracket_separator_left" "${SEPARATOR[@]}" display=$screen \
             --move "m${screen}_${start_space}_bracket_separator_left" before "m${screen}_space_${start_space}"
  bracket_spaces+=("m${screen}_${start_space}_bracket_separator_left")

  sketchybar --add item "m${screen}_${start_space}_bracket_separator_right" left \
             --set "m${screen}_${start_space}_bracket_separator_right" "${SEPARATOR[@]}" display=$screen \
             --move "m${screen}_${start_space}_bracket_separator_right" after "m${screen}_space_${end_space}"
  bracket_spaces+=("m${screen}_${start_space}_bracket_separator_right")

  bracket_name="bracket_spaces_${screen}_${start_space}"
  sketchybar --add bracket "$bracket_name" "${bracket_spaces[@]}"
}

##############################################
# Screen 1, Spaces 1 - 9
##############################################
setup_screen 1 1 9
screen=1
list=("1 2" "3 4" "5 9") # "start_space end_space"
for item in "${list[@]}"; do
  start_space=$(echo "$item" | awk '{print $1}')
  end_space=$(echo "$item" | awk '{print $2}')

  create_bracket $screen $start_space $end_space

  sketchybar --add item "m${screen}_bracket_separator_${end_space}" left \
             --set "m${screen}_bracket_separator_${end_space}" "${SEPARATOR[@]}" display=$screen \
             --move "m${screen}_bracket_separator_${end_space}" after "m${screen}_${start_space}_bracket_separator_right"
done

##############################################
# Screen 2, Spaces 3 - 4
##############################################
setup_screen 2 3 4
create_bracket 2 3 4

# ##############################################
# Screen 2, Spaces 5 - 9
# ##############################################
setup_screen 3 5 9
create_bracket 3 5 9
