module Skrw
  module FormHelper

    def skrw_form_for(object, *args, &block)
      options = args.extract_options!
      options.merge!({ builder: Skrw::FormBuilder, class: Skrw.form_class,
        data: { controller: "skrw--form" } })
      simple_form_for(object, *(args << options), &block)
    end

    def skrw_form_errors(form)
      if form.object.errors.any?
        render "skrw/shared/errors", object: form.object
      end
    end
  end
end
