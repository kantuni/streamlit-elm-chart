port module Main exposing (..)

import Browser
import Color
import Html
import Html.Attributes
import LineChart
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as Intersection
import LineChart.Container as Container
import LineChart.Dots as Dots
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Interpolation as Interpolation
import LineChart.Junk as Junk
import LineChart.Legends as Legends
import LineChart.Line as Line



-- PORTS


port fromJS : (Data -> msg) -> Sub msg



-- MODEL


type alias Point =
    { x : Float
    , y : Float
    }


type alias Stats =
    { region : String
    , data : List Point
    , color : ( Int, Int, Int )
    }


type alias Data =
    List Stats


type alias Model =
    { data : Data
    }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { data = [] }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Received Data


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Received newData ->
            ( { model | data = newData }, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view model =
    LineChart.viewCustom chartConfig (List.map lineCharts model.data)


chartConfig : LineChart.Config Point msg
chartConfig =
    { y = Axis.default 400 "$B" .y
    , x = Axis.default 700 "Year" .x
    , container = containerConfig
    , interpolation = Interpolation.monotone
    , intersection = Intersection.at 1961 0
    , legends = Legends.default
    , events = Events.default
    , junk = Junk.default
    , grid = Grid.default
    , area = Area.normal 0.75
    , line = Line.default
    , dots = Dots.custom (Dots.empty 5 1)
    }


containerConfig : Container.Config msg
containerConfig =
    Container.custom
        { attributesHtml = [ Html.Attributes.style "font-family" "monospace" ]
        , attributesSvg = []
        , size = Container.relative
        , margin = Container.Margin 60 140 60 80
        , id = "streamlit"
        }


lineCharts : Stats -> LineChart.Series Point
lineCharts stats =
    let
        ( r, g, b ) =
            stats.color

        color =
            Color.rgb255 r g b
    in
    LineChart.line color Dots.none stats.region stats.data



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    fromJS Received



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
