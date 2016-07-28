htmlwidgets gallery
===================

This repository serves the [htmwidgets gallery](http://hafen.github.io/htmlwidgetsgallery/).

## Adding a widget

If you are a widget author, you can register your widget by doing the following:

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repository.
2. Create a png thumbnail of an interesting plot from your widget that will look good on a retina screen at 350x300 pixels and put this file in the `images` directory of this repository.
3. Add an entry for your widget in the `_config.yml` file of this repository with the meta data for your widget (copy another entry and modify).  Please see below for guidance on the meta data.
4. Push your changes and [create a pull request](https://help.github.com/articles/creating-a-pull-request/).  To ensure the quality of widgets added to the registry and consistency in how they are displayed, you should expect some amount of discussion during your pull request.

Meta data requirements:

- `name`: the actual name of the R package (required)
- `thumbnail`: location of the thumbnail (required, standard is `images/ghuser-ghrepo.png`)
- `url`: url to the desired landing page you'd like people to first see for the widget (the widget's home page, a vignette, or as a final resort, if not specified, the widget's github page)
- `jslibs`: a comma separated list of javascript library names that the widget depends on, with markdown links to the home pages of the libraries
- `ghuser`: the github user/org where the github repository for the widget resides (required)
- `ghrepo`: the github repository name where the widget resides (required)
- `tags`: comma separated list (with no spaces) of tags that describe the widget - see other widget's tags for ideas
- `cran`: `true` if the package is on CRAN, else `false`
- `examples`: url or list of urls of examples (blog posts, gists, vignettes)
- `ghauthor`: the github handle for the primary author of the widget
- `short`: a short (preferably one sentence) description of the package that will be displayed in limited space under the widget thumbnail in the gallery - ideally should be more than "An htmlwidget interface to library x" as that is obvious from jslib, etc. - instead, should describe what you can do with the widget using library x
- `description`: a longer form description

