# Configuration file for the Sphinx documentation builder.

# -- Project information -----------------------------------------------------

project = 'Labstreaminglayer'
copyright = '2019, Christian Kothe, David Medine, Chadwick Boulay, Matthew Grivich, Tristan Stenner'
author = 'Christian Kothe, David Medine, Chadwick Boulay, Matthew Grivich, Tristan Stenner'

# The full version, including alpha/beta/rc tags
release = '1.13'


# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.intersphinx',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
master_doc = 'index'  # for Sphinx < 2.0

# -- Options for HTML output -------------------------------------------------

html_theme_options = {
#    'logo': 'logo.png',
    'github_user': 'sccn',
    'github_repo': 'labstreaminglayer',
    'github_button': 'true',
    'extra_nav_links': {
        'C++ API': 'https://labstreaminglayer.readthedocs.io/projects/liblsl/',
        }
    }

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']


# intersphinx
intersphinx_mapping = {
    'liblsl': ('https://labstreaminglayer.readthedocs.io/projects/liblsl', None),
}

