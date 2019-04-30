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

-export([shapesArea/1,squaresArea/1, trianglesArea/1, shapesFilter/1, shapesFilter2/1]).

shapesFilter(Shape) when ((Shape =:= rectangle) or (Shape =:= triangle) or (Shape =:= ellipse)) ->
  case Shape of
    rectangle ->
      fun rectangleFilter/1;
    triangle ->
      fun triangleFilter/1;
    ellipse ->
      fun ellipseFilter/1
  end.

rectangleFilter({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  L1 = [{rectangle,X} || {X1,X}<-L, X1 == rectangle],
  {shapes,L1}.

triangleFilter({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  L1 = [{triangle,X} || {X1,X}<-L, X1 == triangle],
  {shapes,L1}.

ellipseFilter({shapes, L}) when is_list(L) ->
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
      shapesFilter(B)
  end.


squareFilter({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  {_,Rectangles} = (shapesFilter(rectangle))({shapes, L}),
  L1 = [{rectangle,{dim, X, X}} || {rectangle,{dim,X, X}} <- Rectangles],
  {shapes,L1}.

circleFilter({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  {_,Ellipses} = (shapesFilter(ellipse))({shapes, L}),
  L1 = [{ellipse,{radius, X, X}} || {ellipse,{radius,X, X}}<-Ellipses],
  {shapes,L1}.


shapesArea({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  ellipseArea({shapes, L}) + rectangleArea({shapes, L}) + trianglesArea({shapes, L}).



rectangleArea({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  {shapes, Rectangles} = (shapes:shapesFilter2(rectangle))({shapes, L}),
  calcRectangleArea(Rectangles).

squaresArea({shapes, L})  when is_list(L) ->
  isShapesStruct(L),
  {shapes, Squares} = (shapes:shapesFilter2(square))({shapes, L}),
  calcRectangleArea(Squares).

calcRectangleArea([]) -> 0;
calcRectangleArea([H|L]) ->
  {rectangle,{dim, Height, Width}} = H,
  Height * Width + calcRectangleArea(L).


trianglesArea({shapes, L})  when is_list(L) ->
  isShapesStruct(L),
  {shapes, Triangles} = (shapes:shapesFilter2(triangle))({shapes, L}),
  calcTriangleArea(Triangles).

calcTriangleArea([]) -> 0;
calcTriangleArea([H|L]) ->
  {triangle,{dim, Base, Height}} = H,
  Height * Base / 2 + calcTriangleArea(L).


ellipseArea({shapes, L}) when is_list(L) ->
  isShapesStruct(L),
  {shapes, Ellipses} = (shapes:shapesFilter2(ellipse))({shapes, L}),
  calcEllipseArea(Ellipses).

calcEllipseArea([]) -> 0;
calcEllipseArea([H|L]) ->
  {ellipse,{radius, Radius1, Radius2}} = H,
  Radius1 * Radius2 * math:pi() + calcEllipseArea(L).


isShapesStruct([]) -> true;
isShapesStruct([{Shape,{Scale,X,Y}}|T]) when
    (((Shape =:= rectangle) and (Scale =:= dim))
  or ((Shape =:= triangle)  and (Scale =:= dim))
  or ((Shape =:= ellipse)   and (Scale =:= radius))),
      X > 0, Y > 0 -> isShapesStruct(T).




