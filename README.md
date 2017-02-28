# DraftServer

Try passport for login etc
 * https://github.com/opendrops/passport
Maybe Coherence
 * https://github.com/smpallen99/coherence

# TODO

 * Colors for positions on screen ( 6 positions )
 * Add in scoring for competitions
 * Create JSON import script
 * Get stewart to enter the position
 * List your team in the app
 * Add positions on the app
 * App Icon
 * Search bar - dissapearing

 * Add game scoring

 * Notification on the phone where you need to pic

## BUGS

 * Cannot save empty position
 * Fix error when api/v1/drafts/100 is is invalid (missing row)


fix error:

Request: GET /account
** (exit) an exception was raised:
    ** (ArgumentError) No helper clause for DraftServer.Router.Helpers.user_path/3 defined for action :update.
The following user_path actions are defined under your router:

  * :confirm
  * :confirm
  * :confirmation_instructions
  * :create
  * :index
  * :invitation_registration
  * :invitation_registration
  * :invited
  * :invited
  * :new
  * :resend_confirmation_instructions
  * :resend_confirmation_instructions
        (phoenix) lib/phoenix/router/helpers.ex:269: Phoenix.Router.Helpers.raise_route_error/5
        (draft_server) web/templates/user/edit.html.eex:4: DraftServer.UserView."edit.html"/1
        (draft_server) web/templates/layout/app.html.eex:29: DraftServer.LayoutView."app.html"/1
        (phoenix) lib/phoenix/view.ex:335: Phoenix.View.render_to_iodata/3
        (phoenix) lib/phoenix/controller.ex:642: Phoenix.Controller.do_render/4
        (sentinel) lib/sentinel/web/controllers/html/account_controller.ex:1: Sentinel.Controllers.Html.AccountController.action/2
        (sentinel) lib/sentinel/web/controllers/html/account_controller.ex:1: Sentinel.Controllers.Html.AccountController.phoenix_controller_pipeline/2
        (draft_server) lib/draft_server/endpoint.ex:1: DraftServer.Endpoint.instrument/4
warning: `Ecto.Changeset.cast/4` is deprecated, please use `cast/3` + `validate_required/3` instead
    (sentinel) lib/sentinel/web/controllers/html/account_controller.ex:21: Sentinel.Controllers.Html.AccountController.edit/4
    (sentinel) lib/sentinel/web/controllers/html/account_controller.ex:1: Sentinel.Controllers.Html.AccountController.action/2
    (sentinel) lib/sentinel/web/controllers/html/account_controller.ex:1: Sentinel.Controllers.Html.AccountController.phoenix_controller_pipeline/2
    (draft_server) lib/draft_server/endpoint.ex:1: DraftServer.Endpoint.instrument/4

Feedback
 * Search at all times
 * Scroll thingy
 * Push notification
 * tap to scroll to top
 * show all the teams
 * usernames on dashboard
 * draft order and stopping of who can go next


iPhone people
  * Richard
  * Bonnie
  * Ben

Android
* Jason
* Jesa
* Wil
* Michael
