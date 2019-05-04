module Main exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Platform.Sub
import Task


type alias Model =
    {}


type Msg
    = NoOp


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Hey" ]
        , div []
            [ iframe [srcdoc """
<html>
  <head>
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\\\(','\\\\)']]}});
    </script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>
  </head>
  <body>
    When $a \\ne 0$, there are two solutions to \\(ax^2 + bx + c = 0\\) and they are
    $$x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}.$$
  </body>
</html>
                              """]
                  []
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
