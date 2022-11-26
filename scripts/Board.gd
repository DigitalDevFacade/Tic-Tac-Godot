extends Node

const PLAYER_ONE = 'X';
const PLAYER_TWO = 'O';

var turn = PLAYER_ONE;

onready var playerTurnLabel = $PlayerTurnLabel;
onready var sections = $Sections;
onready var winnerLabel = $WinnerLabel;
onready var tryAgainButton = $Button;

var board = [
	["","",""],
	["","",""],
	["","",""]
];

func _ready():
	var array_position = 0;
	var order_position = 1;
	var index = 1;
	tryAgainButton.visible = false;
	for section in sections.get_children():
		section.connect("pressed", self, "_on_section_pressed", [section, array_position, order_position]);
		# Setup for positioning on array to keep track of board.
		if index % 3 == 0:
			array_position+=1;
			order_position = 0;
			index = 0;
		order_position+=1;
		index +=1;

func _handle_disconnect():
	for section in sections.get_children():
		section.disconnect("pressed",self,"_on_section_pressed")
		
func _on_section_pressed(selectedBoard, array_position, order_position):
	var completedTurn = selectedBoard.handle_player_choice(turn);
	if completedTurn:
		update_arr_board(array_position, order_position);
		var winner = check_win();
		if winner:
			_handle_disconnect()
			tryAgainButton.visible = true;
			winnerLabel.text = 'Winner! Player ' + winner;
		else:
			handle_player_turn();
	else:
		pass;
		
		
func handle_player_turn():
	turn = PLAYER_ONE if turn == PLAYER_TWO else PLAYER_TWO;
	playerTurnLabel.text = "Player " + turn +  " Turn"

func update_arr_board(array_position, order_position):
	 # required to do -1 due to wrapping.
	board[array_position][order_position -1] = turn;
	pass

func check_win():
	# row wins
	for row in board:
		if row[0] != '':
			if row[0] == row[1] and row[1] == row[2]:
				return row[0]
			
	# column wins
	var column_wins = [[0,0,0],[1,1,1],[2,2,2]];
	for column_points in column_wins:
		for col_pos in column_points:
			if board[0][col_pos] != '':
				if board[0][col_pos] == board[1][col_pos]  and board[1][col_pos]  == board[2][col_pos]:
					return board[0][col_pos]
	# diagnal wins
	if board[0][0] == board[1][1] and board[0][0] == board[2][2]:
		return board[0][0];
	if board[0][2] == board[1][1] and board[0][2] == board[2][0]:
		return board[0][2];
		
	# Check draw
	var flat_arr = [];
	for row in board:
		for cell in row:
			flat_arr.push_front(cell);
	
	if !flat_arr.has(''):
		_handle_disconnect()
		tryAgainButton.visible = true;
		winnerLabel.text = 'Draw!';
		
	return false;

func _on_Button_pressed():
	get_tree().reload_current_scene();
