## Git safety
- Never commit or push unless I explicitly ask.
- Before any push, run `git fetch --prune`.
- If the current branch is behind its upstream, stop and tell me.
- Do not auto-run `git pull`, `git rebase`, or `git merge` unless I explicitly ask.
- Never force-push shared branches or `main`/`master`.
- Only use `git push --force-with-lease` on my own feature branch, and only with explicit approval.
- Never skip hooks with `--no-verify`.
