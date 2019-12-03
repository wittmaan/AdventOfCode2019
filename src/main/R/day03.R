
## --- Day 3: Crossed Wires ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)

input <- scan("../resources/day03input.txt", what = "character")


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
    path <- data.table(x=x[1]:x_new[1], y=rep(x[2], mov_length+1))
  } else {
    path <- data.table(x=rep(x[1], mov_length+1), y=x[2]:x_new[2])
  }
  
  return(path)
}


expect_equal(step(c(0,0), "L10"), data.table(x=0:-10, y=rep(0, 11)))
expect_equal(step(c(0,0), "R10"), data.table(x=0:10, y=rep(0, 11)))
expect_equal(step(c(0,0), "U10"), data.table(x=rep(0, 11), y=0:10))
expect_equal(step(c(0,0), "D10"), data.table(x=rep(0, 11), y=0:-10))


path <- function(x) {
  steps <- strsplit(x, ",") %>% unlist()
  result <- NULL
  last_port <- c(0,0)
  for (s in steps) {
    tmp_step <- step(last_port, s)
    n_step <- nrow(tmp_step)
    last_port <- c(tmp_step[n_step]$x, tmp_step[n_step]$y)
    
    result <- rbind(result, tmp_step)
  }
  
  return(unique(result))
}


p1 <- path("R8,U5,L5,D3")
p2 <- path("U7,R6,D4,L4")

plot(p1, xlim=c(min(p1$x, p2$x), max(p1$x, p2$x)), ylim=c(min(p1$y, p2$y), max(p1$y, p2$y)))
points(p2, pch="+")


calc_intersections <- function(p1, p2) {
  pp1 <- copy(p1)
  pp2 <- copy(p2)
  setkeyv(pp1, c("x", "y"))
  setkeyv(pp2, c("x", "y"))
  intersections <- pp1[pp2, nomatch=0][x !=0 & y != 0]
  intersections[, dist := manhattan_dist(c(0,0), c(x, y)), by = 1:nrow(intersections)]
  return(intersections)
}


calc_min_distance <- function(p1, p2) {
  intersections <- calc_intersections(p1, p2)
  
  return(intersections[dist==min(dist)]$dist)
}


expect_equal(calc_min_distance(path("R8,U5,L5,D3"), path("U7,R6,D4,L4")), 6)
expect_equal(calc_min_distance(path("R75,D30,R83,U83,L12,D49,R71,U7,L72"), path("U62,R66,U55,R34,D71,R55,D58,R83")), 159)
expect_equal(calc_min_distance(path("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"), path("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")), 135)


calc_min_distance(path(input[1]), path(input[2]))

# 2427


## --- Part two ---


calc_minimal_steps <- function(p1, p2) {
  intersections <- calc_intersections(p1, p2)
  p1[, intersection := 0]
  p2[, intersection := 0]
  for (i in 1:nrow(intersections)) {
    p1[intersections[i]$x==x & intersections[i]$y==y, intersection := 1]  
    p2[intersections[i]$x==x & intersections[i]$y==y, intersection := 1]  
  }
  
  p1[, x_diff := abs(x - lead(x))]
  p1[, y_diff := abs(y - lead(y))]
  p2[, x_diff := abs(x - lead(x))]
  p2[, y_diff := abs(y - lead(y))]
  
  ind_p1 <- which(p1$intersection==1)
  ind_p2 <- which(p2$intersection==1)
  
  result <- NULL
  for (i in 1:length(ind_p1)) {
    result <- rbind(result, data.table(x=p1[ind_p1[i]]$x, y=p1[ind_p1[i]]$y, steps=p1[1:ind_p1[i], sum(x_diff) + sum(y_diff) - 1], p="p1"))
  }
  for (i in 1:length(ind_p2)) {
    result <- rbind(result, data.table(x=p2[ind_p2[i]]$x, y=p2[ind_p2[i]]$y, steps=p2[1:ind_p2[i], sum(x_diff) + sum(y_diff) - 1], p="p2"))
  }

  result <- result[, .(sum_steps = sum(steps)), by = .(x, y)]
  
  return(min(result$sum_steps))
}

expect_equal(calc_minimal_steps(path("R8,U5,L5,D3"), path("U7,R6,D4,L4")), 30)
expect_equal(calc_minimal_steps(path("R75,D30,R83,U83,L12,D49,R71,U7,L72"), path("U62,R66,U55,R34,D71,R55,D58,R83")), 610)
expect_equal(calc_minimal_steps(path("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"), path("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")), 410)


calc_minimal_steps(path(input[1]), path(input[2]))

# 27890
