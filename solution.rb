chain_store = []
chain_store_transfer = []

data_subsets = {}
load_counter = 0

### load applicable words into array
File.open("./words").each_line do |line|
  # do not pay attention to uppercase/downcase
  parsed_line = line.strip.downcase

  # do not include words that:
  # 1) contain apostrophes
  # 2) are less than 6 letters
  if (parsed_line.length > 5) and ( !parsed_line.include?("'") )
    first_letter = parsed_line.match(/./).to_s
    data_subsets["#{first_letter}"] = [] unless data_subsets["#{first_letter}"]

    data_subsets[first_letter] << parsed_line
    chain_store << [parsed_line]

    load_counter += 1
  end
end
puts load_counter


### recursive method called by main iterator
def next_words(word, data_subsets)
  total_chars = word.length
  last_six = word[(total_chars-6)..(total_chars)] # move this to regex
  # puts "last_six=#{last_six}"
  exp = Regexp.new("^#{last_six}")

  result = []

  first_char = last_six.match(/./).to_s
  # puts first_char
  data_subset_for_word = data_subsets[first_char]
  return [] if data_subset_for_word.nil?

  data_subset_for_word.each do |compared_word|
    if compared_word.match(exp)
      if compared_word != word
        # puts "word = #{word}"
        # puts "compared word = #{compared_word}"
        result << compared_word
      end
    end
  end
  result
end


### main iterator
hh = 0
while chain_store.count > 5

  chain_store.each do |chain_store_element|
    word = chain_store_element.last
    next_chain_words = next_words(word, data_subsets)

    if next_chain_words.count > 0
      next_chain_words.each do |chain_word|
        chain_store_transfer << chain_store_element.push(chain_word)
        # puts "chain_store_transfer = #{chain_store_transfer}"
      end
    end
    hh+=1
    puts hh if hh % 1000 == 0
  end


  puts "# word chains = #{chain_store.count}"
  chain_store = chain_store_transfer

  # puts "chain_store = #{chain_store}"
  # puts ""
  # puts chain_store.count
end


### write results to file
File.open("small_results.txt", "w+") do |file|
  chain_store.each do |word_chain|
    file.write "#{word_chain}\n"
  end
end
