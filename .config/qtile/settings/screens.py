from libqtile.config import Screen
from libqtile import bar
from libqtile.log_utils import logger
from .widgets import primary_widgets, secondary_widgets, tertiary_widgets
import subprocess

WALLPAPER = '~/.dotfiles/wallpaper.jpg'


def status_bar(widgets):
    return bar.Bar(widgets, 22, margin=[0, 0, 0, 0])


def make_screen(widgets):
    return Screen(
        top=status_bar(widgets),
        wallpaper=WALLPAPER,
        wallpaper_mode='fill',
    )


def count_monitors():
    result = subprocess.run(
        "xrandr | grep -w 'connected' | cut -d ' ' -f 2 | wc -l",
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if result.returncode != 0:
        logger.error(f"Failed counting monitors:\n{result.stderr.decode()}")
        return 1
    return int(result.stdout.decode())


_screen_widgets = [primary_widgets, secondary_widgets, tertiary_widgets]
connected_monitors = count_monitors()
screens = [make_screen(widgets) for widgets in _screen_widgets[:connected_monitors]]
