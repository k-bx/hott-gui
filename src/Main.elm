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


type Expr
    = Var String
    | Sum Expr Expr
    | Prod Expr Expr
    | Def Expr Expr
    | Params Expr (List Expr)
    | OfType Expr Expr
    | TFun Expr Expr


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


r : Expr -> String
r x =
    case x of
        Var s ->
            s

        Sum e1 e2 ->
            "\\sum_{" ++ r e1 ++ "}" ++ r e2

        Prod e1 e2 ->
            "\\prod_{" ++ r e1 ++ "}" ++ r e2

        Def e1 e2 ->
            r e1 ++ " :\\equiv " ++ r e2

        Params name ps ->
            r name ++ "(" ++ String.concat (List.intersperse "," (List.map r ps)) ++ ")"

        OfType e1 e2 ->
            r e1 ++ " : " ++ r e2

        TFun e1 e2 ->
            r e1 ++ " \\rightarrow " ++ r e2


view : Model -> Html Msg
view model =
    let
        formulas =
            [ Sum (Var "x") (Var "y")
            , Def (Params (Var "Iso") [ Var "A", Var "B" ])
                (Sum
                    (OfType (Var "f")
                        (TFun (Var "A")
                            (Var "B")
                        )
                    )
                    (Sum
                        (OfType
                            (Var "g")
                            (TFun (Var "B") (Var "A"))
                        )
                        (Var "TODO")
                    )
                )
            ]

        renderFormula exp =
            div [ class "row" ]
                [ div [ class "col-md-6" ]
                    [ text <| r exp ]
                , div [ class "col-md-6" ]
                    [ iframe
                        [ srcdoc <|
                            """
<html>
  <head>
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\\\(','\\\\)']]}});
    </script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>
  </head>
  <body>
$$
"""
                                ++ r exp
                                ++ """
$$
  </body>
</html>
                              """
                        ]
                        []
                    ]
                ]
    in
    div [ class "container" ] <|
        [ h1 [] [ text "Hey" ]
        ]
            ++ List.map renderFormula formulas


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
