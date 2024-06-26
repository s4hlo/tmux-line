
## A TMUX status line theme inspired by nvim status lines!
![Alt text](./pics/title.gif)


### highlight each tmux mode with a diferent color( e.g when the prefix is pressed)
![Alt text](./pics/showcase.gif)

### Install
To install use [tpm](https://github.com/tmux-plugins/tpm), add the following to your .tmux.conf file:
```bash
set -g @plugin 's4hlo/tmux-line'
```
 
### Styles
![styles](./pics/stylex2.gif)
```bash
set -g @line_style_separator 'angled' # or flat, arrow, rounded 
set -g @line_style_justify 'left' #  or centre, right
```

### Colors


The plugin uses Onedark theme as default but you can change all the colors
- To inherit transparency effects, set the background color to the terminal default.
- ![Alt text](./pics/transparency.gif)
```bash
# modes colors
set -g @line_color_base "#698DDA"
set -g @line_color_sync "#e06c75"
set -g @line_color_prefix "#c678dd"
set -g @line_color_copy "#98c379"

set -g @line_color_fg "#abb2bf"
set -g @line_color_light "#3e4452"
set -g @line_color_dark "#282c34"
set -g @line_color_bg "default"
```

### Modules
this plugin uses modules as shown below.

```
+-------------------------------------------------+
| A | B | C                             X | Y | Z |
+-------------------------------------------------+
```

Available modules:
- `ram`: Displays RAM usage.
- `cpu`: Displays CPU usage.
- `git`: Displays Git Branch in the current panel.
- `session`: Displays session information.
- `user`: Displays current user information.
- `weather`: Displays weather information.
- `title`: Displays a custom text (default: "TMUX").
- `time`: Displays current time in defined format (defalut: '%H:%M').
- `none`: Disable module.


```bash

set -g @line_module_a 'title'
set -g @line_module_b 'user'
set -g @line_module_c 'session'
set -g @line_module_x 'weather'
set -g @line_module_y 'ram'
set -g @line_module_z 'time'

# this is specifc configuration for modules `time` and `title`
set -g @line_date_format '%H:%M'
set -g @line_indicator 'TMUX'
```


