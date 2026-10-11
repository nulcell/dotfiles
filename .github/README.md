# dotfiles

My macOS dotfiles, stored as a bare git repo in `~/.cfg` with `$HOME` as the work tree ([how it works](https://www.atlassian.com/git/tutorials/dotfiles)).

| What                 | Path                                                  |
| -------------------- | ----------------------------------------------------- |
| Neovim (LazyVim)     | `.config/nvim/` ([README](../.config/nvim/README.md)) |
| tmux                 | `.tmux.conf`                                          |
| zsh + powerlevel10k  | `.zshrc`, `.zprofile`, `.p10k.zsh`                    |
| Homebrew (minimal)   | `.homebrew/work/Brewfile` (work / temporary machines) |
| Homebrew (full)      | `.homebrew/personal/Brewfile` (personal machines)     |
| Claude Code skills   | [Claude Code skills](#claude-code-skills) (below)     |

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

## Claude Code skills

Five skill plugins, kept deliberately small. Each owns one job; the table says which are always on and which you call yourself.

| Layer     | Skill                                                                  | Job                          | Use                                                                                                           |
| --------- | ---------------------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Always on | [ponytail](https://github.com/dietrichgebert/ponytail)                 | How much code gets written   | Automatic. `/ponytail lite\|full\|ultra\|off`. `/ponytail-review` reviews a diff                               |
| Always on | Concise output style + [i-have-adhd](https://github.com/ayghri/i-have-adhd) | How replies read       | Concise style is the baseline. Run `/i-have-adhd` only when replies drift verbose                             |
| On demand | [mattpocock-skills](https://github.com/mattpocock/skills)              | Process for non-trivial work | `/setup-matt-pocock-skills` once per repo, then the flow below                                                |
| On demand | [taste-skill](https://github.com/leonxlnx/taste-skill)                 | Frontend design only         | Mention it in UI prompts. Default `taste-skill` only; skip the v1, gpt and style variants until you pick a look |
| On demand | [humanizer](https://github.com/blader/humanizer)                       | Rewriting AI-sounding prose  | `/humanizer:humanizer` or "humanize docs/post.md". Never for code                                             |

### Install

```sh
# inside Claude Code
/plugin marketplace add DietrichGebert/ponytail   && /plugin install ponytail@ponytail
/plugin marketplace add ayghri/i-have-adhd        && /plugin install i-have-adhd@i-have-adhd
/plugin marketplace add blader/humanizer          && /plugin install humanizer@humanizer
/plugin marketplace add Leonxlnx/taste-skill      && /plugin install taste-skill@taste-skill
# from a shell
claude plugin install mattpocock-skills@claude-plugins-official
```

Install mattpocock via the plugin only. Adding it again with `npx skills` duplicates every skill.

### Which to reach for

- **Small task or bug fix:** ponytail alone. Smallest diff, one runnable check.
- **Feature:** Pocock flow, with ponytail still trimming the code:
  `/grill-with-docs` → `/to-spec` → `/to-tickets` → `/implement` (runs `tdd` and `code-review` itself).
- **Brevity:** one layer. Concise style is the baseline, `/i-have-adhd` is a manual override, never a third rule set.
- **Review:** `/ponytail-review` for a quick diff check. `/implement` already runs Pocock's `code-review`, so don't run both on the same diff.
- **UI work:** add taste-skill. **Writing:** add humanizer.

Pocock skills you type yourself: `grill-me`, `grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `implement-spec`, `triage`, `handoff`, `wayfinder`, `retro`, `teach`, `wait-what`, `improve-codebase-architecture`.
The agent picks these up on its own: `tdd`, `diagnosing-bugs`, `research`, `prototype`, `code-review`, `domain-modeling`, `codebase-design`, `pr`.

### Not installed

Cloudflare's `security-audit-skill`, GitHub's `spec-kit` and `jeffallan/claude-skills` overlap with the above or add too much. A personal skills collection may replace them later.
