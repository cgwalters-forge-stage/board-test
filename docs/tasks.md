# Task dispatch

A task is an issue on project 2. Dispatch it with:

```sh
gh workflow run dispatch.yml -f repo=... -f item=N -f kind=implement -f task=...
```

The four kinds in `.github/workflows/dispatch.yml` are:
- `implement`: Propose one draft pull request for an issue.
- `triage`: Assess an issue, leave the tree clean, and return one comment.
- `research`: Investigate an issue, leave the tree clean, and return one comment.
- `review`: Review a pull request's pinned head and return a verdict comment or noop.
