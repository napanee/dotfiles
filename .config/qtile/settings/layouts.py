from libqtile import layout
from libqtile.config import Match

from .theme import colors


layout_defaults = dict(
    border_normal=colors['dark'],
    border_focus=colors['focus'],
    border_width=2,
    fontsize=13,
)

layouts = [
    layout.MonadTall(name='monad', margin=5, **layout_defaults),
    layout.MonadWide(name='monadWide', margin=5, **layout_defaults),
    layout.Max(margin=0),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_progress'),
        Match(wm_class='notification'),
        Match(wm_class='Firefox'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='confirmreset'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='Xephyr'),
        Match(wm_class='ssh-askpass'),
        Match(wm_class='enpass'),
        Match(wm_class='nextcloud'),
        Match(wm_class='pinentry-gtk-2'),
        Match(wm_class='sun-awt-X11-XDialogPeer'),
        Match(wm_class='sun-awt-X11-XWindowPeer'),
        Match(wm_class='pavucontrol'),
        Match(title='branchdialog'),
        Match(title='pinentry'),
        Match(title='Terminator Preferences'),
    ],
    **layout_defaults
)
