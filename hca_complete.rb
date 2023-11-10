# Install the 'daru' and 'gruff' gems if you haven't already
# gem install daru gruff

require 'daru'
require 'gruff'

# Load wine dataset
wine = Daru::DataFrame.from_csv('wine_data.csv')

# Select first 26 rows and drop the 'target' column
data = wine.head(26).delete_vector('target')

# Autoscaling data
def autoscale(data)
  mean_df = data.mean(axis: 0)
  std_df = data.std(axis: 0)

  scaled_data = data.map_rows do |row|
    row.map.with_index { |val, i| (val - mean_df[i]) / std_df[i] }
  end

  Daru::DataFrame.new(scaled_data, order: data.vectors)
end

df = autoscale(data)

# Euclidean Distance Matrix
def df_euclidean_distance_matrix(df)
  matrix = df.map_rows do |row1|
    df.map_rows { |row2| Math.sqrt((row1 - row2).map { |x| x**2 }.sum) }
  end

  Daru::DataFrame.new(matrix)
end

df_oe = df_euclidean_distance_matrix(df)

# Hierarchical Clustering Algorithm (HCA)
def hierarchical_clustering(distance_matrix)
  X = distance_matrix.clone
  full_dict = {}
  list_coord = []
  min_values = []

  names = (X.index.size...2000).to_a.each

  while X.size >= 2
    triangle = X.triangle(:lower)
    triangle_flat = triangle.to_a.flatten

    min1 = triangle_flat.select { |i| i > 0 }.min
    coord = triangle.index(triangle_flat.index(min1))
    list_coord << coord.to_a
    min_values << min1.round(3)

    coord1 = coord.max
    coord2 = coord.min

    new_name = names.next

    names_col = X.index.to_a

    if names_col.include?(X.index[coord1]) && names_col.include?(X.index[coord2])
      full_dict[new_name] = 2
    elsif names_col.include?(X.index[coord1]) && !names_col.include?(X.index[coord2])
      full_dict[new_name] = 1 + full_dict[X.index[coord2]]
    elsif !names_col.include?(X.index[coord1]) && names_col.include?(X.index[coord2])
      full_dict[new_name] = 1 + full_dict[X.index[coord1]]
    else
      full_dict[new_name] = full_dict[X.index[coord1]] + full_dict[X.index[coord2]]
    end

    wektor = X.index.map do |i|
      if X[coord1, i] == 0
        X[coord1, i]
      elsif X[coord2, i] == 0
        X[coord2, i]
      elsif X[coord1, i] > X[coord2, i]
        X[coord1, i]
      else
        X[coord2, i]
      end
    end

    X[coord2] = wektor
    X[coord2, true] = wektor
    X = X.delete_vector(coord1)
    X = X.delete_index(coord1)

    X.rename_vectors({ coord2 => new_name })
    X.rename_index({ coord2 => new_name })
  end

  last = min_values.zip(list_coord, full_dict.values).map do |min_val, cords, k|
    [cords[0], cords[1], min_val, k]
  end

  last
end

hca_complete = hierarchical_clustering(df_oe)

# Plot dendrogram
def plot_dendrogram(data)
  fig = Daru::DataFrame.new(data, order: ['Obj1', 'Obj2', 'Distance', 'NumObj']).plot(type: :dendrogram)
  fig.show
end

plot_dendrogram(hca_complete)

