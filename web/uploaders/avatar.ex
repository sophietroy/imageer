defmodule Imageer.Avatar do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @versions [:original]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    # {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
    # {:ffmpeg, fn(input, output) -> "-i #{input} -ss 0.5 -t 1 -s 250x250 -f image2 #{output}.jpg" end, :jpg}
  end

  # Override the persisted filenames:
  def filename(version, file) do
    file_uuid = UUID.uuid4(:hex)
    filename = Path.basename(file_uuid, Path.extname)
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "images"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
