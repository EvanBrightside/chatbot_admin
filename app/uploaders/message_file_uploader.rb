class MessageFileUploader < CommonUploader
  def extension_whitelist
    %w(jpg jpeg gif png svg mp4 pdf)
  end
end
