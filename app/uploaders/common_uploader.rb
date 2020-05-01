class CommonUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    if original_filename.present?
      original_filename.to_slug.transliterate(:russian).to_s
    end
  end
end
