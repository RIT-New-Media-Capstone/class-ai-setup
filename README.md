# Class AI coding setup

This sets up [opencode](https://opencode.ai), an AI coding assistant that
runs in your terminal, with the models chosen for this class. It takes about
five minutes.

## What you need

- **Node.js 18 or newer** ([nodejs.org](https://nodejs.org)).
- **opencode**: `npm install -g opencode-ai`
- **Your OpenRouter key** from your instructor. It starts with `sk-or-`.
  Treat it like a password: don't paste it into chats, code or commits.

## Quick start: try it with one command

This downloads this folder and starts opencode with the class setup right
away, without installing opencode (you only need Node.js and Git). Put your
key where it says `sk-or-...`. Git may ask you to sign in to GitHub: this
repository is private to the class organization.

**macOS, Linux, or Git Bash on Windows:**

```bash
git clone https://github.com/RIT-New-Media-Capstone/class-ai-setup && OPENROUTER_API_KEY=sk-or-... OPENCODE_CONFIG="$PWD/class-ai-setup/configs/spaceballs.json" npx -y opencode-ai
```

**Windows PowerShell:**

```bash
git clone https://github.com/RIT-New-Media-Capstone/class-ai-setup; $env:OPENROUTER_API_KEY='sk-or-...'; $env:OPENCODE_CONFIG="$PWD\class-ai-setup\configs\spaceballs.json"; npx -y opencode-ai
```

The key and setup only last for that terminal window. To keep them, run
the installer (**Set it up** below) from the `class-ai-setup` folder.

## Set it up

Get this folder (once), unless the quick start already did:

```bash
git clone https://github.com/RIT-New-Media-Capstone/class-ai-setup
```

```bash
cd class-ai-setup
```

**macOS, Linux, or Git Bash on Windows:**

```bash
./install.sh
```

**Windows PowerShell:**

```bash
powershell -ExecutionPolicy RemoteSigned -File install.ps1
```

The installer asks for your key (it won't show it as you paste) and points
opencode at the class setup in this folder. Then **open a new terminal** and
check it:

```bash
opencode models
```

You should see exactly four models starting with `class/@preset/`. If you
do, you're done.

## Use it

```bash
cd my-project
opencode
```

- Just type what you want; opencode reads and edits files in that folder.
- Press **Tab** to switch to **plan** mode: it thinks a problem through
  without changing any files. Press Tab again to go back and build.
- Type `/models` to see the class models.

## When the class setup changes

Your instructor may switch the models. You don't need to reinstall:

```bash
cd class-ai-setup
git pull
```

## Which setup?

Your instructor will tell you if you need something other than the default.

| Setup | Install with | Models |
| ----- | ------------ | ------ |
| `spaceballs` (default) | `./install.sh` | light, ridiculous, ludicrous, plaid |
| `amurica` | `./install.sh amurica` (PowerShell: `-Setup amurica`) | freedom, liberty, liberty-plus, freedom-max-20x |

Running the installer again with a different setup switches to it.

## If something goes wrong

| You see | What to do |
| ------- | ---------- |
| `opencode models` lists lots of models, not four | Open a new terminal. If it persists, run the installer again. |
| `Preset "..." not found for this user` | Your key is from a different OpenRouter workspace. Ask your instructor for a class key. |
| `401` or `User not found` | Your key is wrong or was disabled. Ask your instructor. |
| `402` / "requires more credits" | Your key's credit limit is used up. Tell your instructor. |
| `opencode: command not found` | Install it: `npm install -g opencode-ai`, then open a new terminal. |

## What the installer changes

Only two settings, nothing else on your computer:

- `OPENCODE_CONFIG`: the path to the setup file in this folder.
- `OPENROUTER_API_KEY`: your key, only if it wasn't set already.

On macOS/Linux/Git Bash they go in your shell profile (`~/.zshrc` or
`~/.bashrc`) between `class opencode setup` markers; on Windows they're user
environment variables. Your own opencode settings are left alone. To undo,
delete those lines (or the two variables).
