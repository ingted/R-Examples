if(interactive()) library(testthat)

context("try_fetch")

test_that("try_fetch() gives exponential retry messages",{
  set.seed(1)
  with_mock(
    curl_fetch_memory = function(...){
      retry_on = c(400, 401, 440, 503, 504, 509)
      status_code <- if(runif(1) > 0.26) sample(retry_on, 1) else 200
      list(status_code = status_code, contents = NA)
    }, {
      msg <- "Request failed with status 440. Waiting 0.1 seconds before retry\n"
      expect_message(
        try_fetch(delay = 0.1, no_message_threshold = 0),
        msg
      )
    },
    .env = "curl"
  )
  
})
