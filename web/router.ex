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
    pipe_through [:browser] #, :super_admin

    resources "/users", UserController, only: [:index, :new, :create, :edit, :update]
    resources "/users", UserController, only: [:show] do
      resources "/clinician-connection", ClinicianController, only: [:new, :create]
    end
    resources "/users", UserController, only: [:index, :new, :create, :edit, :update] do
      resources "/carer-connection", CarerController, only: [:new]
      post "/carer-connection", CarerController, :submit_SU_details
      post "/carer-connection/confirm", CarerController, :confirm_SU_details
    end
  end

  scope "/", OxleasAdhd do
    pipe_through [:browser] #, :logged_in

    resources "/medication", MedicationController, only: [:index, :new, :edit] #, :create, :update
    resources "/about-me", AboutMeController, only: [:new, :edit] #, :create, :update
  end
end
