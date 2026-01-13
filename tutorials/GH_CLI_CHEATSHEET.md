# GitHub CLI (gh) Cheatsheet

## Authentication
```bash
gh auth login                    # Login to GitHub account
gh auth status                   # Check authentication status
gh auth logout                   # Logout from GitHub
```

## Repository Operations
```bash
gh repo clone OWNER/REPO         # Clone a repository
gh repo fork                     # Fork the current repository
gh repo create                   # Create a new repository
gh repo view                     # View repository details
gh repo list OWNER               # List repositories for a user/org
```

## Pull Requests
```bash
gh pr create                     # Create a new pull request (interactive)
gh pr create --web               # Create PR in browser
gh pr list                       # List pull requests
gh pr view NUMBER                # View a specific PR
gh pr checkout NUMBER            # Check out a PR locally
gh pr merge NUMBER               # Merge a pull request
gh pr close NUMBER               # Close a pull request
gh pr diff NUMBER                # View PR diff
gh pr review NUMBER              # Review a pull request
```

## Issues
```bash
gh issue create                  # Create a new issue (interactive)
gh issue list                    # List issues
gh issue view NUMBER             # View a specific issue
gh issue close NUMBER            # Close an issue
gh issue reopen NUMBER           # Reopen an issue
gh issue comment NUMBER          # Add a comment to an issue
```

## Workflow/Actions
```bash
gh run list                      # List workflow runs
gh run view RUN_ID               # View details of a workflow run
gh run watch RUN_ID              # Watch a workflow run in real-time
gh workflow list                 # List workflows
gh workflow view WORKFLOW        # View workflow details
```

## Gists
```bash
gh gist create FILE              # Create a gist from a file
gh gist list                     # List your gists
gh gist view GIST_ID             # View a gist
gh gist delete GIST_ID           # Delete a gist
```

## Releases
```bash
gh release create TAG            # Create a new release
gh release list                  # List releases
gh release view TAG              # View a specific release
gh release download TAG          # Download release assets
```

## General
```bash
gh status                        # Show relevant issues, PRs, and notifications
gh browse                        # Open repository in browser
gh help COMMAND                  # Get help for a specific command
```

## Useful Flags
```bash
--repo OWNER/REPO                # Specify repository explicitly
--web                            # Open in browser instead of terminal
-R OWNER/REPO                    # Short form of --repo
```