alias Healthlocker.{Diary, Repo, User, SleepTracker, Symptom, SymptomTracker}
use Timex

{:ok, dummy} = Repo.insert(%User{
  email: "dummy@data.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  role: "slam_user",
  first_name: "Dummy",
  last_name: "Data",
  dob: "01/01/1990"
})

{:ok, symptom} = Repo.insert(%Symptom{
  symptom: "Anger",
  user_id: dummy.id
})

hours = [
  "0.0", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0",
  "5.5", "6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0", "9.5", "10.0", "10.5",
  "11.0", "11.5", "12.0", "12.5", "13.0", "13.5", "14.0"
]
wake = ["0", "1", "2", "3", "4", "5", "6", "7", "9", "10+"]
sleep_notes = [
  "Too hot", "Bad dreams", "Too cold", "Drank too much", "Very thirsty",
  "Nightmares", ""
]
affect_scale =
  ["0 -  Very little effect"] ++ ~w(1 2 3 4 5 6 7 8 9) ++ ["10 - Major effect"]
symptom_notes = [
  "Today was hard to handle", "I coped well today",
  "I took deep breaths when things were tough", "I was able to stay calm"
]

entries = [
  "Today was nice", "Today was sad", "Today I was angry", "Today I felt unwell",
  "I was late for school today", "I heard a really cool new song"
]

Enum.map(0..13, fn index ->
  Repo.insert(%SleepTracker{
    hours_slept: Enum.random(hours),
    wake_count: Enum.random(wake),
    notes: Enum.random(sleep_notes),
    user_id: dummy.id,
    for_date: Timex.shift(Date.utc_today, days: -index)
  })
end)

Enum.map(0..13, fn index ->
  Repo.insert(%Diary{
    entry: Enum.random(entries),
    user_id: dummy.id,
    inserted_at: Timex.shift(DateTime.utc_now(), days: -index)
  })
end)

Enum.map(0..13, fn index ->
  Repo.insert(%SymptomTracker{
    affected_scale: Enum.random(affect_scale),
    notes: Enum.random(symptom_notes),
    symptom_id: symptom.id,
    inserted_at: Timex.shift(DateTime.utc_now(), days: -index)
  })
end)
