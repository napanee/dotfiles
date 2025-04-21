#!/bin/bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode

SPACE=(
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
              --set "$bracket_name" background.color=$COLOR_BRAND

  bracket_spaces=()
  bracket_index=$((bracket_index + 1))
}
bracket_spaces=()
bracket_index=1

##############################################
# Display 1 - All 9 Spaces
##############################################

for i in {1..9}; do
  screen=1
  create_space_item $screen $i

  if [[ $i == 2 || $i == 4 || $i == 9 ]]; then
    # Add spacer
    sketchybar --add item "m1_bracket_spacer_${i}" left \
               --set "m${screen}_bracket_spacer_${i}" "${SPACER[@]}" width=10 display=$screen
    
    create_bracket
  fi
done

##############################################
# Display 2 - Only Spaces 3 and 4
##############################################

for i in {3..4}; do
  screen=2
  create_space_item $screen $i
done

create_bracket

##############################################
# Display 3 - Only Spaces 5 till 9
##############################################

for i in {5..9}; do
  screen=3
  create_space_item $screen $i
done

create_bracket
