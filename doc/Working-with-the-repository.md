# Working with this repository

See also https://git-scm.com/book/en/v2/Git-Tools-Submodules

This repository doesn't contain the apps, just links to their respective submodules
(i.e. `Apps/Examples` is found at commit `abc123def` of
`https://github.com/labstreaminglayer/App-Examples.git`).

## Recommended git settings

To avoid mistake, consider changing the following git settings, either for this
repository (`git config --add setting.name value`) or for all repositories
(`git config --global --add ...`).

- `pull.rebase` `true`: insert new commits *before* your commits, so no merge
  commits are created
- `push.recurseSubmodules` `check`: abort pushing to the main repository if you haven't
  pushed the submodules you're trying to reference
- `push.recurseSubmodules` `on-demand`: automatically push submodules you're updating

## Git cookbook
Some operations have to be done differently than in a normal repository:

- Initial cloning, checking out *all* submodules: `git clone --recurse-submodules git@github.com:labstreaminglayer/labstreaminglayer.git`
- Adding a submodule: `git submodule add https://github.com/<username>/<reponame>.git`.
  Don't use URLs like `ssh://git@github.com/<username>/<reponame>` because they can't be
  checked out anonymously.
  Change them in your local tree with `git remote set-url origin ssh://...` after checking them out
- Check out a single submodule: `git submodule init <path>`, `cd <path>`, `git submodule update`
- update a submodule (set the referenced commit to the newest):
  `git submodule update --remote --rebase <path>`  (rebase local changes) or
  `git submodule update --remote --merge <path>` (merge local changes)
- Change the commit that's referenced in this repository:
    - Commit and push changes in the App repository: `cd Apps/XY`; git commit ...; git push`
    - From the main repository, update the reference: `git add Apps/XY`
    - Once again, check that you have really pushed the app repository
    - Commit and push as usual: `git commit -m'Update references'; git push`

