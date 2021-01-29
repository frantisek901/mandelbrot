# mandelbrot
Very humble try to enrich classical Mandelbrot set analysis -- z_n+1 = c + (z_n ^ k) for k>=0.

# Main issue/ TO-DO:
Code needs to add some good way of plotting 3D data. 

# Description:
Classical Mandelbrot set is given by iterative function:
z_n+1 = c + (z_n ^ 2); z0 = 0+0i
The famous 2D graph inform us for which coefficients 'c' orbits exceed to infnity and for which 'c' orbits stay bounded. In the plot X represents real part of 'c' and Y represents the imaginary part of 'c'. Then black points represent bounded orbits given by 'c' and colored represents orbits (given by respective 'c') which exceeds bounds into infinity.

This code adds third dimension -- exponent 'k'. We might generalize classical set, where k==2 to k >= 0 ('k' less than 0 leads quickly to infinity), so the generalized iterative function is:
z_n+1 = c + (z_n ^ k); z0 = 0+0i
