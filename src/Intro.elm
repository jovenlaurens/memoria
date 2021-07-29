module Intro exposing (..)

import Button exposing (trans_button_sq)
import Debug exposing (toString)
import Html exposing (Html, a, br, button, div, text)
import Html.Attributes as HtmlAttr exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (GraMsg(..), Msg(..))
import Svg
import Svg.Attributes as SvgAttr


type FinishSit
    = Finished
    | Normal
    | TypeDisppear
    | AllAppear
    | TypeAppear



type alias IntroPage =
    { cp : Int
    , state : FinishSit
    , imageOpa : Float
    , wordOpa : Float
    }


initial_intro : IntroPage
initial_intro =
    IntroPage 1 AllAppear 0.0 0.0


initial_end : IntroPage
initial_end =
    IntroPage 1 TypeAppear 1.0 0.0

disppearSpeed = 0.05

appearSpeed = 0.05

get_new_intro : IntroPage -> Int -> IntroPage
get_new_intro intro cstate =
    if cstate == 99 then
        let
            ( oldIm, oldWord ) = (intro.imageOpa, intro.wordOpa)
            ( newIm, newWord ) =
                case (intro.cp, intro.state) of
                    (_, AllAppear) ->
                        ( oldIm + appearSpeed, oldWord + appearSpeed )
                    (_, Normal) ->
                        ( oldIm, oldWord )
                    (_, TypeDisppear) ->
                        ( oldIm, oldWord - disppearSpeed )
                    (_) ->
                        ( oldIm, oldWord )
            (newpage, newState, new2Im ) =
                if newIm > 1.08 && newWord > 1.08 then --need
                    ( intro.cp, Normal, newIm )
                else if newWord <= 0 && newIm >= 1 && intro.cp <= 2 then
                    ( intro.cp + 1, AllAppear, 0 )
                else if newWord <= -0.5 then
                    ( intro.cp, AllAppear, 0 )
                else
                    ( intro.cp, intro.state, newIm )

        in
            { intro | cp = newpage
                    , state = newState
                    , imageOpa = new2Im
                    , wordOpa = newWord
            }
    else
        intro

update_intropage : IntroPage -> IntroPage
update_intropage intro =
    {
        intro | state = TypeDisppear
    }

update_endpage : IntroPage -> IntroPage
update_endpage end =
    {
        end | state = TypeDisppear
    }

list_index_intro : List String -> Int -> String
list_index_intro list index =
    if index > List.length list then
        "abab"

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_intro xs (index - 1)

            _ ->
                "abab"


render_intro : IntroPage -> List (Html Msg)
render_intro intro =
    case intro.cp of
        1 ->
            [ back intro.imageOpa intro.cp
            , div (text_attr intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 1
            ]
        2 ->
            [ back 1 1
            , back intro.imageOpa intro.cp
            , div (text_attr intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 2
            ]
        3 ->
            [ back 1 1
            , back 1 2
            , back intro.imageOpa intro.cp
            , div (text_attr intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 0
            ]
        _ ->
            []

render_end : Int -> IntroPage -> List (Html Msg)
render_end chse end =
    case chse of
        0 ->
            end_back ++
            [ div (text_attr end.wordOpa) (end_base_1 end.cp)
            , button (if end.cp == 3 then 100 else 10)
            ]
        1 ->
            end_back ++
            [ div (text_attr end.wordOpa) (end_base_2 end.cp)
            , button (if end.cp == 3 then 100 else 10)
            ]
        _ ->
            end_back ++
            [ div (text_attr end.wordOpa) (end_base_3 end.cp)
            , button (if end.cp == 3 then 100 else 10)
            ]


        

end_back : List (Html Msg)
end_back =
    [ back 1 1
    , back 1 2
    , back 1 3
    ]


            




get_new_end : IntroPage -> Int -> IntroPage
get_new_end intro cstate =
    if cstate == 30 then
        let
            oldWord =  intro.wordOpa
            newWord  =
                case intro.state of
                    TypeAppear ->
                        oldWord + appearSpeed
                    Normal ->
                        oldWord
                    TypeDisppear ->
                        oldWord - disppearSpeed
                    (_) ->
                        oldWord
            (newpage, newState) =
                if newWord > 1.08 then --need
                    ( intro.cp, Normal)
                else if newWord <= -0.5 then
                    ( intro.cp+1, TypeAppear)
                else
                    ( intro.cp, intro.state)

        in
            { intro | cp = newpage
                    , state = newState
                    , wordOpa = newWord
            }
    else
        intro

back : Float -> Int -> Html Msg
back opa ind =
    Html.img
                [ HtmlAttr.src ("assets/intro/"++(toString ind)++".png")
                , style "top" "0%"
                , style "left" "0%"
                , style "width" "100%"
                , style "position" "absolute"
                , style "opacity" (toString opa)
                ]
                []


button : Int -> Html Msg
button id =
    let
        eff =
            case id of
                0 ->
                    StartChange EnterState
                100 ->
                    Reset
                10 ->
                    Plus 10
                _ ->
                    Plus id
    in
    trans_button_sq ( Button.Button 0 0 100 100 "" eff "block" )




intro_base : String -> Int -> List (Html msg)
intro_base sta ind =
    case ind of
        1 ->
            [ text "My life stopped," --0 0 20
            , br [][]
            , br [][]
            , text "One year ago." --0 1 20
            , br [][]
            , br [][]
            , text "I lost my memory." --0 2 20
            ]

        2 ->
            [ text "Now I have remembered lots of things," --1 3 40
            , br [][], br [][]
            , text "Except Maria, my past lover." --1 4 30
            , br [][], br [][]
            , text "I have heard about her from others many times," --1 5 50
            , br [][], br [][]
            , text "But still can't remember her." --1 6 30
            ]
        3 ->
            [ text "How is she?" --2 7 15
            , br [][], br [][]
            , text "Why we broke out?" --2 8 20
            , br [][], br [][]
            , text "Why she died?" --2 9 15
            , br [][], br [][]
            , text "This house, where we lived together, may give some help." --2 10 60
            , br [][], br [][]
            , text "So, I come here, to find the lost memory for Maria." --2 11 55
            ]
        _ ->
            []




end_base_1 : Int -> List (Html msg)
end_base_1 ind =
    case ind of
        1 ->
            [ 
            ]

        2 ->
            [ text "1111Now I have remembered lots of things," --1 3 40
            , br [][], br [][]
            , text "1111Except Maria, my past lover." --1 4 30
            , br [][], br [][]
            , text "111I have heard about her from others many times," --1 5 50
            , br [][], br [][]
            , text "111But still can't remember her." --1 6 30
            ]
        3 ->
            [ text "1How is she?" --2 7 15
            , br [][], br [][]
            , text "1Why we broke out?" --2 8 20
            , br [][], br [][]
            , text "1Why she died?" --2 9 15
            , br [][], br [][]
            , text "1This house, where we lived together, may give some help." --2 10 60
            , br [][], br [][]
            , text "1So, I come here, to find the lost memory for Maria." --2 11 55
            ]
        _ ->
            []

end_base_2 : Int -> List (Html msg)
end_base_2 ind =
    case ind of
        1 ->
            [ 
            ]

        2 ->
            [ text "322222ow I have remembered lots of things," --1 3 40
            , br [][], br [][]
            , text "1111Except Maria, my past lover." --1 4 30
            , br [][], br [][]
            , text "111I have heard about her from others many times," --1 5 50
            , br [][], br [][]
            , text "111But still can't remember her." --1 6 30
            ]
        3 ->
            [ text "2How is she?" --2 7 15
            , br [][], br [][]
            , text "2Why we broke out?" --2 8 20
            , br [][], br [][]
            , text "2Why she died?" --2 9 15
            , br [][], br [][]
            , text "2This house, where we lived together, may give some help." --2 10 60
            , br [][], br [][]
            , text "So, I come here, to find the lost memory for Maria." --2 11 55
            ]
        _ ->
            []

end_base_3 : Int -> List (Html msg)
end_base_3 ind =
    case ind of
        1 ->
            [ 
            ]

        2 ->
            [ text "3333Now I have remembered lots of things," --1 3 40
            , br [][], br [][]
            , text "3333Except Maria, my past lover." --1 4 30
            , br [][], br [][]
            , text "3333 have heard about her from others many times," --1 5 50
            , br [][], br [][]
            , text "3333But still can't remember her." --1 6 30
            ]
        3 ->
            [ text "3 is she?" --2 7 15
            , br [][], br [][]
            , text "3Why we broke out?" --2 8 20
            , br [][], br [][]
            , text "3Why she died?" --2 9 15
            , br [][], br [][]
            , text "This house, where we lived together, may give some help." --2 10 60
            , br [][], br [][]
            , text "So, I come here, to find the lost memory for Maria." --2 11 55
            ]
        _ ->
            []

text_attr : Float -> List (Html.Attribute msg)
text_attr opa =
    [ style "top" "20%"
    , style "left" "25%"
    , style "width" "50%"
    , style "height" "40%"
    , style "text-align" "center"
    , style "position" "absolute"
    , style "font-size" "40"
    , style "font-family" "Times New Roman"
    , style "opacity" (toString opa)
    ]
