require 'strscan'
require_relative '../lib/file_read.rb'
require_relative '../lib/errors.rb'
require_relative '../lib/colors.rb'
require_relative '../lib/show_error.rb'

@lines_to_use = []

def unify_errors
  @total_errors = @error_arr.length + @punctation_arr.length
end

def init_errors
  return puts 'No errors detected'.blue unless @total_errors != 0
  case @total_errors
  when 1
    puts "#{@total_errors} Error detected".red
  else
    puts "#{@total_errors} Errors detected".red
  end
end

def show_punctuation
  text = "\nChecking for {}, [] and ()"
  puts text.blue unless @error_arr.empty? || @punctation_arr.empty?
  @punctation_arr.map { |hash| hash[:sign] }.each_with_index do |value, index|
    temp = @punctation_arr[index][:result].abs
    puts "Missing #{temp} #{value} #{@punctation_arr[index][:msg]}"
  end
end

def error_lines
  @lines_to_use = @error_arr.map { |hash| hash[:lpos] }.uniq.sort!
end

def show_errors
  return unless @total_errors > 0
  @lines_to_use.each_with_index do |value, _index|
    puts "\nLine #{value} has the following errors".blue
    @error_arr.each_with_index do |_x, y|
      txt = "#{@error_arr[y][:msg]} on col #{@error_arr[y][:offset]}"
      puts txt if @error_arr[y][:lpos] == value
    end
  end
end

filepath = 'test.rb'

check_error(filepath)
unify_errors
init_errors
error_lines
show_errors
show_punctuation
