defmodule Ajisai.Id do
  @moduledoc """
  A Ecto parameterized type of ShortUUID
  """
  use Ecto.ParameterizedType

  def type(_params), do: :string

  def init(opts) do
    Enum.into(opts, %{})
  end

  def cast(id, _params), do: {:ok, id}
  def dump(id, _dumper, _params), do: {:ok, id}
  def load(id, _loader, _params), do: {:ok, id}

  def autogenerate(%{prefix: prefix}), do: prefix <> ShortUUID.generate()
  def autogenerate(_params), do: ShortUUID.generate()
end
