module Skrw
  module FormHelper

    def skrw_form_errors(form)
      if form.object.errors.any?
        render "skrw/shared/errors", object: form.object
      end
    end
  end
end
