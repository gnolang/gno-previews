#!/usr/bin/env bash
# Regenerate index.html from whatever pr-*/ directories exist. Every job that adds
# or removes a preview calls this, so the landing page can never drift from the tree.
set -euo pipefail
cd "$(dirname "$0")/.."

rows=""
count=0
for d in pr-*/; do
  [ -d "$d" ] || continue
  n="${d#pr-}"; n="${n%/}"
  case "$n" in ''|*[!0-9]*) continue;; esac
  count=$((count + 1))
  rows="$rows      <li><a href=\"pr-$n/\">PR #$n</a> <a class=\"src\" href=\"https://github.com/gnolang/gno/pull/$n\">on GitHub</a></li>
"
done
[ "$count" -gt 0 ] || rows="      <li class=\"empty\">No previews are live right now.</li>
"

cat > index.html <<HTML
<!doctype html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex, nofollow">
<title>gno pull request previews</title>
<style>
 :root{color-scheme:light dark;--fg:#14211c;--mute:#6b7671;--accent:#1d6b57;--bg:#fbfaf7}
 @media (prefers-color-scheme:dark){:root{--fg:#e7ece8;--mute:#8b9a92;--accent:#6fc0a4;--bg:#111714}}
 body{background:var(--bg);color:var(--fg);font-family:system-ui,sans-serif;line-height:1.6;
      max-width:44rem;margin:3.5rem auto;padding:0 1.25rem}
 h1{font-size:1.5rem;margin:0 0 .4rem}
 p{color:var(--mute);margin:0 0 1.6rem}
 ul{list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:.55rem}
 li{border-bottom:1px solid color-mix(in srgb,var(--mute) 30%,transparent);padding-bottom:.55rem}
 a{color:var(--accent);text-decoration:none;font-weight:600}
 a:hover{text-decoration:underline}
 a.src{font-weight:400;font-size:.85em;color:var(--mute);margin-left:.6rem}
 .empty{color:var(--mute)}
 footer{margin-top:2.5rem;font-size:.85rem;color:var(--mute)}
</style>
<h1>gno pull request previews</h1>
<p>$count live preview(s) of open pull requests on gnolang/gno.</p>
<ul>
$rows</ul>
<footer>
  Static snapshots rendered with gnodev on a fresh chain — transactions and search do not
  work, and realms show their post-<code>init</code> state. Generated; see
  <a href="https://github.com/gnolang/gno-previews">the repository</a>.
</footer>
HTML
echo "reindex: $count preview(s)"
