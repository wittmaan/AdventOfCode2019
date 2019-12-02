
## --- Day 2: 1202 Program Alarm ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)

input <- scan("../resources/day02input.txt", what = "character")[1] %>% strsplit(",") %>% unlist() %>% as.numeric()

sample_input <- c(1,9,10,3,2,3,11,0,99,30,40,50)

process <- function(x) {
  # addidion
  if (x[1] == 1) {
    return(list(op="add", in1=x[2]+1, in2=x[3]+1, out=x[4]+1))
  } # multiplication
  else if (x[1] == 2) {
    return(list(op="mult", in1=x[2]+1, in2=x[3]+1, out=x[4]+1))
  } # finished
  else if (x[1] == 99) {
    return (NULL)
  } else {
    stop(paste("encountered an unkonwn opcode: ", x[1]))
  }
}

process_opcode <- function(x) {
  max_positions <- length(x)
  act_pos <- 4
  result <- x
  while (TRUE) {
    act_op <- process(result[(act_pos-3):act_pos])
    
    if (is.null(act_op)) {
      break
    }
    
    if (act_op$op == "add") {
      result[act_op$out] <- result[act_op$in1] + result[act_op$in2]
    } else if (act_op$op == "mult") {
      result[act_op$out] <- result[act_op$in1] * result[act_op$in2]
    }
    
    if (act_pos >= max_positions) {
      break
    }
    
    act_pos <- act_pos + 4
  }
  
  return(result)
}


expect_equal(process_opcode(sample_input), c(3500,9,10,70,2,3,11,0,99,30,40,50))
expect_equal(process_opcode(c(1,0,0,0,99)), c(2,0,0,0,99))
expect_equal(process_opcode(c(2,3,0,3,99)), c(2,3,0,6,99))
expect_equal(process_opcode(c(2,4,4,5,99,0)), c(2,4,4,5,99,9801))
expect_equal(process_opcode(c(1,1,1,4,99,5,6,0,99)), c(30,1,1,4,2,5,6,0,99))


input[2] <- 12
input[3] <- 2
result <- process_opcode(input)
result[1]

## 5290681


## --- Part two ---

calc_result <- function(x, noun, verb) {
  result <- x
  result[2] <- noun
  result[3] <- verb
  
  result <- process_opcode(result)
  return(result[1])
}

# check
expect_equal(calc_result(input, input[2], input[3]), 5290681)


d <- data.table(noun=rep(0:99, 100), verb=rep(0:99, each=100))
d[, result := calc_result(input, noun, verb), by = 1:nrow(d)][result == 19690720][, 100 * noun + verb]

## 5741

