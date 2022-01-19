Installation
------------
1. Clone using `git clone https://github.com/keiththomps/dotfiles.git`
1. Modify the dotfiles you'd like to link in _dotfiles_ variable in `bootstrap.sh`
1. Run `./bootstrap.sh`
1. Enjoy your new fangled environment!

Additional Vim Info
-------------------
All vim plugins are installed via [plug][1], and the packages can be found at the top of the `init.vim` file.
Follow the [plug's instructions][1] to add and remove packages as you wish.

Additional Dotfile Info
-----------------------
All dotfile links are managed within the _dotfiles_ variable in the `bootstrap.sh` file. If you would like to link a new file simply add
it to the list in that file and run `./bootstrap.sh`.

[1]: https://github.com/junegunn/vim-plug
