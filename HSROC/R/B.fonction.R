B.fonction <-
function (a, b) 
{
    result = sum((a[, 3] * a[, 1]^2 + a[, 4] * a[, 2]^2)/exp(b * 
        (a[, 1] - 0.5)))
    return(result)
}
