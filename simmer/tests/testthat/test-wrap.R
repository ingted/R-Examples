context("wrap")

test_that("the wrapper behaves as expected", {
  t0 <- create_trajectory() %>%
    seize("server", 1) %>%
    set_attribute("attr", 1) %>%
    release("server", 1)
  
  env <- simmer() %>%
    add_resource("server", 1, 0) %>%
    add_generator("dummy", t0, at(1:10), mon=2) %>%
    run() %>%
    wrap()
  
  expect_equal(env%>%now(), 10)
  expect_equal(env%>%peek(), numeric(0))
  
  arrivals <- env%>%get_mon_arrivals()
  arrivals_res <- env%>%get_mon_arrivals(TRUE)
  attributes <- env%>%get_mon_attributes()
  resources <- env%>%get_mon_resources()
  
  expect_equal(nrow(arrivals), 10)
  expect_equal(nrow(arrivals_res), 10)
  expect_equal(nrow(attributes), 10)
  expect_equal(nrow(resources), 20)
  expect_error(env%>%get_n_generated("asdf"))
  expect_equal(env%>%get_n_generated("dummy"), 10)
  expect_error(env%>%get_capacity("asdf"))
  expect_equal(env%>%get_capacity("server"), 1)
  expect_error(env%>%get_queue_size("asdf"))
  expect_equal(env%>%get_queue_size("server"), 0)
  expect_error(env%>%get_server_count("asdf"))
  expect_equal(env%>%get_server_count("server"), 0)
  expect_error(env%>%get_queue_count("asdf"))
  expect_equal(env%>%get_queue_count("server"), 0)
})
