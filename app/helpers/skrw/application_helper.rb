module Skrw
  module ApplicationHelper

    def skrw_date(date, time: false)
      format = "%d.%m.%Y"
      format += " - %H:%M:%S" if time
      date.strftime format
    end

    def skrw_timestamps(record, show_created: false)
      dates = ["updated at: #{skrw_date(record.updated_at, time: true)}"]
      dates = ["created at: #{skrw_date(record.created_at, time: true)}"] + dates if show_created
      dates.join(", ")
    end
  end
end
