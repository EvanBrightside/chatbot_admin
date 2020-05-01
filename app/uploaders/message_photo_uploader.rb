class MessagePhotoUploader < CommonUploader
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
