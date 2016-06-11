defmodule Rumbl.UserRepoTest do
  use Rumbl.ModelCase
  alias Rumbl.User
  alias Rumbl.Category

  @valid_attrs %{name: "A User", username: "lee"}

  test "converts unique_constraint on username to error" do
    Repo.insert!(%User{username: "bob"})
    attrs = Map.put(@valid_attrs, :username, "bob")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:username, "has already been taken"} in changeset.errors
  end

  test "alphabetical/1 orders by name" do
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})
    Repo.insert!(%Category{name: "b"})

    query = Category |> Category.alphabetical
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(a b c)
  end
end
