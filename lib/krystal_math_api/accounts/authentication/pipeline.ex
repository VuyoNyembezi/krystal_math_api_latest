defmodule KrystalMathApi.Accounts.Authentication.Pipeline do
  @claims %{"typ" => "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :krystal_math_api,
    module: KrystalMathApi.Accounts.Authentication.Guardian,
    error_handler: KrystalMathApi.Accounts.Authentication.ErrorHandler

  # plug Guardian.Plug.VerifySession, claims: @claims
  plug(Guardian.Plug.VerifyHeader, claims: @claims)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)
end
