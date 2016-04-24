require "receipt_parser"

class Receipt < ActiveRecord::Base
  has_many :drugs
  
  def self.from_ocr_content(content)
    drug_hash = ReceiptParser.new.parse_receipt content
    
  end
end
