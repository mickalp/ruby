# Install the 'gruff' gem if you haven't already
# gem install gruff

require 'gruff'

# Sample data
data = {
  'Category A' => [1, 2, 3, 4, 5],
  'Category B' => [5, 4, 3, 2, 1]
}

# Create a Gruff::Scatter plot
graph = Gruff::Scatter.new
graph.title = 'Scatter Plot Example'
graph.x_axis_label = 'X-axis'
graph.y_axis_label = 'Y-axis'

# Add data to the plot
data.each do |category, values|
  graph.dataxy(category, values.each_with_index.map { |val, index| [index + 1, val] })
end

# Set some styling options (optional)
graph.theme_pastel
graph.marker_font_size = 16

# Save the plot to a file
graph.write('scatter_plot.png')

puts 'Scatter plot generated and saved as scatter_plot.png'

