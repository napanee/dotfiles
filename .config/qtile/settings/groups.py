from libqtile.config import Key, Group
from libqtile.lazy import lazy
from .keys import mod, keys

groups = [
    Group('1', label='', layout='monad'),
    Group('2', label='󰊻', layout='monadWide'),
    Group('3', label='', layout='max'),
    Group('4', label='󰎮', layout='monad'),
    Group('5', label='󰎰', layout='monad'),
    Group('6', label='󰎵', layout='monad'),
    Group('7', label='󰎸', layout='monad'),
    Group('8', label='󰎻', layout='monad'),
    Group('9', label='󰎾', layout='monad'),
]

# Screen assignments per number of connected screens
screen_mappings = {
    1: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0, '6': 0, '7': 0, '8': 0, '9': 0},
    2: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 1, '6': 1, '7': 1, '8': 1, '9': 1},
    3: {'1': 0, '2': 0, '3': 2, '4': 2, '5': 1, '6': 1, '7': 1, '8': 1, '9': 1},
}

def go_to_group(group_name):
    def _inner(qtile):
        num_screens = len(qtile.screens)
        mapping = screen_mappings.get(num_screens, screen_mappings[1])
        target = min(mapping.get(group_name, 0), num_screens - 1)
        qtile.to_screen(target)
        qtile.groups_map[group_name].toscreen()
    return _inner

def move_to_group(group_name):
    def _inner(qtile):
        num_screens = len(qtile.screens)
        mapping = screen_mappings.get(num_screens, screen_mappings[1])
        target = min(mapping.get(group_name, 0), num_screens - 1)
        qtile.current_window.togroup(group_name)
        qtile.to_screen(target)
        qtile.groups_map[group_name].toscreen()
    return _inner

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.function(go_to_group(i.name))),
        Key([mod, "shift"], i.name, lazy.function(move_to_group(i.name))),
    ])
