
## --- Day 4: Secure Container ---

## --- Part one ---

library(data.table)
library(testthat)
library(dplyr)


check_password_part1 <- function(x) {
  splitted <- as.character(x) %>% strsplit("") %>% unlist() %>% as.numeric()
  if (any(diff(splitted) < 0)) {
    return(FALSE)
  }
  tab_splitted <- table(splitted)
  
  if (length(tab_splitted) == length(splitted)) {
    return(FALSE)
  }

  return(TRUE)
}

expect_equal(check_password_part1(111111), TRUE)
expect_equal(check_password_part1(223450), FALSE)
expect_equal(check_password_part1(123789), FALSE)
expect_equal(check_password_part1(111123), TRUE)


part1 <- sapply(134792:675810, check_password_part1)
sum(part1)

# 1955

## --- Part two ---

check_password_part2 <- function(x) {
  splitted <- as.character(x) %>% strsplit("") %>% unlist() %>% as.numeric()
  tab_splitted <- table(splitted)
  if (any(diff(splitted) > 0) & any(tab_splitted == 2)) {
    return(TRUE)
  }
  
  return(FALSE)
}


expect_equal(check_password_part2(112233), TRUE)
expect_equal(check_password_part2(123444), FALSE)
expect_equal(check_password_part2(111122), TRUE)


part2 <- sapply(134792:675810, check_password_part2)
sum(part1 & part2)

# 397203 too high


