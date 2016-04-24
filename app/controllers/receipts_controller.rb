class ReceiptsController < ApplicationController
  def create
    puts params
    drugs = ["lipitor", "advil", "viagra"]


    render :create
  end

  def index

  end
end

# CVS\n\npharmacy\n\n400 HOLLISTER AVE, GOLETA, CA\nPHARMACY\n\n‘ LIPlTOR 7 99\n\n2 HITZ 12 99\n\n1 ADVIL 1o 99\n\n4 ITEMS\nSUBTOTAL 3x97\nTAX s 27% ‘ 94\nCASH 34.00\nCHANGE ,10\n\n \n\n04/11/15 420 PM\n\nTHANK VOU. SHOP 24 HOURS AT QﬁQOM\n\n
