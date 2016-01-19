#!/usr/bin/env ruby
class VimColorscheme

  attr_accessor :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def extract_colors
    lines = File.readlines file_path
    lines.select { |l| l =~ /^\s*hi.*gui.*$/ }.map do |line|
      identifier = line.split[1]
      guibg      = line.split.map { |element| element[/^guibg=\#(.*)$/,1] }.compact[0]
      guifg      = line.split.map { |element| element[/^guifg=\#(.*)$/,1] }.compact[0]
      { identifier: identifier, guibg: guibg, guifg: guifg }
    end
  end
end

MAPPINGS = {
  :terminal_background =>  %w(Normal  guifg),
  :terminal_foreground =>  %w(Normal guibg),
  :terminal_color_0 =>     %w(LineNr guibg),
  :terminal_color_1 =>     %w(Error guifg),
  :terminal_color_2 =>     %w(Special guifg),
  :terminal_color_3 =>     %w(TabLine guifg),
  :terminal_color_4 =>     %w(Identifier guifg),
  :terminal_color_5 =>     %w(DiffChange guibg),
  :terminal_color_6 =>     %w(PreProc guifg),
  :terminal_color_7 =>     %w(LineNr guifg),
  :terminal_color_8 =>     %w(Pmenu guibg),
  :terminal_color_9 =>     %w(Constant guifg),
  :terminal_color_10 =>    %w(String guifg),
  :terminal_color_11 =>    %w(Function guifg),
  :terminal_color_12 =>    %w(Statement guifg),
  :terminal_color_13 =>    %w(Type guifg),
  :terminal_color_14 =>    %w(Directory guifg),
  :terminal_color_15 =>    %w(Title guifg),
}

path = ARGV[0]
if path && File.exists?(path)
  colorscheme_highlights = VimColorscheme.new(path).extract_colors
  neovim_mappings = []
  MAPPINGS.each do |terminal_color, vim_mapping|
    highlight          = colorscheme_highlights.detect { |c| c[:identifier] == vim_mapping[0] }
    fallback_highlight = colorscheme_highlights.detect { |c| c[:identifier] == "Normal" }
    if highlight
      color = highlight[vim_mapping[1].to_sym]
      color = fallback_highlight[vim_mapping[1].to_sym] if [nil, ""].include?(color)
    else
      color = fallback_highlight[vim_mapping[1].to_sym]
    end
    neovim_mappings << "let g:#{terminal_color} = \"##{color}\""
  end
  neovim_mappings.each { |neovim_mapping| puts neovim_mapping }
  print "\nDo you want to add the above colors to the colorscheme file? (y/N) > "
  will_patch = STDIN.gets.chomp
  if will_patch.downcase == "y"
    File.open(path, "a") do |file|
      file.puts
      file.puts "\" Terminal colors"
      neovim_mappings.each { |neovim_mapping| file.puts neovim_mapping }
      file.puts
    end
    puts "Done! Enjoy your new terminal colors :D"
  else
    puts "Ok, dont worry, bye :)"
  end
else
  puts "Usage: ./neovim_colorscheme_patcher.rb [path_to_vim_colorscheme]"
end
