GIT_BRANCH = `git status | sed -n 1p`.split(" ").last
GIT_COMMIT = `git log | sed -n 1p`.split(" ").last
GIT_LAST_COMMIT_DATE = `git log | sed -n 3p`.split(" ").join(" ")
