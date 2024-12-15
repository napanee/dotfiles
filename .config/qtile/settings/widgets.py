import os

from libqtile import widget
from libqtile.widget.base import ThreadPoolText, ORIENTATION_HORIZONTAL
from libqtile.widget.net import Net as QtileNet
from libqtile.widget.battery import Battery as QtileBattery, BatteryStatus, BatteryState
from libqtile.widget.sensors import ThermalSensor as QtileThermalSensor

from .theme import colors


class CPU(ThreadPoolText):
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
        ThreadPoolText.__init__(self, 'CPU', **config)
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


class Net(QtileNet):

    def poll(self):
        path = '/sys/class/net/{}/carrier'.format(self.interface[0])
        if not os.path.exists(path):
            return '-'
        if open(path).read().strip() != '1':
            return '-'
        return super().poll()


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


def separator():
    return widget.Spacer(**base(bg='dark'), length=5)


def icon(fg='dark', bg='primary', fontsize=22, text="?", padding=0):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=padding
    )


def workspaces(): 
    return [
        widget.CurrentScreen(**base(bg='dark'), active_text='', inactive_tRext='  ', fontsize=26),
        icon(text=''),
        widget.GroupBox(
            **base(),
            borderwidth=2,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            block_highlight_text_color=colors['active'],
            highlight_method='line',
            highlight_color=colors['primary'],
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['primary'],
            other_current_screen_border=colors['primary'],
            other_screen_border=colors['primary'],
            disable_drag=True
        ),
        icon(text=''),
        separator(),
        widget.CurrentLayoutIcon(
            **base(bg='dark'),
            custom_icon_paths=['~/.config/qtile/layout-icons/gruvbox-dark0'],
            padding = 0,
            scale = 0.5,
        ),
        widget.CurrentLayout(**base(bg='dark'), width=100),
        icon(text='', fg='dark'),
        widget.WindowName(**base(), empty_group_string = 'Desktop'),
    ]

primary_widgets = [
    *workspaces(),
    icon(text=''),
    widget.Systray(**base(bg='dark'), icon_size=16, padding=10),
    separator(),
    icon(text=''),
    CPU(**base(), update_interval=2),
    ThermalSensor(
        **base(),
        tag_name='CPU',
        threshold=70,
        update_interval=2,
        foreground_alert=colors['urgent'],
    ),
    icon(text=''),
    widget.Net(**base(), format=' {up:6.2f}  {down:6.2f} ', prefix='k'),
    widget.Wlan(
        **base(),
        interface='wlp164s0',
        disconnected_message='(-)',
        update_interval=2,
        format='({essid}, {percent:1.0%})'
    ),
    icon(text=''),
    widget.Memory(
        **base(),
        format='󰍛 {MemUsed: .0f} {mm}/{MemTotal: .0f} {mm}  {SwapPercent: .0f}%',
        update_interval=5,
        measure_mem='G',
        measure_swap='G',
    ),
    icon(text=''),
    Battery(**base(), format='{percent:2.0%} | {hour:d}:{min:02d}', low_percentage=0.2),
    icon(text=''),
    icon(fg='text', text='', padding=5, fontsize=26),
    # widget.PulseVolume(
    #     **base(),
    #     limit_max_volume=True,
    #     step=5,
    # ),
    icon(text=''),
    icon(fg='text', text='', padding=5, fontsize=26),
    widget.Backlight(**base(), backlight_name='intel_backlight'),
    icon(text=''),
    widget.KeyboardLayout(**base(), configured_keyboards=['us', 'de']),
    icon(text=''),
    widget.Clock(**base(bg='dark'), format='  %a, %d. %b   %H:%M:%S'),
]

secondary_widgets = [
    *workspaces(),
    icon(text=''),
    widget.Clock(**base(bg='dark'), format='  %a, %d. %b   %H:%M:%S'),
]

tertiary_widgets = [
    *workspaces(),
    icon(text=''),
    widget.Clock(**base(bg='dark'), format='  %a, %d. %b   %H:%M:%S'),
]

widget_defaults = {
    'font': 'SauceCodePro Nerd Font Mono SemiBold',
    'fontsize': 13,
}

extension_defaults = widget_defaults.copy()
