library(httr2)
library(datasets)

bearer_token <- "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE3YjAxYzliOWM0MjNjZDM0MDlhNGVkYzg0NzM0ZjQ2MDc4MmFkMWM0YmIwN2ZmMTdjMjk5ZjI3NDdhMmM5MGY4MTIzMGU4MWM2MDY4ZjM5In0.eyJhdWQiOiIyIiwianRpIjoiYTdiMDFjOWI5YzQyM2NkMzQwOWE0ZWRjODQ3MzRmNDYwNzgyYWQxYzRiYjA3ZmYxN2MyOTlmMjc0N2EyYzkwZjgxMjMwZTgxYzYwNjhmMzkiLCJpYXQiOjE3MjgwMjcyNDcsIm5iZiI6MTcyODAyNzI0NywiZXhwIjoxNzU5NTYzMjQ3LCJzdWIiOiIyMjk2Iiwic2NvcGVzIjpbXX0.nuHl39NbiYvs-eOtN-BFYpL-NPX9cBHHlaOZ0ayoY0VESKwdQeEIa7Q93MjwyE3aFlE7kCr9fIecWUcTxsbyH5Au5qfmfSLEzv1A80Tfm-SS0Op8fogFl_Ymywu7-XXtm8gncwzSGB7dbdOesAIMt_httOcXgZeTC4g2D-SMN2I0aiLHQB00PLfdP8hLe33irUIpzxYd5sc71UTZqN3K2s9bTgBglq5Nda6Kmv2R38s29ZQ9NU1koRJOnywTWBJir3QiZFb3OqyaVJPF3LzGlsv20Z3qlvVMg56B7Q3yhkn3LrKIZWFaRRkolyJXv1FFv7YQI7sNkr3-C4VfbFkVVrhfzSAaziSWjLviX5jUkURY3Co03BJdnhXi6HB_QACpasNDNL6gaFdgUwzrvga1djiXbyJYc9hsp9Nx6cIKQZmRHhUtjf2eXB9xfke7hH2N6zKWvITLStvq8htvCzbb7L_Y83y8maboSdDuxfZ4bTx1t4K5cA9qgay-MGxnlfgRb3HdM8qKcJbwo5KFzfq2I685UG1UDpBKg5Orpdc0hHKppgpKXJkO89YJpckTCRv55rxawfX2bygutHRFPfPavYmXS3OEezDbIuShreexAOQxwqDiUuO4E0egmIEixUB5LDVURqXdPyXO8zEVo6LjBCbu_tUJxFCO0hL1Y2mCQR0"

req <- request("https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at") |> 
  req_auth_bearer_token(bearer_token)


req |> req_perform() |>
  resp_body_json() |>
  str()

req |> req_url_path("/json")


req |> req_perform() |> str()


req |> req_headers(
  lat = "13.10",
  lon = "100.10",
  fields = "tc,rh",
  date = "2024-10-04",
  hour = "8",
  duration = "2"
) 
