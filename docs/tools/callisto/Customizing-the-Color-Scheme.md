You might have noticed that Callisto uses colors in its output for certain lines, just to make things a little more readable (and prettier!).

These colors as well as any emphasis is actually fully configurable.

If you open the `colors.toml` file you should have in your `%appdata%/callisto` folder, you should see entries like this:

```toml
[colors.terminal.action_start]
fg = 0x7BADE2
emphasis = [ "bold" ]
```

Each of these entries specifies the color and emphasis for a type of line Callisto outputs.

`fg = 0x7BADE2` specifies that the foreground color for the line should be RGB color 7BADE2. 

You can also use `bg` to specify a background color if you want. 

You can add multiple different emphasis types to the same line if you want by adding them to the emphasis list. Some valid emphasis types are `bold`, `italic`, `underline` and `strikethrough`.

Feel free to experiment with the colors and maybe shared color schemes too if you want!