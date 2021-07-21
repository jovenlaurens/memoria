module Document exposing (..)
import Picture exposing (ShowState)
import Picture exposing (ShowState(..))
import Html
import Html exposing (Html)
import Messages exposing (Msg)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Memory exposing (MeState)
import Memory exposing (MeState(..))
import Button exposing (trans_button_sq)
import Button exposing (Button)
import Messages exposing (GraMsg(..))



type alias Document =
    { showState : ShowState
    , lockState : MeState
    , index : Int
    , belong : Int
    }

{-| documents | cscene | belong to 
        0          2        0
-}

initial_docu : List Document
initial_docu =
    [
        Document Show Locked 0 0
    ]


list_index_docu :  Int -> List Document -> Document
list_index_docu index list =
    if index > List.length list then
        (Document Show Locked 0 0)

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_docu (index - 1) xs

            _ ->
                (Document Show Locked 0 0)


unlock_cor_docu : Int -> List Document -> List Document
unlock_cor_docu index old =
    let
        fin ind docu = (if docu.index == ind && docu.lockState == Locked then 
                            {docu | lockState = Unlocked }
                        else
                            docu
                        )
    in
        List.map (fin index) old


render_document_detail : Int -> List (Html Msg)
render_document_detail index =
    case index of
            0 ->
                [ Html.embed
                            [ type_ "image/svg+xml"
                            , src "assets/newspaper1.svg"
                            , style "top" "10%"
                            , style "left" "20%"
                            , style "width" "60%"
                            , style "height" "80%"
                            , style "position" "absolute"
                            ]
                            []
                , trans_button_sq (Button 20 10 60 80 "" (StartChange Back) "block")
                ]
            _ ->
                []
    




render_newspaper_index : Int -> List Document -> Html Msg
render_newspaper_index index list =
    let
        tar = list_index_docu index list
    in  
        if tar.showState == Show then
            case tar.index of
                0 ->
                    Html.embed
                        [ type_ "image/png"
                        , src "assets/newspaper1.png"
                        , style "top" "40%"
                        , style "left" "70%"
                        , style "width" "15%"
                        , style "height" "20%"
                        , style "position" "absolute"
                        , style "transform" "rotate(-45deg)"
                        , onClick (StartChange (OnClickDocu 0))
                        ]
                        []
                    

                _ ->
                    Html.embed
                        []
                        []
        else
            Html.embed
                        []
                        []
    


draw_list : Int -> MeState -> List (Html Msg)
draw_list id lck =
    case id of
        0 ->
            (if lck == Locked then
                [ Html.embed
                    [ type_ "image/png"
                        , src "assets/newspaper1.png"
                        , style "top" "30%"
                        , style "left" "10%"
                        , style "width" "15%"
                        , style "height" "20%"
                        , style "position" "absolute"
                        ]
                        []
                ]
            else
                [ Html.embed
                    [ type_ "image/svg+xml"
                        , src "assets/newspaper1.svg"
                        , style "top" "30%"
                        , style "left" "10%"
                        , style "width" "15%"
                        , style "height" "20%"
                        , style "position" "absolute"
                        , onClick (OnClickItem 0 1)
                        ]
                        []
                ]
            )
        _ ->
            []


render_docu_list : Int -> List Document -> List (Html Msg)
render_docu_list index list =
    let
        drawin id docu =
            if docu.belong == id then
                draw_list docu.index docu.lockState
            else
                []


    in
        List.map (drawin index) list |> List.concat
    
