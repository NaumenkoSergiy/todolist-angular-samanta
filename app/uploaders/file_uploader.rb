class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  after :remove, :delete_empty_upstream_dirs

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def serializable_hash
    {
      url: self.url,
      name: self.file.identifier,
      size: self.file.size
    }
  end

  def delete_empty_upstream_dirs
    Dir.delete(::File.expand_path(store_dir, root))
  rescue SystemCallError
    true
  end
end
