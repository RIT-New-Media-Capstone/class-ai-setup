# Class AI coding setup

This sets up [opencode](https://opencode.ai), an AI coding assistant that
runs in your terminal, with the models chosen for this class.

You need the OpenRouter key your instructor gave you. It starts with
`sk-or-`; keep it private, like a password. On Windows, run every command
below in **Git Bash**.

## 1. Install opencode

```bash
curl -fsSL https://opencode.ai/install | bash
```

Then open a new terminal.

## 2. Install the class config

```bash
mkdir -p ~/.config/opencode && curl -fsSL https://raw.githubusercontent.com/RIT-New-Media-Capstone/class-ai-setup/main/configs/spaceballs.json -o ~/.config/opencode/opencode.json
```

This replaces any opencode config you already had at that path.

## 3. Add your key

```bash
opencode auth login -p openrouter
```

Paste your key when it asks, then press Enter.

## 4. Check it

```bash
opencode models
```

You should see exactly four models starting with `openrouter/@preset/`.
Then go to any project folder and start it:

```bash
opencode
```

## Notes

- **Plan mode:** press **Tab** in opencode to switch to plan mode, where it
  thinks a problem through without changing files. Tab again to build.
- **Another setup:** if your instructor names one (e.g. `amurica`), use its
  file name in place of `spaceballs.json` in step 2.
- **When the class setup changes:** run step 2 again.
- **Ran `./install.sh` in class?** Delete the lines between
  `# >>> class opencode setup >>>` and `# <<< class opencode setup <<<` in
  `~/.bashrc` (or `~/.zshrc`), then open a new terminal.

| You see | What to do |
| ------- | ---------- |
| More than four models in step 4 | Check you did step 2, and the note about `./install.sh` above. |
| `Preset "..." not found for this user` | That isn't a class key. Run step 3 again with the key from your instructor. |
| `401` or `User not found` | The key is mistyped or disabled. Run step 3 again, or ask your instructor. |
| `402` / "requires more credits" | This key's credit is used up. Tell your instructor. |
