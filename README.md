ggplot2 extensions gallery
===================

This repository serves the [ggplot2 extensions gallery](https://exts.ggplot2.tidyverse.org/gallery/).

## Adding a ggplot2 extension

If you are a ggplot2 extension developer, you can add your extension by doing the following:

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repository.
2. Create a png thumbnail of an interesting plot from your extension that will look good on a retina screen at 350x300 pixels and put this file in the `images` directory of this repository.
3. Add an entry for your extension in the `_config.yml` file of this repository with the meta data for your extension (copy another entry and modify).  Please see below for guidance on the meta data.
4. Push your changes and [create a pull request](https://help.github.com/articles/creating-a-pull-request/).  To ensure the quality of extensions added to the registry and consistency in how they are displayed, you should expect some amount of discussion during your pull request.

Meta data requirements:

- `name`: the actual name of the R package (required)
- `thumbnail`: location of the thumbnail (required, standard is `images/ghuser-ghrepo.png`)
- `url`: url to the desired landing page you'd like people to first see for the extension (the extension's home page, a vignette, or as a final resort, if not specified, the extension's github page)
- `jslibs`: a comma separated list of javascript library names that the extension depends on, with markdown links to the home pages of the libraries
- `ghuser`: the github user/org where the github repository for the extension resides (required)
- `ghrepo`: the github repository name where the extension resides (required)
- `tags`: comma separated list (with no spaces) of tags that describe the extension - see other extension's tags for ideas
- `cran`: `true` if the package is on CRAN, else `false`
- `examples`: url or list of urls of examples (blog posts, gists, vignettes)
- `ghauthor`: the github handle for the primary author of the extension
- `short`: a short (preferably one sentence) description of the package that will be displayed in limited space under the extension thumbnail in the gallery - ideally should be more than "An htmlextension interface to library x" as that is obvious from jslib, etc. - instead, should describe what you can do with the extension using library x
- `description`: a longer form description

