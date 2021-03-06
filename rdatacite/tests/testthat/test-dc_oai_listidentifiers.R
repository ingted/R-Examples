context("dc_oai_listidentifiers")

test_that("dc_oai_listidentifiers - from", {
  skip_on_cran()

  aa <- dc_oai_listidentifiers(from = "2015-09-03T00:00:00Z", until="2015-09-03T00:30:00Z")

  expect_is(aa, "data.frame")
  expect_is(aa, "oai_df")
  expect_is(aa$identifier, "character")
  expect_is(aa$datestamp, "character")
  expect_equal(as.character(as.Date(aa$datestamp[1])), "2015-09-03")
})

test_that("dc_oai_listidentifiers - from & until", {
  skip_on_cran()

  aa <- dc_oai_listidentifiers(from = '2015-09-03T00:00:00Z', until = '2015-09-03T00:30:00Z')
  bb <- dc_oai_listidentifiers(from = '2015-09-03T00:30:00Z', until = '2015-09-03T01:15:00Z')

  expect_is(aa, "oai_df")
  expect_is(bb, "oai_df")

  expect_less_than(NROW(aa), NROW(bb))
})

test_that("dc_oai_listidentifiers - set", {
  skip_on_cran()

  aa <- dc_oai_listidentifiers(from = '2011-06-01T', until = '2011-11-01T', set = "ANDS")
  bb <- dc_oai_listidentifiers(from = '2011-06-01T', until = '2012-11-01T', set = "CDL.OSU")

  expect_is(aa, "oai_df")
  expect_is(bb, "oai_df")

  expect_equal(aa$setSpec[1], "ANDS")
  expect_equal(bb$setSpec[1], "CDL")
})

test_that("dc_oai_listidentifiers fails well", {
  skip_on_cran()

  no_msg <- "The combination of the values of the from, until, set, and metadataPrefix arguments results in an empty list"

  expect_error(dc_oai_listidentifiers(from = '2011-06-01T', until = 'adffdsadsf'),
               "The request includes illegal arguments")
  expect_error(dc_oai_listidentifiers(from = '2011-06-01T', until = 5),
               "The request includes illegal arguments")
  expect_error(dc_oai_listidentifiers(url = 5), "One or more of your URLs")
  expect_error(dc_oai_listidentifiers(from = '2011-06-01T', until = '2011-11-01T', set = "STUFF"), no_msg)
})
