defmodule Imageer.ImageController do
  use Imageer.Web, :controller
  alias Imageer.Image
  alias Imageer.Repo
  alias Imageer.Avatar

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
    IO.inspect image_params

    image = image_params["image"]

    filename = "#{image.path}"

    IO.puts "image tmp location: #{filename}"



    with {:ok, uploaded_image} <- Avatar.store(image) do
      IO.puts "uploaded_image"
      IO.inspect uploaded_image
       url = Avatar.url(uploaded_image)
       IO.puts "original url: #{url}"
       thumb_url = Avatar.url(uploaded_image, :thumb)
       IO.puts "thumb: #{thumb_url}"

        IO.puts "Success url: #{url}"
        IO.inspect uploaded_image
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

  defp save_url(url) do
    changeset = Image.changeset(%Image{}, %{image: url})
    Repo.insert(changeset)
  end
end
