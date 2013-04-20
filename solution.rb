data = []
chains = []
counter  = 0

### load applicable words into array
File.open("./words").each_line do |line|
  # do not pay attention to uppercase/downcase
  parsed_line = line.strip.downcase

  # do not include words that:
  # 1) contain apostrophes
  # 2) are less than 6 letters
  data << parsed_line if (parsed_line.length > 5 and !parsed_line.include?("'"))
end
puts data.length

### recursive method called by main iterator
def recursive_chain(data, word)
  keep_going = true
  chain = []
  chain << word

  # loop through whole word list for a given word to find word "chain"
  while keep_going
    data.each do |compared_word|
      total_chars = word.length
      last_six = word[(total_chars-6)..(total_chars)]
      # puts "l-#{last_six}"
      exp = Regexp.new("^#{last_six}")

      first_six = compared_word[0..5]
      # puts "f-#{first_six}"
      if (first_six.match(exp) and word != compared_word)
        chain.push(compared_word)
        # puts "chain = #{chain}"
        word = compared_word
      else
        keep_going = false
      end
    end
  end

  # puts "\n"

  if chain.length > 1
    return chain
  else
    return false
  end
end


### main iterator
data.each_with_index do |word, index|
  t = recursive_chain(data, word)
  chains.push(t) if t
  puts "#{index}" if index % 500 == 0
end


### write results to file
File.open("results.txt", "w+") do |file|
  chains.each do |c|
    file.write "#{c}\n"
  end
end
