require "receipt_parser"
require "date"

class Receipt < ActiveRecord::Base
  has_many :drugs
  
  def self.from_ocr_content(content)
    drugs_hash = ReceiptParser.new.parse_receipt content
    drugs = drugs_hash.map do |key, value| 
      if value.is_a? Float 
        Drug.create(name: key, price: value)
      end
    end
    date = DateTime.parse drugs_hash['date']
    pharmacy = drugs_hash['pharmacy_name']
    receipt = Receipt.new(pharmacy_name: pharmacy_name, date: date)
    receipt.drugs << drugs
    receipt
  end
end
