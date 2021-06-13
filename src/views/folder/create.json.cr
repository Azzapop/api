if folder = @folder
  if folder.valid?
    json.raw folder.to_json
  else
    json.string "Invalid folder"
  end
end
