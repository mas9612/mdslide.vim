# mdslide.vim

mdslide.vim is a plugin to create Web slide with Markdown.

If you don't know the Markdown notation in reveal.js, please see https://github.com/hakimel/reveal.js/#markdown.

To use mdslide.vim, you need to install Python3 to your computer and add it to `$PATH` .

## TODO

* to be able to use image
* write test
* correspond to Python2 (not only Python3)

## How to use

### :MdOpenSlide

Open created Web slide. Before run this command, you must start Web server with `:MdStartServer` command.

### :MdRefreshContent

Force to refresh slide contents.

Note: This command is not refresh browser.

### :MdStartServer

Start local Web server to show Web slide.

### :MdStopServer

Stop local Web server.
