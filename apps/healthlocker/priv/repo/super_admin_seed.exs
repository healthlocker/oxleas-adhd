alias Healthlocker.{Repo, User}

Repo.insert!(%User{
  email: "super@admin.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  first_name: "Super",
  last_name: "Admin",
  phone_number: "07519 283 475",
  security_question: "Name of first boss?",
  security_answer: "Betty",
  data_access: false,
  role: "super_admin"
})
