;Author: Steffen Simmen 2023
globals [
  x ;used to setup voters in setup-voters-normal
  y ;used to setup voters in setup-voters-normal
  control-variable ;used as a boolean in decide-type-of-election
  median-x ;the median's x-coordinate of all voters
  median-y ;the median's y-coordinate of all voters
  counter-of-non-voters ;the counter or number of non-voters, used to set the number-of-non-voters, which has the same value, at the end of election process to appear smoother
  number-of-non-voters ;the number of non-voters, set by counter-of-non-voters, which has the same value, at the end of election process to appear smoother
  total-number-of-voters ;the total number of voters
]

breed [ parties a-party ]; turtles can be parties or voters
breed [ voters a-voter ]; turtles can be parties or voters

parties-own [
  number-of-votes ;the number of votes every political party got in this election.
  id ; the id of the political party. Starts with 0.
  go-to-median? ;Shall the party go to the median-voter?
  intelligent? ;Shall the party use "intelligent behavior" by using comparing the difference of votes of this election to the votes of the previous election?
  to-position? ;Shall the party go to the set x and y coordinates?
  wiggle? ;Shall the party wiggle?
  target-x-cor ;Target x-coordinate
  target-y-cor ;Target x-coordinate
  number-of-last-votes ;The number of votes in the previous election
  total-number-of-votes ; All votes the political party ever received. Used for debugging.
  votes-during-election ;used to calculate the number-of-votes. Used to get simple updates in the graphical interface.
]

;Sets up the model.
to setup
  clear-all
  ask patches [ set pcolor white ]
  ask patch 0 0 [ set pcolor black ]
  setup-parties
  ask parties [ set number-of-last-votes 0 set number-of-votes 0]
  setup-voters-normal
  reset-ticks
  tick
end

;Makes unlimited iterations of going. Used by the respective button.
to go
  going
end

;Makes 1 iteration of going. Used by the respective button.
to go-once
  going
end

;Makes 1000 iterations of going. Used by the respective button.
to go-to-1000
  if ticks mod 1000 = 0 [ tick stop ]
  going
end

;the script of all going behavior. Political parties are setup, after that all unnessary parties killed, the party behavior is updated,
;then the movement is done (first intelligent movement, then movement toward median voter, then movement to a set position, then random behavior ("wiggle")),
;after that the type of election is decided and executed, then the visibility of all turtles is updated and then at last the tick increased.
to going
  setup-parties
  cleanup-parties
  update-behavior-of-parties
  go-intelligent
  go-to-median
  go-to-position
  wiggle
  decide-type-of-election
  ifelse visibility-of-parties = true [ ask parties [ set hidden? false ] ] [ ask parties [ set hidden? true ] ]
  ifelse visibility-of-voters = true [ ask voters [ set hidden? false ] ] [ ask voters [ set hidden? true ] ]
  tick
end

;creates all voters. Voters are created via random-normal distribution around the center, where 8 units is one standard deviation.
to setup-voters-normal
  set total-number-of-voters number-of-voters * ( 10 ^ times-10-power )
  set x random-normal 0 8
  set y random-normal 0 8
  while [ x < -32 or x > 32] [ set x random-normal 0 8 ]
  while [ y < -32 or y > 32] [ set y random-normal 0 8 ]
  create-voters total-number-of-voters [ setxy x y
    set x random-normal 0 8
    set y random-normal 0 8
    while [ x < -32 or x > 32] [ set x random-normal 0 8 ]
    while [ y < -32 or y > 32] [ set y random-normal 0 8 ]
  ]
  set median-x median [ xcor ] of voters
  set median-y median [ ycor ] of voters
  ifelse visibility-of-voters = true [ ask voters [ set hidden? false ] ] [ ask voters [ set hidden? true ] ]
end

;setups all political parties. this is done either random or with set x and y coordinates for each political party respectively.
to setup-parties
  if party0 = true and not any? parties with [ id = 0 ] [
    ifelse random-position-0? = true [
      create-parties 1 [ set id 0 setxy random-xcor random-ycor set color black ] ] [
      create-parties 1 [ set id 0 setxy x-cor-0 y-cor-0 set color black ]
    ]
  ]
  if party1 = true and not any? parties with [ id = 1 ] [
    ifelse random-position-1? = true [
      create-parties 1 [ set id 1 setxy random-xcor random-ycor set color red ] ] [
      create-parties 1 [ set id 1 setxy x-cor-1 y-cor-1 set color red ]
    ]
  ]
  if party2 = true and not any? parties with [ id = 2 ] [
    ifelse random-position-2? = true [
      create-parties 1 [ set id 2 setxy random-xcor random-ycor set color yellow ] ] [
      create-parties 1 [ set id 2 setxy x-cor-2 y-cor-2 set color yellow ]
    ]
  ]
  if party3 = true and not any? parties with [ id = 3 ] [
    ifelse random-position-3? = true [
      create-parties 1 [ set id 3 setxy random-xcor random-ycor set color green ] ] [
      create-parties 1 [ set id 3 setxy x-cor-3 y-cor-3 set color green ]
    ]
  ]
  if party4 = true and not any? parties with [ id = 4 ] [
    ifelse random-position-4? = true [
      create-parties 1 [ set id 4 setxy random-xcor random-ycor set color blue ] ] [
      create-parties 1 [ set id 4 setxy x-cor-4 y-cor-4 set color blue ]
    ]
  ]
  if party5 = true and not any? parties with [ id = 5 ] [
    ifelse random-position-5? = true [
      create-parties 1 [ set id 5 setxy random-xcor random-ycor set color pink ] ] [
      create-parties 1 [ set id 5 setxy x-cor-5 y-cor-5 set color pink ]
    ]
  ]
  if party6 = true and not any? parties with [ id = 6 ] [
    ifelse random-position-6? = true [
      create-parties 1 [ set id 6 setxy random-xcor random-ycor set color orange ] ] [
      create-parties 1 [ set id 6 setxy x-cor-6 y-cor-6 set color orange ]
    ]
  ]
  if party7 = true and not any? parties with [ id = 7 ] [
    ifelse random-position-7? = true [
      create-parties 1 [ set id 7 setxy random-xcor random-ycor set color lime ] ] [
      create-parties 1 [ set id 7 setxy x-cor-7 y-cor-7 set color lime ]
    ]
  ]
  ifelse visibility-of-parties = true [ ask parties [ set hidden? false ] ] [ ask parties [ set hidden? true ] ]
end

;kills all parties that exist but should not exist due to the respective button being false
to cleanup-parties
  if party0 = false and any? parties with [ id = 0 ] [ ask parties with [ id = 0 ] [ die ] ]
  if party1 = false and any? parties with [ id = 1 ] [ ask parties with [ id = 1 ] [ die ] ]
  if party2 = false and any? parties with [ id = 2 ] [ ask parties with [ id = 2 ] [ die ] ]
  if party3 = false and any? parties with [ id = 3 ] [ ask parties with [ id = 3 ] [ die ] ]
  if party4 = false and any? parties with [ id = 4 ] [ ask parties with [ id = 4 ] [ die ] ]
  if party5 = false and any? parties with [ id = 5 ] [ ask parties with [ id = 5 ] [ die ] ]
  if party6 = false and any? parties with [ id = 6 ] [ ask parties with [ id = 6 ] [ die ] ]
  if party7 = false and any? parties with [ id = 7 ] [ ask parties with [ id = 7 ] [ die ] ]
end

;updates the settings for each political party
to update-behavior-of-parties
  ask parties [ if id = 0 [ set go-to-median? to-median-0? set intelligent? intelligent-0? set to-position? to-position-0? set target-x-cor x-cor-0 set target-y-cor y-cor-0 set wiggle? wiggle-0? ] ]
  ask parties [ if id = 1 [ set go-to-median? to-median-1? set intelligent? intelligent-1? set to-position? to-position-1? set target-x-cor x-cor-1 set target-y-cor y-cor-1 set wiggle? wiggle-1? ] ]
  ask parties [ if id = 2 [ set go-to-median? to-median-2? set intelligent? intelligent-2? set to-position? to-position-2? set target-x-cor x-cor-2 set target-y-cor y-cor-2 set wiggle? wiggle-2? ] ]
  ask parties [ if id = 3 [ set go-to-median? to-median-3? set intelligent? intelligent-3? set to-position? to-position-3? set target-x-cor x-cor-3 set target-y-cor y-cor-3 set wiggle? wiggle-3? ] ]
  ask parties [ if id = 4 [ set go-to-median? to-median-4? set intelligent? intelligent-4? set to-position? to-position-4? set target-x-cor x-cor-4 set target-y-cor y-cor-4 set wiggle? wiggle-4? ] ]
  ask parties [ if id = 5 [ set go-to-median? to-median-5? set intelligent? intelligent-5? set to-position? to-position-5? set target-x-cor x-cor-5 set target-y-cor y-cor-5 set wiggle? wiggle-5? ] ]
  ask parties [ if id = 6 [ set go-to-median? to-median-6? set intelligent? intelligent-6? set to-position? to-position-6? set target-x-cor x-cor-6 set target-y-cor y-cor-6 set wiggle? wiggle-6? ] ]
  ask parties [ if id = 7 [ set go-to-median? to-median-7? set intelligent? intelligent-7? set to-position? to-position-7? set target-x-cor x-cor-7 set target-y-cor y-cor-7 set wiggle? wiggle-7? ] ]
end

;movement of intelligent behavior
to go-intelligent
  ask parties [ if intelligent? = true [ ifelse number-of-votes - number-of-last-votes < 0 [ right 180 forward random-float 0.75 ] [ forward random-float 0.5 ] ] ]
end

;movement toward median-voter
to go-to-median
  ask parties [ if go-to-median? = true [ facexy median-x median-y forward random-float to-mean-max-range ] ]
end

;movement toward set x and y position
to go-to-position
  ask parties [ if to-position? = true [ facexy target-x-cor target-y-cor forward random-float 0.4 ] ]
end

;random movement
to wiggle
  ask parties [ if wiggle? = true [ ifelse random 2 = 1 [ right random 20 ] [ right random -20 ] forward random-float 0.1 ] ]
end

;decides what type of election is done
to decide-type-of-election
  set control-variable true
  set counter-of-non-voters 0
  set number-of-non-voters 0
  ifelse any? parties [
  if type-of-election = 0 and control-variable = true [ set control-variable false make-normal-election show "made-normal-election" ]
  if type-of-election = 1 and control-variable = true [ set control-variable false make-election-with-max-exclusive-radius show "made-election-with-max-exclusive-radius" ]
  if type-of-election = 2 and control-variable = true [ set control-variable false make-election-with-max-inclusive-radius show "made-election-with-max-inclusive-radius" ]
  if type-of-election = 3 and control-variable = true [ set control-variable false make-election-with-max-exclusive-and-inclusive-radius show "made-election-with-max-exclusive-and-inclusive-radius" ]
  set number-of-non-voters counter-of-non-voters
  ]
  [ set number-of-non-voters total-number-of-voters ]
  set control-variable false
end

;makes the normal election, normal election means that each voter votes for the next political party.
to make-normal-election
  set counter-of-non-voters 0
  ask parties [ set number-of-last-votes number-of-votes set votes-during-election 0 ]
  ask voters [ ask min-one-of parties [ distance myself ] [ set votes-during-election votes-during-election + 1 set total-number-of-votes total-number-of-votes + 1] ]
  ask parties [ set number-of-votes votes-during-election ]
end

;makes the election with max exclusive radius, so if there is more than one political party in the radius around the voter then the voter does not vote.
to make-election-with-max-exclusive-radius
  set counter-of-non-voters 0
  ask parties [ set number-of-last-votes number-of-votes set votes-during-election 0 ]
  ask voters [ ifelse count parties in-radius max-exclusive-radius < 2 [ ask min-one-of parties [ distance myself ] [ set votes-during-election votes-during-election + 1 set total-number-of-votes total-number-of-votes + 1] ] [ set counter-of-non-voters counter-of-non-voters + 1 ] ]
  ask parties [ set number-of-votes votes-during-election ]
end

;makes the elction with max inclusive radius, so the if the next political party is outside this radius then the voter does not vote.
to make-election-with-max-inclusive-radius
  set counter-of-non-voters 0
  ask parties [ set number-of-last-votes number-of-votes set votes-during-election 0 ]
  ask voters [ ifelse count parties in-radius max-inclusive-radius > 0 [ ask min-one-of parties [ distance myself ] [ set votes-during-election votes-during-election + 1 set total-number-of-votes total-number-of-votes + 1] ] [ set counter-of-non-voters counter-of-non-voters + 1 ] ]
  ask parties [ set number-of-votes votes-during-election ]
end

;makes the election with max inclusive and max exclusive radius,
;so if the next political party is outside this radius then the voter does not vote AND if there is more than one political party in the radius around the voter then the voter does not vote.
to make-election-with-max-exclusive-and-inclusive-radius
  set counter-of-non-voters 0
  ask parties [ set number-of-last-votes number-of-votes set votes-during-election 0 ]
  ask voters [ ifelse count parties in-radius max-exclusive-radius < 2 and count parties in-radius max-inclusive-radius > 0 [ ask min-one-of parties [ distance myself ] [ set votes-during-election votes-during-election + 1 set total-number-of-votes total-number-of-votes + 1] ] [ set counter-of-non-voters counter-of-non-voters + 1 ] ]
  ask parties [ set number-of-votes votes-during-election ]
end

;used by the respective button to set the total number of all votes done to 0.
to reset-total-number-of-votes
  ask parties [ set total-number-of-votes 0 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
1082
43
1496
458
-1
-1
6.25
1
10
1
1
1
0
0
0
1
-32
32
-32
32
1
1
1
ticks
30.0

BUTTON
0
75
55
108
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
54
75
109
108
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
552
354
676
387
to-median-1?
to-median-1?
1
1
-1000

SLIDER
272
111
464
144
max-exclusive-radius
max-exclusive-radius
0
20
8.0
1
1
distance
HORIZONTAL

SLIDER
272
142
444
175
max-inclusive-radius
max-inclusive-radius
1
47
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
44
117
77
number-of-voters
number-of-voters
1
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
117
44
230
77
times-10-power
times-10-power
0
5
3.0
1
1
NIL
HORIZONTAL

PLOT
575
10
1067
216
number-of-votes-per-party
ticks
number-of-votes
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"party-0" 1.0 0 -16777216 true "" "if any? parties with [ id = 0 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 0 ] [ id ] ]"
"party-1" 1.0 0 -2674135 true "" "if any? parties with [ id = 1 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 1 ] [ id ] ]"
"party-2" 1.0 0 -1184463 true "" "if any? parties with [ id = 2 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 2 ] [ id ] ]"
"party-3" 1.0 0 -10899396 true "" "if any? parties with [ id = 3 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 3 ] [ id ] ]"
"party-4" 1.0 0 -13345367 true "" "if any? parties with [ id = 4 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 4 ] [ id ] ]"
"party-5" 1.0 0 -2064490 true "" "if any? parties with [ id = 5 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 5 ] [ id ] ]"
"party-6" 1.0 0 -955883 true "" "if any? parties with [ id = 6 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 6 ] [ id ] ]"
"party-7" 1.0 0 -13840069 true "" "if any? parties with [ id = 7 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 7 ] [ id ] ]"
"party-8" 1.0 0 -7500403 true "" "if any? parties with [ id = 8 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 8 ] [ id ] ]"
"party-9" 1.0 0 -6459832 true "" "if any? parties with [ id = 9 ] [ plot [ number-of-votes ] of max-one-of parties with [ id = 9 ] [ id ] ]"

SWITCH
1277
10
1423
43
visibility-of-voters
visibility-of-voters
0
1
-1000

SWITCH
1122
10
1271
43
visibility-of-parties
visibility-of-parties
0
1
-1000

BUTTON
109
76
164
109
NIL
go-once
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
163
76
230
109
NIL
go-to-1000
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
1037
550
1179
583
to-mean-max-range
to-mean-max-range
0
3
0.75
0.25
1
NIL
HORIZONTAL

SLIDER
272
78
444
111
type-of-election
type-of-election
0
3
0.0
1
1
NIL
HORIZONTAL

TEXTBOX
276
10
571
83
Here you can decide what type of election process is used\n0 - normal election \n1 - election with max-exclusive-radius = Indifference of voters\n2 - election with max-inclusive-radius = Alienation of voters\n3 - election with max-exclusive-radius and max-inclusive-radius 
10
0.0
1

SWITCH
8
318
98
351
party0
party0
1
1
-1000

SWITCH
100
318
234
351
random-position-0?
random-position-0?
1
1
-1000

SLIDER
236
318
388
351
x-cor-0
x-cor-0
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
318
547
351
y-cor-0
y-cor-0
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SWITCH
8
354
98
387
party1
party1
1
1
-1000

SWITCH
8
389
98
422
party2
party2
1
1
-1000

SWITCH
8
425
98
458
party3
party3
1
1
-1000

SWITCH
8
460
98
493
party4
party4
1
1
-1000

SWITCH
8
494
98
527
party5
party5
1
1
-1000

SWITCH
8
529
98
562
party6
party6
1
1
-1000

SWITCH
8
564
98
597
party7
party7
1
1
-1000

SWITCH
100
354
234
387
random-position-1?
random-position-1?
1
1
-1000

SWITCH
100
390
234
423
random-position-2?
random-position-2?
1
1
-1000

SWITCH
100
425
234
458
random-position-3?
random-position-3?
1
1
-1000

SWITCH
100
460
234
493
random-position-4?
random-position-4?
1
1
-1000

SWITCH
100
494
234
527
random-position-5?
random-position-5?
1
1
-1000

SWITCH
100
529
234
562
random-position-6?
random-position-6?
1
1
-1000

SWITCH
100
564
234
597
random-position-7?
random-position-7?
1
1
-1000

SLIDER
236
354
388
387
x-cor-1
x-cor-1
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
236
390
388
423
x-cor-2
x-cor-2
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
236
425
388
458
x-cor-3
x-cor-3
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
236
460
388
493
x-cor-4
x-cor-4
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
236
494
388
527
x-cor-5
x-cor-5
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
236
529
388
562
x-cor-6
x-cor-6
-32
32
0.0
0.5
1
NIL
HORIZONTAL

SLIDER
236
564
388
597
x-cor-7
x-cor-7
-32
32
0.0
0.5
1
NIL
HORIZONTAL

SLIDER
391
354
547
387
y-cor-1
y-cor-1
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
390
547
423
y-cor-2
y-cor-2
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
425
547
458
y-cor-3
y-cor-3
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
460
547
493
y-cor-4
y-cor-4
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
494
547
527
y-cor-5
y-cor-5
-32
32
0.0
0.25
1
NIL
HORIZONTAL

SLIDER
391
529
547
562
y-cor-6
y-cor-6
-32
32
0.0
0.5
1
NIL
HORIZONTAL

SLIDER
391
564
547
597
y-cor-7
y-cor-7
-32
32
0.0
0.5
1
NIL
HORIZONTAL

SWITCH
552
390
676
423
to-median-2?
to-median-2?
1
1
-1000

SWITCH
552
425
676
458
to-median-3?
to-median-3?
1
1
-1000

SWITCH
552
460
676
493
to-median-4?
to-median-4?
1
1
-1000

SWITCH
552
494
676
527
to-median-5?
to-median-5?
1
1
-1000

SWITCH
552
318
676
351
to-median-0?
to-median-0?
1
1
-1000

SWITCH
552
529
676
562
to-median-6?
to-median-6?
1
1
-1000

SWITCH
552
564
676
597
to-median-7?
to-median-7?
1
1
-1000

SWITCH
681
318
796
351
intelligent-0?
intelligent-0?
1
1
-1000

SWITCH
681
354
796
387
intelligent-1?
intelligent-1?
1
1
-1000

SWITCH
681
390
796
423
intelligent-2?
intelligent-2?
1
1
-1000

SWITCH
681
425
796
458
intelligent-3?
intelligent-3?
1
1
-1000

SWITCH
681
460
796
493
intelligent-4?
intelligent-4?
1
1
-1000

SWITCH
681
494
796
527
intelligent-5?
intelligent-5?
1
1
-1000

SWITCH
681
529
796
562
intelligent-6?
intelligent-6?
1
1
-1000

SWITCH
681
564
796
597
intelligent-7?
intelligent-7?
1
1
-1000

BUTTON
0
10
178
43
NIL
reset-total-number-of-votes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
800
318
926
351
to-position-0?
to-position-0?
1
1
-1000

SWITCH
800
354
925
387
to-position-1?
to-position-1?
1
1
-1000

SWITCH
800
390
925
423
to-position-2?
to-position-2?
1
1
-1000

SWITCH
800
425
925
458
to-position-3?
to-position-3?
1
1
-1000

SWITCH
800
460
925
493
to-position-4?
to-position-4?
1
1
-1000

SWITCH
800
494
925
527
to-position-5?
to-position-5?
1
1
-1000

SWITCH
800
529
925
562
to-position-6?
to-position-6?
1
1
-1000

SWITCH
800
564
925
597
to-position-7?
to-position-7?
1
1
-1000

SWITCH
931
318
1021
351
wiggle-0?
wiggle-0?
1
1
-1000

SWITCH
931
354
1021
387
wiggle-1?
wiggle-1?
1
1
-1000

SWITCH
931
390
1021
423
wiggle-2?
wiggle-2?
1
1
-1000

SWITCH
931
425
1021
458
wiggle-3?
wiggle-3?
1
1
-1000

SWITCH
931
460
1021
493
wiggle-4?
wiggle-4?
1
1
-1000

SWITCH
931
494
1021
527
wiggle-5?
wiggle-5?
1
1
-1000

SWITCH
931
529
1021
562
wiggle-6?
wiggle-6?
1
1
-1000

SWITCH
931
564
1021
597
wiggle-7?
wiggle-7?
1
1
-1000

MONITOR
384
219
460
264
#-non-voter
number-of-non-voters
17
1
11

MONITOR
384
265
460
310
%-non-voter
number-of-non-voters / total-number-of-voters * 100
17
1
11

MONITOR
463
219
538
264
#-votes-0
[ number-of-votes ] of max-one-of parties with [ id = 0 ] [ id ]
17
1
11

MONITOR
540
220
614
265
#-votes-1
[ number-of-votes ] of max-one-of parties with [ id = 1 ] [ id ]
17
1
11

MONITOR
616
220
690
265
#-votes-2
[ number-of-votes ] of max-one-of parties with [ id = 2 ] [ id ]
17
1
11

MONITOR
692
220
765
265
#-votes-3
[ number-of-votes ] of max-one-of parties with [ id = 3 ] [ id ]
17
1
11

MONITOR
768
220
842
265
#-votes-4
[ number-of-votes ] of max-one-of parties with [ id = 4 ] [ id ]
17
1
11

MONITOR
846
220
920
265
#-votes-5
[ number-of-votes ] of max-one-of parties with [ id = 5 ] [ id ]
17
1
11

MONITOR
921
220
995
265
#-votes-6
[ number-of-votes ] of max-one-of parties with [ id = 6 ] [ id ]
17
1
11

MONITOR
998
219
1069
264
#-votes-7
[ number-of-votes ] of max-one-of parties with [ id = 7 ] [ id ]
17
1
11

MONITOR
463
266
537
311
%-votes-0
[ number-of-votes ] of max-one-of parties with [ id = 0 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
540
266
614
311
%-votes-1
[ number-of-votes ] of max-one-of parties with [ id = 1 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
616
266
690
311
%-votes-2
[ number-of-votes ] of max-one-of parties with [ id = 2 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
692
266
766
311
%-votes-3
[ number-of-votes ] of max-one-of parties with [ id = 3 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
768
266
842
311
%-votes-4
[ number-of-votes ] of max-one-of parties with [ id = 4 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
846
266
920
311
%-votes-5
[ number-of-votes ] of max-one-of parties with [ id = 5 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
921
266
995
311
%-votes-6
[ number-of-votes ] of max-one-of parties with [ id = 6 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

MONITOR
997
266
1070
311
%-votes-7
[ number-of-votes ] of max-one-of parties with [ id = 7 ] [ id ] / ( total-number-of-voters - number-of-non-voters ) * 100
17
1
11

@#$#@#$#@
## WHAT IS IT?

This is a model for political parties and voters in a 2-dimensional policy space. It can be used for moving parties and snapshots of situations.

In Political Science the position of political parties in a 2-dimensional policy space is a relevant point of research. The voters may vote using indifference or alienation.
Alienation means a voter will not vote for a party too close to him. Indifference means a voter will not vote for parties if they are too similar. 

Also, it is possible to let political parties move over time with different behavior.


## HOW IT WORKS

This will create voters and the political parties depending on the settings. The greatest number of voters is 1000000. Nevertheless, it is recommended to adjust that number to the hardware you are using.

Voters will vote for parties in this way: Voters will vote deterministically for the single party next to them. This is always true, but additional behavior can be added to the process of voting. 
First, you can add a max inclusive radius (= indifference), which means that the voter will only vote if there is not more than one party in this max inclusive radius. In other words, if there are two are more political parties within this radius of his the voter will not vote. 
The second addition to voting is the max inclusive radius (= alienation). Voters will vote only for parties in this circle. In other words, if the next political party is outside of this radius then the voter will not vote.
Third it is also possible to add both behaviors at the same time with the slider kind-of-election.

The behavior of parties is more complex. There are 8 different possible political parties, able to be created, deleted and to move. The behavior of each party can be changed during the complete time of each model for all parties. 


## HOW TO USE IT

The number of voters can be pre-defined by using the sliders number-of-voters and times-10-power, where the resulting number of voters is ="number-of-voters"*10^"times-10-power".

The Visibility of voters and parties can be changed by the switches at the right side. 

The number of total votes every party got can be set to 0 by the according button at the top left side. The election results can be seen at the top center.

The slider type-of-election at the center top decides what kind of election is being used. The radius for each way of voting can be adjusted by the sliders underneath that.

Political parties can be created and killed by their switches at the bottom left.

The switch random-position is used if the starting point of a party must be random.

The slider x-cor and y-cor can be used for a not random starting position. 
The starting position of a party will be the x-cor and y-cor of those sliders if the starting position is not random. Also, these sliders are used for the destination of a party. If the switch to-position? is on then the party will move for each tick toward these coordinates. 

The to-median? switch is used to enable the behavior that forces a party to run toward the median voter. The distance can be adjusted for every party with the to-mean-max-range slider.

Wiggle? is used to let a party wiggle. That means that the party will move randomly and change direction randomly by a small amount. 

Intelligent? is used to enable "intelligent" behavior. that means The party will change direction by 180 degrees if the number of votes the party got this election is smaller than the number of votes for the previous election.

## THINGS TO NOTICE
The indifference in this model may actually be homophily with the analysis paralysis of the voter.

## THINGS TO TRY

Try out different numbers of voters and compare them. Is this model behaving differently? 
Compare different strategies for parties and look for changes when new parties enter the stage. Will parties adjust? And in what way will they do that? Are there losers by the number of votes?
Try out if over time every party will get the same amount of votes. If so, is this model stable or fair? Or are there certain losers over time?
What happens when you are using the political parties of your country or land? Will you get results that resemble reality?

## EXTENDING THE MODEL

This model can be extended by long-term analysis tools for numerous runs with equal starting settings. Will parties always behave equally although randomness is present?
Try out non-deterministic voting. 
Code a more straightforward indifference. Maybe it will perform better or worse?



## CREDITS AND REFERENCES

I am Steffen Simmen. This model is part of my master's thesis: 09.2023 in political science at Kiel University.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

orbit 1
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 false true 41 41 218

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
