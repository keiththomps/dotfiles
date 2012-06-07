#!/usr/bin/ruby
git_bundles = [
  # General Purpose Plugins
  "git://github.com/wincent/Command-T.git",
  "git://github.com/tpope/vim-pathogen.git",
  "git://github.com/tpope/vim-markdown.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tpope/vim-endwise.git",
  "git://github.com/scrooloose/syntastic.git",
  "git://github.com/tomtom/tcomment_vim.git",
  # Syntax highlighting
  "git://github.com/digitaltoad/vim-jade.git",
  "git://github.com/kchmck/vim-coffee-script.git",
  "git://github.com/vim-ruby/vim-ruby.git",
  # Python Plugins
  "git://github.com/vim-scripts/pyflakes.vim.git",
]

# Vim.org syntax scripts, also doesn't do anything
vim_syntax = [
  ["http://www.vim.org/scripts/download_script.php?src_id=13026", "django.vim"],
  ["http://www.vim.org/scripts/download_script.php?src_id=17429", "python.vim"],
  ["http://www.vim.org/scripts/download_script.php?src_id=7002", "doctest.vim"],
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

puts "trashing bundle (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end
