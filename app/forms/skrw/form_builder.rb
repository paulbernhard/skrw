module Skrw
  class FormBuilder < SimpleForm::FormBuilder

    def buttons(**options, &block)
      options[:class] = "#{options[:class]} #{Skrw.form_class}__control--buttons".strip
      @template.content_tag :div, options do
        yield if block_given?
      end
    end
  end
end
