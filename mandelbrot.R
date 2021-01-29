## Script for drawing Mandelbrot set for generalized exponent (not only 2)

## Created: 2021-01-29 by FrK
## Edited:  2021-01-29 by FrK

## Encoding: windows-1250

# Package
library(dplyr)
library(tibble)
library(ggplot2)


## Mandelbrot functions
# Basic for k=2, credit: https://en.wikipedia.org/wiki/Mandelbrot_set#Computer_drawings
fc = function(z, c) c + z^2  

# General
fck = function(z, c, k) c + z^k  

# Function finding whether orbit for given 'c' & 'k' escapes bounding and when
# code inspired by pseudo-code at: https://en.wikipedia.org/wiki/Mandelbrot_set#Computer_drawings
escape = function(c, k, max.steps = 1000, draw = F){  
  # Initial values
  z = 0+0i
  z.old = 10+10i
  fixed = FALSE
  step = 0
  if(draw) plot(-2.5:2.5, -2.5:2.5, type = "n")
  
  # Main cycle
  while(((Re(z)^2 + Im(z)^2) <= 4) &  # While it is bounded ...
        (step < max.steps) &   # While we don't reach the maximum of steps...
        (z.old != z)) {  # While 'z' is not on stable point -- after finding stable point we might leave.
    step = step + 1
    z.old = z
    z = fck(z, c, k)  # Iterating Z_n › Z_n+1
    if(draw) (points(z))
    fixed = (z == z.old)
  }
  tibble(
    r = Re(c),  # r = Real part of 'c'
    i = Im(c),  # i = Imaginary part of 'c'
    k = k,  # k = Exponent in 'c + z^k'
    t = step,  # t = how many steps take it to the end (might be fixed point or escaping)
    f = fixed,  # f = T/F, whether it finished in fixed point
    escaped = ((!fixed) & (step < max.steps)) # escaped = T/F, whether it finished by escaping
  )
}

# Searching function: goes through values of 'Cr', 'Ci' and 'k' and 
# reports results for every triple as tibble
search.ck = function(vr, vi, vk = 2, max.steps = 1000, draw = F){
  res = tibble(r = NA, i = NA, k = NA, t = NA, f = NA, escaped = NA)
  for (k in vk){
    for (i in vi){
      for (r in vr){
        esc = escape(complex(real = r, imaginary = i), k, max.steps, draw) 
        res = add_row(res, esc)
      }
    }
  }
  filter(res, !is.na(r))
}


# Generating tibble with information on points 
vals = search.ck(vr = seq(-2.5, 1, 0.01),  # Vector of possible range of real part of 'c'
                 vi = seq(-1, 1, 0.01),  # Vector of possible range of imaginary part of 'c'
                 vk = seq(0, 10, 1),  # Vector of possible range of exponents in 'c + z^k' 
                 max.steps = 100)  # Maximum number of iterations 
                 # -- if orbit doesn't find fixed point nor orbit exceeds limits, it stops after 'max.steps'

# Visualizing data 'vals' -- it is very shy try... not good...
vals %>% filter(!escaped) %>% arrange(desc(k)) %>% 
  ggplot(aes(x = r, y = i, col = k, size = k)) +
  geom_point() +
  theme_minimal()

# TO-DO:
# 3D visualization of data: x = r, y = i, and  z = k 
