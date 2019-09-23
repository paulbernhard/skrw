class Skrw::FormBuilder < ActionView::Helpers::FormBuilder

  # field wrapper with label and error messages
  def field(attr, desc = nil, **options, &block)
    options[:class] = "#{options[:class]} skrw-field".strip

    # add erroneous class
    object_errors = @object.errors[attr]
    options[:class] += " skrw-field--erroneous" if object_errors.any?

    # build output
    output = "".html_safe
    output += self.label(attr, desc) unless desc.nil?
    output += @template.capture(&block)
    output += self.errors(object_errors) if object_errors.any?


    @template.content_tag(:div, options) do
      output.html_safe
    end
  end

  def label(attr, text = nil, options = {}, &block)
    if text
      presence_validators = @object.class.validators.select { |v| v.is_a?(ActiveRecord::Validations::PresenceValidator) && v.attributes.include?(attr) }
      text += " *" if presence_validators.any?
    end

    super(attr, text, options, &block)
  end

  # field errors
  def errors(errors = [])
    @template.content_tag(:div, class: "skrw-errors") do
      errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
    end
  end

  # base errors
  def base_errors
    errors = @object.errors[:base]
    if errors.any?
      @template.content_tag(:div, class: "skrw-form-errors") do
        errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
      end
    end
  end

  # dynamic nested fields
  def dynamic_fields_for(association, &block)
    # create template fields for new association and pass
    # ff as block argument to the yield in a partial
    new_association = association.to_s.classify.constantize.new

    template = self.fields_for(association, new_association, child_index: "NEW_RECORD") do |ff|
      @template.render(layout: "skrw/forms/dynamic_nested_fields",
        locals: { ff: ff, association: association, template: true }) do
          @template.capture(ff, &block)
      end
    end

    # create fields for association and pass ff as
    # block argument to the yield in a partial
    fields = self.fields_for(association) do |ff|
      @template.render(layout: "skrw/forms/dynamic_nested_fields",
        locals: { ff: ff, association: association }) do
          @template.capture(ff, &block)
      end
    end

    # concat template and fields and return in a content_tag
    @template.content_tag(:div,
      class: "skrw-nested-fields skrw-nested-fields--dynamic",
      data: { controller: "skrw-nested-fields" }) do
        @template.concat template
        @template.concat fields
        @template.concat @template.link_to("Add", "#",
          data: { action: "click->skrw-nested-fields#add" }, class: "skrw-control")
    end
  end
end
