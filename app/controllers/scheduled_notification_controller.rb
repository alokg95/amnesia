class ScheduledNotificationController < ApplicationController
  def check
    @notification = Scheduled.last
    render :check and return
  end

end
