
## --- Day 3: Crossed Wires ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)

input <- scan("../resources/day03input.txt", what = "character")[1] %>% strsplit(",") %>% unlist() %>% as.numeric()


manhattan_dist <- function(a, b) { return(sum(abs(a-b))) }


step <- function(x, direction) {
  mov_direction <- substring(direction, 1, 1)
  mov_length <- as.numeric(substring(direction, 2, nchar(direction)))
  x_new <- x
  
  if (mov_direction == "L") {
    x_new[1] <- x[1] - mov_length
  } else if (mov_direction == "R") {
    x_new[1] <- x[1] + mov_length
  } else if (mov_direction == "U") {
    x_new[2] <- x[2] + mov_length
  } else if (mov_direction == "D") {
    x_new[2] <- x[2] - mov_length
  }
  
  if (mov_direction == "L" | mov_direction == "R") {
    path <- data.frame(x=x[1]:x_new[1], y=rep(x[2], mov_length+1))
  } else {
    path <- data.frame(x=rep(x[1], mov_length+1), y=x[2]:x_new[2])
  }
  
  return(path)
}


expect_equal(step(c(0,0), "L10"), data.frame(x=0:-10, y=rep(0, 11)))
expect_equal(step(c(0,0), "R10"), data.frame(x=0:10, y=rep(0, 11)))
expect_equal(step(c(0,0), "U10"), data.frame(x=rep(0, 11), y=0:10))
expect_equal(step(c(0,0), "D10"), data.frame(x=rep(0, 11), y=0:-10))


path <- function(x) {
  steps <- strsplit(x, ",") %>% unlist()
  result <- NULL
  last_port <- c(0,0)
  for (s in steps) {
    tmp_step <- step(last_port, s)
    n_step <- nrow(tmp_step)
    last_port <- c(tmp_step[n_step, 1], tmp_step[n_step, 2])
    
    result <- rbind(result, tmp_step)
  }
  return(result)
}


p1 <- path("R8,U5,L5,D3")
p2 <- path("U7,R6,D4,L4")

#d <- NULL
min_dist <- NULL
for (i in 1:nrow(p1)) {
  for (j in 1:nrow(p2)) {
    act_dist <- manhattan_dist(p1[i,],p2[j,])
    if (act_dist > 0 && (is.null(min_dist) || act_dist < min_dist)) {
      print(min_dist)
      min_dist <- act_dist
    }
    #d <- rbind(d, data.frame(i=i, j=j, dist=))
  }
}  

plot(p1, xlim=c(min(p1$x, p2$x), max(p1$x, p2$x)), ylim=c(min(p1$y, p2$y), max(p1$y, p2$y)))
points(p2, pch="+")

## --- Part two ---




