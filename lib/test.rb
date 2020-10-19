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
       #puts "No. of lines: #{@lines[ind].string}".red
    end
  end
end

def check_error(filepath)
    @file_to_check = LintFile.new(filepath)
    @file_to_check.read
    @error_arr = []
    #file_to_check.lines
  
    @file_to_check.lines.length.times do |line|
      #puts line.to_s.green
      whitespace(line)
      trailing_whitespace(line)
      indentation(line)
      
    end
    p @error_arr
end

def whitespace(line)
  pointer = @file_to_check.lines[line].string.gsub(/ {2,}/).map { |_,arr| Regexp.last_match.begin(0) }
  last = @file_to_check.lines[line].string.length
  @error_arr.push({ line: line + 1,  message: 'Two or more whitespace found', offset: pointer}) if !pointer.empty? && pointer != last
end

def trailing_whitespace(line)
  pointer = @file_to_check.lines[line].string.length
  @error_arr.push({ line: line + 1,  message: 'Trailing Whitespace Detected', offset: pointer}) if @file_to_check.lines[line].string.reverse[0..1].match?(/ {1,}/)
end

def indentation(line)
  p @file_to_check.lines[line].string
  p @file_to_check.lines[line].check_until(/^\s*/i)
  p @file_to_check.lines[line].string.gsub(/^\s*/i).map { |_,arr| Regexp.last_match.end(0) }
end

  filepath = "y.rb"

  check_error(filepath)