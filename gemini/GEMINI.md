
# Use Tools available
use mcp_context7_query-docs to query for api documentation
use mcp_astgrep for abstract syntax tree dumps and efficient structured code search

# Git operations
never rebase or ammend commits. only merge origin/main and make new commits in monaco repos.

# Making changes
- break down commits by units of work
- commits should be broken down into logical parts
- do not group unrelated changes into a single commit
- do not comment code.
- code should be self documenting.
- use clear naming, descriptive variables.
- code should prioritize readability
- code should be concise, but not obfuscated.

# code-review
- if a review is requested to be posted to github it will strictly adhere to the inline review structure with explicit line anchors, severity tags, and concrete suggestion blocks. It will not summarize the PR it self as the author does not need a summary of their own PR
- code review should not usually require the executing of lint or build or test tools as this is all automatically validated via CI.
