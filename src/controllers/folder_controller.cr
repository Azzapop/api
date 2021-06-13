require "./base_controller"
require "../models/folder"

class FolderController < BaseController
  @folders = [] of Folder
  @folder : Folder?

  def index
    @folders = Folder.all.to_a
  end

  def create
    if body = @request.body
      params = CreateParams.parse(body)
      @folder = Folder.new(params)
      if folder = @folder
        folder.save
      end
    end
  end

  def show
    @folder = Folder.find(@param["id"])
  end

  private permit_json_params(CreateParams, { name: String })
end
