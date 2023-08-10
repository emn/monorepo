defmodule Pento.WikiTest do
  use Pento.DataCase

  alias Pento.Wiki

  describe "faqs" do
    alias Pento.Wiki.Faq

    import Pento.WikiFixtures

    @invalid_attrs %{question: nil, answer: nil, upvotes: nil}

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Wiki.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Wiki.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      valid_attrs = %{question: "some question", answer: "some answer", upvotes: 42}

      assert {:ok, %Faq{} = faq} = Wiki.create_faq(valid_attrs)
      assert faq.question == "some question"
      assert faq.answer == "some answer"
      assert faq.upvotes == 42
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer", upvotes: 43}

      assert {:ok, %Faq{} = faq} = Wiki.update_faq(faq, update_attrs)
      assert faq.question == "some updated question"
      assert faq.answer == "some updated answer"
      assert faq.upvotes == 43
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_faq(faq, @invalid_attrs)
      assert faq == Wiki.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %Faq{}} = Wiki.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Wiki.change_faq(faq)
    end
  end
end
