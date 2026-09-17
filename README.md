# gno-previews

Static [gnoweb](https://github.com/gnolang/gno/tree/master/gno.land/pkg/gnoweb) previews of
open pull requests on [gnolang/gno](https://github.com/gnolang/gno), one directory per PR:

    https://gnolang.github.io/gno-previews/pr-<N>/

Nothing here is written by hand. `gnolang/gno`'s `pr-preview.yml` renders a pull request's
changed realms with `gnodev`, and its `pr-preview-publish.yml` pushes the result here and
comments the link on the PR. `pr-preview-cleanup.yml` removes the directory when the PR
closes, and `evict.yml` below sweeps up whatever those two miss.

## Why this is a separate repository

The previews and gno's own GitHub Pages site (the pkgsite godoc mirror) want opposite things
from a publishing pipeline. The docs are regenerated from scratch on every deploy — about
three minutes — and nobody needs them within five minutes of a merge. A preview's entire
value is being there when a reviewer clicks the link in the PR comment.

Sharing one site would mean every preview push rebuilds and re-uploads the docs, because a
GitHub Pages site built by an Actions workflow is published as one whole-site artifact with
no incremental deploy. Publishing from a branch, as this repository does, pushes only the
bytes that changed.

Keeping them apart also keeps the blast radius small: a broken preview job cannot take the
documentation offline, and the two do not share a 1 GB site budget or a git history.

## Write access

`gnolang/gno` publishes here with a **deploy key** — a write-enabled key registered on this
repository, whose private half is the `PREVIEWS_DEPLOY_KEY` secret over there. Deliberately
not a fine-grained personal access token: a deploy key cannot reach any other repository, it
does not expire, and it belongs to the repository rather than to a person, so preview commits
are not attributed to whoever minted it and nothing breaks when that person rotates a token.

## Housekeeping

Previews are deleted when their pull request closes. `evict.yml` additionally drops any
preview whose PR has been closed behind our back or has gone quiet, and enforces a total
size budget so the site cannot approach the 1 GB cap. Because history here is disposable,
it is squashed to a single commit periodically — do not base anything on this repository.

Every page carries `<meta name="robots" content="noindex, nofollow">`: a preview is a
near-duplicate of a real gno.land page and must never compete with it in search results.
