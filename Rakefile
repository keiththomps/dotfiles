require 'fileutils'

require_relative 'dotfile_list'

desc 'Ensure dependencies (vim-plug, etc) are installed'
task :deps do
  `curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  # Install homebrew dependencies
  `brew bundle`

  # Install python dependencies
  `pip install virtualenv tmuxp`
  `pip3 install virtualenv`
end

desc 'Setup/update dotfile symbolic links'
task :link do
  $dotfiles.each do |path|
    if path.is_a?(Array)
      path, directories = path
      if !Dir.exists?(File.join(ENV["HOME"], directories))
        puts "Creating #{File.join(ENV["HOME"], directories)}"
        Dir.mkdir(File.join(ENV["HOME"], directories), 0755)
      end
      linked_file = File.join(ENV["HOME"], directories, path)
    else
      linked_file = File.join(ENV["HOME"], path)
    end

    if File.symlink?(linked_file)
      puts "Unlinking #{linked_file}"
      File.unlink(linked_file)
    else
      puts "Removing #{linked_file}"
      FileUtils.rm_rf(linked_file)
    end
    puts "Linking #{linked_file}"
    File.symlink(File.join(File.dirname(__FILE__), path), linked_file)
  end
end

desc 'Update vim plugins'
task :vim do
  puts "Updating vim plugins"
  `nvim +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean +q +q`
  `nvim +PythonSupportInitPython2 +PythonSupportInitPython3 +q +q`
end

desc 'Link dotfiles and setup vim'
task :default => [:deps, :link, :vim]
