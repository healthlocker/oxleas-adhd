defmodule Healthlocker.Router do
  use Healthlocker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Healthlocker.Plugs.Auth, repo: Healthlocker.Repo
    plug :find_room
  end

  pipeline :logged_in do
    plug Healthlocker.Plugs.RequireLogin
    plug :find_room
  end

  pipeline :super_admin do
    plug Healthlocker.Plugs.RequireSuperAdmin
  end

  pipeline :staff_or_teacher do
    plug Healthlocker.Plugs.RequireStaffOrTeacher
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # routes for oxleas only super admin can access
  scope "/super-admin", Healthlocker.OxleasAdhd do
    pipe_through [:browser, :super_admin]

    resources "/users", UserController, only: [:index, :new, :create, :edit, :update] do
      resources "/clinician-connection", ClinicianController, only: [:new, :create, :edit, :update]
      resources "/carer-connection", CarerController, only: [:new]
      post "/carer-connection", CarerController, :submit_SU_details
      post "/carer-connection/confirm", CarerController, :confirm_SU_details
    end
  end

  # routes for oxleas only staff can access
  scope "/", Healthlocker.OxleasAdhd do
    pipe_through [:browser, :staff_or_teacher]
    resources "/caseload", CaseloadController, only: [:index]

    scope "/caseload", Caseload, as: :caseload do
      resources "/users", UserController, only: [:show] do
        resources "/rooms", RoomController, only: [:show]
      end
    end

    resources "/users", UserController do
      resources "/medication", MedicationController, only: [:new, :create, :edit, :update]
      resources "/school-feedback", AnswerController, only: [:new, :create, :edit ,:update]
    end
  end

  # logged in routes for oxleas
  scope "/", Healthlocker.OxleasAdhd do
    pipe_through [:browser, :logged_in]
    resources "/account", AccountController, only: [:index]
    put "/account/update", AccountController, :update
    get "/account/consent", AccountController, :consent
    put "/account/consent/update", AccountController, :update_consent
    get "/account/password/edit", AccountController, :edit_password
    put "/account/password/update", AccountController, :update_password

    resources "/users", UserController do
      resources "/medication", MedicationController, only: [:index, :show]
      resources "/about-me", AboutMeController, only: [:new, :edit, :create, :update]
      resources "/school-feedback", AnswerController, only: [:index, :show]
    end
    scope "/care-team", CareTeam, as: :care_team do
      resources "/rooms", RoomController, only: [:show]
      resources "/contacts", ContactController, only: [:show], singleton: true
    end
  end

  # logged out routes for oxleas
  scope "/", Healthlocker.OxleasAdhd do
    pipe_through [:browser]

    resources "/login", LoginController, only: [:index, :create, :delete]
  end

  # generic routes requiring a logged in user
  scope "/", Healthlocker do
    pipe_through [:browser, :logged_in]

    resources "/posts", PostController, only: [:new, :create, :edit, :update] do
      post "/likes", PostController, :likes
    end
    resources "/coping-strategy", CopingStrategyController
    resources "/goal", GoalController
    resources "/toolkit", ToolkitController, only: [:index]
    resources "/components", ComponentController, only: [:index]
    resources "/messages", MessageController, only: [:index]
    resources "/sleep-tracker", SleepTrackerController, only: [:new, :create]
    resources "/care-plan", CarePlanController, only: [:index]



    resources "/slam", SlamController, only: [:new, :create]
    resources "/symptom", SymptomController, only: [:new, :create]
    resources "/symptom-tracker", SymptomTrackerController, only: [:new, :create]
    resources "/tracking-overview", TrackerController, only: [:index] do
      get "/prev-date", TrackerController, :prev_date
      get "/next-date", TrackerController, :next_date
    end
    resources "/diary", DiaryController, only: [:new, :create, :edit, :update]
  end

  # generic routes not requiring a logged in user
  scope "/", Healthlocker do
    pipe_through :browser

    get "/", PageController, :index
    resources "/feedback", FeedbackController, only: [:index, :create]
    resources "/pages", PageController, only: [:index, :show]
    resources "/posts", PostController, only: [:show, :index]
    resources "/support", SupportController, only: [:index]
    resources "/tips", TipController, only: [:index]
    resources "/password", PasswordController, only: [:new, :create, :edit, :update]
    resources "/epjs-button", ButtonController, only: [:index]
  end

  scope "/", Healthlocker do
    get "/_version", GithubVersionController, :index # for deployment versioning
  end
end
