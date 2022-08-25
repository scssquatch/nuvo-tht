require_relative '../life'

RSpec.describe 'Board' do
  describe '.print_board' do
    let(:cells) do
      {
        "1,1" => true,
        "1,2" => false,
      }
    end
    let(:board) { Board.new(width: 1, height: 2, cells: cells) }

    it 'prints out a board with x for alive and o for dead' do
      expected_board = <<~BOARD
        ---
        -x-
        ---
        -o-
        ---
      BOARD
      expect { board.print_board }.to output(expected_board).to_stdout
    end
  end

  describe '.next_board_state' do
    let(:cells) do
      {
        "1,1" => false,
        "1,2" => true,
        "1,3" => false,
        "2,1" => false,
        "2,2" => true,
        "2,3" => false,
        "3,1" => false,
        "3,2" => true,
        "3,3" => false,
      }
    end
    let(:board) { Board.new(width: 3, height: 3, cells: cells) }

    it 'returns a new board instance for the next state based on current state' do
      new_board = board.next_board_state
      expected_cells = {
        "1,1" => false,
        "1,2" => false,
        "1,3" => false,
        "2,1" => true,
        "2,2" => true,
        "2,3" => true,
        "3,1" => false,
        "3,2" => false,
        "3,3" => false,
      }
      expect(new_board.cells).to eq(expected_cells)
    end
  end

  describe 'get_neighbor_states' do
    let(:cells) do
      {
        "1,1" => false,
        "1,2" => true,
        "1,3" => true,
        "2,1" => false,
        "2,2" => true,
        "2,3" => false,
        "3,1" => false,
        "3,2" => true,
        "3,3" => false,
      }
    end
    let(:board) { Board.new(width: 3, height: 3, cells: cells) }

    it "returns an array of the states of a cell's neighbors" do
      expect(board.get_neighbor_states(2, 2)).to match_array([false, true, true, false, false, false, true, false])
    end

    it 'only returns neighbors that exist on the board' do
      expect(board.get_neighbor_states(1, 1)).to match_array([true, false, true])
    end
  end

  describe 'get_cell_state' do
    let(:cells) do
      {
        "1,1" => false,
        "1,2" => true,
      }
    end
    let(:board) { Board.new(width: 1, height: 2, cells: cells) }

    it 'returns the state of a given cell' do
      expect(board.get_cell_state(1, 1)).to eq(false)
    end
  end

  describe 'get_next_cell_state' do
    let(:cells) do
      {
        "1,1" => true,
        "1,2" => false,
      }
    end
    let(:board) { Board.new(width: 1, height: 2, cells: cells) }

    context 'when the cell is alive' do
      context 'and has less than 2 live neighbors' do
        let(:neighbors) { [true, false, false] }

        it 'dies' do
          expect(board.get_next_cell_state(1, 1, neighbors)).to eq(false)
        end
      end

      context 'and has more than 3 live neighbors' do
        let(:neighbors) { [true, true, true, true] }

        it 'dies' do
          expect(board.get_next_cell_state(1, 1, neighbors)).to eq(false)
        end
      end

      context 'and has 2 live neighbors' do
        let(:neighbors) { [true, true, false, false] }
        it 'stays alive' do
          expect(board.get_next_cell_state(1, 1, neighbors)).to eq(true)
        end
      end
    end

    context 'when the cell is dead' do
      context 'and has exactly 3 live neighbors' do
        let(:neighbors) { [true, true, true, false] }
        it 'comes to life' do
          expect(board.get_next_cell_state(1, 2, neighbors)).to eq(true)
        end
      end

      context 'and does not have 3 live neighbors' do
        let(:neighbors) { [true, true, true, true] }
        it 'stays dead' do
          expect(board.get_next_cell_state(1, 2, neighbors)).to eq(false)
        end
      end
    end
  end

  describe 'set_cell_state' do
    let(:cells) do
      {
        "1,1" => true,
        "1,2" => false,
      }
    end
    let(:board) { Board.new(width: 1, height: 2, cells: cells) }

    it 'sets the cell state' do
      expect(board.cells).to eq(cells)
      board.set_cell_state(1, 1, false)
      expected_cells = {
        "1,1" => false,
        "1,2" => false,
      }
      expect(board.cells).to eq(expected_cells)
    end
  end

  describe 'cell_alive?' do
    let(:cells) do
      {
        "1,1" => true,
        "1,2" => false,
      }
    end
    let(:board) { Board.new(width: 1, height: 2, cells: cells) }

    context 'when the cell is alive' do
      it 'returns true' do
        expect(board.cell_alive?(1, 1)).to eq(true)
      end
    end

    context 'when the cell is dead' do
      it 'returns false' do
        expect(board.cell_alive?(1, 2)).to eq(false)
      end
    end
  end
end
