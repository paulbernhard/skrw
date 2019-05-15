module Skrw
  class FormBuilder < SimpleForm::FormBuilder

    def buttons(**options, &block)
      options[:class] = "#{options[:class]} #{Skrw.form_class}__control #{Skrw.form_class}__control--buttons".strip
      @template.content_tag :div, options do
        yield if block_given?
      end
    end

    def dynamic_fields_for(form, record_name, partial: nil, add_label: "Add", delete_label: "Delete", **options)
      @template.render "skrw/forms/dynamic_fields_for", form: form, record_name: record_name, partial: partial,
        add_label: add_label, delete_label: delete_label
    end

    def nested_field(**options, &block)
      options[:class] = "#{options[:class]} #{Skrw.form_class}__nested-fields__field".strip
      @template.content_tag :div, options do
        yield if block_given?
      end
    end
  end
end
