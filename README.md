# git-prompt

This is my prompt, which provides all sorts of useful information about the current status of Git repositories. It is written in pure Bash.

## Dependencies

* Bash 4.x is highly recommended. (OS X Mavericks only comes with Bash 3.x.)
* GNU sed (aka `gsed`, as opposed to the other `sed`) is highly recommended.

If you are running a modern version of OS X, you can install these via Homebrew or MacPorts.

## Enabling it

Simply dropping these into your `profile.d` directory or loading them via `~/.profile` isn't enough. You must actually _turn it on_.

```bash
export GIT_EXTENDED_PROMPT=true
```

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
```

## Other stuff

If you're running OS X, check out my [Type-R Terminal style](https://github.com/skyzyx/terminal-style).

Also, I'm a big fan of using [Meslo LG S](https://github.com/andreberg/Meslo-Font) 14pt for my Terminal. Give it a whirl!

You can set them in the Terminal.app `Preferences pane → Startup`.
