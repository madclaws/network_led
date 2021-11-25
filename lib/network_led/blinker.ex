defmodule NetworkLed.Blinker do
  @moduledoc """
  Genserver for blinking LEDs..
  """

  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("Started Blinker")
    {:ok, led} = Circuits.GPIO.open(26, :output)
    {:ok, %{led: led}}
  end

  @impl true
  def handle_cast(:enable, state) do
    Logger.info("Enabling LED")

    Nerves.Leds.set(green: true)
    Circuits.GPIO.write(state.led, 1)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:disable, state) do
    Logger.info("Disabling LED")
    Nerves.Leds.set(green: false)
    Circuits.GPIO.write(state.led, 0)
    {:noreply, state}
  end

  def enable do
    GenServer.cast(__MODULE__, :enable)
  end

  def disable do
    GenServer.cast(__MODULE__, :disable)
  end
end
