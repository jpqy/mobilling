class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  validates :file, presence: true, integrity: true, processing: true
end
