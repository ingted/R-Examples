context("resource-priorities")

test_that("priority queues are adhered to (1)", {
  t0 <- create_trajectory("nonprior") %>%
    seize("server", 1, priority=0) %>%
    timeout(2) %>%
    release("server", 1)
  
  t1 <- create_trajectory("prior") %>%
    seize("server", 1, priority=1) %>%
    timeout(2) %>%
    release("server", 1)
  
  env <- simmer() %>%
    add_resource("server", 1) %>%
    add_generator("__nonprior", t0, at(c(0, 1))) %>%
    add_generator("__prior", t1, at(1)) %>% # should be served second
    run()
  
  arrs <-
    env%>%get_mon_arrivals()
  
  expect_equal(arrs[arrs$name=="__prior0",]$end_time, 4)
})

test_that("priority queues are adhered to (2)", {
  t0 <- create_trajectory("nonprior") %>%
    seize("server", 1, priority=0) %>%
    timeout(2) %>%
    release("server", 1)
  
  t1 <- create_trajectory("prior") %>%
    seize("server", 1, priority=1) %>%
    timeout(2) %>%
    release("server", 1)
  
  env <- simmer() %>%
    add_resource("server", 1) %>%
    add_generator("__nonprior", t0, at(c(0, 0))) %>%
    add_generator("__prior", t1, at(1)) %>% # should be served second
    run()
  
  arrs <-
    env%>%get_mon_arrivals()
  
  expect_equal(arrs[arrs$name=="__prior0",]$end_time, 4) 
})

test_that("priority queues are adhered to and same level priorities are processed FIFO", {
  t0 <- create_trajectory("_t0_prior") %>%
    seize("server", 1, priority=1) %>%
    timeout(2) %>%
    release("server", 1)
  
  t1 <- create_trajectory("_t1_prior") %>%
    seize("server", 1, priority=1) %>%
    timeout(2) %>%
    release("server", 1)
  
  env <- simmer() %>%
    add_resource("server", 1) %>%
    add_generator("_t0_prior", t0, at(c(0, 2, 4, 6))) %>%
    add_generator("_t1_prior", t1, at(c(1, 3, 5, 7))) %>%
    run()
  
  arrs <-
    env%>%get_mon_arrivals()
  
  arrs_ordered <-
    arrs[order(arrs$end_time),]
  
  expect_equal(as.character(arrs_ordered$name), 
               c("_t0_prior0", "_t1_prior0", "_t0_prior1", "_t1_prior1", 
                 "_t0_prior2", "_t1_prior2", "_t0_prior3", "_t1_prior3"))
})

test_that("a lower priority arrival gets rejected before accessing the server", {
  t0 <- create_trajectory() %>%
    seize("dummy", 1) %>%
    timeout(10) %>%
    release("dummy", 1)
  
  t1 <- create_trajectory() %>%
    seize("dummy", 1, priority=1) %>%
    timeout(10) %>%
    release("dummy", 1)
  
  env <- simmer() %>%
    add_generator("p0a", t0, at(0, 0)) %>%
    add_generator("p1a", t1, at(2, 3)) %>%
    add_resource("dummy", 1, 2) %>%
    run()
  
  arrs <- env %>% get_mon_arrivals()
  arrs_ordered <- arrs[order(arrs$name),]
  
  expect_equal(as.character(arrs[!arrs$finished,]$name), "p0a1")
  expect_equal(arrs_ordered$end_time, c(10, 3, 20, 30))
})
