from libqtile.config import Drag, Click
from libqtile.lazy import lazy
from .keys import mod


mouse = [
    Drag(
        [mod], 'Button1', lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Click([mod], 'Button2', lazy.window.toggle_fullscreen()),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size())
]
