
## A TMUX status line theme inspired by nvim status lines!

##### To install use [tpm](https://github.com/tmux-plugins/tpm):

Add the following to your .tmux.conf file:

	set -g @plugin 's4hlo/tmux-statusline'

#### Configuration

```bash
# TODO add options
set -g @line_indicator true
```

# ------- STYLE CUSTOMIZATION --------------
```bash
STYLE=$(t_option @line_style_separator 'angled')
JUSTIFY=$(t_option @line_style_justify 'left')
```

# ------ COLORS CONFIGURATION -------

```bash
set -g @line_color_base "#698DDA")
set -g @line_color_sync "#e06c75")
set -g @line_color_prefix "#c678dd")
set -g @line_color_copy "#98c379")
```

```bash
set -g @line_color_fg "#abb2bf")
set -g @line_color_light "#3e4452")
set -g @line_color_dark "#282c34")
set -g @line_color_bg "default")
```

### Modules


# ------- SPECIAL MODULES CONFIGURATION ------
```bash
set -g @line_date_format '%H:%M'
set -gn @line_indicator 'TMUX'
```

# ------ MODULES CONFIGURATION ------

availables modules
-ram 
-cpu
-git
-session
-user
-weather
-title
-time


```bash
set -g @line_module_a 'TITLE'
set -g @line_module_b 'USER'
set -g @line_module_c 'SESSION'
set -g @line_module_x 'WEATHER'
set -g @line_module_y 'RAM'
set -g @line_module_z 'TIME'
```


