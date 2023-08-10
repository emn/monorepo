defmodule Pento.WikiFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Wiki` context.
  """

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        question: "some question",
        answer: "some answer",
        upvotes: 42
      })
      |> Pento.Wiki.create_faq()

    faq
  end
end
