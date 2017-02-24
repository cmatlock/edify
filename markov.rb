require 'ap'

require 'optparse'

options = {:filename => "sample_text.txt", :ngram => 2}

parser = OptionParser.new do |opts|
	opts.banner = "Usage: markov.rb [options]"

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
end


class MarkovBot
	def initialize(filename, ngram)
		@filename = filename
		@ngram = ngram
	end

	def get_sample_text(sample_text=@filename)
		full_text = []
		puts "Creating text list"
		File.open(sample_text) do |file|
			file.each do |line|
				full_text.concat(line.strip.downcase.split)
			end
		end

		return full_text
	end

	def create_markov_graph(word_list=get_sample_text(), ngram=@ngram)
		markov_list = {}

		# Collect word frequencies
		word_list.each_cons(ngram) do |current_words|
			first = current_words.take(ngram-1).join(" ")
			second = current_words[-1]
			if markov_list.has_key?(first)
				if markov_list[first].has_key?(second)
					markov_list[first][second] = markov_list[first][second].next
				else
					markov_list[first][second] = 1
				end
			else
				markov_list[first] = {second => 1}
			end

		end

		# Calculate percentages

		markov_list.each do |word, frequencies|
			total = 0
			frequencies.each_value do |value|
				total = total + value
			end

			frequencies.each do |key, value|
				frequencies[key] = (Float(value)/Float(total)) * 100.0
			end
		end

		puts "Graph completed"
		return markov_list
	end
end


parser.parse!
work = MarkovBot.new(options[:filename], options[:ngram])
work.create_markov_graph()

ap work.create_markov_graph(), :indent => -2