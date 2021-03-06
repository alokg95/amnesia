require "receipt_parser"
require "date"
require "base64"

class Receipt < ActiveRecord::Base
  has_many :drugs
  
  def self.from_ocr_content(content)
    drugs_hash = ReceiptParser.new.parse_receipt content
    drugs = drugs_hash.map do |key, value| 
      if value.is_a? Float
        Drug.new(name: key, price: value, vendor: drugs_hash["pharmacy_name"])
      end
    end
    date = DateTime.strptime("04/11/15", "%m/%d/%y")
    pharmacy = drugs_hash['pharmacy_name']
    receipt = Receipt.new(pharmacy_name: pharmacy, date: date)
    receipt.drugs << drugs.compact
    receipt
  end
end
