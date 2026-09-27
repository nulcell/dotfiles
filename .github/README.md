# dotfiles

My macOS dotfiles, stored as a bare git repo in `~/.cfg` with `$HOME` as the work tree ([how it works](https://www.atlassian.com/git/tutorials/dotfiles)).

| What                 | Path                                                  |
| -------------------- | ----------------------------------------------------- |
| Neovim (LazyVim)     | `.config/nvim/` ([README](../.config/nvim/README.md)) |
| tmux                 | `.tmux.conf`                                          |
| zsh + powerlevel10k  | `.zshrc`, `.zprofile`, `.p10k.zsh`                    |
| Homebrew (minimal)   | `.homebrew/work/Brewfile` (work / temporary machines) |
| Homebrew (full)      | `.homebrew/personal/Brewfile` (personal machines)     |
| Claude Code settings | `.claude/settings.json`                               |

## Install on a new machine

```sh
# 1. Homebrew, then oh-my-zsh (+ zsh-syntax-highlighting, zsh-autosuggestions plugins)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# 2. Dotfiles
git clone --bare git@github.com:nulcell/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
# If checkout complains about existing files, back them up and retry:
#   mkdir -p .config-backup && config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | xargs -I{} sh -c 'mkdir -p .config-backup/$(dirname {}) && mv {} .config-backup/{}'
#   config checkout
config config --local status.showUntrackedFiles no

# 3. Packages: pick one (see "Homebrew" below)
brew bundle --file ~/.homebrew/work/Brewfile      # minimal CLI set
brew bundle --file ~/.homebrew/personal/Brewfile  # everything: apps, VS Code extensions, etc.

# 4. tmux plugins: start tmux, then press prefix + I
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Neovim installs its plugins on first launch.

## Day to day

`config` is plain git pointed at `~/.cfg`:

```sh
config status
config add .config/kitty/kitty.conf   # start tracking a new file
config commit -m "..." && config push
```

## Homebrew

Two Brewfiles, one per machine type. Set `BF` to the one this machine uses:

```sh
BF=~/.homebrew/work/Brewfile       # work / temporary machines
BF=~/.homebrew/personal/Brewfile   # personal machines
```

| Task                                        | Command                                       |
| ------------------------------------------- | --------------------------------------------- |
| Install missing + upgrade outdated          | `brew update && brew bundle --file $BF`       |
| Check whether anything is missing           | `brew bundle check --file $BF --verbose`      |
| List installed packages not in the Brewfile | `brew bundle cleanup --file $BF`              |
| Uninstall those packages                    | `brew bundle cleanup --file $BF --force`      |
| Add a package                               | `brew install <pkg>`, then regenerate (below) |

Regenerate a Brewfile from what's installed, then review `config diff` before committing:

```sh
# work: CLI tools only
brew bundle dump --file ~/.homebrew/work/Brewfile --no-cask --no-vscode --no-go --no-npm --no-restart --force
# personal: everything
brew bundle dump --file ~/.homebrew/personal/Brewfile --no-go --force
```

Regenerating the work Brewfile on a personal machine pulls in every CLI tool installed there, so trim the diff before committing.
