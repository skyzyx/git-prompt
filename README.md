# git-prompt

This is my prompt, which provides all sorts of useful information about the current status of Git repositories. It is written in pure Bash.

A plain-text version looks like this:

```bash
[ryanparman@rparman: ~/projects/my-project] 12:00:00 (master +1 -2 3× 4∆ 5* 6! <local>) ✓
     ↑        ↑                ↑               ↑        ↑             ↑                 ↑
   User     Machine           Path            Time    Branch [Git state information]  Last exit status
```

* `master` — The current branch that the repo is set to.
* `+1` — The number of commits "ahead" this branch is compared to its remote copy. (Local has new commits)
* `-2` — The number of commits "behind" this branch is compared to its remote copy. (Remote has new commits)
* `3×` — The number of files that have merge conflicts.
* `4∆` — The number of changed files that have been staged (a.k.a., "added") for commit.
* `5*` — The number of changed files that have NOT been staged (a.k.a., "added") for commit.
* `6!` — The number of new files that have not yet been added to the repository.
* `<local>` — This is only shown if the branch has not yet been pushed to the remote. It is a local-only branch.

**Last exit status:**
* `✓` — The last command exited with NO errors.
* `‼︎` — The last command exited with errors.

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
By default, the prompt is not rewritten. You can change that by setting `dark` for dark-colored consoles, `light` for light-colored consoles, and `nocolor` for a formatted prompt with no color settings.

```bash
export GIT_EXTENDED_PROMPT_COLOR="dark"
```

### System Time
You can add the system’s time to the prompt by enabling it.

```bash
export GIT_EXTENDED_PROMPT_TIME="true"
```

## Known Issues

See the _Issues_ tab in GitHub.

## Other stuff

If you're running OS X, check out my [Type-R Terminal style](https://github.com/skyzyx/terminal-style).

Also, I'm a big fan of using [Meslo LG S](https://github.com/andreberg/Meslo-Font) 14pt for my Terminal. Give it a whirl!

You can set them in the Terminal.app `Preferences pane → Startup`.

## Great artists steal

Portions of this code are from https://github.com/magicmonty/bash-git-prompt.
