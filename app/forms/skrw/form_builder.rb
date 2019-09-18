class Skrw::FormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper

  def label(attr, text = nil, **options, &block)
    if @object.errors[attr].any?
      options[:class] = (options[:class].to_s + " skrw-label--erroneous").strip
    end
    super(attr, text = nil, **options, &block)
  end

  def text_field(attr, **options)
    render_with_errors(attr) do
      super(attr, options)
    end
  end

  def base_errors
    errors = @object.errors[:base]
    if errors.any?
      @template.content_tag(:div, class: "skrw-form-errors") do
        errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
      end
    end
  end

  def render_with_errors(attr, &block)
    errors = @object.errors[attr]
    if errors.any?
      @template.content_tag(:div, class: "skrw-field--erroneous") do
        output = yield
        output += errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
        output
      end
    else
      yield
    end
  end
end
