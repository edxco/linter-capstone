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
    @indent_pointer = []
    @tags = []
    #file_to_check.lines

    lines_empty
    double_empty_line
    #p @lines_empty
  
    @file_to_check.lines.length.times do |line|
      #puts line.to_s.green
      #indentation_offset(line)
      #-trailing_whitespace(line)
      #-whitespace(line)
      closing_tags(line)
    end
    count_open_tags
    #p "Errors found"
    #p @error_arr
    #p @indent_pointer
end

def whitespace(line)
  unless @lines_empty.include? (line + 1)
    pointer = @file_to_check.lines[line].string.gsub(/ {2,}/).map { |_,arr| Regexp.last_match.begin(0) }
    unless pointer[0] == 0 && pointer[1] == 0 || pointer[1] == nil
      pointer.shift if pointer[0] == 0
      @error_arr.push({ line_pos: line + 1,  message: 'Excess Whitespace Detected', offset: pointer})
      #puts "line_pos: #{line + 1}, whitespace excess found on col #{pointer}".red
    end
    last = @file_to_check.lines[line].string.length
  end
end

def trailing_whitespace(line)
  pointer = @file_to_check.lines[line].string.length
  #puts "pointer #{pointer} on line #{line}"
  @error_arr.push({ line_pos: line + 1,  message: 'Trailing Whitespace Detected', offset: pointer}) if @file_to_check.lines[line].string.reverse[0..1].match?(/ {1,}/)
end

def indentation_offset(line)
  unless @lines_empty.include? (line + 1)
    indent_pointer = @file_to_check.lines[line].string.gsub(/^\s*/i).map { |_,arr| Regexp.last_match.end(0) }
    indent_pointer = indent_pointer.select {|num| num > 0 }
    @indent_pointer.push({line_pos: line + 1, pointer: indent_pointer}) if !indent_pointer.empty?
  end
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
      @error_arr.push({ line_pos: @lines_empty[y],  message: 'Excess empty line', offset: nil})
    #else next 
    end 
  end 
end

def closing_tags(line)
  #puts "line #{line} #{@file_to_check.lines[line].string.scan(/\p{Ps}/)}"
  @tags << @file_to_check.lines[line].string.scan(/\p{Ps}/)
  @tags << @file_to_check.lines[line].string.scan(/\p{Pe}/)
end

def count_open_tags
  # brackets_o_count = 0
  # parenthesis_o_count = 0
  # curly_o_count = 0
  # brackets_c_count = 0
  # parenthesis_c_count = 0
  # curly_c_count = 0
  p @tags.flatten!
  p brackets_o_count = @tags.count("{")
  p parenthesis_o_count = @tags.count("(")
  p curly_o_count = @tags.count("[")
  p "-------------------"
  p brackets_c_count = @tags.count("}")
  p parenthesis_c_count = @tags.count(")")
  p curly_c_count = @tags.count("]")
  
end

  filepath = "y.rb"
  check_error(filepath)

