import os

from libqtile.config import Key
from libqtile.lazy import lazy


mod = os.getenv('QTILE_MOD', 'mod4')

keys = [
    Key([mod, 'shift'], 'Return', lazy.spawn('terminator')),
    Key([mod], 'space', lazy.spawn('rofi -show drun')),
    Key([mod], 'w', lazy.spawn('rofi -show window')),
    Key([mod, 'shift'], 'l', lazy.spawn('betterlockscreen -l')),
    Key([mod, 'shift'], 'e', lazy.spawn('rofi -show emoji')),
    Key([mod, 'shift'], 'w', lazy.spawn('wifimenu')),
    Key([mod], 'k', lazy.spawn('/usr/bin/xmodmap ~/.Xmodmap')),
    Key([mod], 'b', lazy.spawn('google-chrome-stable')),

    Key([mod, 'shift'], 'q', lazy.spawn('powermenu')),

    Key([mod, 'shift'], 'd', lazy.spawn('display_desktop')),
    Key([mod, 'shift'], 's', lazy.spawn('display_single')),


    Key([mod], 'r', lazy.layout.reset()),

    # Switch between windows in current stack pane
    Key([mod], 'Tab', lazy.layout.down()),
    Key([mod, 'shift'], 'Tab', lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, 'shift'], 'down', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'up', lazy.layout.shuffle_up()),
    Key([mod, 'shift'], 'equal', lazy.layout.grow()),
    Key([mod, 'shift'], 'minus', lazy.layout.shrink()),

    Key([mod, 'shift'], 'f', lazy.window.toggle_floating()),

    Key([mod, 'shift'], 'left', lazy.prev_screen()),
    Key([mod, 'shift'], 'right', lazy.next_screen()),

    # Key([mod, 'shift'], 'left', lazy.prev_screen()),
    # Key([mod, 'shift'], 'right', lazy.next_screen()),

    # Swap panes of split stack
    # Key([mod, 'shift'], 'n', lazy.layout.client_to_next()),
    # Key([mod], 'space', lazy.layout.next()),
    # Key([mod, 'control'], 'space', lazy.layout.rotate()),
    # Key([mod, 'shift'], 'space',
    #     lazy.layout.toggle_split(),
    #     lazy.layout.swap_main()),
    # Key([mod], 'm',
    #     lazy.layout.toggle_switch(),
    #     lazy.layout.flip()),

    Key([mod, 'shift'], 'space', lazy.widget['keyboardlayout'].next_keyboard(), desc='Next keyboard layout.'),

    # Toggle between different layouts as defined below
    Key([mod], 'l', lazy.next_layout()),

    # Sound
    Key([], 'XF86AudioMute', lazy.spawn('changevolume mute')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('changevolume down')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('changevolume up')),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('changebacklight down')),
    Key([], 'XF86MonBrightnessUp', lazy.spawn('changebacklight up')),

    Key([mod, 'control'], 'r', lazy.restart()),
    Key([mod, 'control'], 'q', lazy.shutdown()),
    Key([mod, 'shift'], 'x', lazy.window.kill()),
]
