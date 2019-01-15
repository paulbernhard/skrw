module Skrw
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    # Errors

    def errors(**options)
      object.errors.add(:title, "something wroong")
      if object.errors.any?
        @template.content_tag(:ul, insert_class("#{base_class}errors", options)) do
          messages = ""
          object.errors.full_messages.each { |msg| messages += error(msg) }
          messages.html_safe
        end
      end
    end

    def error(message)
      content_tag(:li, message, class: "#{base_class}error")
    end

    # Rows and Groups

    def row(**options, &block)
      @template.content_tag(:div, insert_class("#{base_class}row", options)) { yield if block_given? }
    end

    def group(method, **options, &block)
      class_names = "#{base_class}group"
      class_names += " #{base_class}group--with-errors" if object.errors.has_key?(method)

      @template.content_tag(:div, insert_class("#{class_names}", options)) do
        yield if block_given?
      end
    end

    def label_group(method, text = nil, field_type, field_options: {}, **options)
      group(method, options) do
        label(method, text) + send(field_type, method, field_options)
      end
    end

    # Labels and Fields

    # def label(method, text = nil, **options, &block)
    #   super(method, text, insert_class("#{base_class}label", options))
    # end

    # def text_field(method, **options)
    #   super(method, options)
    # end

    # def email_field(method, **options)
    #   super(method, options)
    # end

    # def password_field(method, **options)
    #   super(method, options)
    # end

    def controls(**options, &block)
      @template.content_tag(:div, insert_class("#{base_class}controls", options)) { yield if block_given? }
    end

    private

      def insert_class(class_name, options = {})
        output = options
        output[:class] = ("#{class_name} " + (output[:class] || "")).strip
        output
      end

      def base_class
        "skrw-form__"
      end
  end
end