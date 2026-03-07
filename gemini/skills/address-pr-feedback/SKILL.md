---
name: address-pr-comments
description: Address review comments on a GitHub pull request. Use when the user asks to "address PR comments", "respond to review feedback", "handle reviewer comments", or "resolve review threads".
disable-model-invocation: true
---

# Address PR Review Comments

## Context

- Current branch: !`git branch --show-current`
- get pull request review with git mcp: `pull_request_read`

## Your task

Work through every unresolved review thread on this PR systematically. For each thread:

### Step 1 — Understand the comment
Read the comment carefully. Identify:
- What file and line it refers to
- What the reviewer is asking for (change, question, clarification, nitpick)
- Whether a code change is actually required

### Step 2 — Make changes if needed
If a code change is warranted:
- Read the relevant file(s) first
- Make the change using Edit (or Write for new files)
- Do NOT commit yet — collect all changes first

If no change is needed (e.g. the reviewer asked a question, or you disagree), prepare a clear explanation.

### Step 3 — Commit each change separately
After addressing a comment that requires code changes, create a single follow-up commit. Write a short message that summarizes what was changed (e.g. `"fix: use const for immutable bindings per review"`) rather than a generic message:

Skip this step if no code changes were made.
Provide a commit message and wait until prompted to continue if not allowed to commit.

### Step 4 — Reply to each comment
use github mcp

Good reply patterns:
- For changes made: "Done — <brief description of what changed>."
- For questions answered: "< direct answer to question >."
- For declined suggestions: "I kept the existing approach because <reason>."

### Step 5 — Resolve each thread
Resolve every thread/comment if satisfactory
use git mcp / gh cli and GraphQL id field:

```
gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "<thread_id>"}) { thread { id isResolved } } }'
```
## Notes

- Work through all unresolved threads before committing — batch the code changes into one commit
- If the PR has no open review threads, report that there is nothing to address
- Always reply before resolving so the reviewer sees the response
- Keep replies concise and direct
