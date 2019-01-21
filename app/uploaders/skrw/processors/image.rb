require 'image_processing/vips'

module Skrw::Processors::Image
  
  def self.process(file)
    pipeline = ImageProcessing::Vips
      .source(file)
      .convert('jpg')

    large = pipeline.resize_to_limit!(800, 800)
    medium = pipeline.resize_to_limit!(400,400)
    small = pipeline.resize_to_limit!(200,200)

    { large: large, medium: medium, small: small }
  end
end