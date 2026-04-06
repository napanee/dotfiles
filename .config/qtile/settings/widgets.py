import os

from libqtile import widget
from libqtile.widget.base import BackgroundPoll, ORIENTATION_HORIZONTAL
from libqtile.widget.net import Net as QtileNet
from libqtile.widget.battery import Battery as QtileBattery, BatteryStatus, BatteryState
from libqtile.widget.sensors import ThermalSensor as QtileThermalSensor

from .theme import colors


class CPU(BackgroundPoll):
    orientations = ORIENTATION_HORIZONTAL
    defaults = [
        ('update_interval', 1, 'The update interval.'),
        ('format', '{percent:2.0%}', ''),
        ('warn_threshold', 0.5, ''),
        ('warn_foreground', colors['warning'], ''),
        ('alert_threshold', 0.9, ''),
        ('alert_foreground', colors['urgent'], ''),
    ]

    def __init__(self, **config):
        BackgroundPoll.__init__(self, 'CPU', **config)
        self.add_defaults(CPU.defaults)
        self.seconds = self.get_stats()

    def get_stats(self):
        line = open('/proc/stat').readlines()[0].strip()
        metrics = [
            'user', 'nice', 'system', 'idle', 'iowait', 'irq', 'softirq',
            'steal', 'guest', 'guest_nice'
        ]
        return dict(zip(metrics, [int(m) for m in line[5:].split(' ')]))

    def poll(self):
        try:
            new_seconds = self.get_stats()
            delta_seconds = {}
            for metric in new_seconds:
                delta_seconds[metric] = new_seconds[metric] - self.seconds[metric]

            self.seconds = new_seconds

            delta_seconds['percent'] = 1 - (
                delta_seconds['idle'] / sum(delta_seconds.values()))

            if delta_seconds['percent'] > self.alert_threshold:
                self.layout.colour = self.alert_foreground
            elif delta_seconds['percent'] > self.warn_threshold:
                self.layout.colour = self.warn_foreground
            else:
                self.layout.colour = self.foreground

            return self.format.format(**delta_seconds)
        except Exception:
            return 'N/A'


class ThermalSensor(QtileThermalSensor):

    def poll(self):
        val = super().poll()
        if not val:
            return '(-)'

        return '({})'.format(val.replace('.0', ''))


class Battery(QtileBattery):

    def build_string(self, status: BatteryStatus) -> str:
        akku_str = super().build_string(status)
        key = ""
        percent = status.percent
        state = status.state

        if state == BatteryState.CHARGING:
            key += "󰂄"
        elif percent < 0.1:
            key += "󰂎"
        elif percent < 0.2:
            key += "󰁺"
        elif percent < 0.3:
            key += "󰁻"
        elif percent < 0.4:
            key += "󰁼"
        elif percent < 0.5:
            key += "󰁽"
        elif percent < 0.6:
            key += "󰁾"
        elif percent < 0.7:
            key += "󰁿"
        elif percent < 0.8:
            key += "󰂀"
        elif percent < 0.9:
            key += "󰂁"
        elif percent < 1.0:
            key += "󰂂"
        else:
            key += "󰁹"

        return key + ' ' + akku_str


def base(fg='text', bg='primary'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg],
    }


def separator(length=5):
    return widget.Spacer(**base(bg='dark'), length=length)


def icon(fg='text', bg='primary', fontsize=20, text="?", padding=5):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=padding
    )

def datetime():
    return [
        icon(bg='dark', text=''),
        widget.Clock(**base(bg='dark'), format='%a, %d. %b'),
        icon(bg='dark', text=''),
        widget.Clock(**base(bg='dark'), format='%H:%M:%S'),
    ]

def workspaces():
    return [
        widget.CurrentScreen(**base(bg='dark'), active_text='', inactive_text='', fontsize=26),
        widget.GroupBox(
            **base(),
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            fontsize=20,
            margin_x=0,
            padding_x=5,
            block_highlight_text_color=colors['active'],
            highlight_method='block',
            highlight_color=colors['primary'],
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['primary'],
            other_current_screen_border=colors['primary'],
            other_screen_border=colors['primary'],
            disable_drag=True
        ),
        separator(),
        widget.CurrentLayout(
            **base(bg='dark'),
            custom_icon_paths=['~/.config/qtile/layout-icons/gruvbox-neutral_orange'],
            padding = 0,
            scale = 0.8,
            mode='icon',
        ),
        separator(),
        widget.WindowName(**base(), empty_group_string = 'Desktop'),
    ]

primary_widgets = [
    *workspaces(),
    widget.Systray(**base(bg='dark'), icon_size=16, padding=5),
    separator(5),
    icon(text='󰍛'),
    CPU(**base(), update_interval=2),
    ThermalSensor(
        **base(),
        tag_name='CPU',
        threshold=70,
        update_interval=2,
        foreground_alert=colors['urgent'],
    ),
    separator(1),
    icon(text=''),
    widget.Wlan(
        **base(),
        interface='wlp164s0',
        disconnected_message='(-)',
        update_interval=2,
        format='{essid}, {percent:1.0%}'
    ),
    separator(1),
    icon(text=''),
    widget.Memory(
        **base(),
        format='{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm} {SwapPercent: .0f}%',
        update_interval=5,
        measure_mem='G',
        measure_swap='G',
    ),
    separator(1),
    Battery(**base(), format='{percent:2.0%} | {hour:d}:{min:02d}', low_percentage=0.2),
    separator(1),
    icon(text=''),
    separator(1),
    icon(text=''),
    widget.Backlight(**base(), backlight_name='intel_backlight'),
    separator(1),
    widget.KeyboardLayout(**base(), configured_keyboards=['us', 'de deadacute']),
    *datetime(),
]

secondary_widgets = [
    *workspaces(),
    *datetime(),
]

tertiary_widgets = [
    *workspaces(),
    *datetime(),
]

widget_defaults = {
    'font': 'SauceCodePro Nerd Font Mono SemiBold',
    'fontsize': 13,
}

extension_defaults = widget_defaults.copy()
