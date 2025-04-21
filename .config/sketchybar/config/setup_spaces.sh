#!/bin/sh

# SPACE_ICONS_GROUPS=(
#   " "
#   " "
#   "    "
# )

# space_id=0
# bracket_index=0

# for icons_string in "${SPACE_ICONS_GROUPS[@]}"; do
#   bracket_index=$((bracket_index+1))
#   IFS=' ' read -r -a icons <<< "$icons_string"
#   bracket_name="spaces$bracket_index"
#   displays=(1)

#   if [ "$bracket_index" -ne 1 ]; then
#     displays+=( "$bracket_index" )
#   fi

#   bracket_spaces=()

#   sketchybar --add item "spacer_inner_left$bracket_index" left --set "spacer_inner_left$bracket_index" "${SPACER[@]}"
#   sketchybar --set "spacer_inner_left$bracket_index" display=$bracket_index
#   bracket_spaces+=("spacer_inner_left$bracket_index")
  
#   for icon in "${icons[@]}"; do
#     space_id=$((space_id+1))
#     item_name="space.$space_id"

#     for d in "${displays[@]}"; do
#       item_name="space.${space_id}_display${d}"

#       space=(
#         space="$space_id"
#         background.height=18
#         icon="$icon"
#         icon.padding_left=8
#         icon.padding_right=8
#         label.drawing=off
#         display=$d
#         script="$PLUGIN_DIR/space.sh"
#       )

#       sketchybar --add space "$item_name" left --set "$item_name" "${space[@]}"
#       bracket_spaces+=("$item_name")
#     done
#   done

#   sketchybar --add item "spacer_inner_right$bracket_index" left --set "spacer_inner_right$bracket_index" "${SPACER[@]}"
#   sketchybar --set "spacer_inner_right$bracket_index" display=$bracket_index
#   bracket_spaces+=("spacer_inner_right$bracket_index")

#   sketchybar --add bracket "$bracket_name" "${bracket_spaces[@]}" \
#              --set "$bracket_name" background.color=0xAA007aff
# done


SPACE_ICONS=("" "" "" "" "" "" "" "" "")
SPACER=(
  label.drawing=off
  icon.drawing=off
  padding_left=2
  padding_right=2
  background.color=0x00000000
)

##############################################
# Display 1 - All 9 Spaces
##############################################

bracket_spaces=()
bracket_index=1

for i in {1..9}; do
  item_name="m1_space_$i"

  space=(
    space="$i"
    background.height=18
    icon="${SPACE_ICONS[$i-1]}"
    icon.padding_left=8
    icon.padding_right=8
    label.drawing=on
    display=1
    associated_space=$i
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space "$item_name" left --set "$item_name" "${space[@]}"
  bracket_spaces+=("$item_name")

  if [[ "$i" == 2 || "$i" == 4 || "$i" == 9 ]]; then
    # Add spacer
    sketchybar --add item "bracket_spacer_$i" left \
               --set "bracket_spacer_$i" "${SPACER[@]}" width=10 display=1
    
    # Bracket abschließen
    bracket_name="bracket_spaces_${bracket_index}"
    sketchybar --add bracket "$bracket_name" "${bracket_spaces[@]}" \
               --set "$bracket_name" background.color=0xAA007aff

    # Reset for next group
    bracket_spaces=()
    bracket_index=$((bracket_index + 1))
  fi
done

##############################################
# Display 2 - Only Spaces 3 and 4
##############################################

for i in {3..4}; do
  sketchybar --add item m2_space_$i left \
             --set m2_space_$i associated_space=$i associated_display=2 label=$i
done

##############################################
# Display 3 - Only Spaces 5 till 9
##############################################

for i in {5..9}; do
  sketchybar --add item m3_space_$i left \
             --set m3_space_$i associated_space=$i associated_display=3 label="$i"
done
