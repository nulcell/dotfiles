# Neovim + LazyVim Cheatsheet

Condensed from [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/)
(all 20 chapters), checked against this config. `<Space>` is the leader. Press a prefix
(`<Space>`, `g`, `z`, `[`, `]`, `"`, `'`, `<C-w>`) and wait for the which-key menu.
Search every keymap with `<Space>sk`.

## This config vs. the book

| What                                   | Effect                                                                                             |
| -------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `;` → `:`                              | `;` opens Command mode. Flash's "repeat f/t" `;` is gone: press `f`/`t` again (or `,` backwards)   |
| `<Space>e` / `<Space>E`                | Still the Snacks explorer. mini.files is `<Space>fm` (current file's dir) / `<Space>fM` (cwd)      |
| `<Space>h` / `<Space>H` / `<Space>1-9` | Harpoon: menu / add file / jump to file N. Don't copy the book's `<Space>h` gitsigns remap         |
| `<Space>a…`                            | Claude Code, not Sidekick/Copilot. See [AI](#ai)                                                   |
| `<Space>am`, `<M-]>` …                 | Local Ollama ghost text. See [AI](#ai)                                                             |
| `:Tutor`                               | Disabled (`tutor` is in `disabled_plugins` in `lua/config/lazy.lua`)                               |
| Multicursor `Q` (ch. 13)               | Needs Neovim 0.13+. This machine runs 0.12, so it's not available                                  |
| Always on                              | Relative + absolute numbers, inline git blame, explorer shows dotfiles, format on save             |
| Extras                                 | mini-files, mini-surround, yanky, dial, harpoon2, inc-rename, refactoring, neogen, project, test.core, dap.core, claudecode, plus lang extras |

## Modes

| Key                            | Mode / action                                                          |
| ------------------------------ | ---------------------------------------------------------------------- |
| `Esc` (`<C-c>` works too)      | Back to Normal                                                         |
| `i` / `a`                      | Insert before / after the cursor                                       |
| `I` / `A`                      | Insert at start of text / end of line                                  |
| `o` / `O`                      | Open a new line below / above                                          |
| `gi`                           | Insert again where you last left Insert mode                           |
| `v` / `V` / `<C-v>`            | Visual: characters / lines / block                                     |
| `:`                            | Command mode (ex commands). `Tab`/`S-Tab` cycle, `<C-y>` accepts and keeps typing, `Down` descends into a dir |
| `q:` (or `<C-f>` in cmdline)   | Editable command-history window. Run a line with `Enter`, close with `<C-c>` |
| `5ifoo<Esc>` / `80i*<Esc>`     | A count before insert repeats the inserted text                        |

Grammar: `[count]verb[count]motion` or `verb[count](a|i)object`. `.` repeats the last change.

## Moving

### Characters, words, lines

| Key                | Move                                                                           |
| ------------------ | ------------------------------------------------------------------------------ |
| `h j k l`          | ← ↓ ↑ →. Use counts with relative numbers: `5j`, `15k`                         |
| `w` / `b` / `e`    | Next word start / previous word start / word end                               |
| `ge`               | End of the previous word (`4ge` takes a count)                                 |
| `W B E gE`         | Same, but words are separated only by whitespace                               |
| `0` / `^` / `$`    | Column 0 / first non-blank / end of line                                       |
| `g_`               | Last non-blank                                                                 |
| `gg` / `G` / `42G` | Top / bottom / line 42 (same as `:42`)                                         |
| `(` / `)`          | Previous / next sentence                                                       |
| `{` / `}`          | Previous / next blank-line "paragraph"                                         |
| `%`                | Matching bracket (or the nearest enclosing one)                                |

### Find, till, seek (flash.nvim)

| Key                | Action                                                                               |
| ------------------ | ------------------------------------------------------------------------------------ |
| `f{c}` / `F{c}`    | Jump to char forward / back. Press `f` again, or `3f`, for later matches             |
| `t{c}` / `T{c}`    | Jump just before the char. Mostly useful with verbs: `d2ts`                          |
| `s{chars}{label}`  | **Seek**: jump to any visible text, in any window                                    |
| `S`                | Treesitter select: pick a surrounding syntax node by its paired labels               |
| `r` / `R` (after a verb) | Remote: act somewhere else, then jump back. `yR…p`, `drAth2w`, `gsaraa3e*`     |

### Scrolling and view (`z` menu)

| Key                   | Action                                                                 |
| --------------------- | ---------------------------------------------------------------------- |
| `<C-d>` / `<C-u>`     | Half page down / up                                                    |
| `<C-f>` / `<C-b>`     | Full page forward / back (takes a count)                               |
| `<C-e>` / `<C-y>`     | Scroll one line without moving the cursor                              |
| `zt` / `zz` / `zb`    | Put the cursor line at top / middle / bottom. Add `0` for column 0: `zz0` |

### Jumps and marks

| Key                   | Action                                                                  |
| --------------------- | ----------------------------------------------------------------------- |
| `<C-o>` / `<C-i>`     | Back / forward in jump history                                          |
| `ma` / `'a`           | Set / jump to mark `a` in this file                                     |
| `mA` / `'A`           | Uppercase = global mark, works across files                             |
| `'.`                  | Last change                                                             |
| `'<` / `'>`           | Start / end of the last visual selection                                |
| `'[`                  | Start of the last changed text (`V'[` selects what you just pasted)     |
| `<Space>sm`           | Marks picker                                                            |
| `:delm a`             | Delete a mark                                                           |

### Unimpaired `[` / `]` (previous / next)

| Key                     | Target                                                                    |
| ----------------------- | ------------------------------------------------------------------------- |
| `[(` `[{` `[<` / `]` …  | Jump out to the enclosing unmatched bracket                               |
| `[%` / `]%`             | Enclosing bracket of any type (the only way out of `[]`)                  |
| `[[` / `]]`             | Previous / next reference to the word under the cursor                    |
| `[f` `[c` `[m` / `]`…   | Function / class / method start. Uppercase (`]F`) jumps to the end       |
| `[i` / `]i`             | Top / bottom of the current indent scope                                  |
| `[d` `[e` `[w` / `]`…   | Diagnostic / error / warning. `[D`/`]D` first / last                      |
| `[s` / `]s`             | Misspelling                                                               |
| `[t` / `]t`             | TODO/FIXME comment                                                        |
| `[h` / `]h`             | Git hunk                                                                  |
| `[q` / `]q`             | Quickfix / Trouble item, across files                                     |
| `[b` / `]b`             | Buffer                                                                    |
| `[y` / `]y`             | Right after a put: cycle through yank history                             |
| `[p` / `]p`             | Put on the line above / below, re-indented                                |
| `[<Space>` / `]<Space>` | Add a blank line above / below                                            |
| `[c` / `]c` in diff mode | Previous / next change                                                   |
| `g[(` / `g])`           | Nearest surrounding open / close char (mini.ai). A count jumps out further |

## Editing

### Verbs

| Verb           | Does                                        | Line / to end of line |
| -------------- | ------------------------------------------- | --------------------- |
| `d`            | Delete (goes to the clipboard)              | `dd` / `D`            |
| `c`            | Change (delete, then Insert)                | `cc` / `C`            |
| `y`            | Yank (copy)                                 | `yy` / `Y`            |
| `gU` / `gu`    | Uppercase / lowercase                       | `gUU` / `guu`         |
| `>` / `<`      | Indent / dedent                             | `>>` / `<<`           |
| `=`            | Auto-indent                                 | `==`                  |
| `gq`           | Format with conform (`gqag` = whole file)   |                       |
| `gw`           | Rewrap to `textwidth`, cursor stays put     | `gww`, `gwip`, `gwig` |
| `gc`           | Toggle comment                              | `gcc` (`5gcc`)        |
| `gsa`          | Add a surrounding pair                      | See below             |
| `!`            | Filter through a shell command              | `!!`                  |

Examples: `d3w`, `3dw`, `d^`, `d2fe`, `c$`, `dsfoo{label}`, `gc5j`, `gcap`, `gcSh`, `>ap`, `v5>` (5 indent levels).

### Single keys

| Key                | Action                                                                  |
| ------------------ | ----------------------------------------------------------------------- |
| `x` / `X`          | Delete the char under / before the cursor (`5x`)                        |
| `r{c}`             | Replace one char                                                        |
| `~`                | Toggle case of one char                                                 |
| `J` / `gJ`         | Join lines, with / without whitespace fix-up (`3J`)                     |
| `xp`               | Swap two chars. `dwwP` moves a word, `daWwp` moves an argument          |
| `u` / `<C-r>`      | Undo / redo. `<Space>su` opens the undotree                             |
| `.`                | Repeat the last change. `2.` replaces the count (it doesn't multiply it) |
| `<C-a>` / `<C-x>`  | Increment / decrement. Dial also flips `true`↔`false`, weekdays, months, versions |
| `g<C-a>`           | In Visual, make a numbered sequence: `o1.<Esc>9.V'[g<C-a>`              |
| `gco` / `gcO`      | New comment line below / above                                          |
| `z=`               | Spelling suggestions (`<Space>us` toggles spell check)                  |
| `g<C-g>`           | Word, line, and byte counts                                             |

### Text objects: `verb` + `a`/`i` + object

`i` = inside, `a` = around (includes delimiters or whitespace). Rule of thumb: `ciw` to change, `daw` to delete.

| Obj                  | Selects                                                         |
| -------------------- | --------------------------------------------------------------- |
| `w` `W` `s` `p`      | Word, WORD, sentence, paragraph                                 |
| `"` `'` `` ` `` / `q` | That quote type / nearest quote of any type                    |
| `(` `[` `{` `<` / `b` | That bracket type / nearest bracket of any type                |
| `*` `_` etc.         | Between punctuation (Markdown: `ci*`, `ca_`)                    |
| `g`                  | Whole buffer (`yig`, `cag`)                                     |
| `f` `c` `o`          | Function, class, block/loop/conditional (treesitter)            |
| `t`                  | HTML/JSX tag                                                    |
| `i`                  | Indent scope                                                    |
| `h`                  | Git hunk (`dih` reverts an addition)                            |
| `n…` / `l…`          | Next / last object: `cin{`, `dil(`                              |
| count before `a`/`i` | Outer levels: `d2a{`, `c3i{`                                    |

### Surround (mini.surround, `gs` prefix)

| Key                       | Action                                                             |
| ------------------------- | ------------------------------------------------------------------ |
| `gsa{motion}{char}`       | Add. `(` adds inner spaces, `)` doesn't. `t` prompts for a tag     |
| `gsd{char}`               | Delete (`2gsd{` for the second-nearest)                            |
| `gsr{old}{new}`           | Replace: `gsr"'`                                                   |
| `gsh{char}`               | Highlight (dry run)                                                |
| `gsf` / `gsF`             | Jump to the right / left surrounding char                          |
| Visual `gsa{char}`        | Surround the selection                                             |

Examples: `gsaiw"`, `gsai[)`, `gsaa[)`, `gsa$"`, `gsaSb'`, `gsaapt` then `p` gives `<p>…</p>`.

### Insert-mode keys

| Key                  | Action                                                        |
| -------------------- | ------------------------------------------------------------- |
| `<C-r>{reg}`         | Insert a register. `<C-r>+` is the clipboard                  |
| `<C-a>`              | Re-insert the last inserted text                              |
| `<C-o>{cmd}`         | Run one Normal command, then return to Insert                 |
| `<C-t>` / `<C-d>`    | Indent / dedent the current line                              |
| `<C-u>`              | Delete what you typed on this line                            |
| `<C-v>{key}`         | Insert a key literally (e.g. `<C-v><Esc>` inside `:norm`)     |
| `<C-]>`              | Expand an abbreviation without adding a space                 |
| `<C-n>` / `<C-p>`    | Next / previous completion item                               |
| `<C-y>` / `Enter`    | Accept completion                                             |
| `Tab`                | Next snippet field                                            |

## Visual mode

| Key                    | Action                                                            |
| ---------------------- | ----------------------------------------------------------------- |
| `o`                    | Jump to the other end of the selection                            |
| `gv`                   | Reselect the last selection                                       |
| `<C-v>` then `I`/`A`   | Block insert / append on every line. `<C-v>$` goes to each line's end |
| `d c y x r{c} > < gc`  | Act on the selection (then back to Normal)                        |
| `:`                    | Opens as `:'<,'>`, a command on the selected lines                |
| `!cmd`                 | Pipe the lines through a shell command: `!jq`, `!sort`, `!tr -s ' '` |
| `<C-Space>`            | Treesitter incremental selection (press again to grow)            |
| `]n` / `[n`, `]N` / `[N` | Select the next / previous node, next / previous sibling node   |

## Registers and clipboard

`y`, `d`, and `c` all write to the system clipboard (`+` = `*` = unnamed). Turn that off with `vim.opt.clipboard = ""`.

| Key                  | Action                                                             |
| -------------------- | ------------------------------------------------------------------ |
| `p` / `P`            | Put after / before (whole lines go below / above). Takes a count   |
| `gp` / `gP`          | Put, and leave the cursor after the pasted text                    |
| `>p` `<p` `>P` `<P`  | Put and change the indent                                          |
| `"ay…` / `"Ay…`      | Yank into register `a` / append to `a`                             |
| `"ap`                | Put from `a`                                                       |
| `"_d…`               | Black hole: delete without touching the clipboard                  |
| `"0p`                | Last yank (survives later deletes)                                 |
| `"1`…`"9`, `"-`      | Recent deletes, small (sub-line) delete                            |
| `".`  `"%`           | Last inserted text, current filename                               |
| `"` (wait)           | Registers menu                                                     |
| `<Space>s"`          | Registers picker                                                   |
| `<Space>p`           | Yank history picker (yanky)                                        |
| `:let @a = @+`       | Copy one register into another. `:let @+ = @%` copies the filename |

### Macros

| Key                  | Action                                                             |
| -------------------- | ------------------------------------------------------------------ |
| `qq` … `q`           | Record into `q` (any letter works)                                 |
| `qQ`                 | Append to recording `q`                                            |
| `@q` / `@@`          | Play `q` / replay the last one played                              |
| `"qp` → edit → `"qyiw` | Edit a macro as text, then save it back                          |
| `:%norm @q`          | Run a macro on every line                                          |

## Files and pickers

| Key                          | Action                                                            |
| ---------------------------- | ----------------------------------------------------------------- |
| `<Space><Space>` / `<Space>ff` | Find files (project root)                                       |
| `<Space>fF`                  | Find files (cwd). Use it when the root guess is wrong (monorepos) |
| `<Space>fg`                  | Git files                                                         |
| `<Space>fr` / `<Space>fR`    | Recent files (all / cwd)                                          |
| `<Space>fc`                  | Config files                                                      |
| `<Space>fp`                  | Projects                                                          |
| `<Space>fb` / `<Space>,`     | Buffers                                                           |
| `<Space>e` / `<Space>E`      | Snacks explorer (root / cwd)                                      |
| `<Space>fm` / `<Space>fM`    | mini.files (current file's dir / cwd)                             |
| `:e path`, `:cd`, `:lcd`, `:pwd` | Open file, change cwd (global / this window), print cwd       |

**Inside a picker:** fuzzy and smart-case. A space starts a second filter term (live grep is the exception: there it's a literal space).

| Key                   | Action                                                        |
| --------------------- | ------------------------------------------------------------- |
| `Enter`               | Open                                                          |
| `Tab`                 | Multi-select                                                  |
| `<M-s>`               | Label jump to a line                                          |
| `<C-d>` / `<C-u>`     | Scroll the results                                            |
| `<C-f>` / `<C-b>`     | Scroll the preview                                            |
| `<M-w>`               | Focus the preview                                             |
| `<C-v>` / `<C-s>`     | Open in a vertical / horizontal split                         |
| `<C-q>`               | Send the results (or the selection) to quickfix               |
| `<M-t>`               | Send to Trouble                                               |
| `<C-x>`               | Close buffer (in the buffer picker)                           |
| `Esc Esc`             | Close (one `Esc` switches to Normal mode)                     |
| `<Space>sR`           | Resume the last picker                                        |

**Snacks explorer:** `Enter` open/expand, `BS` up a dir, `a` add (a trailing `/` makes a dir), `d` delete, `r` rename, `y`/`p` copy/paste, `m` move, `i` filter, `H` hidden files, `?` help, `q` close.

**mini.files** (edit the listing like a buffer): `l` enter / open, `h` go out, `o` new file, `dd` delete, `yy`/`p` copy, rename by editing the line, `=` apply changes (then `y`/`n`), `q` close.

## Buffers, windows, tabs, sessions

| Key                              | Action                                                       |
| -------------------------------- | ------------------------------------------------------------ |
| `H` / `L`, `[b` / `]b`           | Previous / next buffer                                       |
| `` <Space>` ``                   | Alternate (last) buffer                                      |
| `<Space>bd` / `<Space>bD`        | Close buffer / close buffer and its window                   |
| `<Space>bo` `bl` `br`            | Close others / to the left / to the right                    |
| `<Space>bp` / `<Space>bP`        | Pin / close all unpinned                                     |
| `<Space>bj`                      | Pick a buffer by label                                       |
| `<Space>.` / `<Space>S`          | Scratch buffer (per cwd) / pick one                          |
| `<Space>wv` / `<Space>ws`        | Vertical / horizontal split (also `<Space>\|` / `<Space>-`)   |
| `<C-h/j/k/l>` or `<Space>wh`…    | Move between windows                                         |
| `<Space>wq` `wc` `wd` `wo`       | Quit window / close / close (same) / close all others        |
| `<Space>w+ - > <` / `<Space>w=`  | Resize (use counts) / equalize                               |
| `<Space>w<Space>`                | Hydra: keep the window menu open (`vvvs`), `Esc` exits       |
| `<Space>wT`                      | Move the window to a new tab                                 |
| `<Space>uz` / `<Space>uZ`        | Zen / zoom                                                   |
| `<Space><Tab><Tab>`              | New tab                                                      |
| `gt` / `gT` / `3gt`              | Next / previous / tab 3 (also `<Space><Tab>]` / `[`)         |
| `<Space><Tab>d`                  | Close the tab                                                |
| `za` `zc` `zo` `zO` `zR`         | Folds: toggle / close / open / open recursively / open all   |
| `<Space>qq`                      | Quit all (the session is saved)                              |
| `<Space>qs` / `<Space>ql` / `<Space>qS` | Restore this dir's session / the last one / pick one  |
| `<Space>qd`                      | Don't save the session on exit                               |
| Harpoon                          | `<Space>H` add, `<Space>h` menu, `<Space>1`…`9` jump         |

## Search and replace

| Key                       | Action                                                                  |
| ------------------------- | ----------------------------------------------------------------------- |
| `/pat` / `?pat`           | Search forward / back. `n` is always down, `N` always up. `3n`          |
| `\C` / `\c` anywhere      | Force case-sensitive / insensitive (default: smart case)                |
| `\V`                      | Literal text from here on (turns regex off)                             |
| Vim regex                 | `.` `*` `\+` `\=` (optional) `\S` `\d` `\(…\)`. Use `\0`/`\1` in replacements |
| `<Space>/` / `<Space>sg`  | Live grep, project root (`<Space>sG` = cwd). Uses ripgrep regex         |
| `<Space>sw` / `<Space>sW` | Grep the word or selection (root / cwd)                                 |
| `<Space>sb` / `<Space>sB` | Lines in this buffer / grep open buffers                                |
| `<Space>sr`               | Grug-far project replace. `\r` replace, `\s` sync your edits, `\t` history, `g?` help. Commit first |

**`:s` substitute:** `:[range]s/pat/rep/[flags]`

| Piece                         | Meaning                                                         |
| ----------------------------- | --------------------------------------------------------------- |
| Range: none                   | Current line                                                    |
| Range: `%`                    | Whole file                                                      |
| Range: `'<,'>`                | Last visual selection                                           |
| Range: `3,8`                  | Lines 3 to 8                                                    |
| Range: `'a,'b`                | Between marks `a` and `b`                                       |
| Range: `,/pat/`               | From here to the next line matching `pat`                       |
| Flags                         | `g` all on the line, `c` confirm each, `i`/`I` ignore / match case |
| `:s//rep`                     | Reuse the last search pattern                                   |
| `:%sg`                        | Repeat the last substitute on the whole file, all matches      |
| `:s+/a/+/b/+`                 | Any delimiter works (handy for paths)                           |
| `:%s/hell\(\S*\)/X\1/`        | Capture groups                                                  |

**Bulk line commands**

| Command                           | Does                                                          |
| --------------------------------- | ------------------------------------------------------------- |
| `:%norm A;`                       | Run Normal keys on every line (`<C-v><Esc>` for Esc)          |
| `:%g/pat/d`, `:g!/pat/d`          | Delete lines that match / don't match                         |
| `:%g/pat/s/a/b/g`                 | Substitute only on matching lines                             |
| `:%g/pat/norm …`                  | Normal keys on matching lines                                 |
| `:'<,'>w file`                    | Write the selected lines to a file                            |
| `:!cmd`                           | Run a shell command without changing the buffer               |
| `:iabbr ifmain if __name__…`      | Abbreviation (make it permanent in `autocmds.lua` with a FileType autocmd) |

## Code (LSP, treesitter)

| Key                       | Action                                                          |
| ------------------------- | --------------------------------------------------------------- |
| `gd` / `gD` / `gy` / `gI` | Go to definition / declaration / type definition / implementation |
| `gr`                      | References picker (`<M-t>` sends them to Trouble)               |
| `K` / `gK`                | Hover docs / signature help                                     |
| `<Space>ca` / `<Space>cA` | Code action / source action                                     |
| `<Space>cr` / `<Space>cR` | Rename symbol (inc-rename) / rename file                        |
| `<Space>cf`               | Format now (it also formats on save)                            |
| `<Space>cd`               | Line diagnostics popup                                          |
| `<Space>ss` / `<Space>sS` | Symbols in the file / workspace. Type `function` to filter      |
| `<Space>cs`               | Symbols outline sidebar (Trouble)                               |
| `<Space>cn`               | Generate a doc comment (neogen)                                 |
| `<Space>r…`               | Refactoring: `rf` extract function, `rx` extract variable, `ri` inline, `rs` pick |
| `<Space>xx` / `<Space>xX` | Diagnostics in Trouble (workspace / this buffer)                |
| `<Space>xt` / `<Space>xQ` | TODOs / quickfix in Trouble                                     |
| `<Space>st` / `<Space>sT` | TODO picker                                                     |
| `<Space>cm`               | Mason: `i` install, `U` update all, `g?` help                   |
| `<Space>cl`               | LSP info                                                        |
| `:lsp restart`            | Kick a stuck server                                             |
| `<Space>sn…`              | Noice messages: `a` all, `l` last, `d` dismiss. Also `:messages` |
| `:LazyHealth`, `:checkhealth mason` | Health checks                                         |
| `<Space>ut`               | Toggle the sticky context line (needs the `ui.treesitter-context` extra, which is off) |
| `<Space>uC` / `<Space>ub` | Colorscheme picker / light↔dark                                 |

## Git

| Key                          | Action                                                      |
| ---------------------------- | ----------------------------------------------------------- |
| `<Space>gg`                  | Lazygit                                                     |
| `<Space>gs`                  | Status picker. `Tab` stages / unstages a file               |
| `<Space>gl` / `<Space>gd`    | Log / diff hunks picker                                     |
| `<Space>gS`                  | Stash                                                       |
| `<Space>ghs` / `<Space>ghS`  | Stage hunk / stage buffer                                   |
| `<Space>ghr` / `<Space>ghR`  | Reset hunk / reset buffer                                   |
| `<Space>ghu`                 | Undo the last stage                                         |
| `<Space>ghp`                 | Preview hunk inline                                         |
| `<Space>ghb`                 | Blame line                                                  |
| `<Space>ghd` / `<Space>ghD`  | Diff against the index / against the last commit            |
| `<Space>gi` `gI` / `gp` `gP` | GitHub issues / PRs (open / all). `Enter` opens actions; in a PR diff `<M-w>` then `Enter` comments, `<C-s>` submits |
| `[h` `]h`, `ih`              | Hunk motions / hunk object                                  |

**Diff mode** (`nvim -d a b` or `<Space>ghd`): `]c`/`[c` next / previous change, `do`/`dp` (or `:diffget`/`:diffput`) obtain / put, `zo` unfolds, `:diffoff` exits.
For merges, set `git mergetool` to vimdiff, then `vag` + `:%diffg 2` (buffers 1 local, 2 base, 3 remote, 4 merged).

**Terminal:** `<C-/>` toggles it (`<Space>fT` for a cwd terminal). `Esc Esc` (or `<C-\><C-n>`) goes to Normal mode, `i` back to the shell. `<C-z>` suspends nvim; `fg` brings it back.

## AI

| Key                        | Action                                                       |
| -------------------------- | ------------------------------------------------------------ |
| `<Space>ac`                | Toggle Claude Code                                           |
| `<Space>af`                | Focus Claude Code                                            |
| `<Space>ar` / `<Space>aC`  | Resume / continue a session                                  |
| `<Space>ab`                | Add the current buffer to the context                        |
| Visual `<Space>as`         | Send the selection                                           |
| `<Space>aa` / `<Space>ad`  | Accept / deny the proposed diff                              |
| `<Space>am`                | Toggle Ollama ghost text                                     |
| Insert `<M-]>` / `<M-[>`   | Request / cycle suggestions                                  |
| Insert `<M-y>` / `<M-Y>`   | Accept all / accept one line                                 |
| Insert `<M-e>`             | Dismiss                                                      |

## Debugging (DAP)

| Key                       | Action                                                        |
| ------------------------- | ------------------------------------------------------------- |
| `<Space>db` / `<Space>dB` | Toggle breakpoint / conditional breakpoint                    |
| `<Space>dc`               | Run / continue (also starts a session)                        |
| `<Space>da` / `<Space>dl` | Run with args / run the last config                           |
| `<Space>di` `dO` `do`     | Step into / over / out                                        |
| `<Space>dC`               | Run to cursor                                                 |
| `<Space>dt`               | Terminate                                                     |
| `<Space>du`               | Toggle the DAP UI. In watches, `i` adds an expression; in locals, `e` edits a value |
| `<Space>de` / `<Space>dr` | Eval / REPL                                                   |
| Setup                     | Install adapters from Mason (`delve`, `debugpy`, `chrome-debug-adapter`) |

## Testing (neotest)

| Key                       | Action                                                        |
| ------------------------- | ------------------------------------------------------------- |
| `<Space>tt` / `<Space>tT` | Run this file / all test files                                |
| `<Space>tr` / `<Space>tl` | Run the nearest test / the last run                           |
| `<Space>td`               | Debug the nearest test (stops at the failure)                 |
| `<Space>to` / `<Space>tO` | Output popup (`q` closes) / output panel                      |
| `<Space>ts`               | Summary. `J`/`K` jump to failures, `m` mark, `R` run marked, `M` clear marks, `?` help |
| `<Space>tw` / `<Space>tS` | Toggle watch / stop                                           |
| Failures                  | Listed in Trouble. Use `]q` / `[q`                            |

## Config (lazy.nvim)

| Where / what                 | Notes                                                          |
| ---------------------------- | -------------------------------------------------------------- |
| `<Space>l` → `S`             | Lazy UI → sync (install, clean, update). `q` closes            |
| `:LazyExtras` → `x`          | Toggle an extra                                                |
| `lua/config/options.lua`     | `vim.opt.x = …` (`vim.g.x` when docs say `g:`)                 |
| `lua/config/keymaps.lua`     | `vim.keymap.set(mode, lhs, rhs, {desc=…})`. Remove one with `vim.keymap.del` |
| `lua/config/autocmds.lua`    | `vim.api.nvim_create_autocmd("FileType", {pattern=…, callback=…})` |
| `lua/plugins/*.lua`          | Every file is loaded. It must `return { … }` (one spec or a list) |
| `.lazy.lua` in a project     | Per-project spec overrides                                     |
| `~/.config/nvim/snippets/`   | VS Code-style snippets: `package.json` + `<lang>.json`         |

Spec fields:

```lua
return {
  "owner/repo",            -- or dir = "~/path", url = "…"
  enabled = false,         -- disable a built-in plugin
  opts = { … },            -- merged into LazyVim's opts, passed to setup()
  opts = function(_, opts) -- or modify them in place (no return)
    table.insert(opts.x, …)
  end,
  keys = {                 -- merged; { "<leader>e", false } removes a key
    { "<leader>xy", function() … end, mode = { "n", "x" }, desc = "…" },
  },
  lazy = false, event = "BufRead", ft = "python", cmd = "Foo", -- loading
  build = "make",          -- runs on install/update
  config = function(_, opts) … end, -- replaces LazyVim's config: last resort
  branch = "…", tag = "…", commit = "…", version = "…",
}
```

Colorscheme: `{ "LazyVim/LazyVim", opts = { colorscheme = "…" } }`.
Help: `:help topic`, `:helpgrep text`, and `<C-]>` follows a help link. Minimal repro: `nvim -u repro.lua`.
