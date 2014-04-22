Dotfiles
========

My public dotfiles, lovingly grown over many years, through hours of wasted
time.

## install

Run this:

```sh
git clone https://github.com/askedrelic/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Vim" — you can simply add a `vim` directory and put
files in there. Anything with an extension of `.symlink` will get symlinked
without extension into `$HOME` when you run `script/bootstrap`.


## areas of interest

* bin/
	* Random scripts I've written and collected
	* youtube-dl - download youtube videos
	* prettyJSON.py - format JSON
	* findr.sh - makes GNU find much more useful for most situations
	* cloc.pl - SLOC analyzer

* vim/ and my .vimrc
	* Reasonably organized, well commented vimrc. Vim is my main IDE, so I'm always tweaking vim.
	* NERDTree - good filesystem browser
	* taglist - essential source code browser
	* fuzzyfinder - similar to textmate's fuzzy file finder, this is a hack of ruby scripts and fuzzyfinder vim plugin. great for finding files!

* system/
	* .bash_profile should be loaded first, sets up the ENV and PATH
	* .bashrc sets ENV variables and settings, loads other customizations
	* .bash_aliases is shorter scripts and command aliases
	* .bash_machines is shortcuts to all my machines
	* input.rc has some cool hacks for viewing history and setting up the terminal


## thanks

I copied [Zach Holman's](http://github.com/ryanb)
[dotfiles](https://github.com/holman/dotfiles) for the layout and symlink idea.
