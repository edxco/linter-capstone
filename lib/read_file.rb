require 'strscan'
require_relative 'colors.rb'

class LintFile
  attr_reader :file, :lines
  def initialize(filepath)
    @file = File.open(filepath)
    @lines = []
  end

  def get_lines_and_text
    @file.each_with_index do |line, ind|
       @lines[ind] = StringScanner.new(line)
       puts "No. of lines: #{@lines[ind].string}".red
    end
  end
end

def check_end_line(current_file)
  p current_file.eos?
end

def check_whitespace(s)
  unless s.string.match?(/\S/)
  return
  end
end

filepath = "t.rb"
puts "The path is #{filepath}"

p current_file = LintFile.new(filepath)

current_file.get_lines_and_text
puts "Aqui imprimo un elemento del array".red
p current_file.lines[2]
puts "Aqui imprimo lines".green
p current_file.lines.length

check_whitespace(current_file.lines[2])

