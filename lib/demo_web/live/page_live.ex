defmodule DemoWeb.PageLive do
  use DemoWeb, :live_view

  alias SonicClient.Modes.Search

  @impl true
  def mount(_params, _session, socket) do
    {:ok, sonic_conn} = open_connection()

    {:ok,
     assign(socket,
       sonic_conn: sonic_conn,
       query: "",
       beers: get_beers(sonic_conn),
       suggestions: []
     )}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    %{sonic_conn: sonic_conn, beers: beers} = socket.assigns

    {:noreply,
     assign(socket, beers: beers, query: query, suggestions: suggest_words(sonic_conn, query))}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    %{sonic_conn: sonic_conn} = socket.assigns
    {:noreply, assign(socket, beers: get_beers(sonic_conn, query), query: query, suggestions: [])}
  end

  defp get_beers(conn, term \\ "ipa") do
    {:ok, beers} = Search.query(conn, "beers", "default_bucket", term)

    beers
  end

  defp suggest_words(_conn, ""), do: []

  defp suggest_words(conn, prefix) do
    {:ok, words} = Search.suggest(conn, "beers", "default_bucket", prefix)
    words
  end

  defp open_connection() do
    SonicClient.start(
      Application.fetch_env!(:sonic_client, :host),
      Application.fetch_env!(:sonic_client, :port),
      "search",
      Application.fetch_env!(:sonic_client, :password)
    )
  end

  defp format(text) do
    case String.ends_with?(text, "}") do
      true ->
        text

      _ ->
        ~s(#{text}"})
    end
  end
end
