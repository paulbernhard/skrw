module Skrw
  module ApplicationHelper

    def date(date, time: false)
      date_format = "%d.%m.%Y"
      time_format = "%H:%M:%S"
      format = time ? time_format : date_format
      date.strftime format
    end

    def timestamps(record, show_created: false)
      dates = ["updated at: #{date(record.updated_at, time: true)}"]
      dates = ["created at: #{date(record.created_at, time: true)}"] + dates if show_created
      dates.join(", ")
    end
  end
end
