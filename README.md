# Sample VHDL Project

I'm using this project to learn VHDL. There's nothing Earth-shattering here and I'm positive everything in here has been done millions of times before. That being said...

## What's it do?

This project will eventually grow into a simple ALU where operands can be input, the operator can be selected and the result is displayed. The input consists of a single push/rotary button. The display is a 4-digit 7-segment led. Most likely I'll add more led displays as I get things going.

## What's the platform?

This is being built with the wonderful Papilio One from GadgetFactory using the Xilinx ISE.

## VHDL Components

I haven't progressed to building libraries yet, but I do have a few re-usable components:

* A 7-Segment LED Decoder - This converts any 4-bit value to a hex digit. Note that decimal points are not handled in this layer
* A 4-Digit LED Display - This uses the 7-Segment LED Decoder with a time multiplexer to manage the display of 4 LED digits. This component contains a register for the decimal points so each can be turned on separately
* A Rotaty Decoder - This converts the output of a rotary switch into increment and decrement signals.
* A Button Debouncer - This debounces the rather noisy rotary switch that I'm using. It uses a couple of flip-flops to (hopefully) avoid metastability coming from the button input. This is fed into a timing circuit which essentially turns on a signal after the button has been stable for about 500us.

## Parts

Below is a list of parts I'm using for this project

* [Papilio One](http://www.gadgetfactory.net)
* [4-digit 7-segment display](http://www.sparkfun.com/products/9481)
* [Rotary Encoder](http://www.sparkfun.com/products/9117)
* [Knob](http://www.sparkfun.com/products/8828)

## Links

* [Papilio.cc](http://papilio.cc/)

