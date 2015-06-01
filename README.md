# git-prompt

This is my prompt, which provides all sorts of useful information about the current status of Git repositories. It is written in pure Bash.

## Dependencies

* GNU sed (aka `gsed`, as opposed to the other `sed`) is **required**.
  ```bash
  # Homebrew
  brew install gnu-sed
  
  # MacPorts
  port install gsed
  ```
* Bash 4.x is highly recommended. (OS X Mavericks only comes with Bash 3.x.)
  ```bash
  # Homebrew
  brew install bash
  
  # MacPorts
  port install bash
  ```

In OS X, you can tell Terminal to use the new version of Bash by changing your preferences.
```
Preferences → General → Shells Open With
```

## Enabling it

Simply dropping these into your `profile.d` directory or sourcing them via `~/.profile`, `~/.bash_profile`, `~/.bashrc` or `/etc/bashrc` isn't enough. You must actually _turn it on_.

```bash
export GIT_EXTENDED_PROMPT=true
```

## Customization
### Symbology
If you want to change the symbology, you can do so by tweaking the environment variables.

```bash
export GIT_EXTENDED_PROMPT_HASH=":"
export GIT_EXTENDED_PROMPT_CONFLICTED="\xC3\x97"
export GIT_EXTENDED_PROMPT_STAGED="\xE2\x88\x86"
export GIT_EXTENDED_PROMPT_CHANGED="*"
export GIT_EXTENDED_PROMPT_UNTRACKED="!"
export GIT_EXTENDED_PROMPT_AHEAD="+"
export GIT_EXTENDED_PROMPT_BEHIND="-"
export GIT_EXTENDED_PROMPT_OK="\xE2\x9c\x93"
export GIT_EXTENDED_PROMPT_NOK="\xE2\x80\xBC"
export GIT_EXTENDED_PROMPT_NOREMOTE="<local>"
```

### Color Scheme
By default, the prompt uses a color scheme designed for a dark background. If you use a light background (such as the default in OS X Terminal), you can switch this to a more favorable palette by setting the following environment variable.

```bash
export PROMPT_COMMAND="__wp_set_prompt_command_for_basic";
```

### Freestyle
If you'd like to completely customize the prompt, feel free to write your own function (using `__wp_set_prompt_command_for_basic` or `__wp_set_prompt_command_for_dark` as a template), and set _that_ function as the value for the `PROMPT_COMMAND` environment variable.

## Known Issues

See the _Issues_ tab in GitHub.

## Other stuff

If you're running OS X, check out my [Type-R Terminal style](https://github.com/skyzyx/terminal-style).

Also, I'm a big fan of using [Meslo LG S](https://github.com/andreberg/Meslo-Font) 14pt for my Terminal. Give it a whirl!

You can set them in the Terminal.app `Preferences pane → Startup`.

## Great artists steal

Portions of this code are from https://github.com/magicmonty/bash-git-prompt.
