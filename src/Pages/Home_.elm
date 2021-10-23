module Pages.Home_ exposing (page)

import Html
import Page exposing (Page)
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request -> Page
page _ req =
    Page.static
        { view = view req
        }


type alias Model =
    {}


view : Request -> View msg
view req =
    { title = "Homepage"
    , body = UI.layout [ Html.text ("Hello, " ++ req.url.host ++ "!") ]
    }
