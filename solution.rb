# Programming Quiz for Periscope
# Weston Platter (westonplatter@gmail.com)
#

chain_store = []
data_subsets = {}

load_counter = 0
CUT_WORD_LENGTH = 6

time_start = Time.new


### Load Strings greater than 5 characters into Hash organized array subsets, IE,
#
#   data_subsets = { "aaa" => ["aaabbb", "aaaccc"],
#                    "bbb" => ["bbbeee", "bbbfff", "bbbggg"],
#                    # ... more arrays ...
#                    "zzz" => ["zzzwww", "zzzxxx"]
#                  }
#
# This is a trivial optimization to make the program run faster.
#
File.open("./words").each_line do |line|
  # do not pay attention to uppercase/downcase
  parsed_line = line.strip.downcase

  if parsed_line.length > (CUT_WORD_LENGTH-1)
    hash_key = parsed_line.match(/.../).to_s
    data_subsets["#{hash_key}"] = [] unless data_subsets["#{hash_key}"]

    data_subsets[hash_key] << parsed_line
    chain_store << [parsed_line]

    load_counter += 1
  end
end
puts "words = #{load_counter}"
puts "Hash contains #{data_subsets.count} array subsets\n\n"


### For a given word, get next words in chain. Returns empty array of no next words.
def next_words(word, data_subsets)
  total_chars = word.length
  last_six = word[(total_chars - CUT_WORD_LENGTH)..(total_chars)]
  exp = Regexp.new("^#{last_six}")

  result = []

  hash_key = last_six.match(/.../).to_s
  data_subset_for_word = data_subsets[hash_key]
  return [] if data_subset_for_word.nil?

  data_subset_for_word.each do |compared_word|
    if compared_word.match(exp)
      if compared_word != word
        result << compared_word
      end
    end
  end
  result
end


### Main iterator
iterations = 0
maxes = []

while chain_store.count > 1

  chain_store.each_with_index do |chain_store_element, index|
    word = chain_store_element.last
    next_chain_words = next_words(word, data_subsets)

    if next_chain_words.count > 0
      next_chain_words.each do |chain_word|
        ne = Array.new(chain_store_element) << chain_word
        chain_store << ne

        # decided to go fast and hard code when to record maxes.
        # this could be made to dynamically capture new maxes if needed.
        maxes << ne if ne.count > 8
      end
    end

    # since we want this to be fast ...
    # delete (array element) since we added (array element + next chain word)
    chain_store.delete_at(index)
  end

  puts "iteration = #{iterations}, word chains = #{chain_store.count}"
  iterations += 1
end

puts "\nTime to run = #{Time.new - time_start}\n\n"
maxes.each do |max|
  puts "#{max}"
end
