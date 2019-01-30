json.errors do
  json.array!(@object.errors)
end

json.html(render partial: 'skrw/shared/errors', locals: { object: @object }, formats: [:html])