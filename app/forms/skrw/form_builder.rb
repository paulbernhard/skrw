module Skrw
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    # label and form controls
    #
    # form.label(:title, "Title", class: "form-label")
    # form.control(:title, :text_field, class: "form-text-field")

    def label(method, text = nil, **options)
      insert_class("s-form__label", options)
      super(method, text, options)
    end

    def control(method, field_type, **options)
      insert_class("s-form__control", options)
      send(field_type, method, options)
    end

    # group and label_group as wrappers for label and control
    # can show errors for the field if method is given and with_errors: true
    # 
    # the following two groups do the same
    #
    # form.group(:title, with_errors: true) do
    #   form.label(:title, "Title")
    #   form.text_field(:title)
    # end
    #
    # form.label_group(:title, :text_field, "Title", with_errors: true)

    def group(method = nil, with_errors: true, **options, &block)
      insert_class("s-form__group", options)

      if method && with_errors && @object.errors.include?(method)
        insert_class("s-form__group--with-errors", options)
      end

      @template.content_tag(:div, options) do
        body = @template.capture(&block)
        body += errors(method) if method && with_errors
        body
      end
    end

    def label_group(method, field_type, text = nil, label_options: {}, field_options: {}, **options)
      group(method, options) do
        body = label(method, text, label_options)
        body += control(method, field_type, field_options)
      end
    end

    # error messages for the whole form object or a specific key
    # 
    # form.errors => div with all object errors
    # form.errors(:title) => div with object errors on :title

    def errors(method = nil, **options)
      messages = method.nil? ? @object.errors.full_messages : @object.errors.full_messages_for(method)

      if messages.any?
        insert_class("s-form__errors", options)
        @template.content_tag(:div, options) do
          messages.map { |msg| @template.content_tag(:div, msg) }.join("").html_safe
        end
      end
    end

    def handlers(**options)
      insert_class("s-form__handlers", options)
      @template.content_tag(:div, options) do
        yield
      end
    end

    private

      def insert_class(class_name, options)
        options[:class] = options[:class].to_s + " #{class_name}"
        options[:class].strip!
        options
      end

  end
end