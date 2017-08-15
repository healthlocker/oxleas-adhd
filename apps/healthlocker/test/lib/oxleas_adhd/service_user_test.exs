defmodule Healthlocker.OxleasAdhd.ServiceUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Carer, OxleasAdhd.ServiceUser}

  setup %{} do
    user = %User{
      id: 1234,
      email: "service_user@mail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      role: "service_user"
    } |> Repo.insert!

    carer = %User{
      id: 1235,
      email: "carer@mail.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      security_question: "Question?",
      security_answer: "Answer",
      role: "carer"
    } |> Repo.insert!

    %Carer{
      carer_id: 1235,
      caring_id: 1234
    } |> Repo.insert!

    {:ok, user: user, carer: carer}
  end

  test "ServiceUser.for returns user when service user is input", %{user: user} do
    actual = ServiceUser.for(user)
    expected = Repo.get!(User, 1234)
    assert actual == expected
  end

  test "ServiceUser.for returns user.caring when carer is input", %{carer: carer} do
    actual = ServiceUser.for(carer)
    expected = Repo.get!(User, 1234)
    assert actual == expected
  end
end
