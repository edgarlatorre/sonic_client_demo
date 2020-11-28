defmodule Mix.Tasks.Populate do
  use Mix.Task

  alias SonicClient.Modes.Control
  alias SonicClient.Modes.Ingest

  @shortdoc "Populate beer from csv."
  def run(_) do
    Mix.Task.run("app.start")
    {:ok, conn} = open_connection("ingest")
    Ingest.flush(conn, "beers")

    File.read!("priv/resources/beers.json")
    |> Jason.decode!()
    |> Enum.each(fn beer -> save(conn, beer) end)

    SonicClient.stop(conn)

    {:ok, conn} = open_connection("control")
    Control.consolidate(conn)
    SonicClient.stop(conn)
  end

  defp save(conn, beer) do
    index = ~s(#{beer["name"]} #{beer["style"]})
    Ingest.push(conn, "beers", ~s(#{beer["id"]}:#{beer["name"]}), index)
  end

  defp open_connection(mode) do
    SonicClient.start(
      Application.fetch_env!(:sonic_client, :host),
      Application.fetch_env!(:sonic_client, :port),
      mode,
      Application.fetch_env!(:sonic_client, :password)
    )
  end
end
