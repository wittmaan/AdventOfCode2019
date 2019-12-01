
## --- Day 1: The Tyranny of the Rocket Equation ---

## --- Part one ---

library(data.table)
library(testthat)

input <- fread("../resources/day01input.txt", header = FALSE, sep = "\n")$V1
sum(floor(input / 3) - 2)

## 3391707


## --- Part two ---

calc_fuel <- function(x) {
  f <- function(y) { floor(y / 3) - 2 }
  fuels <- c(x)
  while (TRUE) {
    act.val <- f(fuels[length(fuels)])
    if (act.val < 0) {
      break
    }
    
    fuels <- c(fuels, act.val)
  }
  
  return(sum(fuels[-1]))
}

expect_equal(calc_fuel(100756), 50346)

sum(sapply(input, calc_fuel))

## 5084676

