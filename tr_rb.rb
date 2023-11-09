# gem install daru

require 'daru'

# Create a Daru DataFrame with sample data
data = {
  'Name' => ['Alice', 'Bob', 'Charlie', 'David', 'Eva'],
  'Age' => [25, 30, 22, 35, 28],
  'Salary' => [50000, 60000, 45000, 70000, 55000]
}

df = Daru::DataFrame.new(data)

# Display basic information about the DataFrame
puts 'DataFrame:'
puts df.inspect

# Calculate and display basic statistics
puts "\nBasic Statistics:"
puts "Mean Age: #{df['Age'].mean}"
puts "Maximum Salary: #{df['Salary'].max}"

# Plotting the data
puts "\nPlotting Data:"

# Install the 'gruff' gem if you haven't already
# gem install gruff
require 'gruff'

# Create a Gruff::Bar plot for Salary
bar_graph = Gruff::Bar.new
bar_graph.title = 'Salary Distribution'
bar_graph.labels = { 0 => 'Alice', 1 => 'Bob', 2 => 'Charlie', 3 => 'David', 4 => 'Eva' }
bar_graph.data('Salary', df['Salary'].to_a)
bar_graph.write('salary_distribution.png')

puts 'Bar plot of Salary distribution saved as salary_distribution.png'

