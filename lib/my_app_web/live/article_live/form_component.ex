defmodule MyAppWeb.ArticleLive.FormComponent do
  use MyAppWeb, :live_component

  alias MyApp.Blog

  @impl true
  def update(%{article: article} = assigns, socket) do
    changeset = Blog.change_article(article)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"article" => article_params}, socket) do
    changeset =
      socket.assigns.article
      |> Blog.change_article(article_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"article" => article_params}, socket) do
    save_article(socket, socket.assigns.action, article_params)
  end

  defp save_article(socket, :edit, article_params) do
    case Blog.update_article(socket.assigns.article, article_params) do
      {:ok, _article} ->
        {:noreply,
         socket
         |> put_flash(:info, "Article updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_article(socket, :new, article_params) do
    case Blog.create_article(article_params) do
      {:ok, _article} ->
        {:noreply,
         socket
         |> put_flash(:info, "Article created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
