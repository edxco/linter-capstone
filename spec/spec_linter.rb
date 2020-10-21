require_relative '../lib/errors.rb'

describe LintFile do
  let(:original) { '../bad.rb' }
  let(:file_open) { LintFile.new(original) }

  describe 'File reader #initialize' do
    it 'Returns a file instance' do
      expect(file_open.file.class).to eql(File.open(original).class)
    end
    it "returns a unique instance of an open file as when using Ruby's File class" do
      expect(file_open.lines).not_to eql(File.open(original))
    end
  end

  describe 'Reading and storing lines from file #read' do
    it 'All data is an array' do
      expect(file_open.lines.class).to eql(Array)
    end
    it 'Lines equal to length of array' do
      file_open.read
      expect(file_open.lines.count).to eql(File.open(original).count)
    end
  end

  describe 'Testing punctuation method' do
    it 'Returns an error when are more brackets open' do
      check_error(original)
      expect(@punctation_arr.include?(sign: punct, result: 1, msg: 'to close')).to eql(true)
    end
  end
end
