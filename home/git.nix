{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # SCons
      ".sconsign.dblite"

      # Node
      "logs"
      "*.log"
      "pids"
      "*.pid"
      "*.seed"
      "lib-cov"
      "coverage"
      ".grunt"
      ".lock-wscript"
      "build/Release"
      "node_modules"

      # Windows
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"
      "$RECYCLE.BIN/"
      "*.cab"
      "*.msi"
      "*.msm"
      "*.msp"
      "*.lnk"

      # Linux
      "*~"
      ".directory"
      ".Trash-*"

      # Sass
      ".sass-cache"
      "*.css.map"

      # JetBrains
      "*.iml"
      ".idea/"
      "*.ipr"
      "*.iws"
      ".idea_modules/"
      "atlassian-ide-plugin.xml"
      "com_crashlytics_export_strings.xml"
      "crashlytics.properties"
      "crashlytics-build.properties"
      "/out/"

      # Sublime Text
      "*.tmlanguage.cache"
      "*.tmPreferences.cache"
      "*.stTheme.cache"
      "*.sublime-workspace"
      "sftp-config.json"

      # Bower
      "bower_components"
      ".bower-cache"
      ".bower-registry"
      ".bower-tmp"

      # Grunt
      "dist/"
      ".tmp/"

      # Vim
      "[._]*.s[a-w][a-z]"
      "[._]s[a-w][a-z]"
      "*.un~"
      "Session.vim"
      ".netrwhist"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      "*.so"
      ".Python"
      "env/"
      "build/"
      "develop-eggs/"
      "downloads/"
      "eggs/"
      ".eggs/"
      "lib/"
      "lib64/"
      "parts/"
      "sdist/"
      "var/"
      "*.egg-info/"
      ".installed.cfg"
      "*.egg"
      "*.manifest"
      "*.spec"
      "pip-log.txt"
      "pip-delete-this-directory.txt"
      "htmlcov/"
      ".tox/"
      ".coverage"
      ".coverage.*"
      ".cache"
      "nosetests.xml"
      "coverage.xml"
      "*,cover"
      ".hypothesis/"
      "*.mo"
      "*.pot"
      "local_settings.py"
      "instance/"
      ".scrapy"
      "docs/_build/"
      "target/"
      ".ipynb_checkpoints"
      ".python-version"
      "celerybeat-schedule"
      ".env"
      "venv/"
      "ENV/"
      ".spyderproject"

      # VS Code
      ".vscode/*"
      "!.vscode/settings.json"
      "!.vscode/tasks.json"
      "!.vscode/launch.json"
      "!.vscode/extensions.json"
    ];

    settings = {
      alias = {
        tree = ''log --graph --full-history --all --color --date=short --pretty=format:"%Cred%x09%h %Creset%ad%Cblue%d %Creset %s %C(bold)(%an)%Creset"'';
        graph = ''log --graph --full-history --all --color --date=short --pretty=format:"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n"'';
        up = "!git fetch && git rebase --autostash FETCH_HEAD";
        l = "log --pretty=oneline --graph --abbrev-commit";
        ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
        a = "add";
        ap = "add -p";
        c = "commit --verbose";
        ca = "commit -a --verbose";
        cm = "commit -m";
        cam = "commit -a -m";
        m = "commit --amend --verbose";
        d = "diff";
        ds = "diff --stat";
        dc = "diff --cached";
        s = "status";
        co = "checkout";
        cob = "checkout -b";
        b = ''!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--' '';
        r = "reset";
        r1 = "reset HEAD^";
        r2 = "reset HEAD^^";
        rh = "reset --hard";
        rh1 = "reset HEAD^ --hard";
        rh2 = "reset HEAD^^ --hard";
        sl = "stash list";
        sa = "stash apply";
        ss = "stash save";
        p = ''!"git pull; git submodule foreach git pull origin master"'';
        pr = ''!"pr() { git fetch origin pull/$1/head:pr-$1; git checkout pr-$1; }; pr"'';
        la = ''!git config -l | grep alias | cut -c 7-'';
      };
      apply.whitespace = "fix";
      core = {
        autocrlf = "input";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
        editor = "vim";
      };
      diff.renames = "copies";
      fetch.prune = true;
      help.autocorrect = 1;
      merge = {
        log = true;
        ff = "only";
      };
      pull.rebase = true;
      push.default = "current";
      status = {
        short = true;
        branch = true;
      };
      url = {
        "git@github.com:" = {
          pushInsteadOf = [
            "https://github.com/"
            "github:"
            "git://github.com/"
          ];
        };
        "git://github.com/" = {
          insteadOf = "github:";
        };
        "git@gist.github.com:" = {
          insteadOf = "gst:";
          pushInsteadOf = [
            "gist:"
            "git://gist.github.com/"
          ];
        };
        "git://gist.github.com/" = {
          insteadOf = "gist:";
        };
      };
      rerere.enabled = true;
    };
  };
}
