require 'gnuplot'
require 'launchy'
require 'csv'

#$VERBOSE = true
RANGE = 600

Gnuplot.open do |gp|
  Gnuplot::SPlot.new gp do |plot|
    plot.view "30,0"
    plot.terminal "png nocrop medium size 2048,1600"
    plot.output "plot.png"

    plot.xrange "[-#{RANGE}:#{RANGE}]"
    plot.yrange "[-#{RANGE}:#{RANGE}]"
    plot.zrange "[-#{RANGE}:#{RANGE}]"

    plot.datafile "separator ','"
    plot.data = [
      Gnuplot::DataSet.new("'data.txt'") { |d|
        d.title = "Plot"
        d.linewidth = 5
      }
    ]
  end
end

`open plot.png`
