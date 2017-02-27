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
	attr_accessor :graph

	def initialize(filename, ngram)
		@filename = filename
		@ngram = ngram
		@graph = {}
	end

	def get_sample_text(sample_text=@filename)
		full_text = []
		File.open(sample_text) do |file|
			file.each do |line|
				full_text.concat(line.gsub(/[.,!'‘’“”"?_\-;:()]/, " ").strip.downcase.split)
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

			cum_prob = 0.0
			frequencies.each do |key, value|
				frequencies[key] = cum_prob + (Float(value)/Float(total)) * 100.0
				cum_prob = frequencies[key]
			end
		end
		@graph = markov_list
		return markov_list
	end
end


parser.parse!
work = MarkovBot.new(options[:filename], options[:ngram])
# ap work.create_markov_graph(), :indent => -2
work.create_markov_graph()

rng = Random.new

while true
	ed_speak = []
	number = gets.chomp.to_i

	if number < 3
		puts "Please pick a number greater than 2."
	else
		# pick a random word to start
		ed_speak << work.graph.keys.sample
		number.times do
			next_possible_words = work.graph[ed_speak.last]
			break if next_possible_words.nil?
			random_number = rng.rand(100.0)
			winner_word = ''
			next_possible_words.each do |key, value|
				winner_word	= key
				if random_number < value
					break
				end
			end
			ed_speak << winner_word
		end
		puts "Ed says: #{ed_speak.join(" ").capitalize}."
  end 

end
