accel t a b = (a*t)**2 + b*t

results = map (\x -> accel x 1 1) [0,1..]