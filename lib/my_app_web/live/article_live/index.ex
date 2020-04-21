defmodule MyAppWeb.ArticleLive.Index do
  use MyAppWeb, :live_view

  alias MyApp.Blog
  alias MyApp.Blog.Article

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :articles, fetch_articles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, Blog.get_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Article{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Articles")
    |> assign(:article, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    article = Blog.get_article!(id)
    {:ok, _} = Blog.delete_article(article)

    {:noreply, assign(socket, :articles, fetch_articles())}
  end

  defp fetch_articles do
    Blog.list_articles()
  end
end
