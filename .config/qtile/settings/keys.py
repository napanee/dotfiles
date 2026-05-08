import os

from libqtile.config import Key
from libqtile.lazy import lazy


mod = os.getenv('QTILE_MOD', 'mod4')

def move_window_up():
    @lazy.function
    def __inner(qtile):
        layout_name = qtile.current_layout.name
        if layout_name == 'treeTab':
            qtile.current_layout.move_up()
        else:
            qtile.current_layout.shuffle_up()
    return __inner

def move_window_down():
    @lazy.function
    def __inner(qtile):
        layout_name = qtile.current_layout.name
        if layout_name == 'treeTab':
            qtile.current_layout.move_down()
        else:
            qtile.current_layout.shuffle_down()
    return __inner

keys = [
    # switch layout
    Key([mod], 'comma', lazy.group.setlayout('monad'), desc='go to monad-layout'),
    Key([mod], 'period', lazy.group.setlayout('monadWide'), desc='go to monadWide-layout'),
    Key([mod], 'slash', lazy.group.setlayout('max'), desc='go to max-layout'),
    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),

    # switch screen
    Key([mod], 'q', lazy.to_screen(2), desc='go to screen 1'),
    Key([mod], 'w', lazy.to_screen(0), desc='go to screen 2'),
    Key([mod], 'e', lazy.to_screen(1), desc='go to screen 3'),

    # Switch between windows in current stack pane
    Key([mod], 'down', lazy.layout.down()),
    Key([mod], 'up', lazy.layout.up()),
    Key([mod], 'Page_Down', lazy.layout.next_section(), desc='Fokus zur nächsten Sektion'),
    Key([mod], 'Page_Up', lazy.layout.prev_section(), desc='Fokus zur vorherigen Sektion'),

    # Move windows up or down in current stack
    Key([mod, 'shift'], 'down', move_window_down()),
    Key([mod, 'shift'], 'up', move_window_up()),
    Key([mod, 'shift'], 'Page_Down', lazy.layout.section_down(), desc='Verschiebe Fenster in Sektion darunter'),
    Key([mod, 'shift'], 'Page_Up', lazy.layout.section_up(), desc='Verschiebe Fenster in Sektion darunter'),
    Key([mod, 'shift'], 'equal', lazy.layout.grow()),
    Key([mod, 'shift'], 'minus', lazy.layout.shrink()),
    Key([mod, 'shift'], '0', lazy.layout.normalize()),

    Key([mod], 'f', lazy.window.toggle_fullscreen()),
    Key([mod, 'shift'], 'f', lazy.window.toggle_floating()),
    Key([mod], 'r', lazy.layout.reset()),
    Key([mod, 'shift'], 'r', lazy.reload_config()),

    # Apps runner
    Key([mod, 'shift'], 'Return', lazy.spawn('wezterm')),
    Key([mod], 'space', lazy.spawn('rofi -show drun')),
    Key([mod, 'shift'], 'q', lazy.spawn('powermenu')),
    Key([mod, 'shift'], 'w', lazy.spawn('rofi -show window')),
    Key([mod, 'shift'], 'e', lazy.spawn('rofi -show emoji')),
    # Key([mod, 'shift'], 'w', lazy.spawn('wifimenu')),
    Key([mod, 'shift'], 'b', lazy.spawn('google-chrome-stable')),
    Key([mod, 'shift'], 'l', lazy.spawn('betterlockscreen -l')),

    # Change display setup
    Key([mod, 'shift'], 'd', lazy.spawn('display_desktop')),
    Key([mod, 'shift'], 's', lazy.spawn('display_single')),

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
