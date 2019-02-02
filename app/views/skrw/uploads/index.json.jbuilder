json.array! @uploads do |upload|
  json.body(render(partial: 'skrw/uploads/form', locals: { upload: upload }, formats: [:html]))
end