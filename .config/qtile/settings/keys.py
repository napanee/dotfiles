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
    Key([mod], 'b', lazy.spawn('firefox')),

    Key([mod, 'shift'], 'q', lazy.spawn('powermenu')),

    Key([mod, 'shift'], 'd', lazy.spawn('xrandr --output eDP-1 --mode 1920x1080 --pos 6000x1868 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate left --output HDMI-2 --off --output DP-3 --off --output HDMI-3 --off --output DP-1-8 --primary --mode 3840x2160 --pos 2160x958 --rotate normal --output DP-1-1 --off')),
    Key([mod, 'shift'], 's', lazy.spawn('xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-3 --off --output HDMI-3 --off --output DP-1-8 --off --output DP-1-1 --off')),


    Key([mod], 'r', lazy.layout.reset()),

    # Switch between windows in current stack pane
    Key([mod], 'Tab', lazy.layout.down()),
    Key([mod, 'shift'], 'Tab', lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, 'shift'], 'down', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'up', lazy.layout.shuffle_up()),
    Key([mod, 'shift'], 'plus', lazy.layout.grow()),
    Key([mod, 'shift'], 'minus', lazy.layout.shrink()),

    Key([mod, 'shift'], 'f', lazy.window.toggle_floating()),

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
