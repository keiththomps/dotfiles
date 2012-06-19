Prerequisites
-------------
* Vim with Ruby support (on OS X use this script: https://gist.github.com/1110471 )
* Ruby used to compile Vim set to active, needs to have bundler and rake installed

Installation
------------
1. Clone using `git clone https://github.com/keiththomps/dotfiles.git`
2. Modify the Vim packages you'd like to install in _bundle_list.rb_
3. Modify the dotfiles you'd like to link in _dotfile_list.rb_
4. Run `rake`
5. Enjoy your new fangled environment!

Additional Vim Info
-------------------
All vim plugins are installed via Pathogen by Tim Pope, and the configuration for those is contained within the
_bundle_list.rb_ file. To install a new bundle add it to the list and run either `rake` or `rake vim`. If 
installing the Command-T plugin (which you are by default), you must use the same ruby you used to compile Vim 
when you run the rake task.

Additional Dotfile Info
-----------------------
All dotfile links are managed within the _dotfile_list.rb_ file. If you would like to link a new file simply add
it to the list in that file and run `rake` or `rake link`.