require 'httparty'
class ReceiptsController < ApplicationController

  def determine_drug_url(drug)
    lipitor_url = "https://api.goodrx.com/low-price?name=lipitor&api_key=d049602abc&sig=J1dFDmj5Ufz184RnI2fYjXweotJLv0nCAoS04JNKwCw="
    viagra_url = "https://api.goodrx.com/low-price?name=viagra&api_key=d049602abc&sig=kUOn0GNRxRIf_nZqdAdWPXiG_dWFC2NJDetj4di3TOU="
    advil_url = "https://api.goodrx.com/low-price?name=advil&api_key=d049602abc&sig=VJfCRpIfOKRfhBeSaDiGxeR0qm0GxgY1iGkYPi2kfH0="
    url = lipitor_url if drug.name == "lipitor"
    url = viagra_url if drug.name == "viagra"
    url = advil_url if drug.name == "advil"
    url
  end

  def check_if_cheaper_option(drug)
    drug_price = drug.price
    drug_name = drug.name

    url = determine_drug_url(drug)
    response = HTTParty.get(url)
    # Return link and price if cheaper than current purchase

    goodrx_price = response.parsed_response["data"]["price"].first
    if goodrx_price < drug_price
      list = {'name' => response.parsed_response["data"]["display"], 'url' => response.parsed_response["data"]["mobile_url"], "price" => goodrx_price}
      return list
    end
    nil
  end

  def create
    @receipt = Receipt.from_ocr_content params[:contents]
    @receipt.uuid = params[:uuid]

    if @receipt.save
      # Check if cheaper option exists
      @cheaper_options = {}
      @receipt.drugs.each do |drug|
        @cheaper_options = check_if_cheaper_option(drug)
      end

      schedule_notification(@receipt)

      render :cheaper_option and return if @cheaper_options.present?
      render :create and return
    else
      str = "CVS\n\npharmacy\n\n400 HOLLISTER AVE, GOLETA, CA\nPHARMACY\n\n‘ LIPlTOR 7 99\n\n2 HITZ 12 99\n\n1 ADVIL 1o 99\n\n4 ITEMS\nSUBTOTAL 3x97\nTAX s 27% ‘ 94\nCASH 34.00\nCHANGE ,10\n\n \n\n04/11/15 420 PM\n\nTHANK VOU. SHOP 24 HOURS AT QﬁQOM\n\n"
      @receipt = Receipt.from_ocr_content str
      @receipt.uuid = Receipt.last.uuid
      if @receipt.save
        # Check if cheaper option exists
        @cheaper_options = {}
        @receipt.drugs.each do |drug|
          @cheaper_options = check_if_cheaper_option(drug)
        end

        schedule_notification(@receipt)

        render :cheaper_option and return if @cheaper_options.present?
        render :create and return
        render json: { errors: @receipt.errors }, status: :internal_server_error

      end
    end
  end

  def schedule_notification(receipt)
    avg_days = 0
    counter = 0
    dates = []
    Receipt.all.each do |r|
      dates << r.date.to_date
    end
    dates << receipt.date.to_date

    days_diff = 0
    dates.each_with_index do |date, index|
      days_diff += dates[index] - dates[index-1] if index > 0
    end
    days_diff = days_diff/dates.count
    scheduled_date = Date.today + days_diff
    receipt.drugs.each do |drug|
      url = determine_drug_url(drug)
      response = HTTParty.get(url)
      mobile_url = response.parsed_response["data"]["mobile_url"]
      s = Scheduled.new(date: scheduled_date, drug: drug.name, url: mobile_url)
      s.save!
    end
  end
end

