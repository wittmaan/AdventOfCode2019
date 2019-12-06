
## --- Day 5: Sunny with a Chance of Asteroids ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)


process <- function(x) {
  DE <- x %% 10
  C <- (x %/% 100) %% 10
  B <- (x %/% 1000) %% 10
  A <- (x %/% 10000) %% 10
  return(list(DE=DE, C=C, B=B, A=A))
}

expect_equal(process(1002), list(DE=2, C=0, B=1, A=0))

POSITION_MODE <- 0
IMMEDIATE_MODE <- 1


process_opcode <- function(x) {
  
  pos <- 1
  while(TRUE) {
    p <- process(x[pos])
    
    if (p$DE == 99) {
      break
    } # addition
    else if (p$DE == 1) {
      pos1 <- ifelse(p$C == POSITION_MODE, x[pos+1], pos+1)
      pos2 <- ifelse(p$B == POSITION_MODE, x[pos+2], pos+2)
      x[]
      
    }
  }
  
}


process_opcode(c(1002,4,3,4,33))


## --- Part two ---

