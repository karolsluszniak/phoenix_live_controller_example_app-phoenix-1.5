defmodule MyAppWeb.ArticleControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.Blog

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:article) do
    {:ok, article} = Blog.create_article(@create_attrs)
    article
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Articles"
    end
  end

  describe "new article" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :new))
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "create article" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)

      conn = get(conn, Routes.article_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Article"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "edit article" do
    setup [:create_article]

    test "renders form for editing chosen article", %{conn: conn, article: article} do
      conn = get(conn, Routes.article_path(conn, :edit, article))
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "update article" do
    setup [:create_article]

    test "redirects when data is valid", %{conn: conn, article: article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @update_attrs)
      assert redirected_to(conn) == Routes.article_path(conn, :show, article)

      conn = get(conn, Routes.article_path(conn, :show, article))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete(conn, Routes.article_path(conn, :delete, article))
      assert redirected_to(conn) == Routes.article_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.article_path(conn, :show, article))
      end
    end
  end

  defp create_article(_) do
    article = fixture(:article)
    %{article: article}
  end
end
