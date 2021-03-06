defmodule Indexer do
  @moduledoc """
  Indexes an Ethereum-based chain using JSONRPC.
  """

  alias Explorer.Chain

  @doc """
  The maximum `t:Explorer.Chain.Block.t/0` `number` that was indexed

  If blocks are skipped and inserted out of number order, the max number is still returned

      iex> insert(:block, number: 2)
      iex> insert(:block, number: 1)
      iex> Indexer.max_block_number()
      2

  If there are no blocks, `0` is returned to indicate to index from genesis block.

      iex> Indexer.max_block_number()
      0

  """
  def max_block_number do
    case Chain.max_block_number() do
      {:ok, number} -> number
      {:error, :not_found} -> 0
    end
  end

  @doc """
  The next `t:Explorer.Chain.Block.t/0` `number` that needs to be indexed (excluding skipped blocks)

  When there are no blocks the next block is the 0th block

      iex> Indexer.max_block_number()
      0
      iex> Indexer.next_block_number()
      0

  When there is a block, it is the successive block number

      iex> insert(:block, number: 2)
      iex> insert(:block, number: 1)
      iex> Indexer.next_block_number()
      3

  """
  def next_block_number do
    case max_block_number() do
      0 -> 0
      num -> num + 1
    end
  end
end
