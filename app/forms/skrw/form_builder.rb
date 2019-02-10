module Skrw
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    # fields and labels
    #
    # skrw wrappers for basic label and field methods
    # available methods are:
    # 
    # label, text_field, email_field, password_field, date_field, 
    # time_field, datetime_field, number_field, phone_field, 
    # search_field, text_area

    %w(text_field email_field password_field date_field time_field datetime_field number_field phone_field search_field text_area).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(method, options = {})
          super(method, insert_class('s-form__control', options))
        end
      RUBY_EVAL
    end

    %w(date_select time_select datetime_select).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(method, options = {}, html_options = {})
          @template.content_tag(:div, class: 's-form__select-group') do
            super(method, options, insert_class('s-form__control', html_options))
          end
        end
      RUBY_EVAL
    end

    def select(method, choices = nil, options = {}, html_options = {})
      super(method, choices, options, insert_class('s-form__control', html_options))
    end

    def label(method, text = nil, **options)
      super(method, text, insert_class("s-form__label", options))
    end

    # group wrappers for label and control groups
    # renders errors for respective field if method is given and with_errors = true (default)
    # the following are identical
    #
    # group(:title, true, **options) do
    #   label(:title, "Title")
    #   text_field(:title)
    # end
    #
    # label_group(:title, "Title", true, label_options: {}, **options) do
    #   text_field(:title)
    # end
    #
    # label_text_field(:title, "Title", true, label_options: {}, field_options: {}, **options)

    def group(method = nil, with_errors = true, **options, &block)
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

    def label_group(method, text = nil, with_errors = true, label_options: {}, **options, &block)
      group(method, with_errors, options) do
        body = label(method, text, label_options)
        body += @template.capture(&block)
        body
      end
    end

    %w(text_field email_field password_field date_field time_field datetime_field number_field phone_field search_field text_area).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def label_#{selector}(method, text = nil, with_errors = true, label_options: {}, field_options: {}, **options)
          # super(method, insert_class('s-form__control', options))
          label_group(method, text, with_errors, label_options) do
            selector = __method__.to_s.gsub('label_', '').to_sym
            send(selector, method, field_options)
          end
        end
      RUBY_EVAL
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