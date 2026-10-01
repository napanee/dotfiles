import os
import subprocess

from libqtile import widget
from libqtile.widget.base import BackgroundPoll, ORIENTATION_HORIZONTAL
from libqtile.widget.net import Net as QtileNet
from libqtile.widget.battery import Battery as QtileBattery, BatteryStatus, BatteryState
from libqtile.widget.sensors import ThermalSensor as QtileThermalSensor

from .theme import colors


def find_battery():
    """Return the name of the first battery (e.g. 'BAT0', 'BAT1'), or None.

    Scans /sys/class/power_supply and returns the first entry whose `type`
    is 'Battery', so it works regardless of the battery's index.
    """
    base_dir = '/sys/class/power_supply'
    try:
        names = sorted(os.listdir(base_dir))
    except OSError:
        return None
    for name in names:
        type_path = os.path.join(base_dir, name, 'type')
        try:
            with open(type_path) as f:
                if f.read().strip() == 'Battery':
                    return name
        except OSError:
            continue
    return None


def has_battery():
    """Check if a battery is present (laptop)."""
    return find_battery() is not None


def has_backlight():
    """Check if backlight control is available (laptop)."""
    return os.path.isdir('/sys/class/backlight/intel_backlight')


def _is_wireless(iface):
    """Return True if the given network interface is a WiFi device.

    The kernel exposes a 'wireless' subdirectory (and a 'phy80211' symlink)
    under /sys/class/net/<iface> only for wireless interfaces.
    """
    base = os.path.join('/sys/class/net', iface)
    return (os.path.isdir(os.path.join(base, 'wireless'))
            or os.path.exists(os.path.join(base, 'phy80211')))


def find_interfaces():
    """Return network interfaces in priority order (ethernet first, then WiFi).

    Scans /sys/class/net, skips the loopback and virtual interfaces, and
    orders real ethernet interfaces before wireless ones so a wired
    connection is preferred. Falls back to an empty list on error.
    """
    base_dir = '/sys/class/net'
    try:
        names = sorted(os.listdir(base_dir))
    except OSError:
        return []

    ethernet, wireless = [], []
    for name in names:
        if name == 'lo':
            continue
        # Skip virtual interfaces (no device symlink), e.g. docker0, veth, br-*
        if not os.path.exists(os.path.join(base_dir, name, 'device')):
            continue
        if _is_wireless(name):
            wireless.append(name)
        else:
            ethernet.append(name)

    return ethernet + wireless


class NetworkStatus(BackgroundPoll):
    """Shows IP address of the primary network interface.
    If a WiFi connection is active, also shows the SSID."""

    orientations = ORIENTATION_HORIZONTAL
    defaults = [
        ('update_interval', 5, 'The update interval.'),
        ('interfaces', None, 'Interfaces to check (in priority order). '
         'If None, they are auto-detected from /sys/class/net.'),
        ('disconnected_message', '(-)', 'Text when no connection is found.'),
    ]

    def __init__(self, **config):
        BackgroundPoll.__init__(self, 'NetworkStatus', **config)
        self.add_defaults(NetworkStatus.defaults)

    def _get_ip(self, iface):
        """Get IP address for an interface, or None."""
        try:
            out = subprocess.check_output(
                ['ip', '-4', '-o', 'addr', 'show', iface],
                stderr=subprocess.DEVNULL
            ).decode().strip()
            if out:
                # format: "2: enp6s0    inet 192.168.1.10/24 ..."
                return out.split()[3].split('/')[0]
        except (subprocess.CalledProcessError, IndexError):
            pass
        return None

    def _get_ssid(self):
        """Get current WiFi SSID, or None.

        Prefers nmcli (works reliably when NetworkManager owns the
        connection) and falls back to iwgetid on systems without it.
        """
        # nmcli: list active connections, pick the active wifi one
        try:
            out = subprocess.check_output(
                ['nmcli', '-t', '-f', 'ACTIVE,SSID', 'dev', 'wifi'],
                stderr=subprocess.DEVNULL
            ).decode()
            for line in out.splitlines():
                # format: "yes:MySSID" / "no:OtherSSID"
                active, _, ssid = line.partition(':')
                if active == 'yes' and ssid:
                    return ssid
        except (subprocess.CalledProcessError, FileNotFoundError):
            pass

        # Fallback: iwgetid (wireless-extensions based)
        try:
            out = subprocess.check_output(
                ['iwgetid', '-r'],
                stderr=subprocess.DEVNULL
            ).decode().strip()
            return out if out else None
        except (subprocess.CalledProcessError, FileNotFoundError):
            return None

    def poll(self):
        # Auto-detect interfaces each poll so hotplugged devices are picked up.
        interfaces = self.interfaces if self.interfaces else find_interfaces()

        # Try each interface in order, return the first one with an IP
        for iface in interfaces:
            ip = self._get_ip(iface)
            if ip:
                # If this is a wireless interface, try to get SSID
                ssid = None
                if _is_wireless(iface):
                    ssid = self._get_ssid()

                if ssid:
                    return f'{ssid} ({ip})'
                else:
                    return ip

        return self.disconnected_message


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
            fontsize=28,
            margin_x=0,
            padding_x=5,
            block_highlight_text_color=colors['active'],
            highlight_method='block',
            highlight_color=colors['primary'],
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['focus'],
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

def battery_widgets():
    """Return battery widgets only if battery hardware is present."""
    name = find_battery()
    if name:
        return [
            separator(1),
            Battery(**base(), battery=name, format='{percent:2.0%} | {hour:d}:{min:02d}', low_percentage=0.2),
        ]
    return []

def backlight_widgets():
    """Return backlight widgets only if backlight hardware is present."""
    if has_backlight():
        return [
            separator(1),
            icon(text=''),
            widget.Backlight(**base(), backlight_name='intel_backlight'),
        ]
    return []

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
    NetworkStatus(
        **base(),
        disconnected_message='(-)',
        update_interval=5,
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
    widget.TextBox(
        **base(),
        text='',
        fontsize=20,
        padding=5,
        mouse_callbacks={'Button1': lambda: subprocess.Popen(['rofi-audio-sink'])},
    ),
    *battery_widgets(),
    *backlight_widgets(),
    separator(1),
    widget.TextBox(
        **base(),
        text='󰂯',
        fontsize=16,
        padding=3,
        mouse_callbacks={'Button1': lambda: subprocess.Popen(['rofi-bluetooth'])},
    ),
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
