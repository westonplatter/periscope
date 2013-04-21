chain_store = []
data_subsets = {}
load_counter = 0
CUT = 6

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

  if parsed_line.length > (CUT-1)
    hash_key = parsed_line.match(/.../).to_s
    data_subsets["#{hash_key}"] = [] unless data_subsets["#{hash_key}"]

    data_subsets[hash_key] << parsed_line
    chain_store << [parsed_line]

    load_counter += 1
  end
end
puts load_counter
puts data_subsets.count


### get words in chain for a word
def next_words(word, data_subsets)
  total_chars = word.length
  last_six = word[(total_chars - CUT)..(total_chars)]
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


### main iterator
hh = 0
max = 0
transfer = []
while chain_store.count > 1
  time_start = Time.new

  chain_store.each_with_index do |chain_store_element, index|
    word = chain_store_element.last
    next_chain_words = next_words(word, data_subsets)

    if next_chain_words.count > 0
      next_chain_words.each do |chain_word|
        ne = Array.new(chain_store_element) << chain_word
        # puts "#{ne.count} #{chain_word} - #{ne.to_s}" if ne.count > 8
        puts "#{ne.count} - #{ne.to_s}" if ne.count > 8
        chain_store << ne

        if chain_store_element.count >= max
          max = chain_store_element.count
          if max > 3
            File.open("max_#{max}.txt", "w+") do |file|
              chain_store.each do |word_chain|
                file.write "#{word_chain.to_s}\n"
              end
            end
          end
        end
      end
    end

    chain_store.delete_at(index)
  end




  # puts "# word chains = #{chain_store.count}"
  # puts "time split = #{Time.new - time_start}"
  # puts "\n"
end


### write results to file
# File.open("small_results.txt", "w+") do |file|
#   file.write("-- results\n")
#   chain_store.each do |word_chain|
#     file.write "#{word_chain.to_s}\n"
#   end

#   puts "\n\n"
# end
