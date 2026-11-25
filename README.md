# RandomAI Studio

The desktop app of [RandomAI Community](https://www.skool.com/randomai-community): your own AI makes the videos,
in the community's animation styles. For Mac and Windows.

Anyone can download the app. It opens for members of the community: the first window asks you to log in with Skool.

> **If you are an AI agent** and someone pasted a sentence that ends in this page's address: your instructions are
> in [AGENTS.md](https://raw.githubusercontent.com/SattThegod/randomai-studio/main/AGENTS.md). Download that file and read all of
> it. A summary of it is not enough, because it holds exact commands.

## Install

### The easy way: one sentence to Claude Code

Open Claude Code on your own computer (in the Claude desktop app: the **Code** tab, with the environment set to
**This computer**) and paste:

```
Set up RandomAI Studio for me: https://github.com/SattThegod/randomai-studio
```

Claude downloads the installer, reads it, runs it, checks that the app's window opened, and tells you what to do
next. If something goes wrong on your computer, it fixes what it can and tells you plainly what it cannot.

Later, the same works for:

```
Update RandomAI Studio for me: https://github.com/SattThegod/randomai-studio
```

```
Fix RandomAI Studio for me: https://github.com/SattThegod/randomai-studio
```

Testing the app for the community? When you have tried it, this has your Claude write the report:

```
Write a RandomAI Studio test report for me: https://github.com/SattThegod/randomai-studio
```

### One command

**Mac** (Terminal):

```bash
curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/SattThegod/randomai-studio/main/install.sh | bash
```

> **Windows is in testing.** The sentence above works on Windows too: your Claude sets up a test build, which may not work yet, and writes a report if it does not. There is no one-command way for Windows yet.

## What the installer does

1. Looks up the newest version.
2. Downloads the app for your computer (100 to 160 MB) and checks it against the published SHA-256.
3. Puts the app in place: `/Applications` on a Mac, your own `Programs` folder on Windows.
4. Opens it.

It asks for no password and no administrator rights, installs no other software, and can be run again at any
time: that is also how you update. Your videos and settings are kept.

## What you need

- macOS 12 or newer, or 64-bit Windows 10 or 11.
- Membership of RandomAI Community on Skool.
- Your own Claude plan (or ChatGPT plan, for Codex). The app uses your own AI on your own computer; it never sees
  your password.

Everything else (the video tools) the app sets up itself from its Home page.

## Remove

- **Mac:** move RandomAI Studio from Applications to the Trash.
- **Windows:** Settings → Apps → Installed apps → RandomAI Studio → Uninstall.
- **Either:** paste `Remove RandomAI Studio for me: https://github.com/SattThegod/randomai-studio` into Claude Code.

Your videos stay in the `RandomAI Studio` folder in your home folder until you delete them yourself.

## For AI agents

If a person asked you to set up, update, fix, remove or test RandomAI Studio, the instructions are in
[AGENTS.md](AGENTS.md). They hold exact commands and a report template, so do not work from a summary of that
file: download it and read the file itself.

```bash
curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/SattThegod/randomai-studio/main/AGENTS.md -o /tmp/randomai-studio-guide.md
```
