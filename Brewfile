# Brewfile — non-nix install path for da's dotfiles
# Generated from hosts/default.nix + hosts/daMacStudio.nix + home/default.nix.
# Apply with: brew bundle --file=./Brewfile

# ── Taps ─────────────────────────────────────────────────────────────
tap "arthur-ficial/tap"
tap "eugene1g/safehouse"
tap "nikitabobko/tap"
tap "osx-cross/arm"
tap "osx-cross/avr"

# ── Work-machine tools (from hosts/*.nix) ────────────────────────────
brew "arthur-ficial/tap/apfel"
brew "eugene1g/safehouse/agent-safehouse"
brew "gemini-cli"
brew "container"
brew "mas"
brew "macos-trash"
brew "mole"
brew "oven-sh/bun/bun"
brew "colima"
brew "devcontainer"
brew "docker"

# ── CLI tools (moved from nixpkgs) ───────────────────────────────────
brew "actionlint"
brew "ast-grep"
brew "docker-compose"
brew "fd"
brew "gh"
brew "go"
brew "jq"
brew "just"
brew "libdvdcss"
brew "markdownlint-cli2"
brew "mediainfo"
brew "mosh"
brew "node@22"
brew "pnpm"
brew "ripgrep"
brew "shellcheck"
brew "shfmt"
brew "television"
brew "tree"
brew "uv"
brew "wget"
brew "zizmor"
brew "zsh-completions"

# ── Shell integrations (replacing home-manager programs.*) ───────────
brew "starship"
brew "zoxide"
brew "fzf"
brew "carapace"
brew "zsh-syntax-highlighting"

# ── Added for the non-nix path ───────────────────────────────────────
# bash: Apple's stock bash 3.2 lacks globstar (used in bashrc)
brew "bash"
# git-lfs: was programs.git.lfs.enable = true under home-manager
brew "git-lfs"
# neovim: was programs.neovim.enable = true under home-manager
brew "neovim"

# ── GUI apps ─────────────────────────────────────────────────────────
cask "aerospace"
cask "claude"
cask "granola"
cask "zed"
cask "lm-studio"
