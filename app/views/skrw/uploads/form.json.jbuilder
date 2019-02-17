json.html(render partial: 'skrw/uploads/form', locals: { upload: @upload }, formats: [:html])

if flash.any?
  json.flash(render partial: 'skrw/shared/flash', formats: [:html])
end