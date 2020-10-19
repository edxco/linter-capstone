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