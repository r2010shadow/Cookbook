# PiCar

import RPi.GPIO as gpio
import time
import sys
import Tkinter as tk
from sensor import distance

IN1 = 36
IN2 = 38
IN3 = 35
IN4 = 37

def init():
    gpio.setmode(gpio.BOARD)
    gpio.setup(IN1, gpio.OUT)
    gpio.setup(IN2, gpio.OUT)
    gpio.setup(IN3, gpio.OUT)
    gpio.setup(IN4, gpio.OUT)

def forward(tf):
    gpio.output(IN1, False)
    gpio.output(IN2, True)
    gpio.output(IN3, True)
    gpio.output(IN4, False)
    time.sleep(tf)
    gpio.cleanup()

def reverse(tf):
    gpio.output(IN1, True)
    gpio.output(IN2, False)
    gpio.output(IN3, False)
    gpio.output(IN4, True)
    time.sleep(tf)
    gpio.cleanup()


def pivot_left(tf):
    gpio.output(IN1, True)
    gpio.output(IN2, False)
    gpio.output(IN3, True)
    gpio.output(IN4, False)
    time.sleep(tf)
    gpio.cleanup()


def pivot_right(tf):
    gpio.output(IN1, False)
    gpio.output(IN2, True)
    gpio.output(IN3, False)
    gpio.output(IN4, True)
    time.sleep(tf)
    gpio.cleanup()


def key_input(event):
    init()
    print 'Key:',event.char
    key_press =   event.char
    sleep_time = 0.080

    if key_press.lower() == 'w':
        forward(sleep_time)
    elif key_press.lower() == 's':
        reverse(sleep_time)
    elif key_press.lower() == 'a':
        pivot_left(sleep_time)
    elif key_press.lower() == 'd':
        pivot_right(sleep_time)
    else:
        pass

    curDis = distance('cm')
    print('curdis is ', curDis)

    if curDis < 20:
        init()
        reverse(2)


cmd = tk.Tk()
cmd.bind('<KeyPress>', key_input)
cmd.mainloop()

