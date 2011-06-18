GIT_BRANCH = `git status | sed -n 1p`.split(" ").last
GIT_COMMIT = `git log | sed -n 1p`.split(" ").last
date_or_author = `git log | sed -n 3p`
# If a merge occurs the date of the commit will be on the fourth line.
GIT_LAST_COMMIT_DATE = date_or_author.include?('Date')? date_or_author : `git log | sed -n 4p`
