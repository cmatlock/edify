require 'optparse'


options = {:filename => "sample_text.txt", :ngram => 2}

parser = OptionParser.new do |opts|
	opts.banner = "Usage: edify.rb [run|graph] [options]"

	opts.on('-f', '--filename [filename]', 'Filename of sample text file') do |filename|
		options[:filename] = filename
	end
	opts.on('-n', '--ngram [INTEGER]', Integer, 'N-gram') do |ngram|
		options[:ngram] = ngram
	end

	opts.on('-h', '--help', 'Displays this help text') do 
		puts opts
		exit
	end

	opts.on()
end


parser.parse!
command = ARGV.pop

# run bot
# create graph

case command
	when "run"
		puts "Running"
	when "create"
		puts "Creating"
	else
		puts "Uh...nothing"
end


raise "I need to know what to do, Eddy!" unless command
# work = MarkovBot.new(options[:filename], options[:ngram])