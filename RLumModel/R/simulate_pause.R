#' sequence step "pause" in model simulation
#'
#' This function simulates the pause between measurements or after irradiation steps
#' in quartz in the energy-band-model.
#'
#' @param temp \code{\link{numeric}} (\bold{required}): set temperature [deg. C] of the pause simulation
#'
#' @param duration \code{\link{numeric}} (\bold{required}): duration of the pause in model simulation
#'
#' @param n \code{\link{numeric}} or \code{\linkS4class{RLum.Results}} (\bold{required}):
#' concentration of electron-/holetraps, valence- and conduction band
#' from step before. This is necessary to get the boundary condition for the ODEs.
#'
#' @param parms \code{\linkS4class{RLum.Results}} (\bold{required}): The specific model parameters are used to simulate
#' numerical quartz luminescence results.
#'
#' @param \dots further arguments and graphical parameters passed to
#' \code{\link{plot.default}}. See details for further information
#'
#' @return This function returns an Rlum.Results object from the pause simulation.
#'
#' @note This function can do just nothing at the moment.
#'
#' @section Function version: 0.1.0
#'
#' @author Johannes Friedrich, University of Bayreuth (Germany),
#'
#' @references
#'
#' Bailey, R.M., 2001. Towards a general kinetic model for optically and thermally stimulated
#' luminescence of quartz. Radiation Measurements 33, 17-45.
#'
#' @seealso \code{\link{plot}}
#'
#' @examples
#'
#' #so far no example available
#'
#' @noRd
.simulate_pause <- function(
  temp,
  duration,
  n,
  parms
  ){

# check input arguments ---------------------------------------------------

  ##check if duration is a positive number
  if(duration < 0){
    stop("\n [.simulate_pause()] Argument 'duration' has to be an positive number!")
  }

  ##check if temperature is > 0 K (-273 degree celsius)
  if(temp < -273){
    stop("\n [.simulate_pause()] Argument 'temp' has to be > 0 K!")
  }

  ##check if object is of class RLum.Data.Curve
  if(class(n) != "RLum.Results"){
    n <- n
  } else {
    n <- n$n
  }

# Set parameters for ODE ---------------------------------------------------


  ##============================================================================##
  # SETTING PARAMETERS FOR HEATING
  #
  # R: electron-hole-production-rate = 0
  # P: Photonflux (in Bailey 2004: wavelength [nm]) = 0
  # b: heating rate [deg. C/s] = 0
  ##============================================================================##

  R <- 0
  P <- 0
  b <- 0

  ##============================================================================##
  # SETTING PARAMETERS FOR ODE
  ##============================================================================##

  times <- seq(0, duration, by = duration/100)
  parameters.step  <- list(R = R, P = P, temp = temp, b = b, times = times, parms = parms)

  ##============================================================================##
  # SOLVING ODE (deSolve requiered)
  ##============================================================================##
  out <- deSolve::lsoda(y = n, times = times, parms = parameters.step, func = .set_ODE, rtol=1e-3, atol=1e-3, maxsteps=1e5)
  ##============================================================================##

  ##============================================================================##

  ##============================================================================##
  # TAKING THE LAST LINE OF "OUT" TO COMMIT IT TO THE NEXT STEP
  ##============================================================================##

  return(Luminescence::set_RLum(class = "RLum.Results",
                  data = list(
                    n = out[length(times),-1],
                    temp = temp
                  )))
}
