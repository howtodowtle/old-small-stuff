# tiny code snippets that I want to archive

+ `schafkopf_wkeiten.R` calculates useful probabilities for the traditional Bavarian card game [Schafkopf](https://en.wikipedia.org/wiki/Schafkopf). The game can be played online at [sauspiel.de](https://www.sauspiel.de).
+ `optimal location cph.R`, used to find a good place for where to look for rooms in Copenhagen, depending on which spots I frequent and how often. No public transport or bikepaths included, just Euclidian distance.
+ `lotto.R` takes a vector of weights of lottery numbers as input, convertes those to drawing probabilities and draws random lottery numbers for the German lottery game "6 aus 49" (pick 6 out of 49) according to these probabilities. While any lottery game probably still has negative expected value, this strategy aims to increase the expected value of a combination by assigning a lower drawing probability to popular or more common numbers (for example popular due to birthdays: 1-31, 1-12, 19xx) and thus increasing the expected payout while keeping the winning probability constant.
+ `norrebrogpx.R` displays a GPX file (for example of a run on [Strava](http://strava.com/)) as a line, or points, on a map.
