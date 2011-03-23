# Sample VHDL Project

This is a project that I'm using as a vehicle to learn VHDL. You won't find anything Earth-shattering as I'm sure everything in here has been done millions of times before. That being said...

## What's it do?

This will eventually grow into a simple ALU where inputs are defined using a rotary switch, an operator is selected, and the result is displayed on a 4-digit 7-segment display. At some point, I would like this to grow into a extremely simple microprocessor, but I must take baby steps at first.

## What's the platform?

This is being built with the wonderful Papilio One from GadgetFactory using the Xilinx WebPack ISE.

## VHDL Components

I haven't progressed to building libraries yet, but I do have a few re-usable components:

* A 7-Segment LED Decoder - This converts any 4-bit value to a hex digit. Note that decimal points are not handled in this layer
* A 4-Digit LED Display - This uses the 7-Segment LED Decoder with a time multiplexer to manage the display of 4 LED digits. This component contains a register for the decimal points so each can be turned on individually.
* A Rotary Decoder - This converts the output of a rotary switch into increment and decrement signals.
* A Button Debouncer - This debounces the rather noisy rotary switch that I'm using. It uses a couple of flip-flops to (hopefully) avoid metastability coming from the button input. This is fed into a timing circuit which essentially turns on a signal after the button has been stable for about 500us.

## Parts

Below is a list of parts I'm using for this project

* [Papilio One](http://www.gadgetfactory.net)
* [4-digit 7-segment display](http://www.sparkfun.com/products/9481)
* [Rotary Encoder](http://www.sparkfun.com/products/9117)
* [Knob](http://www.sparkfun.com/products/8828)

## Links

* [Papilio.cc](http://papilio.cc/)

