defmodule OxleasAdhd.Router do
  use OxleasAdhd.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :logged_in do
    plug OxleasAdhd.Plugs.RequireLogin
  end

  pipeline :super_admin do
    plug OxleasAdhd.Plugs.RequireSuperAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OxleasAdhd do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/super-admin", OxleasAdhd do
    pipe_through [:browser, :super_admin]

    resources "/users", UserController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", OxleasAdhd do
  #   pipe_through :api
  # end
end
