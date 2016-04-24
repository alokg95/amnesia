class ReceiptParser

  def self.parse_receipt(str)

    def numeric?(char)
      char =~ /[[:digit:]]/
    end


    @matched_words = []
    def get_drug(word)
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
    @drug_lines = []

    def get_price(word)
      @cleaned_arr.each do |input|
        if input.include?(word)
          @drug_lines << input
        end
      end
    end

    input_arr = str.split("\n")
    @cleaned_arr = []
    input_arr.each do |input|
      unless input.empty?
        line = input.strip.downcase
        if numeric?(line[-1]) || numeric?(line[0])
          if numeric?(line[1]) || line[1] == " "
            @cleaned_arr << line
          end

        end
      end
    end
    @drug_list = []
    @cleaned_arr.each do |input|
      line_arr = input.split(" ")
      word = line_arr[1]
      drug_word = get_drug(word)
      @drug_list << drug_word if drug_word
    end

    @price_list = []
    @matched_words.each do |input|
      get_price(input)
      @drug_lines.each do |line|
        if line.include?(input)
          index = line.index(input) + input.length
          price = line[index..line.length].strip.sub(/ /, ".").sub(/[o]/, "0").sub(/[il]/, "1")
          # puts price
          @price_list << price
        end
      end
    end

    list = @drug_list.zip(@price_list).map { |w1, w2| { w1 => w2 } }
  end


end