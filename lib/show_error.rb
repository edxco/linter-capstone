@lines_to_use = []

def unify_errors
  @total_errors = @error_arr.length + @punctation_arr.length
end

def init_errors
  'No errors detected'.blue unless @total_errors != 0

  case @total_errors
  when 1
    "#{@total_errors} Error detected".red
  else
    "#{@total_errors} Errors detected".red
  end
end

def show_punctuation
  text = "\nChecking for {}, [] and ()".light_blue
  text.blue unless @error_arr.empty? || @punctation_arr.empty?
  @punctation_arr.map { |hash| hash[:sign] }.each_with_index do |value, index|
    temp = @punctation_arr[index][:result].abs
    "Missing #{temp} #{value} #{@punctation_arr[index][:msg]}"
  end
end

def error_lines
  @lines_to_use = @error_arr.map { |hash| hash[:lpos] }.uniq.sort!
end

def check_valid_file
  text = 'not valid, please choose Good (g) or Bad (b) test file'
  filepath = gets.chomp.to_s
  while check_letter(filepath)
    "#{filepath} #{text}".red
    filepath = gets.chomp.to_s
  end
  filepath.eql?('b') ? 'bad.rb' : 'good.rb'
end

def check_letter(filepath)
  filepath.eql?('b') || filepath.eql?('g') ? false : true
end
