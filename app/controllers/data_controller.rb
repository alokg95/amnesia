class DataController < ApplicationController
  def purchase_info
    @total_purchases = 0
    @goodrx_total = 0
    Receipt.all.each do |receipt|
      # if receipt.pharmacy_name != "goodrx"
      #   total_purchases
      # end
      receipt.drugs.each do |drug|
        @goodrx_total += drug.price if drug.vendor == "goodrx"
        @total_purchases += drug.price
      end
    end
    render :info and return
  end

end
