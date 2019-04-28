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

shapesFilter1(rectangle)->
  fun rectangleFilter/1;

shapesFilter1(triangle)->
  fun triangleFilter/1;

shapesFilter1(ellipse)->
  fun ellipseFilter/1.

rectangleFilter(Tuple) ->
  isShapesStruct(Tuple),
  {shapes,L} = Tuple,
  L1 = [{rectangle,X} || {X1,X}<-L, X1 == rectangle],
  {shapes,L1}.

triangleFilter(Tuple) ->
  {shapes,L} = Tuple,
  L1 = [{triangle,X} || {X1,X}<-L, X1 == triangle],
  {shapes,L1}.

ellipseFilter(Tuple) ->
  {shapes,L} = Tuple,
  L1 = [{ellipse,X} || {X1,X}<-L, X1 == ellipse],
  {shapes,L1}.

shapesFilter2(X)->
  case X of
    square ->
      fun squareFilter/1;
    circle ->
      fun circleFilter/1;
    B when B =:= 'triangle'; B =:= 'ellipse'; B =:= 'rectangle' ->
      shapesFilter1(B)
  end.


squareFilter(Tuple) ->
  Rectangles = (shapesFilter1(rectangle))(Tuple),
  {shapes, L} = Rectangles,
  L1 = [{rectangle,{dim, X, X}} || {rectangle,{dim,X, X}}<-L],
  {shapes,L1}.

circleFilter(Tuple) ->
  Ellipses = (shapesFilter1(ellipse))(Tuple),
  {shapes, L} = Ellipses,
  L1 = [{ellipse,{radius, X, X}} || {ellipse,{radius,X, X}}<-L],
  {shapes,L1}.





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shapesArea(Tuple) ->
  ellipseArea(Tuple) + squaresArea(Tuple) + triangleArea(Tuple).




squaresArea(Tuple) ->
  {shapes, Squares} = (shapes:shapesFilter2(square))(Tuple),
  calcSquareArea(Squares).

calcSquareArea([]) -> 0;

calcSquareArea([H|L]) ->
  {rectangle,{dim, Height, Width}} = H,
  Height * Width + calcSquareArea(L).


triangleArea(Tuple) ->
  {shapes, Triangles} = (shapes:shapesFilter2(triangle))(Tuple),
  calcTriangleArea(Triangles).

calcTriangleArea([]) -> 0;

calcTriangleArea([H|L]) ->
  {triangle,{dim, Base, Height}} = H,
  Height * Base / 2 + calcTriangleArea(L).


ellipseArea(Tuple) ->
  {shapes, Ellipses} = (shapes:shapesFilter2(ellipse))(Tuple),
  calcEllipseArea(Ellipses).

calcEllipseArea([]) -> 0;

calcEllipseArea([H|L]) ->
  {ellipse,{radius, Radius1, Radius2}} = H,
  Radius1 * Radius2 * math:pi() + calcEllipseArea(L).



isShapesStruct({X,Y}) when X =:= shapes, Y =/= []->
  isValidShape(Y);
isShapesStruct(_) -> false.

isValidShape([]) -> true;
isValidShape([{Shape,{Scale,X,Y}}|T]) when ((Shape =:= rectangle) or (Shape =:= triangle) or (Shape =:= ellipse)),
  ((Scale =:= dim) or (Scale =:= radius)), X > 0, Y > 0-> isValidShape(T);
isValidShape(_) -> false.

