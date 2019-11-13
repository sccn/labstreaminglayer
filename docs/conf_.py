# Configuration file for the Sphinx documentation builder.
import subprocess, os

# -- Path setup --------------------------------------------------------------

# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'liblsl'
copyright = '2019, Christian Kothe, MIT'
author = 'Christian Kothe, David Medine, Chadwick Boulay, Matthew Grivich, Tristan Stenner'

# The full version, including alpha/beta/rc tags
release = '1.13'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
        'breathe',
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = ['_static']

breathe_projects = { 'liblsl': 'liblsl_api/xml/'}
breathe_default_project = 'liblsl'

# The reST default role (used for this markup: `text`) to use for all documents.
default_role = 'cpp:any'

# If true, '()' will be appended to :func: etc. cross-reference text.
add_function_parentheses = True
highlight_language = 'c++'
primary_domain = 'cpp'

