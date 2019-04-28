%-------------------------------------------------------------------
% @author agear
% @copyright (C) 2019, <COMPANY>
% @doc
%
% @end
% Created : 21. Apr 2019 13:05
%-------------------------------------------------------------------
-module(shapes).
-author("ageare").

-export([shapesArea/1,squaresArea/1,triangleArea/1,shapesFilter1/1, shapesFilter2/1]).

shapesFilter1(Shape) when ((Shape =:= rectangle) or (Shape =:= triangle) or (Shape =:= ellipse)) ->
  case Shape of
    rectangle ->
      fun rectangleFilter/1;
    triangle ->
      fun triangleFilter/1;
    ellipse ->
      fun ellipseFilter/1
  end.

rectangleFilter({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  isShapesStruct(L),
  L1 = [{rectangle,X} || {X1,X}<-L, X1 == rectangle],
  {shapes,L1}.

triangleFilter({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  isShapesStruct(L),
  L1 = [{triangle,X} || {X1,X}<-L, X1 == triangle],
  {shapes,L1}.

ellipseFilter({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  isShapesStruct(L),
  L1 = [{ellipse,X} || {X1,X}<-L, X1 == ellipse],
  {shapes,L1}.



shapesFilter2(Shape) when ((Shape =:= rectangle) or (Shape =:= triangle) or
  (Shape =:= ellipse) or (Shape =:= square) or (Shape =:= circle))  ->
  case Shape of
    square ->
      fun squareFilter/1;
    circle ->
      fun circleFilter/1;
    B when B =:= 'triangle'; B =:= 'ellipse'; B =:= 'rectangle' ->
      shapesFilter1(B)
  end.


squareFilter({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    {_,Rectangles} = (shapesFilter1(rectangle))({Shapes, L}),
    L1 = [{rectangle,{dim, X, X}} || {rectangle,{dim,X, X}} <- Rectangles],
    {shapes,L1}
  end.

circleFilter({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    {_,Ellipses} = (shapesFilter1(ellipse))({Shapes, L}),
    L1 = [{ellipse,{radius, X, X}} || {ellipse,{radius,X, X}}<-Ellipses],
    {shapes,L1}
  end.


shapesArea({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    ellipseArea({Shapes, L}) + rectangleArea({Shapes, L}) + triangleArea({Shapes, L})
  end.


rectangleArea({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    {shapes, Rectangles} = (shapes:shapesFilter2(rectangle))({Shapes, L}),
    calcRectangleArea(Rectangles)
  end.

squaresArea({Shapes, L})  when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    {shapes, Squares} = (shapes:shapesFilter2(square))({Shapes, L}),
    calcRectangleArea(Squares)
  end.

calcRectangleArea([]) -> 0;

calcRectangleArea([H|L]) ->
  {rectangle,{dim, Height, Width}} = H,
  Height * Width + calcRectangleArea(L).


triangleArea({Shapes, L})  when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
      {shapes, Triangles} = (shapes:shapesFilter2(triangle))({Shapes, L}),
      calcTriangleArea(Triangles)
  end.

calcTriangleArea([]) -> 0;

calcTriangleArea([H|L]) ->
  {triangle,{dim, Base, Height}} = H,
  Height * Base / 2 + calcTriangleArea(L).


ellipseArea({Shapes, L}) when Shapes =:= shapes, is_list(L) ->
  Res = isShapesStruct(L),
  if
    Res == true ->
    {shapes, Ellipses} = (shapes:shapesFilter2(ellipse))({Shapes, L}),
    calcEllipseArea(Ellipses)
  end.

calcEllipseArea([]) -> 0;

calcEllipseArea([H|L]) ->
  {ellipse,{radius, Radius1, Radius2}} = H,
  Radius1 * Radius2 * math:pi() + calcEllipseArea(L).



isShapesStruct([]) -> true;
isShapesStruct([{Shape,{Scale,X,Y}}|T]) when ((Shape =:= rectangle) or (Shape =:= triangle) or (Shape =:= ellipse)),
  ((Scale =:= dim) or (Scale =:= radius)), X > 0, Y > 0 -> isShapesStruct(T);
isShapesStruct(_) -> false.




