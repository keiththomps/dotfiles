#!/usr/bin/env ruby
require 'irb/completion'

IRB.conf[:USE_COLORIZE] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE unless defined?(Rails)
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
