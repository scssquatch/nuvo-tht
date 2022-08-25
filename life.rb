class Board
  attr_reader :width, :height, :cells, :random

  def initialize(width:, height:, seed: 12345, cells: {})
    @width = width
    @height = height
    @cells = cells
    return unless @cells.empty? # skip random cell generation if cells given

    @seed = seed
    @random = Random.new(seed)

    # generate all cells, insert into cells object with coords as keys, state as value
    (1..width).each do |x|
      (1..height).each do |y|
        # set_cell_state(x, y, get_random_state)
        # if x == 5 && y == 1 || x == 5 && y == 3 || x == 5 && y == 3 # Oscillator
        if x == 5 && y == 1 || x == 5 && y == 3 || x == 6 && y == 2 || x == 4 && y == 3 || x == 6 && y == 3 # Glider
          set_cell_state(x, y, true)
        else
          set_cell_state(x, y, false)
        end
      end
    end
  end

  def print_board
    (1..height).each do |y|
      states = []
      (1..width).each do |x|
        states << get_cell_state(x, y)
        print '---'
      end
      print "\n"
      states.each do |state|
        print '-'
        marker = state ? 'x' : 'o'
        print marker
        print '-'
      end

      print "\n"
    end
    print '---'*width
    print "\n"
  end

  def next_board_state
    new_cells = {}
    (1..height).each do |y|
      (1..width).each do |x|
        neighbor_states = get_neighbor_states(x, y)
        next_cell_state = get_next_cell_state(x, y, neighbor_states)
        new_cells["#{x},#{y}"] = next_cell_state
      end
    end
    Board.new(width: width, height: height, cells: new_cells)
  end

  def get_neighbor_states(x, y)
    neighbor_states = []
    [-1, 0, 1].each do |x_neighbor_diff|
      [-1, 0, 1].each do |y_neighbor_diff|
        next if x_neighbor_diff == 0 && y_neighbor_diff == 0 # Ignore self when checking neighbors


        x_neighbor = x + x_neighbor_diff
        y_neighbor = y + y_neighbor_diff
        next if get_cell_state(x_neighbor, y_neighbor).nil? # Ignore spaces "outside" the board area

        neighbor_states << get_cell_state(x_neighbor, y_neighbor)
      end
    end
    neighbor_states
  end

  def get_cell_state(x, y)
    cells["#{x},#{y}"]
  end

  def get_random_state
    # Going to have 20% of cells be turned on to start
    random.rand(100) < 20
  end

  def get_next_cell_state(x, y, neighbor_states)
    live_neighbor_count = neighbor_states.count { |state| state }
    if (cell_alive?(x, y))
      if live_neighbor_count < 2 || live_neighbor_count > 3
        return false
      else
        return true
      end
    else
      if live_neighbor_count == 3
        return true
      else
        return false
      end
    end
  end

  def set_cell_state(x, y, state)
    cells["#{x},#{y}"] = state
  end

  def cell_alive?(x, y)
    get_cell_state(x, y) == true
  end
end

board = Board.new(width: 20, height: 20, seed: 12345)
while(true) do
  puts 'next?'
  continue = gets
  break unless continue == "\n"
  board.print_board
  board = board.next_board_state
end
