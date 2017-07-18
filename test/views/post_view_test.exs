defmodule App.PostViewTest do
  use App.ConnCase, async: true
  alias App.Post
  alias App.PostView

  test "converts markdown to html" do
    {:safe, result} = PostView.markdown("**Hello, world!**")
    assert String.contains? result, "<strong>Hello, world!</strong>"
  end

  test "markdown converts nil to empty string" do
    result = PostView.markdown(nil)
    assert result == ""
  end

  describe "PostView.heading/1" do
    test "when heading exists it extracts the header" do
      post = %Post{content: "# I'm a markdown heading"}
      assert PostView.heading(post) == "I'm a markdown heading"
    end

    test "when heading does not exist it returns false" do
      post = %Post{content: "Content with no heading"}
      refute PostView.heading(post)
    end
  end

  describe "PostView.body/1" do
    test "when heading exists it extracts the body" do
      post = %Post{content: "# Heading\n\nRest of the body"}
      assert PostView.body(post) == "\n\nRest of the body"
    end
  end
end
