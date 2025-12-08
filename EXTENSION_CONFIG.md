# GNOME Extension Configuration Guide

This guide will help you configure your GNOME extensions to match the exact look and feel of this dotfiles setup.

---

## Table of Contents
- [OpenBar Configuration](#openbar-configuration)
- [PaperWM Configuration](#paperwm-configuration)
- [Tiling Assistant Configuration](#tiling-assistant-configuration)
- [Tiling Shell Configuration](#tiling-shell-configuration)
- [Other Extensions](#other-extensions)

---

## OpenBar Configuration

OpenBar is the top bar that provides system information and customization. After installation, you need to manually configure the colors and widgets.

### Accessing OpenBar Settings
1. Open **Extensions** app (or press `Super` and search for "Extensions")
2. Find **OpenBar** in the list
3. Click the ⚙️ settings icon

### Color Configuration

#### Dark Theme Colors (Main Setup)
Configure these in OpenBar preferences under **Colors** → **Dark Theme**:

| Setting | RGB Values | Description |
|---------|------------|-------------|
| **Background Color** | `0, 0, 0` (Black) | Main bar background |
| **Foreground Color** | `255, 255, 255` (White) | Text color |
| **Hover Color** | `139, 140, 148` | Element hover effect |
| **Active Color** | `179, 180, 180` | Active/selected items |
| **Border Color** | `179, 180, 180` | Widget borders |
| **Menu Background** | `24, 24, 24` | Dropdown menu background |
| **Menu Hover** | `83, 92, 90` | Menu item hover |
| **Menu Selected** | `139, 140, 148` | Menu selected item |
| **Shadow Color** | `0, 0, 0` | Shadow effects |

#### Color Palette
These are the custom palette colors used throughout:

```
Palette 1:  RGB(22, 24, 24)     - Darkest shade
Palette 2:  RGB(179, 180, 180)  - Light gray
Palette 3:  RGB(67, 70, 69)     - Dark gray
Palette 4:  RGB(113, 114, 114)  - Medium gray
Palette 5:  RGB(50, 60, 58)     - Dark teal
Palette 6:  RGB(230, 230, 230)  - Very light gray
Palette 7:  RGB(83, 92, 90)     - Muted teal
Palette 8:  RGB(139, 148, 146)  - Light teal
Palette 9:  RGB(139, 140, 148)  - Light blue-gray
Palette 10: RGB(83, 84, 92)     - Medium blue-gray
Palette 11: RGB(148, 140, 124)  - Tan/beige
Palette 12: RGB(148, 132, 124)  - Warm tan
```

### Bar Settings

| Setting | Value | Description |
|---------|-------|-------------|
| **Position** | Top | Bar position on screen |
| **Height** | 35px | Bar height |
| **Transparency** | 100% opaque (alpha: 1.0) | No transparency |
| **Hover Effect** | Enabled (65% opacity) | Slight transparency on hover |
| **Neon Effect** | Enabled | Glowing effect on elements |
| **Gradient** | Disabled | No gradient background |
| **Shadow** | Disabled | No shadow under bar |

### Recommended Widgets to Add

After setting colors, add these widgets to match the setup:
1. **Workspace Indicator** - Shows current workspace
2. **Window Title** - Displays active window name
3. **System Resources** - CPU/RAM usage
4. **Network Indicator** - Connection status
5. **Volume Control** - Audio controls
6. **Clock/Date** - Time and date display
7. **Power Menu** - System controls

To add widgets:
1. In OpenBar settings, go to **Widgets** tab
2. Click **Add Widget** button
3. Select from available widgets
4. Drag to reorder

---

## PaperWM Configuration

PaperWM provides scrollable tiling window management. Most settings are already applied via dconf, but here are the key settings:

### Window Behavior
| Setting | Value |
|---------|-------|
| **Window Gap** | 15px |
| **Vertical Margin Bottom** | 20px |
| **Selection Border Size** | 0px (no border) |
| **Maximize Width** | 100% |

### Keybindings (Pre-configured)
| Action | Shortcut |
|--------|----------|
| Move Left | `Shift + Alt + Left` |
| Move Right | `Shift + Alt + Right` |
| Move Up | `Shift + Alt + Up` |
| Move Down | `Shift + Alt + Down` |
| Switch Left | `Alt + Left` |
| Switch Right | `Alt + Right` |
| Toggle Fullscreen | `Shift + Alt + F` |
| Maximize Width | `Alt + F` |
| Close Window | `Shift + Alt + Q` |
| Resize Width Increase | `Shift + Alt + P` |
| Resize Width Decrease | `Shift + Alt + U` |
| Resize Height Increase | `Shift + Alt + O` |
| Resize Height Decrease | `Shift + Alt + I` |

### Visual Settings
- **Show Focus Mode Icon**: Enabled
- **Show Window Position Bar**: Disabled
- **Show Workspace Indicator**: Disabled
- **Edge Preview**: Enabled (scale: 0.04)

---

## Tiling Assistant Configuration

Complements PaperWM with additional tiling features.

### Settings
| Setting | Value |
|---------|-------|
| **Active Window Hint Color** | RGB(211, 70, 21) - Orange |
| **Tiling Popup All Workspaces** | Enabled |

### Keybindings (Pre-configured)
| Action | Shortcut |
|--------|----------|
| Tile Maximize | `Super + Up` or `Super + KP_5` |
| Restore Window | `Super + Down` |

---

## Tiling Shell Configuration

Advanced tiling layouts for complex window arrangements.

### Layouts Included
1. **Layout 1** - 5-tile layout with side panels
2. **Layout 2** - 3-column layout
3. **Layout 3** - 33/67 split layout
4. **Layout 4** - 67/33 split layout

### Settings
- **Custom Border Color**: Enabled
- **Selected Layouts**: Layout 1 (default)

To switch layouts:
1. Use the layout switcher in the top bar
2. Or configure keyboard shortcuts in Tiling Shell settings

---

## Other Extensions

### Blur My Shell
Provides blur effects for the shell. Already configured via dconf - no manual setup needed.

### Just Perfection
UI tweaking extension. Settings are applied automatically.

### Clipboard Indicator
Shows clipboard history. Click the indicator in the top bar to access history.

### Media Controls
Shows currently playing media. Appears in top bar when media is playing.

### Hide Top Bar
Auto-hides the top bar when not needed. Already configured.

---

## Applying Configuration

After manual configuration:

1. **Restart GNOME Shell** (required for changes to take effect):
   - **X11**: Press `Alt + F2`, type `r`, press Enter
   - **Wayland**: Log out and log back in

2. **Verify Extensions Are Enabled**:
   ```bash
   gnome-extensions list --enabled
   ```

3. **Troubleshooting**:
   - If extensions don't work, try disabling and re-enabling them
   - Check extension logs: `journalctl -f -o cat /usr/bin/gnome-shell`
   - Ensure extension versions match your GNOME version

---

## Quick Color Reference

For easy copy-paste when configuring OpenBar:

**Main Colors:**
- Background: `#000000` or `rgb(0, 0, 0)`
- Foreground: `#FFFFFF` or `rgb(255, 255, 255)`
- Accent: `#8B8C94` or `rgb(139, 140, 148)`
- Active: `#B3B4B4` or `rgb(179, 180, 180)`

**Decimal Format (for dconf/gsettings):**
- Background: `['0.000', '0.000', '0.000']`
- Foreground: `['1.000', '1.000', '1.000']`
- Accent: `['0.545', '0.549', '0.580']`
- Active: `['0.702', '0.702', '0.702']`

---

## Screenshots Reference

Refer to the demo screenshots in `/demo/` folder to see how the final setup should look.

---

**Need Help?** Check `TROUBLESHOOTING.md` for common issues and solutions.
