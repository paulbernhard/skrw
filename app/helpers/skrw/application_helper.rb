module Skrw
  module ApplicationHelper

    def skrw_date(date, time: false)
      date_format = "%d.%m.%Y"
      time_format = "%H:%M:%S"
      format = time ? time_format : date_format
      date.strftime format
    end

    def skrw_timestamps(record, show_created: false)
      dates = ["updated at: #{skrw_date(record.updated_at, time: true)}"]
      dates = ["created at: #{skrw_date(record.created_at, time: true)}"] + dates if show_created
      dates.join(", ")
    end
  end
end
