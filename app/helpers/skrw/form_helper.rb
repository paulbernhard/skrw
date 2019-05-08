module Skrw
  module FormHelper

    def skrw_form_for(object, *args, &block)
      options = args.extract_options!
      simple_form_for(object, *(args << options.merge(builder: Skrw::FormBuilder)), &block)
    end
  end
end
