from libqtile.config import Key, Group
from libqtile.lazy import lazy
from .keys import mod, keys


groups = [
    Group('1', label='', layout='monad'),
    Group('2', label='󰨞', layout='monadWide'),
    Group('3', label='', layout='max'),
    Group('4', label='', layout='monad'),
    Group('5', label='', layout='monad'),
    Group('5', label='', layout='monad'),
    Group('6', label='', layout='monad'),
    Group('7', label='', layout='monad'),
    Group('8', label='', layout='monad'),
    Group('9', label='', layout='monad'),
]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=False)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, 'shift'], i.name, lazy.window.togroup(i.name, switch_group=False)),
    ])
