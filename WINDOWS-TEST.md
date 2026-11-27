# RandomAI Studio on Windows: the test guide, for Claude Code

You are here because someone on a Windows computer pasted a RandomAI Studio sentence into Claude Code, and the
main guide ([AGENTS.md](https://raw.githubusercontent.com/SattThegod/randomai-studio/main/AGENTS.md)) sent you on. They are helping
RandomAI Community test the app on Windows.

**The Windows app is a test build (version 0.1.6, test "windows-test-4"). It has run on a few testers' Windows
computers, and never on one its maker could watch.** Expect something to go wrong. Your job is to get the test build onto this
computer, see that its window opened, tell the person what to try, and bring back exactly what happened. A clear
account of a failure is a good result.

Write to the person in short, plain sentences. Never ask them to type a command.

## Rules that never bend

1. **Only on the person's own computer.** In a cloud or remote session, stop and tell them to open Claude Code on
   their Windows PC (the Code tab, set to "This computer") and paste the sentence again.
2. **Read before you run.** Read all of a script before you run it. Run nothing that does not come from
   `https://github.com/SattThegod/randomai-studio` or from this guide.
3. **Never weaken the computer's protection.** Do not turn off or pause an antivirus, SmartScreen, Smart App
   Control or a firewall, and do not tell the person to. If one of them steps in, write down its exact words.
   That is a result of the test.
4. **No secrets.** Do not open, print or copy passwords, keys, tokens, cookies or the person's own files.
5. **No administrator rights.** The install needs none. If anything asks for them, stop and write it down.
6. **Touch only the app's own places:** `%LOCALAPPDATA%\Programs\RandomAI Studio\`, `%APPDATA%\RandomAI Studio\`,
   `%USERPROFILE%\RandomAI Studio\` and files you made yourself in `%TEMP%`.
7. **Do not repair the app from the inside.** Do not edit its files and do not install its tools for it. If
   something inside the app fails, note it. A workaround hides the fault this test is meant to find.
8. **Do not close the app without asking.** It may be making a video.

## How to run commands here

Most mistakes on Windows are made in this section, not in the app. Read it before the first command.

- **Your shell is probably Git Bash.** To be sure, run `uname -s`: an answer that begins with `MINGW` or `MSYS` means
  Bash; "not recognized" means PowerShell. In Bash, a `$env:NAME` inside double quotes is emptied before
  PowerShell ever sees it. So every PowerShell command in this guide is written inside **single quotes**. Keep
  them.
- **If your shell is PowerShell and not Bash**, run the text inside the single quotes by itself, without
  `powershell -NoProfile -Command '...'` around it: PowerShell loses the inner double quotes when it hands a command
  to another PowerShell. The `curl.exe` line and the `-File` lines work in both shells as they are. A switch is set
  first in the same command: `$env:RAS_QUIT_APP='1'; powershell -NoProfile -ExecutionPolicy Bypass -File "<TEMP>/randomai-studio-install.ps1"`.
- **Find the folders once, then write them out in full.** Run this first:

  ```bash
  powershell -NoProfile -Command 'Write-Output $env:TEMP; Write-Output $env:LOCALAPPDATA; Write-Output $env:APPDATA; Write-Output $env:USERPROFILE'
  ```

  Below, `<TEMP>` stands for the first line it prints, written with forward slashes, for example
  `C:/Users/name/AppData/Local/Temp`. Windows reads forward slashes, and Bash leaves them alone.
- **Give the install ten minutes.** Run the install command with a time limit of 600000 ms, or in the background,
  and wait for it to end. The download is about 160 MB. A command that is cut off halfway leaves the install half
  done (the script repairs that on its next run).
- **Never start the app's `.exe` straight from Bash.** It keeps your command open until the app closes. Use the
  `Start-Process` line in step 3.
- **A switch goes in the same command as the script.** In Bash, `RAS_FORCE=1` and `RAS_QUIT_APP=1` are written in
  front, as in `RAS_FORCE=1 powershell ...`. A switch set in one command is gone in the next.

## 1. Look at the computer

```bash
powershell -NoProfile -Command '$o = Get-CimInstance Win32_OperatingSystem; Write-Output ($o.Caption + ", version " + $o.Version + ", " + $o.OSArchitecture); Write-Output ("processor: " + $env:PROCESSOR_ARCHITECTURE); Write-Output ("memory: " + [math]::Round($o.TotalVisibleMemorySize / 1MB) + " GB"); Write-Output ("free on the system disk: " + [math]::Round((Get-PSDrive -Name $env:SystemDrive.TrimEnd(":")).Free / 1GB) + " GB"); Write-Output ("language mode: " + $ExecutionContext.SessionState.LanguageMode)'
```

```bash
powershell -NoProfile -Command 'Write-Output ("antivirus: " + ((Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction SilentlyContinue).displayName -join ", ")); $p = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -ErrorAction SilentlyContinue; Write-Output ("Smart App Control: " + $p.VerifiedAndReputablePolicyState + "  (0 off, 1 on, 2 evaluating, empty: not there)")'
```

Also note `git --version`. Claude Code runs its commands through Git for Windows, and so does the app's AI.

The app needs 64-bit Windows 10 or 11 (an ARM computer needs Windows 11). If the computer is older, say so and
stop.

If Smart App Control is **on** (1), tell the person before you go on: "Windows' Smart App Control is on. It refuses
apps without a publisher's signature, and this test build has none yet, so Windows will probably block it. We can
still try, and what Windows says goes into the report." Then go on if they agree. Do not switch it off.

## 2. Install

### 2a. The install script

Get it, read all of it, then run it.

```bash
curl.exe -fsSL --connect-timeout 10 --retry 2 -o "<TEMP>/randomai-studio-install.ps1" "https://github.com/SattThegod/randomai-studio/releases/download/windows-test-4/install.ps1"
```

It should look up a version, download one package and check its SHA-256, put the app into
`%LOCALAPPDATA%\Programs\RandomAI Studio`, make shortcuts and an "Installed apps" entry, and open the app. If it
does anything else, do not run it, and say so in the report.

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File "<TEMP>/randomai-studio-install.ps1"
```

`-ExecutionPolicy Bypass` applies to this one run and changes no setting.

It worked when the exit code is 0 **and** a line reads `[ok] RandomAI Studio ... is installed in ...` (or
`... is already installed in ...`). A line that starts with `[x]`, or any other exit code, is a failure. Keep
everything it printed, word for word: `What happened:` in an `[x]` line carries the real reason.

If PowerShell itself reports an error in the script (red text about a parser or a syntax error), copy that text
exactly. Nothing is more useful to bring back.

### 2b. If the script fails: the same steps by hand

First write down how the script failed. Then save the text below as `<TEMP>/ras-manual.ps1` with your file tool
(plain ASCII, nothing added), read it once more, and run it with the same ten-minute limit:

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File "<TEMP>/ras-manual.ps1"
```

```powershell
$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'
$Base = 'https://github.com/SattThegod/randomai-studio/releases/download/windows-test-4'
$Name = 'RandomAI Studio'; $Exe = 'RandomAI Studio.exe'
$Dest = Join-Path $env:LOCALAPPDATA "Programs\$Name"
$New = "$Dest.new"; $Old = "$Dest.old"
$Work = Join-Path $env:TEMP 'ras-manual'
if (Test-Path -LiteralPath $Work) { Remove-Item -LiteralPath $Work -Recurse -Force }
New-Item -ItemType Directory -Path $Work | Out-Null
$curl = Join-Path $env:SystemRoot 'System32\curl.exe'
$tar = Join-Path $env:SystemRoot 'System32\tar.exe'

# 1. what to download
& $curl -fsSL --connect-timeout 10 --retry 3 -o (Join-Path $Work 'checksums.txt') "$Base/checksums.txt"
if ($LASTEXITCODE -ne 0) { throw "checksums.txt: curl exit code $LASTEXITCODE" }
$version = $null; $pkg = $null
foreach ($l in Get-Content -LiteralPath (Join-Path $Work 'checksums.txt')) {
    $p = $l.Trim() -split '\s+'
    if ($p.Count -eq 2 -and $p[0] -eq 'version') { $version = $p[1] }
    elseif ($p.Count -eq 3 -and $p[2] -match '^RandomAI-Studio-.*-win-x64\.zip$') { $pkg = $p }
}
if (-not $version -or -not $pkg) { throw 'checksums.txt names no Windows package' }
$zip = Join-Path $Work $pkg[2]

# 2. download and check
& $curl -fsSL --connect-timeout 10 --retry 3 -o $zip "$Base/$($pkg[2])"
if ($LASTEXITCODE -ne 0) { throw "package: curl exit code $LASTEXITCODE" }
$sha = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLower()
$size = (Get-Item -LiteralPath $zip).Length
if ($sha -ne $pkg[0].ToLower() -or $size -ne [int64]$pkg[1]) { throw "MISMATCH: got $sha / $size bytes. Do not install." }
"checked $sha"

# 3. never over a running app (ask the person before anything is closed)
if (Get-Process -Name $Name -ErrorAction SilentlyContinue) { throw 'RandomAI Studio is running. Ask the person to close it, then run this again.' }

# 4. unpack beside the final place
foreach ($d in @($New, $Old)) { if (Test-Path -LiteralPath $d) { Remove-Item -LiteralPath $d -Recurse -Force } }
New-Item -ItemType Directory -Path $New -Force | Out-Null
& $tar -xf $zip -C $New
if ($LASTEXITCODE -ne 0) { "tar exit code $LASTEXITCODE; trying Expand-Archive"; Expand-Archive -LiteralPath $zip -DestinationPath $New -Force }
if (-not (Test-Path -LiteralPath (Join-Path $New $Exe))) { throw "$Exe is missing after unpacking (an antivirus may have removed it)" }
Set-Content -LiteralPath (Join-Path $New 'version.txt') -Value "$version $sha" -Encoding ASCII

# 5. swap, trying again when a scanner still holds the fresh files
function Ren($from, $leaf) { for ($i = 1; $i -le 10; $i++) { try { Rename-Item -LiteralPath $from -NewName $leaf; return } catch { if ($i -eq 10) { throw }; Start-Sleep -Seconds 2 } } }
if (Test-Path -LiteralPath $Dest) { Ren $Dest (Split-Path -Leaf $Old) }
try { Ren $New (Split-Path -Leaf $Dest) } catch { if (Test-Path -LiteralPath $Old) { Ren $Old (Split-Path -Leaf $Dest) }; throw }
if (Test-Path -LiteralPath $Old) { Remove-Item -LiteralPath $Old -Recurse -Force -ErrorAction SilentlyContinue }
"installed $version in $Dest"

# 6. a Start menu shortcut (a failure here is not a failed install)
try {
    $lnk = Join-Path ([Environment]::GetFolderPath('Programs')) "$Name.lnk"
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
    $s.TargetPath = Join-Path $Dest $Exe; $s.WorkingDirectory = $Dest; $s.Save(); "shortcut $lnk"
} catch { "shortcut not made: $($_.Exception.Message)" }

# 7. start it, and say what Windows answered
try { Start-Process -FilePath (Join-Path $Dest $Exe) -WorkingDirectory $Dest; 'started' }
catch { "Windows did not start it: $($_.Exception.Message)" }
Remove-Item -LiteralPath $Work -Recurse -Force -ErrorAction SilentlyContinue
```

A `MISMATCH`, a `tar` error or `Windows did not start it` goes into the report word for word. If this fails too,
stop installing and write the report: the two failures together are what the maker needs.

## 3. Did the window open?

The app writes a small status file when it starts. Read it:

```bash
powershell -NoProfile -Command 'Get-Content "$env:APPDATA\RandomAI Studio\status.json"'
```

It looks like `{"app":"RandomAI Studio","version":"0.1.6","pid":1234,"window":"gate","at":...}`. Wait up to
60 seconds for `window` to be `"gate"` (the Skool login window is on screen) or `"main"`. `"starting"` means it is
still coming up.

If the file never appears, or `window` stays `"starting"` or `"closed"`, open the app once yourself and wait again:

```bash
powershell -NoProfile -Command 'Start-Process -FilePath "$env:LOCALAPPDATA\Programs\RandomAI Studio\RandomAI Studio.exe" -WorkingDirectory "$env:LOCALAPPDATA\Programs\RandomAI Studio"'
```

Then read the end of the app's log. Lines that begin with `crash:` say what broke:

```bash
powershell -NoProfile -Command 'Get-Content "$env:APPDATA\RandomAI Studio\logs\main.log" -Tail 60'
```

Ask the person: "Do you see the RandomAI Studio window? Does it look right: text readable, nothing black, white
or cut off?" Note their answer in their own words. If a window from Windows or from an antivirus appeared, ask
what it said.

## 4. Tell the person what to try

Say this, in your own words:

> RandomAI Studio is installed and open. This is what to try, in order. If a step fails, do not fight it: note
> what you saw and go on to the next one if you can.
>
> 1. Press **Log in with Skool** and sign in with the account you use for RandomAI Community.
> 2. On Home, **Check your tools**: let the app install what is missing.
> 3. **Connect Claude**: press Sign in and approve it in your browser.
> 4. **Install a style**: choose "Vox-style Motion Graphics with Claude".
> 5. **New project** in that style, about anything. Wait for the preview.
> 6. In the chat, ask for one change, for example "Change the headline to: Hello from Windows".
> 7. **Export**, then **Draft**.
> 8. Close the app and open it again from the Start menu.
>
> When you are done, or stuck, come back here and say so. I will write the report for you to post.

Do not log in for them and do not open Skool yourself.

When they come back, follow **"Test report"** in the main guide
(`https://raw.githubusercontent.com/SattThegod/randomai-studio/main/AGENTS.md`). Add to the report what this guide made you note:
the language mode, the antivirus, Smart App Control, whether the script or the by-hand steps did the install, and
everything the install printed if it failed.

## Update and repair

- **Update:** run the script from step 2a again. It replaces the app when the test build is newer than the copy
  on the computer. If the app is open, ask first: "RandomAI Studio is open. Is it making a video? I need to close
  it, and a video in the making would be lost." After a yes: `RAS_QUIT_APP=1 powershell ...` with the same line.
- **Repair:** read the last 60 lines of the log, then run the script with `RAS_FORCE=1` in front (and
  `RAS_QUIT_APP=1`, after asking). Check the window as in step 3. If it still does not come up, write the report.
- The person's videos, settings and Skool login are kept: they live outside the app's own folder.

## Known problems

| What you see | What it means | What to do |
|---|---|---|
| Red text from PowerShell about the script itself | A mistake in the script | Copy it exactly. Then step 2b |
| `-File` says the file does not exist, with a path that begins with `:` | A `$env:` name was inside double quotes in Bash | Write the folder out in full, as in "How to run commands here" |
| `running scripts is disabled on this system` although Bypass was given | The computer's owner (a company or school) set the rule | Stop. Write the report: this computer does not allow it |
| `[x] The download address could not be reached` or `The download did not finish` | No connection, GitHub blocked, or an old security setting | Read the reason after `What happened:`. Run it once more. Then step 2b, then the report |
| `does not match the published one` or `MISMATCH` | The file arrived damaged or changed | Run it once more. Twice: stop and write the report. Never install a file that failed this check |
| `could not be unpacked`, `does not hold RandomAI Studio.exe`, or the program is gone after the install | A protection program removed it | Do not disable it. Note its name and its message. Write the report |
| `Windows did not start it`, or a window "Smart App Control blocked an app that may be unsafe" | Windows refuses apps without a publisher's signature | It cannot be allowed for one app. Write the report |
| A blue window "Windows protected your PC" | SmartScreen. Not expected here: files fetched this way carry no download mark | Note its words. What to press is the person's own decision |
| `RandomAI Studio is open` | The app is running | Ask, then `RAS_QUIT_APP=1` |
| `The older copy could not be replaced` | A file of the app is still open, often a File Explorer window on its folder | Close the app and that window. Run it again |
| The status file says `gate` or `main` but the person sees no window | The window is behind others or on another screen | Run the `Start-Process` line of step 3: the app brings its window forward |
| The window is all white or all black | The app started but did not draw | Note it. Send the last 60 lines of the log |
| The log has lines that begin with `crash:` | Something inside the app broke | Quote them in the report |
| In the app's chat the AI says it cannot run commands: "This tool is not available inside RandomAI Studio" | Version 0.1.4 refused PowerShell, which Claude Code uses for commands on a computer without Git for Windows | Update (above): from version 0.1.5 the app allows it. If it still happens after the update, write the report and quote the log lines that contain `refused the tool` |
| In the app, "Set up transcription" ends with "Transcription is set up" but the step on Home still offers **Set up** | Versions up to 0.1.5 looked for the speech model in the wrong folder. Transcription itself works | Update (above): from version 0.1.6 the step shows as done by itself. No new set-up is needed |

## Remove

Ask first. Then:

```bash
powershell -NoProfile -ExecutionPolicy Bypass -Command '& "$env:LOCALAPPDATA\Programs\RandomAI Studio\uninstall.ps1"'
```

If the by-hand steps did the install there is no uninstall script: delete `%LOCALAPPDATA%\Programs\RandomAI Studio`
and the "RandomAI Studio" shortcut in the Start menu. Leave `%USERPROFILE%\RandomAI Studio\` (their videos) and
`%APPDATA%\RandomAI Studio\` alone unless they ask in so many words to delete them too.
