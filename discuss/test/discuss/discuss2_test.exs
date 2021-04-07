defmodule Discuss.Discuss2Test do
  use Discuss.DataCase

  alias Discuss.Discuss2

  describe "topics" do
    alias Discuss.Discuss2.Topic

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discuss2.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Discuss2.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Discuss2.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Discuss2.create_topic(@valid_attrs)
      assert topic.title == "some title"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discuss2.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Discuss2.update_topic(topic, @update_attrs)
      assert topic.title == "some updated title"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Discuss2.update_topic(topic, @invalid_attrs)
      assert topic == Discuss2.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Discuss2.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Discuss2.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Discuss2.change_topic(topic)
    end
  end
end
