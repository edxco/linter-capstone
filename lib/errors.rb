require 'strscan'
require_relative 'file_read.rb'
require_relative 'colors.rb'
def check_error(filepath)
  @file_to_check = LintFile.new(filepath)
  @file_to_check.read
  @punctation_arr, @error_arr, @lines_empty, @tags = Array.new(4) { [] }
  @double_empty_line = []
  @pos_white = 0

  lines_empty
  double_empty_line

  check_loop
end

def check_loop
  @file_to_check.lines.length.times do |line|
    indentation(line)
    trailing_whitespace(line)
    whitespace(line)
    count_tags(line)
    position_whitespace(line)
  end
  tags_results
end

def whitespace(line)
  text = 'Excess Whitespace Detected'
  return if @lines_empty.include?(line + 1)
  pos = @file_to_check.lines[line].string.gsub(/ {2,}/).map { |_, _arr| Regexp.last_match.begin(0) }
  # rubocop:enable Metrics/LineLength
  pos.shift if pos[0].nil? || pos[0].zero?
  @error_arr.push(lpos: line + 1, msg: text, offset: pos) unless pos[0].nil?
end
# rubocop:enable Metrics/AbcSize

def trailing_whitespace(line)
  text = 'Trailing Whitespace Detected'
  return if @lines_empty.include?(line + 1)
  pointer = @file_to_check.lines[line].string.length
  return unless @file_to_check.lines[line].string.reverse[0..1].match?(/ {1,}/)
  @error_arr.push(lpos: line + 1, msg: text, offset: pointer)
end

def position_whitespace(line)
  pos = @file_to_check.lines[line].string
  pos.gsub(/^\s*/i).map { |_, _arr| Regexp.last_match.end(0) }
end

def indentation(line)
  return if @lines_empty.include?(line + 1)
  text = 'Indentation Error Detected'
  pos = position_whitespace(line)
  test_end(line)
  @error_arr.push(lpos: line + 1, msg: text, offset: pos[0]) if pos[0] != @pos_white
  test_def(line)
end

def test_def(line)
  @pos_white = 2 if @file_to_check.lines[line].string =~ /\bdef\b/i
end

def test_end(line)
  @pos_white = 0 if @file_to_check.lines[line].string =~ /\bend\b/i
end

def lines_empty
  @file_to_check.lines.length.times do |line|
    @lines_empty << line + 1 if @file_to_check.lines[line].string.strip.empty?
  end
end

def double_empty_line
  text_msg = 'Double or more empty lines'
  @lines_empty.each_with_index do |x, y|
    if x == @lines_empty[y - 1] + 1
      @double_empty_line << @lines_empty[y]
      @error_arr.push(lpos: @lines_empty[y], msg: text_msg, offset: nil)
    end
  end
end

def count_tags(line)
  @tags << @file_to_check.lines[line].string.scan(/\p{Ps}/)
  @tags << @file_to_check.lines[line].string.scan(/\p{Pe}/)
end

def tags_results
  @tags.flatten!
  curly_o_count = @tags.count('{')
  parenthesis_o_count = @tags.count('(')
  brackets_o_count = @tags.count('[')

  curly_c_count = @tags.count('}')
  parenthesis_c_count = @tags.count(')')
  brackets_c_count = @tags.count(']')

  compare(brackets_o_count, brackets_c_count, 'Brackets []')
  compare(parenthesis_o_count, parenthesis_c_count, 'Parenthesis ()')
  compare(curly_o_count, curly_c_count, 'Curly {}')
end

def compare(open, close, punct)
  result = open - close
  case result
  when (-10_000..-1)
    @punctation_arr.push(sign: punct, result: result, msg: 'to open')
  when (1..10_000)
    @punctation_arr.push(sign: punct, result: result, msg: 'to close')
  end
end
# rubocop:enable Metrics/LineLength
