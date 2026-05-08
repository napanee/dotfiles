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
    layout.Max(name='max', margin=0),
    layout.TreeTab(
        name='treeTab',
        fontsize=13,
        panel_width=200,                                # Etwas breiter für bessere Lesbarkeit
        bg_color="2e3440",                              # Dunkles Nord-Blau/Grau
        active_bg="81a1c1",                             # Helles Blau für den aktiven Tab
        active_fg="2e3440",                             # Dunkler Text auf hellem Grund (besserer Kontrast)
        inactive_bg="3b4252",                           # Subtiles Grau für inaktive Tabs
        inactive_fg="d8dee9",                           # Hellgrauer Text
        urgent_bg="bf616a",                             # Nord-Rot für Alarme
        urgent_fg="ffffff",
        section_fg="eceff4",                            # Farbe der Sektions-Überschriften
        section_fontsize=10,
        section_top=15,                                 # Mehr Abstand nach oben für Sektionen
        section_bottom=10,
        border_width=0,                                 # Flat Design ohne Rahmen
        vspace=4,                                       # Mehr Platz zwischen den Tabs
        padding_x=-10,                                  # Text rückt etwas vom Rand ein
        padding_y=8,                                    # Tab-Höhe wird angenehmer
        level_shift=12,                                 # Deutlichere Einrückung für Baumstrukturen
        sections=["Browser", "Terminal", "Work"]        # Deine Sektionsnamen
    ),
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
        Match(wm_class='com.cisco.secureclient.gui'),
        Match(title='branchdialog'),
        Match(title='pinentry'),
        Match(title='Terminator Preferences'),
    ],
    **layout_defaults
)
