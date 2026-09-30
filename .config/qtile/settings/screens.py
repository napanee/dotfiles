from libqtile.config import Screen
from libqtile import bar
from .widgets import primary_widgets, secondary_widgets, tertiary_widgets

def status_bar(widgets):
    return bar.Bar(widgets, 22, margin=[0, 0, 0, 0])


def make_screen(widgets):
    return Screen(
        top=status_bar(widgets),
    )


# Always define a Screen for every monitor we could possibly have.
#
# Do NOT slice this list by the number of currently-connected monitors:
# with reconfigure_screens = True, qtile reconfigures screens on every
# screen_change event (DPMS wake, unlock, xrandr, and notably daisy-chained
# MST monitors that come up one after another with a delay). If a physical
# output appears that has no configured Screen, qtile ends up with a Screen
# that never got a group assigned, which crashes _process_screens with
# "AttributeError: 'Screen' object has no attribute 'group'" and forces a
# manual `qtile restart`.
#
# By defining all screens up front, qtile assigns groups to the connected
# outputs and simply leaves the extra screen(s) inactive.
_screen_widgets = [primary_widgets, secondary_widgets, tertiary_widgets]
screens = [make_screen(widgets) for widgets in _screen_widgets]
