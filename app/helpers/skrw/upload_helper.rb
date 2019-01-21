module Skrw
  module UploadHelper


    # RESPONSIVE PICTURE TAG
    # versions defines available versions for image sources
    # expects an array of symbols and media querries, such as 
    # versions: [[:small, "(max-width: 375px)"], [:large, "(min-width: 376px)"]]
    # 
    # densities defines multiple densities per version
    # expects an array of symbols, such as densities: [:2x, :3x]
    # this would look for versions :small, :small_2x, :large, :large_2x

    def responsive_picture_tag(file, versions: [], densities: [], caption: nil)
      output = "".html_safe

      # is file a Hash with versions or a single file
      if file.is_a?(Hash) && versions.any?

        # sources from versions
        versions.each do |version|
          identifier = version.first
          media = version.last

          # build srcset
          srcset = [file[identifier].url]

          # add densities to srcset (such as small_2x)
          densities.each do |density|
            d_identifier = "#{identifier}_#{density}".to_sym
            srcset << "#{file[d_identifier].url} #{density}" if file.has_key?(d_identifier)
          end

          # add version source to output
          output << %Q(<source srcset="#{srcset.join(', ')}" media="#{media}">).html_safe
        end

        # add first version as default img
        output << image_tag(file.values.first.url, alt: "#{caption unless caption.nil?}")
      else
        output << image_tag(file.url, alt: "#{caption unless caption.nil?}")
      end

      %Q(<picture>#{output}</picture>).html_safe
    end
  end
end