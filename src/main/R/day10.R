
## --- Day 10: Monitoring Station ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)

input <- scan("../resources/day10input.txt", what = "character")[1] %>% strsplit(",") %>% unlist() %>% as.numeric()

sample_input <- ".#..#
.....
#####
....#
...##"

lines <- strsplit(sample_input, "\n") %>% unlist()

sapply(lines, function(y) {
  y
  #sapply(y, function(x) {  
  #  tmp <- strsplit(x, "")[[1]]
  #  tmp
  #})
  
})



  


## --- Part two ---



# 5525561

