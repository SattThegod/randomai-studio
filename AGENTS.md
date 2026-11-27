# Setting up RandomAI Studio: a guide for Claude Code

You are reading this because someone pasted one of these sentences into Claude Code:

- **Set up RandomAI Studio for me: https://github.com/SattThegod/randomai-studio**
- **Update RandomAI Studio for me: https://github.com/SattThegod/randomai-studio**
- **Fix RandomAI Studio for me: https://github.com/SattThegod/randomai-studio**
- **Remove RandomAI Studio for me: https://github.com/SattThegod/randomai-studio**
- **Write a RandomAI Studio test report for me: https://github.com/SattThegod/randomai-studio**

RandomAI Studio is a desktop app (Mac and Windows) for members of RandomAI Community on Skool. In it, the member's
own AI makes videos. Your job here is small: get the app onto this person's computer, make sure its window really
opened, and tell them the one thing they do next. For the last sentence the job is different: see "Test report".
Most members are not programmers. Write to them in short, plain
sentences, and never ask them to type a command.

**Read this file itself, not a summary of it.** Some page readers hand you a summary or a paraphrase. The commands
and the report template below are meant to be used exactly, so if that is what you have, download the file and
read it:

```bash
curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/SattThegod/randomai-studio/main/AGENTS.md -o /tmp/randomai-studio-guide.md
```

(In PowerShell: `curl.exe` and `-o "$env:TEMP\randomai-studio-guide.md"`.)

## Rules that never bend

1. **Only on the person's own computer.** If you are running in a cloud or remote session (your files are not the
   person's own disk), stop and say so: nothing installed there reaches them. Tell them to open Claude Code on
   their computer (in the Claude desktop app: the Code tab, with the environment set to "This computer") and paste
   the sentence again.
2. **Read before you run.** Download the install script to a file, read all of it, and only then run it. Run
   nothing that does not come from `https://github.com/SattThegod/randomai-studio` or its releases.
3. **Never weaken the computer's protection.** Do not turn off or pause an antivirus, Gatekeeper, SmartScreen,
   Smart App Control or a firewall, and do not tell the person to. If one of them blocks the app, say what it
   blocked and write the report at the end of this guide.
4. **No secrets.** Do not open, print or copy passwords, keys, tokens, cookies or the contents of the person's
   files. The app needs none of them to install.
5. **No administrator rights.** The install needs none. If something asks for a password or for administrator
   rights, stop and tell the person what asked and why, before anything else.
6. **Touch only the app's own places** (listed under "Where things are"). Never delete the person's videos.
7. **Do not close the app without asking.** If it is open, the person may have a video being made. Ask first.

## Set up

### 1. Look at the computer

**Windows is in testing.** If this is a Windows computer: the Windows app is a test build that may not work yet. Say so in one sentence and ask the person whether to go on. If they agree, download `https://raw.githubusercontent.com/SattThegod/randomai-studio/main/WINDOWS-TEST.md` to a file (`curl.exe -fsSL --connect-timeout 10 <that address> -o <a file in the temp folder>`), read the file itself and not a summary of it, and follow it for Set up, Update and Fix. This guide has no Windows install steps. Its rules, "Test report", "Remove" and "Where things are" apply on Windows as written.

Find out which system this is (macOS or Windows), its version and its processor. The app needs macOS 12 or newer,
or 64-bit Windows 10 or 11. If the computer is older, say so plainly and stop.

### 2. Get the install script and read it

**Mac**

```bash
curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/SattThegod/randomai-studio/main/install.sh -o /tmp/randomai-studio-install.sh
```

Read the whole file. It should do exactly four things: look up the newest version, download one package and check
its SHA-256, put the app in place, open it. If it does anything else, do not run it: tell the person and write the
report.

### 3. Run it

**Mac**

```bash
bash /tmp/randomai-studio-install.sh
```

The download is 100 to 160 MB, so allow a few minutes on a slow connection.

Read every line the script prints. Success ends with a line that starts with `✓` (Mac) or `[ok]` (Windows) and
says "is installed in" or "is already installed in". A line that starts with `✗` or `[x]` is a failure: find it in
"Known problems" below.

### 4. Make sure the window is really there

The app writes a small status file when it starts:

- Mac: `~/Library/Application Support/RandomAI Studio/status.json`
- Windows: `%APPDATA%\RandomAI Studio\status.json`

It looks like `{"app":"RandomAI Studio","version":"0.1.3","pid":1234,"window":"gate","at":1795430000000}`
(`at` is the time in milliseconds). On a Mac, read it with:

```bash
cat "$HOME/Library/Application Support/RandomAI Studio/status.json"
```

Wait up to 60 seconds for `window` to be `"gate"` (the Skool login window is on screen) or `"main"` (the person was
already logged in), with `at` no older than a few minutes. `"starting"` means it is still coming up: wait.

If the file never appears, or `window` stays `"starting"` or `"closed"`: open the app once yourself, wait again,
then read the end of the log and look in "Known problems". On a Mac:

```bash
open -a "RandomAI Studio"
```

```bash
tail -n 60 "$HOME/Library/Application Support/RandomAI Studio/logs/main.log"
```

On Windows the same three commands are in step 3 of `WINDOWS-TEST.md`, written for the shell you have there.

### 5. Tell the person what to do next

Say this, in your own words:

> RandomAI Studio is installed and open. In its window, press **Log in with Skool** and sign in with the account
> you use for RandomAI Community. After that, the Home page walks you through the rest: it checks your tools,
> connects your Claude, and installs your first style.

Do not try to log in for them, and do not open Skool yourself.

If the person says they are testing the app for the community, add one line: when they have gone through the
app, they come back and paste the "Write a RandomAI Studio test report for me" sentence.

## Update

The same script updates the app. If the app is open, ask the person first: "RandomAI Studio is open. Is it making a
video right now? I need to close it to update." Only after they say it can be closed, run the script with
`RAS_QUIT_APP=1`:

- Mac: `RAS_QUIT_APP=1 bash /tmp/randomai-studio-install.sh`
- Windows: `$env:RAS_QUIT_APP = "1"`, then the command from step 3

Their videos, settings and Skool login are kept: they live outside the app's own folder.

## Fix

1. Read the last 60 lines of the log and the status file.
2. Run the script with `RAS_FORCE=1` (and `RAS_QUIT_APP=1`, after asking as above). It downloads the app again and
   replaces the copy on the computer.
3. Check the window as in step 4.
4. If it still does not come up, write the report.

Problems inside the app (a style that will not install, Claude not connected, a preview that does not build) are
not install problems. The app's Home page has a system check that repairs tools; send the person there.

## Remove

Ask first. Then:

- Mac: quit the app, and move `/Applications/RandomAI Studio.app` (or the copy in `~/Applications`) to the Trash.
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -Command '& "$env:LOCALAPPDATA\Programs\RandomAI Studio\uninstall.ps1"'`
  (the single quotes matter when your shell is Bash).

Leave the person's videos (the `RandomAI Studio` folder in their home folder) and the app's data folder alone
unless they ask in so many words to delete them too.

## Test report

The person is one of the community's early testers. They have tried the app and want to send feedback. Your job
is to look, ask and write. **Change nothing.** Do not install, update, repair or remove anything while you write
a report, even when you can see what is wrong: the report is how it gets fixed for everyone.

### 1. Look

Read these and nothing else in the app's data folder (that folder also holds the person's logins):

- the status file and `logs/main.log` (see "Where things are"), and `logs/main.old.log` only if the log is shorter
  than 150 lines;
- whether the app is installed, and which version;
- the system: its version, the processor, the memory and the free disk space (on a Mac: `sw_vers`, `uname -m`,
  `sysctl -n hw.memsize`, `df -h /`). On Windows also the name of the active antivirus and whether Smart App
  Control is on, off or evaluating: the two commands are in step 1 of `WINDOWS-TEST.md`;
- Claude Code: its version and where it is, if a `claude` command is on this computer.

In the log, every start of the app is a line with `start <version> on <system>`. Work from the last three starts.
The lines worth quoting contain `failed`, `error`, `could not`, `crash:`, `MISSING`, `refused` or a mark `✗`.

Every few minutes the app writes a line about its membership check (`skool check ...`, `skool: checked ...`).
Leave those lines out everywhere, also when you count "the last 30 lines": they say nothing about the test. Keep
one only if it ends in something other than `member`.

Do not say whether the app is up to date from what the repository's page shows. If it matters: on a Mac the
newest released version is the first line of `https://github.com/SattThegod/randomai-studio/releases/latest/download/checksums.txt`;
on Windows it is the version named at the top of `WINDOWS-TEST.md`.

### 2. Ask

Ask these five together, and say that short answers are fine:

1. How far did you get? Installed · logged in with Skool · tools ready · Claude connected · a style installed ·
   a first project with a preview · a change through the chat · a video exported · closed and opened again.
2. Where did it go wrong, if anywhere, and what was on the screen?
3. Did macOS, Windows or an antivirus show a message? What did it say?
4. Was anything slow, confusing or ugly?
5. What is the one thing you would change?

Then ask whether they recorded their screen.

### 3. Write

Fill in the report below. Quote log lines exactly, with these things taken out: replace the home folder's name
with `~` in every path, and leave out email addresses, user and computer names, passwords, keys, tokens, cookies
and the contents of the person's own files.

```
RandomAI Studio test report
App: <version> · installed with <the sentence | the Terminal command> · <installed | not installed>
System: <macOS 15.2, Apple chip, 16 GB memory, 80 GB free | Windows 11 23H2 (build 22631), 64-bit Intel, 16 GB memory, 80 GB free>
Protection: <on Windows: antivirus name · Smart App Control on / off / evaluating | on a Mac: leave this line out>
Claude Code: <version, and where it is | no claude command found>

How far it got:
 1 Install                  <worked | failed | not tried>  <one line>
 2 Log in with Skool        <...>
 3 Tools                    <...>  <which ones the app installed, which were already there>
 4 Connect Claude           <...>
 5 Install a style          <...>  <which style, how long>
 6 First project, preview   <...>
 7 A change through chat    <...>
 8 Export                   <...>
 9 Close and open again     <...>

What went wrong, in the person's words:
<...>

What the log says about it (exact lines, at most 25):
<...>

Messages from macOS, Windows or an antivirus (exact words):
<...>

Slow, confusing or ugly:
<...>

The one thing to change:
<...>

Screen recording: <yes | no>

The last 30 lines of the log, without the membership-check lines:
<...>
```

### 4. Hand it over

Give the report in one block the person can copy. Ask them to read it, then post it under the early testers post
in RandomAI Community, together with the link to their recording if they made one.

## Where things are

| | Mac | Windows |
|---|---|---|
| The app | `/Applications/RandomAI Studio.app` (or `~/Applications`) | `%LOCALAPPDATA%\Programs\RandomAI Studio\` |
| Settings, the log, the status file | `~/Library/Application Support/RandomAI Studio/` | `%APPDATA%\RandomAI Studio\` |
| The person's videos and styles | `~/RandomAI Studio/` | `%USERPROFILE%\RandomAI Studio\` |

## Known problems

| What you see | What it means | What to do |
|---|---|---|
| `This installer is for a Mac` / `for Windows` | The wrong script for this system | Use the other one |
| `needs macOS 12 or newer` / `needs Windows 10 or 11` / `needs 64-bit Windows` | The computer is too old | Tell the person. There is no workaround |
| A download stands still for many seconds before anything is printed | One of GitHub's server addresses cannot be reached from this network, and the download tool waits on it before it tries the next one | Nothing is broken. The install script moves on by itself after a few seconds. For a `curl` you run yourself, add `--connect-timeout 10`, as in the command above |
| `That did not get through at once. Trying again, with more patience…` | The quick first try failed; the script is trying again with longer waits | Let it run. It ends with `✓` or with one of the lines below |
| `The download address could not be reached` or `The download did not finish` | No connection, or GitHub is blocked on this network | Check the connection and run it once more. If GitHub is blocked (an office or school network), say so |
| `does not match the published one` | The file arrived damaged or changed | Run it once more. If it happens twice, stop and write the report. Never install a file that failed this check |
| `RandomAI Studio is open` | The app is running | Ask the person, then use `RAS_QUIT_APP=1` (see Update) |
| `cannot be written to` / `could not be replaced` | No right to write in that folder, or the app is still open | Close the app. On a Mac the script falls back to `~/Applications` by itself |
| Mac: "RandomAI Studio is damaged" or "cannot be opened" | The download mark is still on the app (it was copied by hand, not by the script) | `xattr -dr com.apple.quarantine "/Applications/RandomAI Studio.app"`, then open it again. This removes a mark from this one app; it does not switch Gatekeeper off |
| Windows: `The package does not hold RandomAI Studio.exe`, or the program disappears after install | An antivirus removed it | Do not disable the antivirus. Tell the person which program blocked it; they can allow RandomAI Studio there themselves. Then run the script again |
| Windows: "Smart App Control blocked an app that may be unsafe" | Windows refuses apps without a publisher's signature | It cannot be allowed for one app. Write the report |
| The status file says `gate` but the person sees no window | The window is behind others or on another screen | Mac: `open -a "RandomAI Studio"`. Windows: start the program again; it brings its window forward |
| Windows: in the app's chat the AI says it cannot run commands ("This tool is not available inside RandomAI Studio") | Version 0.1.4 refused PowerShell, which Claude Code uses for commands on a computer without Git for Windows | Update: the test build named in `WINDOWS-TEST.md` allows it |
| In the app, "Set up transcription" ends with "Transcription is set up" but the step on Home still offers **Set up** | Versions up to 0.1.5 looked for the speech model in the wrong folder. Transcription itself works | Update: from version 0.1.6 the step shows as done by itself. No new set-up is needed |
| The log ends with a line containing `failed to start` | Something inside the app did not start | Run Fix once. Then the report |

## The report, when you cannot fix it

Give the person this, filled in, to post in the community's support posts. Keep it short and leave out anything
private: no email address, no user name, no passwords, keys or tokens, no file contents.

```
RandomAI Studio install report
System: <macOS 15.2 on Apple chip | Windows 11 23H2, 64-bit>
What I ran: <set up | update | fix>
Where it stopped: <step number and one sentence>
The lines the installer printed at the end:
<up to 10 lines>
The last lines of the app's log, if there is one:
<up to 15 lines, with the home folder's name replaced by ~>
What protection software, if any, showed a message: <name and its message>
```
