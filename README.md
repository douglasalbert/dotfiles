# dotfiles

Personal macOS dotfiles managed declaratively with **nix-darwin** (system-level config) and **home-manager** (user-level packages and dotfiles). Targets Apple Silicon (aarch64-darwin).

## Bootstrap

### Prerequisites

1. **Install Xcode Command Line Tools** (required for git and compilers):

   ```sh
   xcode-select --install
   ```

2. **Install Determinate Nix** (recommended over the official installer — handles macOS upgrades gracefully):

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   Open a new terminal to pick up the Nix environment.

3. **Install Homebrew** (nix-darwin manages casks/brews but Homebrew itself must be installed first):

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

### First-time install

Clone the repo and apply:

```sh
git clone https://github.com/douglasalbert/dotfiles ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix run nix-darwin -- switch --flake .
```

## Usage

**Apply changes:**

```sh
darwin-rebuild switch --flake .
```

**Validate flake syntax without applying:**

```sh
nix flake check
```

**Update all flake inputs (nixpkgs, nix-darwin, home-manager):**

```sh
nix flake update
```

## Machine-specific secrets

Sensitive config (API keys, work credentials, etc.) goes in local files that are sourced at shell startup but never committed:

| Shell | File |
|-------|------|
| Bash  | `~/.bash_profile.local` |
| Zsh   | `~/.profile.local` |
