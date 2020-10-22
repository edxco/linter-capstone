require 'strscan'
require_relative 'colors.rb'

class LintFile
  attr_reader :file, :lines
  def initialize(filepath)
    @file = File.open(filepath)
    @lines = []
  end

  def read
    @file.each_with_index do |line, ind|
      @lines[ind] = StringScanner.new(line)
      # puts "No. of lines: #{@lines[ind].string}".red
    end
  end
end

def check_error(filepath)
  @file_to_check = LintFile.new(filepath)
  @file_to_check.read
  @error_arr = []
  # file_to_check.lines

  @file_to_check.lines.length.times do |line|
    # puts line.to_s.green
    whitespace(line)
    trailing_whitespace(line)
  end
  p @error_arr
end

def whitespace(line)
  pointer = @file_to_check.lines[line].string.gsub(/ {2,}/).map { |_, _arr| Regexp.last_match.begin(0) }
  @error_arr.push({ line: line + 1, message: 'Two or more whitespace found', offset: pointer }) unless pointer.empty?
end

def trailing_whitespace(line)
  puts @file_to_check.lines[line].string.green
  puts @file_to_check.lines[line].string[-1, 1].green
  puts 'Termina trailing'.red
end

filepath = 't.rb'

check_error(filepath)
