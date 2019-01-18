module Skrw
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    # form error messages for all object errors
    # or specific key errors such as :title
    def errors(errors_for = nil)
      messages = errors_for.nil? ? @object.errors.full_messages : @object.errors.full_messages_for(errors_for)

      if messages.any?
        @template.content_tag(:ul, class: "#{base_class}errors") do
          output = "".html_safe
          messages.each do |message|
            output << content_tag(:li, message, class: "#{base_class}error")
          end
          output
        end
      else
        return ""
      end
    end

    # form row wrapper
    def row(**options, &block)
      @template.content_tag(:div, insert_class("#{base_class}row", options)) { yield if block_given? }
    end

    # form group wrapper
    def group(method, **options, &block)
      class_names = "#{base_class}group"
      class_names += " #{base_class}group--with-errors" if @object.errors.has_key?(method)

      @template.content_tag(:div, insert_class("#{class_names}", options)) do
        output = "".html_safe
        output << yield if block_given?
        output
      end
    end

    # output a labeled form group for a method with a field_type
    # field-specific error messages can be added with 'with_erros: true'
    # label_group(:title, :text_field, with_errors: true)
    def label_group(method, text = nil, field_type, field_options: {}, with_errors: false, **options)
      group(method, options) do
        output = "".html_safe
        output << errors(method) if with_errors
        output << label(method, text) # label method
        output << send(field_type, method, field_options) # field method according to field_type
        output
      end
    end

    # form controls wrapper
    def controls(**options, &block)
      @template.content_tag(:div, insert_class("#{base_class}controls", options)) do
        yield if block_given?
      end
    end

    private

      def insert_class(class_name, options = {})
        output = options
        output[:class] = ("#{class_name} " + (output[:class] || "")).strip
        output
      end

      def base_class
        Skrw.form_css_base_class + "__"
      end
  end
end