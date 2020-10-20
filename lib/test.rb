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
    @reserved_words = [/def/i, /if/i, /do/i, /class/i]
    @lines_empty = []
    @double_empty_line = []
    #file_to_check.lines

    lines_empty
    p @lines_empty
    double_empty_line
  
    @file_to_check.lines.length.times do |line|
      #puts line.to_s.green
      indentation_offset(line)
      #whitespace(line)
      trailing_whitespace(line)
    end
    p "Errors found"
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

def indentation_offset(line)
  pointer = @file_to_check.lines[line].string.gsub(/^\s*/i).map { |_,arr| Regexp.last_match.end(0) }
end

def lines_empty

  @file_to_check.lines.length.times do |line|
    #no_line = @file_to_check.lines[line].string.gsub(/^\s*\n/i).map { |_,arr| Regexp.last_match.end(0) }
     @lines_empty << line + 1 if @file_to_check.lines[line].string.strip.empty?
     
     

    #@lines_empty << line + 1 unless no_line.empty?
      #puts "Im in line #{line +1} This lines are empty #{@lines_empty}"
    end
end

def double_empty_line
  @lines_empty.each_with_index do |x, y| 
    #puts ("y = #{y} y-1 = #{@lines_empty[y - 1]} x = #{x}") 
    if x == @lines_empty[y - 1] + 1
      @double_empty_line << @lines_empty[y]
      puts "Line #{@lines_empty[y]} it's a double empty line" 
    else next 
    end 
  end 
end

  filepath = "y.rb"
  check_error(filepath)
