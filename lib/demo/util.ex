defmodule Util do
  def encode(content) do
    Base.encode16(content)
  end

  def decode(content) do
    Base.decode16!(content)
  end
end
