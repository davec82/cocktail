defmodule Cocktail do
  @moduledoc """
  Top level types and convenience functions.

  This module holds some top-level types and a convenience function for
  creating a new schedule. Details available in the `Cocktail.Schedule` module.
  """

  alias Cocktail.Schedule

  @type frequency :: :yearly   |
                     :monthly  |
                     :weekly   |
                     :daily    |
                     :hourly   |
                     :minutely |
                     :secondly

  @type day_number :: 0..6

  @type day_atom :: :monday    |
                    :tuesday   |
                    :wednesday |
                    :thursday  |
                    :friday    |
                    :saturday  |
                    :sunday

  @type day :: day_number | day_atom

  @type hour_number :: 0..23

  @type schedule_option :: {:duration, pos_integer}

  @type schedule_options :: [schedule_option]

  @type rule_option :: {:frequency, frequency}  |
                       {:interval, pos_integer} |
                       {:count, pos_integer}    |
                       {:until, DateTime.t}     |
                       {:days, [day]}    |
                       {:hours, [hour_number]}

  @type rule_options :: [rule_option]

  @doc """
  Creates a new schedule using the given start time and options.

  see `Cocktail.Schedule.new/1` for details.
  """
  @spec schedule(DateTime.t, schedule_options) :: Schedule.t
  def schedule(start_time, options \\ []), do: Schedule.new(start_time, options)
end
