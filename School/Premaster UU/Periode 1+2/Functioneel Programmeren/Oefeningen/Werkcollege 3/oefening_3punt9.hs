bepaalKapitaal :: Float -> Float -> Float -> Int
bepaalKapitaal 0 0 0 = 0
bepaalKapitaal begin eind rente = if (begin*(1 + rente) ) < eind then 1 + berekenVolgende else 0
                                  where berekenVolgende = bepaalKapitaal (begin*(1 + rente) ) eind rente

