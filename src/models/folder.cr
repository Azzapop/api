require "jennifer"

class Folder < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    name: String,
    created_at: Time?,
    updated_at: Time?,
  )

  validates_length :name, minimum: 1, maximum: 15
end
