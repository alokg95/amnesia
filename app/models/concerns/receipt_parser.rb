class ReceiptParser

  def initialize()
    @matched_words = []
    @drug_lines = []
    @drug_list = []
    @cleaned_arr = []
    @price_list = []
  end

  def parse_receipt(str)

    numeric = lambda do |char|
      return char =~ /[[:digit:]]/
    end

    get_drug = lambda do |word|
      num_char_common = 0
      most_common_word = nil
      drugs = ["lipitor", "advil", "viagra"]
      drugs.each do |drug|
        in_common = drug.count(word)
        if drug.length == word.length && in_common > num_char_common
          most_common_word = drug
          num_char_common = in_common
          @matched_words << word if num_char_common > word.length/2
        end
      end
      return most_common_word if num_char_common > word.length/2
    end
    
    get_price = lambda do |word|
      @cleaned_arr.each do |input|
        if input.include?(word)
          @drug_lines << input
        end
      end
    end

    input_arr = str.split("\n")
    
    input_arr.each do |input|
      unless input.empty?
        line = input.strip.downcase
        if numeric.call(line[-1]) || numeric.call(line[0])
          if numeric.call(line[1]) || line[1] == " "
            @cleaned_arr << line
          end

        end
      end
    end
    
    @cleaned_arr.each do |input|
      line_arr = input.split(" ")
      word = line_arr[1]
      drug_word = get_drug.call(word)
      @drug_list << drug_word if drug_word
    end

    @matched_words.each do |input|
      get_price.call(input)
      @drug_lines.each do |line|
        if line.include?(input)
          index = line.index(input) + input.length
          price = line[index..line.length].strip.sub(/ /, ".").sub(/[o]/, "0").sub(/[il]/, "1").to_f
          # puts price
          @price_list << price
        end
      end
    end

    list = @drug_list.zip(@price_list).map { |w1, w2| { w1 => w2 } }
    list << { 'date' => @cleaned_arr.last.split.first }

    hash = list.reduce Hash.new, :merge
    hash['pharmacy_name'] = 'CVS'
    hash
  end


end