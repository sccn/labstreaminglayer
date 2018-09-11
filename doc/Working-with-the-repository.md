See also https://git-scm.com/book/en/v2/Git-Tools-Submodules

This repository doesn't contain the apps, just links to their respective submodules
(i.e. `Apps/Examples` is found at commit `abc123def` of
`https://github.com/labstreaminglayer/App-Examples.git`).

Therefore, some operations have to be done differently than in a normal repository:

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

