
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

  act_val <- x
  fuel_sum <- 0
  while (TRUE) {
    act_val <- f(act_val)
    if (act_val < 0) {
      break
    }
    
    fuel_sum <- fuel_sum + act_val
  }
  
  return(fuel_sum)
}

expect_equal(calc_fuel(100756), 50346)

sum(sapply(input, calc_fuel))

## 5084676

