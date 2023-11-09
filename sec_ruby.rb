require 'csv'

# Load the data from a CSV file
data = CSV.read('data.csv', headers: true)

# Clean the data
data.delete_if { |row| row['price'].nil? || row['price'].empty? }

# Calculate the mean price
mean_price = data.map { |row| row['price'].to_f }.sum / data.length

# Create a histogram of the prices
prices = data.map { |row| row['price'].to_f }
prices_histogram = prices.group_by(&:to_i).transform_values(&:count)

# Plot the histogram
require 'chartkick'

Chartkick.new do |chart|
  chart.title = 'Price Histogram'
  chart.xlabel = 'Price'
  chart.ylabel = 'Count'
  chart.column_chart prices_histogram
end

# Display the mean price
puts "Mean price: #{mean_price}"
