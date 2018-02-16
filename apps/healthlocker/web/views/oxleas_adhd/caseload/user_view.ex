defmodule Healthlocker.OxleasAdhd.Caseload.UserView do
  use Healthlocker.Web, :view

  @pink_select "b--hl-pink hl-pink b"
      @default "b--hl-grey hl-dark-blue"
  def get_classes(section) do
    case section do
      "rooms" ->
        [@pink_select, @default, @default, @default]
      "interactions" ->
        [@default, @pink_select,  @default, @default]
      "tracking" ->
        [@default, @default, @pink_select, @default]
      "details" ->
        [@default, @default, @default, @pink_select]
    end
  end
end
