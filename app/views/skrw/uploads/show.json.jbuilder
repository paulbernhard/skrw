json.upload do
  json.extract!(@upload, :id, :file_data, :uploadable_type, :uploadable_id, :created_at, :updated_at)
end

json.html(render(partial: 'skrw/uploads/upload', locals: { upload: @upload }, formats: [:html]))