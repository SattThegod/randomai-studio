#!/bin/bash
# RandomAI Studio: the installer for a Mac.
#
#   curl -fsSL --connect-timeout 10 https://raw.githubusercontent.com/SattThegod/randomai-studio/main/install.sh | bash
#
# What it does, and nothing else:
#   1. looks up the newest version and which package fits this Mac (Apple or Intel chip);
#   2. downloads that package and checks it against the published SHA-256;
#   3. puts "RandomAI Studio.app" into /Applications (or ~/Applications if that folder is not writable);
#   4. opens the app.
# It asks for no password, installs no other software and changes nothing outside the app's own folder.
# It is safe to run again: it updates an older copy, and leaves an up-to-date one alone.
#
# Switches (environment variables), all optional:
#   RAS_BASE_URL=<address>   take checksums.txt and the packages from here instead of the GitHub release
#   RAS_INSTALL_DIR=<folder> put the app in this folder
#   RAS_FORCE=1              install again even when this version is already there (repair)
#   RAS_QUIT_APP=1           if the app is open, ask it to close first (only after the person agreed)
#   RAS_NO_OPEN=1            do not open the app at the end
#
# Everything is inside main(), which is called on the last line: a download that stopped halfway runs nothing.
set -euo pipefail

main() {
  local REPO="SattThegod/randomai-studio"
  local APP_NAME="RandomAI Studio"
  local BASE="${RAS_BASE_URL:-https://github.com/${REPO}/releases/latest/download}"
  BASE="${BASE%/}"

  say() { printf '%s\n' "$*"; }
  ok() { printf '✓ %s\n' "$*"; }
  fail() {
    printf '✗ %s\n' "$*" >&2
    exit 1
  }

  # GitHub answers from several server addresses. On some networks one of them cannot be reached, and curl left
  # to itself waits up to a minute on it before it tries the next one. With a limit on the time to connect it
  # moves on after a few seconds. So: a quick try first, then a patient one for a connection that really is slow.
  #   fetch <address> <file> [bar]
  local patient=""
  fetch() {
    local show="-sS" quiet="-s"
    if [ "${3:-}" = "bar" ] && [ -t 2 ]; then
      show="--progress-bar"
      quiet="--progress-bar"
    fi
    if [ -z "$patient" ]; then
      # the quick try keeps its complaint to itself: the patient one below says what is wrong, if anything is
      if curl -fL $quiet --connect-timeout 8 "$1" -o "$2"; then return 0; fi
      patient=1
      say "That did not get through at once. Trying again, with more patience…"
    fi
    curl -fL $show --retry 2 --connect-timeout 30 "$1" -o "$2"
  }

  # ── this computer ───────────────────────────────────────────────────────────────────────────────────────────
  [ "$(uname -s)" = "Darwin" ] || fail "This installer is for a Mac. On Windows, use install.ps1 instead."
  local arch
  case "$(uname -m)" in
    arm64) arch="arm64" ;;
    x86_64) arch="x64" ;;
    *) fail "This Mac's processor ($(uname -m)) is not supported." ;;
  esac
  local os_major
  os_major="$(sw_vers -productVersion | cut -d. -f1)"
  [ "${os_major:-0}" -ge 12 ] || fail "RandomAI Studio needs macOS 12 or newer. This Mac has macOS $(sw_vers -productVersion)."
  case "$REPO" in
    OWNER/REPO | __REPO*) [ -n "${RAS_BASE_URL:-}" ] || fail "This copy of the installer has no download address yet. Use the command from the community's Install lesson." ;;
  esac

  local dest_dir="${RAS_INSTALL_DIR:-/Applications}"
  if [ -z "${RAS_INSTALL_DIR:-}" ] && [ ! -w "$dest_dir" ]; then dest_dir="$HOME/Applications"; fi
  mkdir -p "$dest_dir" || fail "The folder $dest_dir cannot be created."
  [ -w "$dest_dir" ] || fail "The folder $dest_dir cannot be written to."
  local dest="$dest_dir/$APP_NAME.app"

  # not "local": the clean-up below runs when the script ends, after this function has returned
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/randomai-studio.XXXXXX")"
  trap 'if [ -n "${tmp:-}" ] && [ -d "$tmp" ]; then rm -rf "$tmp"; fi' EXIT

  # ── the newest version ──────────────────────────────────────────────────────────────────────────────────────
  say "RandomAI Studio installer (Mac, $arch)"
  say "Looking up the newest version…"
  fetch "$BASE/checksums.txt" "$tmp/checksums.txt" || fail "The download address could not be reached ($BASE). Check the internet connection and try again."
  local version line want_sha want_size file
  version="$(awk '$1 == "version" { print $2; exit }' "$tmp/checksums.txt")"
  line="$(grep -E "  RandomAI-Studio-.*-mac-${arch}\.zip\$" "$tmp/checksums.txt" | head -n 1 || true)"
  [ -n "$version" ] && [ -n "$line" ] || fail "The release has no package for this Mac ($arch). Tell the community's support."
  want_sha="$(printf '%s' "$line" | awk '{ print $1 }')"
  want_size="$(printf '%s' "$line" | awk '{ print $2 }')"
  file="$(printf '%s' "$line" | awk '{ print $3 }')"
  case "$file" in */* | *..*) fail "The release names a file outside its own folder. Nothing was installed." ;; esac

  # ── already there? ──────────────────────────────────────────────────────────────────────────────────────────
  local have=""
  if [ -d "$dest" ]; then have="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$dest/Contents/Info.plist" 2>/dev/null || true)"; fi
  if [ "$have" = "$version" ] && [ "${RAS_FORCE:-}" != "1" ]; then
    ok "RandomAI Studio $version is already installed in $dest_dir"
    if [ "${RAS_NO_OPEN:-}" != "1" ]; then open "$dest" || true; fi
    say "Next: in the window that opens, press \"Log in with Skool\"."
    return 0
  fi

  # an open app cannot be replaced: it is never closed without being asked to
  if pgrep -f "$dest/Contents/MacOS/" >/dev/null 2>&1; then
    if [ "${RAS_QUIT_APP:-}" = "1" ]; then
      say "Closing RandomAI Studio…"
      # this copy, by its place on disk: another copy of the app elsewhere is left alone
      osascript -e "tell application \"$dest\" to quit" >/dev/null 2>&1 || true
      local i
      for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        pgrep -f "$dest/Contents/MacOS/" >/dev/null 2>&1 || break
        sleep 1
      done
    fi
    if pgrep -f "$dest/Contents/MacOS/" >/dev/null 2>&1; then fail "RandomAI Studio is open. Close it (wait for any video it is making), then run this again."; fi
  fi

  # ── download and check ──────────────────────────────────────────────────────────────────────────────────────
  say "Downloading RandomAI Studio $version ($((want_size / 1000000)) MB)…"
  fetch "$BASE/$file" "$tmp/$file" bar || fail "The download did not finish. Check the internet connection and try again."
  local got_sha got_size
  got_size="$(stat -f %z "$tmp/$file")"
  got_sha="$(shasum -a 256 "$tmp/$file" | awk '{ print $1 }')"
  if [ "$got_sha" != "$want_sha" ] || [ "$got_size" != "$want_size" ]; then
    fail "The downloaded file does not match the published one (expected ${want_sha:0:12}…, got ${got_sha:0:12}…). Nothing was installed. Try again; if it happens twice, tell the community's support."
  fi
  ok "Downloaded and checked (SHA-256 ${got_sha:0:12}…)"

  # ── put it in place ─────────────────────────────────────────────────────────────────────────────────────────
  ditto -x -k "$tmp/$file" "$tmp/unpacked" || fail "The package could not be unpacked."
  [ -d "$tmp/unpacked/$APP_NAME.app/Contents/MacOS" ] || fail "The package does not hold $APP_NAME.app. Nothing was installed."
  # a file fetched by a script carries no download mark; this only makes sure, so the app opens without a warning
  xattr -dr com.apple.quarantine "$tmp/unpacked/$APP_NAME.app" 2>/dev/null || true
  if [ -d "$dest" ]; then
    mv "$dest" "$tmp/previous.app" || fail "The older copy in $dest_dir could not be replaced. Close RandomAI Studio and try again."
  fi
  if ! mv "$tmp/unpacked/$APP_NAME.app" "$dest"; then
    if [ -d "$tmp/previous.app" ]; then mv "$tmp/previous.app" "$dest" || true; fi
    fail "The app could not be put into $dest_dir. The older copy, if there was one, is back in place."
  fi
  ok "RandomAI Studio $version is installed in $dest_dir${have:+ (it was $have)}"

  if [ "${RAS_NO_OPEN:-}" != "1" ]; then
    open "$dest" || say "The app is installed but did not open by itself. Open \"$APP_NAME\" from $dest_dir."
  fi
  say "Next: in the window that opens, press \"Log in with Skool\"."
}

main "$@"
