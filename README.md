# sample-repo
sample dev-ops repository
the script updates the version value in packages.json and increase it by 1
its supposed to be used when main branch is being published.
the script accepts as an argument what type of version is it: patch/major/minor (default=patch)
the script performs the following steps:
checks for latest node published version
updates the latest published version within the package.json
increases the version according to the argument for patch, major, or minor (default=patch)
if package does not exist in npm repository, its assumed that the package was not published yet, and its terminated gracefully without doing anything
for all other cases, its throwing the erroe to the console
