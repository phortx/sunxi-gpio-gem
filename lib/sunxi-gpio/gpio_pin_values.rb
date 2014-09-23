module Sunxi
  module GpioPinValues
    INIT_ERRORS = [
        :SETUP_OK,
        :SETUP_DEVMEM_FAIL,
        :SETUP_MALLOC_FAIL,
        :SETUP_MMAP_FAIL
    ]

    GPIO_PUD_OFF = 0
    GPIO_PUD_DOWN = 1
    GPIO_PUD_UP = 2

    GPIO_HIGH = 1
    GPIO_LOW = 0

    GPIO_DIRECTION_INPUT=0
    GPIO_DIRECTION_OUTPUT=1

    WATCH_POLLING_SEC=0.1

    # A =   0
    # B =  32
    # C =  64
    # D =  95
    # E = 128
    # F = 160
    # G = 192
    # H = 224
    # I = 256

    PINS = {
        PB14: 46,
        PB15: 47,
        PB16: 48,
        PB17: 49,
        PB18: 50,
        PB19: 51,
        PB2: 34,
        PB3: 35,
        PB4: 36,
        PC19: 83,
        PC20: 84,
        PC21: 85,
        PC22: 86,
        PG0: 192,
        PG1: 193,
        PG10: 202,
        PG11: 203,
        PG2: 194,
        PG3: 195,
        PG4: 196,
        PG5: 197,
        PG6: 198,
        PG7: 199,
        PG8: 200,
        PG9: 201,
        PI14: 270,
        PI15: 271,
        PI20: 276,
        PI21: 277,
        PI3: 259
    }
  end
end