Prerequisites
=============
* Vim with Ruby support (on OS X use this script "https://gist.github.com/1110471")
* Ruby used to compile Vim set to active, needs to have bundler and rake installed

Installation
------------
1. Clone using `git clone `
2. Move the vim-config directory to be .vim via `mv vim-config .vim`
3. cd into your .vim directory and run `bash create_links.sh` to create the symbolic links to ~/.vimrc (this will remove the current .vimrc in your HOME so move that if you'd like to take things from it)
4. Run `ruby update_bundles.rb` to download and install all of the plugins you have listed in the update_bundles.rb
5. Activate Command-T by cd'ing into bundles/command-t and running `bundle install` & `rake make`

Additional Info
---------------
All vim plugins are installed via Pathogen by Tim Pope, and the configuration for those is contained within the update_bundles.rb file. To install a new package simple add it to the git_bundles list in that file and re-run steps 4 & 5 of the installation. Everytime you update your bundles you'll need to re-compile the command-t extensions.
