=================================
Contributing to the documentation
=================================

LSL's documentation lives in two places:

* **This site** (``docs/`` in the `labstreaminglayer repository <https://github.com/sccn/labstreaminglayer>`__):
  what LSL is, getting started, devices, tools, language bindings, troubleshooting. Written in
  reStructuredText, described below.
* **The liblsl documentation** (``docs/`` in the `liblsl repository <https://github.com/sccn/liblsl>`__):
  getting, building and linking liblsl, its configuration, how it works on the network, and the
  C/C++ API reference. Written in Markdown (MyST) with Mermaid diagrams; build it with
  ``pip install -r docs/requirements.txt`` and ``sphinx-build docs docs/_build/html`` (Doxygen
  must be installed for the API reference).

Both are published on Read the Docs and rebuilt on every push.

Restructured Text (RST)
=======================

Restructured Text
(`Quickstart <https://docutils.sourceforge.io/docs/user/rst/quickstart.html>`_,
`another Quickstart <https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`_)
is a text based markup language like markdown.
In combination with `Sphinx <https://www.sphinx-doc.org/>`_ it is used to build this documentation.

You can view the source code for
`this page <https://github.com/sccn/labstreaminglayer/blob/master/docs/dev/doc_syntax.rst>`_
on Github.

Building the documentation
--------------------------

The
`documentation on ReadTheDocs <https://labstreaminglayer.readthedocs.io/>`_
is built on every commit to the
:repo:`Labstreaminglayer repository <sccn/labstreaminglayer>`.
In order to avoid several commits until you get the formatting right, install
the requirements (``pip install -r docs/requirements.txt``) and build the
documentation in the ``docs`` folder with
:samp:`make html`, or (if you don't have :command:`make` installed)
:samp:`sphinx-build . _build/html`.



Linking to…
-----------------------------

You can avoid repeating yourself by adding links to separate pages or
paragraphs where something is explained in more depth.
There are several ways to do this

External links
~~~~~~~~~~~~~~

External links can be written as :samp:`\`<{target}>\`_`,
e.g. `<https://www.google.com/search?q=sphinx+cheat+sheet>`_) or with a better
link text before the URL as :samp:`\`{link text} <{target}>\`_`, e.g.
`a timeless classic <https://www.youtube.com/watch?v=oHg5SJYRHA0>`_.


.. _my-label:

Internal links
~~~~~~~~~~~~~~

After setting a
`label <https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#role-ref>`_
with :samp:`.. _{my-label}:` before a section, you can refer to it as
:samp:`:ref:`{link text} <{my-label}>``: :ref:`link text <my-label>` (or, without a link text
:ref:`my-label`).

You can link to entire documents via their *relative* path, excluding the file
extension with the
`:doc: <https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#role-doc>`_ role.
Omitting the link text inserts the title of the document, so
:samp:`:doc:`doc_syntax`` produces :doc:`doc_syntax`.


LSL documentation shortcuts
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some pages are linked to quite often, so there are some shortcuts configured in :file:`conf.py`:

:samp:`:repo:`{foo}`` creates a link to :samp:`https://github.com/{foo}`
(of course, you can add link texts with all these commands, e.g.
:samp:`:repo:`{your new start page} <sccn/liblsl>``).

:samp:`:lslrepo:`{LabRecorder}`` links to
:samp:`https://github.com/labstreaminglayer/App-{LabRecorder}` and
:samp:`:lslrelease:`{LabRecorder}`` to an App's release page, i.e.
:samp:`https://github.com/labstreaminglayer/App-{LabRecorder}/releases`.

:samp:`:liblsl:`{link text} <{guide/linking.html}>`` links to a page of the liblsl
documentation, e.g. :liblsl:`Using liblsl in your project <guide/linking.html>`. Prefer this
for liblsl's guide pages (written in Markdown); for the API reference use the intersphinx links below.

`Intersphinx`_
~~~~~~~~~~~~~~

.. _Intersphinx: https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html

You can link to anything in the :doc:`liblsl docs <liblsl:index>` with the commands described in
:ref:`my-label` by prefixing the label / doc with ``liblsl``, e.g.
:samp:`doc:`liblsl:ref/freefuncs`` produces this link: :doc:`liblsl:ref/freefuncs`.

You can even use this to refer to pages created directly from the documentation
comments in the C++ header files, e.g. :samp:`:any:`liblsl:proc_dejitter``
produces this link: :any:`liblsl:proc_dejitter`.
When using the predefined roles (e.g. `:cpp:enum`), you don't need to prefix `liblsl:`, e.g.
:samp:`:cpp:enum:`lsl_processing_options_t`` produces :cpp:enum:`lsl_processing_options_t`.

You can list the available link targets by running
:command:`python -msphinx.ext.intersphinx https://labstreaminglayer.readthedocs.io/projects/liblsl/objects.inv`.

