json.array do
  @folders.each do |folder|
    # TODO partials
    json.raw folder.to_json
  end
end
