class DataController < ApplicationController
  def purchase_info
    @total_purchases = 0
    @advil_total = 0
    @viagra_total = 0
    @lipitor_total = 0
    @goodrx_total = 0
    Receipt.all.each do |receipt|
      # if receipt.pharmacy_name != "goodrx"
      #   total_purchases
      # end
      receipt.drugs.each do |drug|
        @goodrx_total += drug.price if drug.vendor == "goodrx"
        @total_purchases += drug.price
        @advil_total += drug.price if drug.name == "advil"
        @lipitor_total += drug.price if drug.name == "lipitor"
        @viagra_total += drug.price if drug.name == "viagra"
      end
    end
    render :info and return
  end

end
