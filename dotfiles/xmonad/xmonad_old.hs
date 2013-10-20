    --
    -- An example, simple ~/.xmonad/xmonad.hs file.
    -- It overrides a few basic settings, reusing all the other defaults.
    --

    import XMonad

    main = xmonad $ defaultConfig
        { borderWidth        = 2
        , terminal           = "urxvt"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#cd8b00" }
