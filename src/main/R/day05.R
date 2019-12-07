
## --- Day 5: Sunny with a Chance of Asteroids ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)

input <- scan("../resources/day05input.txt", what = "character")[1] %>% strsplit(",") %>% unlist() %>% as.numeric()


process <- function(x) {
  opcode <- x %% 10
  mode_par1 <- (x %/% 100) %% 10
  mode_par2 <- (x %/% 1000) %% 10
  mode_par3 <- (x %/% 10000) %% 10
  return(list(opcode=opcode, mode_par1=mode_par1, mode_par2=mode_par2, mode_par3=mode_par3))
}

expect_equal(process(1002), list(opcode=2, mode_par1=0, mode_par2=1, mode_par3=0))

POSITION_MODE <- 0
IMMEDIATE_MODE <- 1


process_opcode <- function(x, input) {
  
  pos <- 1
  len_x <- length(x)
  output <- NULL
  cat("got this input:", input, "\n")
  opcodes <- NULL
  
  while(TRUE) {
    cat("pos =", pos, "/ len =", len_x, "\n")
    
    if (x[pos] == 99 || pos >= len_x) {
      break
    }
    
    p <- process(x[pos])
    opcodes <- c(opcodes, p$opcode)
    
    # addition
    if (p$opcode == 1) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1)
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2)
      out <- ifelse(p$mode_par3 == POSITION_MODE, x[pos+3]+1, pos+3)
      x[out] <- x[in1] + x[in2] 
      pos <- pos + 4
    } # multiplication 
    else if (p$opcode == 2) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1) 
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2) 
      out <- ifelse(p$mode_par3 == POSITION_MODE, x[pos+3]+1, pos+3) 
      x[out] <- x[in1] * x[in2] 
      pos <- pos + 4
    } # input
    else if (p$opcode == 3) {
      x[x[pos+1]+1] <- input
      pos <- pos + 2
    } # output
    else if (p$opcode == 4) {
      out <- ifelse(p$mode_par1 == POSITION_MODE, x[x[pos+1]+1], x[pos+1])
      output <- c(output, out)
      pos <- pos + 2
    } # jump-if-true
    else if (p$opcode == 5) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1)
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2)
      pos <- ifelse(x[in1] != 0, x[in2]+1, pos+3) 
    } # jump-if-false
    else if (p$opcode == 6) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1)
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2)
      pos <- ifelse(x[in1] == 0, x[in2]+1, pos+3) 
    }
    # less than
    else if (p$opcode == 7) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1)
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2)
      x[x[pos+3]+1] <- as.numeric(x[in1] < x[in2])
      pos <- pos + 4
    } # equal 
    else if (p$opcode == 8) {
      in1 <- ifelse(p$mode_par1 == POSITION_MODE, x[pos+1]+1, pos+1)
      in2 <- ifelse(p$mode_par2 == POSITION_MODE, x[pos+2]+1, pos+2)
      x[x[pos+3]+1] <- as.numeric(x[in1] == x[in2])
      pos <- pos + 4
    }
    # unkown opcode
    else {
      print(opcodes)
      stop(paste0("unkown opcode: ", p$opcode))
    }
  }
  return(list(x=x, output=output))
}


expect_equal(process_opcode(c(1002,4,3,4,33,99), 2), list(x=c(1002,4,3,4,99,99), output=NULL))
expect_equal(process_opcode(c(3,0,4,0,99), 2), list(x=c(2,0,4,0,99), output=c(2)))
expect_equal(process_opcode(c(1101,100,-1,4,0), 2), list(x=c(1101,100,-1,4,99), output=NULL))

result <- process_opcode(input, 1)
result$output

# 4601506

## --- Part two ---

expect_equal(process_opcode(c(3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
                              1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
                              999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99), 1), 
             list(x=c(3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,
                      98,0,1,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,
                      1000,1,20,4,20,1105,1,46,98,99), output=999))


result <- process_opcode(input, 5)
result$output

# 5525561

