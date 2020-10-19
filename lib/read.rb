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

def errors
end

def check_error(filepath)
    @file_to_check = LintFile.new(filepath)
    @file_to_check.read
    #file_to_check.lines
  
    @file_to_check.lines.length.times do |line|
      #puts line.to_s.green
      whitespace(line)
    end
end

def whitespace(line)
  puts @file_to_check.lines[line].string
  if @file_to_check.lines[line].string.match?("  ")
    puts "Two or more whitespace found".red
  end
end

  filepath = "t.rb"

  check_error(filepath)