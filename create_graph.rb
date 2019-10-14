

def get_sample_text()
	full_text = []

	Dir.chdir("/Users/ookami/eBooks")

	file_list = Dir.glob(File.join("**", "*.txt"))

	# stat_hash = Hash.new(0)
	file_list.each do | filename |
		File.open(filename).each do |line|
			# stat_hash[line.valid_encoding?] = stat_hash[line.valid_encoding?] + 1 
 			full_text.concat((line.scrub).gsub(/[.,!'‘’“”"?_\-;:()]/, " ").strip.downcase.split)
		end
	end

	return full_text
end

def create_markov_graph(word_list=get_sample_text(), ngram=2)
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
	file_store = File.new("markov_graph.txt", "w")
	file_store.puts(markov_list)
	file_store.close()

	return markov_list
end

get_sample_text()