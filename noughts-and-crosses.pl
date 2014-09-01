use strict;
use warnings;

my @board = (".", ".", ".",
			 ".", ".", ".",
			 ".", ".", "."); # Holds the symbol which lies in a 3x3 board

sub getSymbol { # Returns the symbol which lies in a particular row and col
	my $row = $_[0];
	my $col = $_[1];
	return $board[$row*3 + $col];
}

sub addSymbol { # Adds a symbol to the board returns true if symbol was added
	my $symbol = $_[0];
	my $row = $_[1];
	my $col = $_[2];
	
	if ($row > 2 || $col > 2) {
		print("($row, $col) is out of the board!\n");
		return 0;
	} elsif (getSymbol($row, $col) eq ".") {
		$board[$row*3 + $col] = $symbol;
		return 1;
	} else {
		print("There is already a symbol at ($row, $col).\n");
		return 0;
	}
}

sub drawBoard { # Draws the board
	my @boardCopy = @board;
	splice(@boardCopy, 3, 0, "\n"); # Insert new lines to split rows
	splice(@boardCopy, 7, 0, "\n");
	splice(@boardCopy, 11, 0, "\n");
	print(@boardCopy);
}

sub turn { # Plays a single turn of a symbol
	my $symbol = $_[0];
	
	print("$symbol> Enter the row: ");
	my $row = <STDIN>;
	chop($row);
	print("$symbol> Enter the col: ");
	my $col = <STDIN>;
	chop($col);
	
	until (addSymbol($symbol, $row, $col)) {
		print("$symbol> Enter the row: ");
		$row = <STDIN>;
		chop($row);
		print("$symbol> Enter the col: ");
		$col = <STDIN>;
		chop($col)
	}

	drawBoard();
}

sub toggleTurn { # Toggles which symbols turn it is
	my $currentTurn = $_[0];
	if ($currentTurn eq "x") {
		return "o";
	} else {
		return "x";
	}
}

sub getRow { # Returns the symbols in a particular row
	my $row = $_[0];
	my @rowSymbols = ();
	
	for (my $col = 0; $col < 3; $col++) {
		push(@rowSymbols, getSymbol($row, $col));
	}
	return @rowSymbols;
}

sub getCol { # Returns the symbols in a particular coloumn
	my $col = $_[0];
	my @colSymbols = ();
	
	for (my $row = 0; $row < 3; $row++) {
		push(@colSymbols, getSymbol($row, $col));
	}
}

sub getForwardDiagonal {
	return (getSymbol(0, 0), getSymbol(1, 1), getSymbol(2, 2));
}

sub getBackwardDiagonal {
	return (getSymbol(2, 0), getSymbol(1, 1), getSymbol(0, 2));
}

sub won { # Checks if a player has won
	my @winningLines = ();
	for (my $i = 0; $i < 3; $i++) {
		push(@winningLines, join("", getRow($i)));
		push(@winningLines, join("", getCol($i)));
	}
	push(@winningLines, join("", getForwardDiagonal()));
	push(@winningLines, join("", getBackwardDiagonal()));
	
	if (grep {$_ eq "xxx"} @winningLines) {
		return "x";
	} elsif (grep {$_ eq "ooo"} @winningLines) {
		return "o";
	} else {
		return 0;
	}
}

sub draw { # Returns true if there is a draw
	if (grep {$_ eq '.'} @board) {
		return 0;
	} else {
		return 1;
	}
}

sub play { # The main game loop
	my $currentSymbol = "x";
	drawBoard();
	while ((not won()) && (not draw())) {
		turn($currentSymbol);
		$currentSymbol = toggleTurn($currentSymbol);
	}
	if (won()) {
		print(won() . " wins!\n");
	} else {
		print("The game was a draw!\n");
	}
}

play();