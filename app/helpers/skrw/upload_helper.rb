module Skrw
  module UploadHelper

    # image_tag for file object with optional versions hash
    # will use first in hash or 'version' argument
    # 
    # use:  file_image_tag(file, version: :small, options)

    def file_image_tag(file, version: nil, **options)
      
      # if file has versions else file.url
      if file.is_a?(Hash)
        key = version.nil? ? file.keys.first : version
        url = file[key].url
        image_tag(url, options)
      else
        image_tag(file.url, options)
      end
    end

    # responsive image_tag with srcset support 
    # for file object with versions hash will create srcset 
    # from versions with widths from file.metadata['width']
    # 'default' argument sets :version used for img src
    # 
    # use:  file_srcset_image_tag(file, versions: [:small, :medium, :large]
    #                             default: :large, options)

    def file_srcset(file, versions: [])
      if file.is_a?(Hash) && versions.any?
        return versions.map { |v| "#{file[v].url} #{file[v].metadata['width']}w" }.join(', ')
      else
        return nil
      end
    end

    def file_srcset_image_tag(file, versions: [], default: nil, **options)
      src = nil

      if file.is_a?(Hash)
        src = default.nil? ? file.values.first.url : file[default].url
      else
        src = file.url
      end
      
      srcset = file_srcset(file, versions: versions)
      options.merge!({ srcset: srcset })

      image_tag(src, options)

      # # with srcset / src if versions else only src
      # if file.is_a?(Hash) && versions.any?

      #   # set src to default or first of versions
      #   src = default.nil? ? file.values.first.url : file[default].url
        
      #   # build srcset and merge with image options
      #   srcset = versions.map { |v| "#{file[v].url} #{file[v].metadata['width']}w" }.join(', ')
      #   options.merge!({ srcset: srcset })

      #   # output image_tag with srcset (merged into options)
      #   image_tag(src, options)
      # else

      #   # output image_tag with src only
      #   src = file.is_a?(Hash) ? file.values.first.url : file.url
      #   image_tag(src, options)
      # end
    end

    # uploads panel for uploads within scope of parent
    # to work with stimulus controller
    # resource: Upload, scope: @event, uploads: @event.uploads.chronological

    def uploader(upload: nil)
      render partial: 'skrw/uploads/form', upload: upload
    end

    def upload_panel(resource: nil, scope: nil, uploads: nil, max_number_of_files: nil)
      render partial: 'skrw/uploads/upload_panel', 
             locals: { resource: resource, scope: scope, uploads: uploads, 
                       max_number_of_files: max_number_of_files }
    end
  end
end