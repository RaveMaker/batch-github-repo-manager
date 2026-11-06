Batch GitHub Repo Manager
=========================

Bash scripts to clone, pull, and create GitHub repositories in bulk.

| Script | Purpose |
|--------|---------|
| `multiClone.sh` | Clone all repos for a user or organization |
| `multiPull.sh` | `git pull` every repo under one or more folders |
| `multiCreate.sh` | Create GitHub repos from subfolders and push them |

- Supports GIT and HTTPS clone.
- Supports more than 100 repos (pages past the GitHub API page size).
- Debug mode: set `DEBUG_MODE="true"` to print actions without running them.

### Installation

1. Clone this repo or copy the files to your preferred directory.

2. Create settings from the example and edit values:

```bash
cp settings.cfg.example settings.cfg
```

```bash
# Shared: GitHub user or organization name (from the GitHub URL)
GIT_NAME="username"

# Shared: debug mode — set to "false" to perform real git operations
DEBUG_MODE="true"

# multiClone: where to clone repositories
DEST_FOLDER="/My/Git/Repos"

# multiClone: account type — User=1 Organization=2
USER_ORG="1"

# multiClone: clone protocol — GIT=1 HTTPS=2
GIT_HTTPS="1"

# multiPull: folders to pull (if unset, uses DEST_FOLDER)
# DEST_FOLDERS=("/My/Git/Repos" "/My/Other/Repos")

# multiCreate: folder whose subfolders become GitHub repos
FOLDER="/temp"
```

### Usage

```bash
./multiClone.sh
./multiPull.sh
./multiCreate.sh              # uses GIT_NAME and FOLDER from settings.cfg
./multiCreate.sh myuser /temp # optional CLI overrides
```

### Settings reference

| Variable | Used by | Description |
|----------|---------|-------------|
| `GIT_NAME` | all | GitHub user or organization name |
| `DEBUG_MODE` | all | `"true"` = dry run, `"false"` = real git ops |
| `DEST_FOLDER` | multiClone, multiPull | Clone destination; also default pull root |
| `DEST_FOLDERS` | multiPull | Optional array of folders to pull |
| `USER_ORG` | multiClone | `1` = user, `2` = organization |
| `GIT_HTTPS` | multiClone | `1` = git@, `2` = HTTPS |
| `FOLDER` | multiCreate | Parent folder whose subfolders become repos |

Author: [RaveMaker][RaveMaker].

[RaveMaker]: http://ravemaker.net
