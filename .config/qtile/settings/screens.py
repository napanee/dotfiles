from libqtile.config import Screen
from libqtile import bar
from libqtile.log_utils import logger
from .widgets import primary_widgets, secondary_widgets, tertiary_widgets
import subprocess


def status_bar(widgets):
    return bar.Bar(widgets, 22, margin=[0,0,0,0])


screens = [
    Screen(
        top=status_bar(primary_widgets),
        wallpaper='~/.dotfiles/wallpaper.jpg',
        wallpaper_mode='fill',
    )
]

xrandr = "xrandr | grep -w 'connected' | cut -d ' ' -f 2 | wc -l"

command = subprocess.run(
    xrandr,
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

if command.returncode != 0:
    error = command.stderr.decode("UTF-8")
    logger.error(f"Failed counting monitors using {xrandr}:\n{error}")
    connected_monitors = 1
else:
    connected_monitors = int(command.stdout.decode("UTF-8"))

if connected_monitors > 1:
    screens.append(
        Screen(
            top=status_bar(secondary_widgets),
            wallpaper='~/.dotfiles/wallpaper.jpg',
            wallpaper_mode='fill',
        )
    )
    screens.append(
        Screen(
            top=status_bar(tertiary_widgets),
            wallpaper='~/.dotfiles/wallpaper.jpg',
            wallpaper_mode='fill',
        )
    )
