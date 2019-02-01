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

    def file_srcset_image_tag(file, versions: [], default: nil, **options)
      
      # with srcset / src if versions else only src
      if file.is_a?(Hash) && versions.any?

        # set src to default or first of versions
        src = default.nil? ? file.values.first.url : file[default].url
        
        # build srcset and merge with image options
        srcset = versions.map { |v| "#{file[v].url} #{file[v].metadata['width']}w" }.join(', ')
        options.merge!({ srcset: srcset })

        # output image_tag with srcset (merged into options)
        image_tag(src, options)
      else

        # output image_tag with src only
        src = file.is_a?(Hash) ? file.values.first.url : file.url
        image_tag(src, options)
      end
    end

    # uploads panel for uploads within scope of parent
    # to work with stimulus controller

    def uploads_panel(uploads: nil, parent: nil, **options)
      # add class
      options[:class] = options[:class] + " s-uploads"

      # add data-tags for stimulus controller
      data = {  'controller': 'uploads', 'uploads-index-url': uploads_path,
                'uploads-uploadable-type': parent.nil? ? nil : parent.class.name,
                'uploads-uploadable-id': parent.nil? ? nil : parent.id }

      # merge data with options
      options[:data] = options[:data] || {}
      options[:data].merge!(data)

      render partial: 'skrw/uploads/uploads', locals: { uploads: uploads, parent: parent, options: options }
    end
  end
end