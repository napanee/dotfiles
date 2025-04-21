#!/bin/bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode

SPACE=(
  background.color=$COLOR_BRAND
  background.height=18
  background.padding_right=2
  background.padding_left=2
  icon.padding_right=5
  icon.padding_left=5
  label.drawing=off
)
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

  bracket_spaces+=("$item_name")
}
create_bracket() {
  bracket_name="bracket_spaces_${bracket_index}"
  sketchybar --add bracket "$bracket_name" "${bracket_spaces[@]}" \
             --set "$bracket_name"

  bracket_spaces=()
  bracket_index=$((bracket_index + 1))
}
bracket_spaces=()
bracket_index=1

##############################################
# Display 1 - All 9 Spaces
##############################################

screen=1
for i in {1..9}; do
  create_space_item $screen $i

  if [[ $i == 2 || $i == 4 || $i == 9 ]]; then
    sketchybar --add item "m${screen}_bracket_separator_${i}" left \
               --set "m${screen}_bracket_separator_${i}" "${SEPARATOR[@]}" width=10 display=$screen

    create_bracket
  fi
done

##############################################
# Display 2 - Only Spaces 3 and 4
##############################################

screen=2
for i in {3..4}; do
  create_space_item $screen $i
done

create_bracket

##############################################
# Display 3 - Only Spaces 5 till 9
##############################################

screen=3
for i in {5..9}; do
  create_space_item $screen $i
done

create_bracket
