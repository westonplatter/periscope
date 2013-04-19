data = []
r = []
skip_previous_word = nil
last_parsed_line = nil
chains = []
chain = false
counter  = 0

#### load applicable words into array
File.open("./small_words").each_line do |line|
  parsed_line = line.strip.gsub("'", '').downcase
  data << parsed_line if (parsed_line.length > 5 and parsed_line != last_parsed_line)
  last_parsed_line = parsed_line
end

### recursive method
def recursive_chain(data, word)
  keep_going = true
  chain = []
  chain << word

  while keep_going
    total_chars = word.length+1
    last_six = word[(total_chars-5)..(total_chars)]
    # puts "l-#{last_six}"
    exp = Regexp.new("^#{last_six}")

    data.each do |compared_word|
      first_six = compared_word[0..6]
      # puts "f-#{first_six}"
      if (match = first_six.match(exp))
        chain.push(compared_word)
        puts "chain = #{chain}"
        keep_going = true
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
end


### write results to file
File.open("small_results.txt", "w+") do |file|
  chains.each do |c|
    file.write "#{c}\n"
  end
end
