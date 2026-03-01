# ============================================================
# Zsh config — sans Oh-My-Zsh, avec Starship
# Backup: ~/.zshrc.backup.20260301
# ============================================================

# ----- PATH -----
export PATH="$HOME/.local/bin:$HOME/.rbenv/bin:./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# ----- Completions -----
fpath=(~/.zsh/plugins/zsh-completions/src ~/.zsh/completions $fpath)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
# Compile zcompdump en background pour accélérer les prochains lancements
{
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# ----- History -----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY

# ----- Plugins -----
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
export YSU_MESSAGE_POSITION="after"
export YSU_IGNORED_GLOBAL_ALIASES=("G" "H" "T" "L" "NUL")
source ~/.zsh/plugins/you-should-use/you-should-use.plugin.zsh
source ~/.zsh/plugins/zsh-autopair/autopair.zsh
autopair-init

# History substring search keybindings (flèches haut/bas)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Navigation par mots (Ctrl+flèches)
bindkey '^[[1;5D' backward-word      # Ctrl+←
bindkey '^[[1;5C' forward-word       # Ctrl+→

# Début/fin de ligne (Home/End)
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End

# Supprimer un mot (Ctrl+Backspace / Ctrl+Delete)
bindkey '^H' backward-kill-word      # Ctrl+Backspace
bindkey '^[[3;5~' kill-word          # Ctrl+Delete

# Alt+flèches (navigation par mots aussi)
bindkey '^[[1;3D' backward-word      # Alt+←
bindkey '^[[1;3C' forward-word       # Alt+→

# Shift+flèches (sélection — si supporté par le terminal)
bindkey '^[[1;2D' backward-char      # Shift+←
bindkey '^[[1;2C' forward-char       # Shift+→

# ----- SSH Agent -----
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# ----- Last working directory -----
ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p "$ZSH_CACHE_DIR"
chpwd_last_working_dir() {
  echo "$PWD" >| "$ZSH_CACHE_DIR/last-working-dir"
}
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_last_working_dir
if [[ "$PWD" == "$HOME" && -r "$ZSH_CACHE_DIR/last-working-dir" ]]; then
  cd "$(<"$ZSH_CACHE_DIR/last-working-dir")"
fi

# ----- rbenv (lazy load) -----
_lazy_load_rbenv() {
  unset -f rbenv ruby gem irb bundle rails rake
  eval "$(rbenv init -)"
}
rbenv() { _lazy_load_rbenv && rbenv "$@" }
ruby() { _lazy_load_rbenv && ruby "$@" }
gem() { _lazy_load_rbenv && gem "$@" }
irb() { _lazy_load_rbenv && irb "$@" }
bundle() { _lazy_load_rbenv && bundle "$@" }
rails() { _lazy_load_rbenv && rails "$@" }
rake() { _lazy_load_rbenv && rake "$@" }

# ----- pyenv (lazy load, seulement si installé) -----
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  _lazy_load_pyenv() {
    unset -f pyenv python python3 pip pip3
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init - 2> /dev/null)"
  }
  pyenv() { _lazy_load_pyenv && pyenv "$@" }
  python() { _lazy_load_pyenv && python "$@" }
  python3() { _lazy_load_pyenv && python3 "$@" }
  pip() { _lazy_load_pyenv && pip "$@" }
  pip3() { _lazy_load_pyenv && pip3 "$@" }
fi

# ----- fnm (node version manager, cache) -----
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  _fnm_cache="$HOME/.cache/zsh/fnm_env.zsh"
  if [[ ! -f "$_fnm_cache" || "$_fnm_cache" -ot "$FNM_PATH" ]]; then
    fnm env --use-on-cd > "$_fnm_cache"
  fi
  source "$_fnm_cache"
  unset _fnm_cache
fi

# ----- Git aliases (ex oh-my-zsh git plugin) -----
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gam='git am'
alias gap='git apply'
alias gapa='git add --patch'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbl='git blame -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcam='git commit --all --message'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcf='git config --list'
alias gcl='git clone --recurse-submodules'
alias gcm='git checkout $(git_main_branch)'
alias gcmsg='git commit --message'
alias gco='git checkout'
alias gcount='git shortlog --summary --numbered'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit --gpg-sign'
alias gd='git diff'
alias gdca='git diff --cached'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat --patch'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias gm='git merge'
alias gma='git merge --abort'
alias gms='git merge --squash'
alias gmtl='git mergetool --no-prompt'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
alias gpra='git pull --rebase --autostash'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpu='git push upstream'
alias gpv='git push --verbose'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote --verbose'
alias gsb='git status --short --branch'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gss='git status --short'
alias gst='git status'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --patch'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'
alias gt='git tag'
alias gta='git tag --annotate'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias ggpush='git push origin $(git_current_branch)'
alias ggpull='git pull origin $(git_current_branch)'
alias ggfl='git push --force-with-lease origin $(git_current_branch)'

# Fonctions utilitaires git
git_current_branch() { git symbolic-ref --short HEAD 2>/dev/null }
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done
  echo master
}
git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done
  echo develop
}

# ----- Navigation -----
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

# ----- Couleurs fichiers (utilisé par eza) -----
export LS_COLORS="$(vivid generate one-dark)"

# ----- eza (remplaçant moderne de ls) -----
alias ls='eza --color=always --icons'
alias l='eza -lF --icons'
alias la='eza -laF --icons'
alias ll='eza -l --icons'
alias lt='eza --tree --level=2 --icons'
alias ldot='eza -ld .* --icons'

# ----- bat (remplaçant moderne de cat) -----
alias cat='batcat --paging=never'
alias bat='batcat'

# ----- ripgrep & fd -----
alias fd='fdfind'

# ----- Common aliases -----
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias t='tail -f'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| rg'
alias -g L="| less"
alias -g NUL="> /dev/null 2>&1"
alias dud='du -d 1 -h'
alias duf='du -sh *'
alias h='history'
alias hgrep="fc -El 0 | grep"
alias sortnr='sort -n -r'
alias unexport='unset'

# ----- Custom aliases -----
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ----- Environment -----
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUNDLER_EDITOR=code
export EDITOR="code --wait"
export PYTHONBREAKPOINT=ipdb.set_trace

# ----- zoxide (remplacement intelligent de cd, cache) -----
_zoxide_cache="$HOME/.cache/zsh/zoxide_init.zsh"
if [[ ! -f "$_zoxide_cache" || "$_zoxide_cache" -ot "$(which zoxide)" ]]; then
  zoxide init zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"
unset _zoxide_cache

# ----- fzf (recherche floue) -----
source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null

# ----- Starship prompt (cache, doit être à la fin) -----
_starship_cache="$HOME/.cache/zsh/starship_init.zsh"
if [[ ! -f "$_starship_cache" || "$_starship_cache" -ot "$(which starship)" ]]; then
  starship init zsh > "$_starship_cache"
fi
source "$_starship_cache"
unset _starship_cache

# bun completions
[ -s "/home/sarkraf/.bun/_bun" ] && source "/home/sarkraf/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
