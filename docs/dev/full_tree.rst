:orphan:

.. role:: cmd(code)
   :language: bash

Working With The LabStreamingLayer Repository
=============================================

See also https://git-scm.com/book/en/v2/Git-Tools-Submodules

This repository doesn’t contain the apps, just links to their respective
submodules (i.e. ``Apps/AppTemplate_cpp_qt`` is found at commit ``abc123def`` of
``https://github.com/labstreaminglayer/AppTemplate_cpp_qt``).

Recommended git settings
------------------------

To avoid mistakes, consider changing the following git settings, either
for this repository (:cmd:`git config --add setting.name value`) or for all
repositories (:cmd:`git config --global --add ...`).

-  ``pull.rebase`` ``true``: insert new commits *before* your commits,
   so no merge commits are created
-  ``push.recurseSubmodules`` ``check``: abort pushing to the main
   repository if you haven’t pushed the submodules you’re trying to
   reference
-  ``push.recurseSubmodules`` ``on-demand``: automatically push
   submodules you’re updating

Git cookbook
------------

Some operations have to be done differently than in a normal repository:

Initial cloning, checking out *all* submodules:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  :cmd:`git clone --recurse-submodules git@github.com:labstreaminglayer/labstreaminglayer.git`

Adding a submodule:
~~~~~~~~~~~~~~~~~~~

:cmd:`git submodule add https://github.com/<username>/<reponame>.git Apps/AppXY`

Don’t use URLs like ``ssh://git@github.com/<username>/<reponame>``
because they can’t be checked out anonymously.
Change them *in your local tree* with
:cmd:`git remote set-url origin ssh://...` after
checking them out.

If you're using bash, you can ``cd`` to the subdirectory and set your local
remote with
:cmd:`git remote set-url origin git@github.com:labstreaminglayer/App-${PWD##*/}`

Check out a single submodule: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:cmd:`git submodule update --init <path>`

Update a submodule
~~~~~~~~~~~~~~~~~~

set the referenced commit to the newest:
:cmd:`git submodule update --remote --rebase <path>` (rebase local changes) or

:cmd:`git submodule update --remote --merge <path>` (merge local changes)

Change the commit that’s referenced in this repository:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Commit and push changes in the App repository:  

.. code:: bash

   cd Apps/XY
   git add .
   git commit -m'Message'
   git push


From the main repository, update the reference:
:cmd:`git add Apps/XY`

Commit and push as usual:

.. code:: bash

   git add Apps/XY
   git commit -m'Update references'
   git push --recurse-submodules=on-demand
