defmodule App.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug App.Plugs.Auth, repo: App.Repo
    plug :find_room
  end

  pipeline :logged_in do
    plug App.Plugs.RequireLogin
    plug :find_room
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # endpoints requiring a logged in user
  scope "/", App do
    pipe_through [:browser, :logged_in]

    resources "/posts", PostController, only: [:new, :create, :edit, :update] do
      post "/likes", PostController, :likes
    end

    resources "/coping-strategy", CopingStrategyController
    resources "/goal", GoalController
    resources "/toolkit", ToolkitController, only: [:index]
    resources "/account", AccountController, only: [:index]
    put "/account/update", AccountController, :update
    put "/account/disconnect", AccountController, :disconnect
    get "/account/consent", AccountController, :consent
    put "/account/consent/update", AccountController, :update_consent
    get "/account/security/edit", AccountController, :edit_security
    put "/account/security/update", AccountController, :update_security
    get "/account/password/edit", AccountController, :edit_password
    put "/account/password/update", AccountController, :update_password
    resources "/components", ComponentController, only: [:index]
    resources "/messages", MessageController, only: [:index]
    resources "/sleep-tracker", SleepTrackerController, only: [:new, :create]
    resources "/care-plan", CarePlanController, only: [:index]

    scope "/care-team", CareTeam, as: :care_team do
      resources "/rooms", RoomController, only: [:show]
      resources "/contacts", ContactController, only: [:show], singleton: true
    end

    scope "/caseload", Caseload, as: :caseload do
      resources "/users", UserController, only: [:show] do
        resources "/rooms", RoomController, only: [:show]
      end
    end

    resources "/slam", SlamController, only: [:create]
    resources "/symptom", SymptomController, only: [:new, :create]
    resources "/symptom-tracker", SymptomTrackerController, only: [:new, :create]
    resources "/tracking-overview", TrackerController, only: [:index] do
      get "/prev-date", TrackerController, :prev_date
      get "/next-date", TrackerController, :next_date
    end
    resources "/diary", DiaryController, only: [:new, :create, :edit, :update]
  end

  # endpoints not requiring a logged in user
  scope "/", App do
    pipe_through :browser

    get "/", PageController, :index
    resources "/feedback", FeedbackController, only: [:index, :create]
    resources "/login", LoginController, only: [:index, :create, :delete]
    resources "/users", UserController, only: [:index, :new, :create, :update] do
      get "/signup2", UserController, :signup2
      put "/create2", UserController, :create2
      get "/signup3", UserController, :signup3
      put "/create3", UserController, :create3
    end
    resources "/pages", PageController, only: [:index, :show]
    resources "/posts", PostController, only: [:show, :index]
    resources "/support", SupportController, only: [:index]
    resources "/tips", TipController, only: [:index]
    resources "/password", PasswordController, only: [:new, :create, :edit, :update]
    resources "/epjs-button", ButtonController, only: [:index]
    resources "/caseload", CaseloadController, only: [:index]
  end
end
