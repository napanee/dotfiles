from libqtile import hook

import os
import subprocess

from settings.keys import mod, keys
from settings.groups import groups
from settings.layouts import layouts, floating_layout
from settings.widgets import widget_defaults, extension_defaults
from settings.screens import screens
from settings.mouse import mouse
from settings.path import qtile_path


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = 'smart'

dgroups_key_binder = None
dgroups_app_rules = []

wmname = 'LG3D'

reconfigure_screens = True
theme = 'cozy'


@hook.subscribe.client_new
def new_window_hook(window):
    if window.name == 'Enpass' and not hasattr(window.qtile, '_initial_enpass'):
        window.qtile._initial_enpass = True
        window.qtile.call_soon(window.kill)
        return

    if window.floating:
        window.togroup()
        window.cmd_bring_to_front()
