# Ruby and Leap Motion Examples

This repo has sample code to read coordinates from the Leap Motion
and turn them into graphics using GnuPlot.

## How?

Connect the Leap to your USB port

Run:

    ruby leap.rb


This script will read the data from your Leap and will write it onto a file
called `data.txt`.

Then,

    ruby plot.rb

This script will take that `data.txt` and plot it with `gnuplot`.

