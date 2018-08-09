defmodule Imageer.ImageController do
  use Imageer.Web, :controller
  alias Imageer.Image
  alias Imageer.Repo

  def index(conn, _) do
    render(conn, "index.html")
  end

  def new(conn, _) do
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  # image_params:
  # %{
  #   "image" => %Plug.Upload{
  #     content_type: "image/jpeg",
  #     filename: "cat.jpg",
  #     path: "/var/folders/n0/50kt769x1w176hq_j9q2mm4m0000gn/T//plug-1533/multipart-1533699457-894724532219117-1"
  #   }
  # }
  def create(conn, %{"image" => image_params}) do

    image = image_params["image"]
    filename = "#{image.path}"

    with {:ok, uploaded_image} <- upload(filename, image.content_type),
      {:ok, image} <- save_url(uploaded_image.secure_url) do
        IO.puts "Success"
        IO.puts "original_url: #{uploaded_image.secure_url}"

        # Cloudinary API uses file extension, eg: jpg, to determine it is
        # making thumbnail from video
        options = %{
          start_offset: 1,
          width: 160,
          height: 160,
          resource_type: "video",
          format: "jpg"
        }
        thumbnail_url = Cloudex.Url.for(uploaded_image.public_id, options)
        thumbnail_url = "https:#{thumbnail_url}"
        IO.puts "thumbnail_url: #{thumbnail_url}"

        conn
        |> put_flash(:info, "Image was added")
        |> redirect(to: image_path(conn, :index))
    else
      {:error, changeset = %Ecto.Changeset{}} ->
        IO.puts "Error saving"
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", changeset: changeset)
      {:error, reason} ->
        IO.puts "Error: #{reason}"
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: image_path(conn, :index))
    end
  end

  defp upload(filename, "video" <> _rest) do
    Cloudex.upload(filename, %{}, "video")
  end
  defp upload(filename, _content_type) do
    Cloudex.upload(filename)
  end

  defp save_url(url) do
    changeset = Image.changeset(%Image{}, %{image: url})
    Repo.insert(changeset)
  end
end
