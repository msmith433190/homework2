function [] = chess()
    board = setUpBoard();
    inputError = false;
    invalidMove = false;
   
    while true
        clc;
        displayBoard(board);
        if inputError
           fprintf('Error: Improper input format, please try again.\n'); 
           inputError = false;
        end
        
        if invalidMove
           fprintf('Sorry, the piece you selected cannot move to that location. Please try again.\n');
           invalidMove = false;
        end
        
        origin = input('Please enter the location of the piece you wish to move or Quit to quit: ','s');
        if strcmp(origin,'Quit') || strcmp(origin,'quit')
           break; 
        %Making sure that the origin string is in the expected format
        elseif length(origin) ~= 3 || origin(1) < 'A' || origin(1) > 'H' || (origin(2) ~= ',' && origin(2) ~= ' ') || origin(3) < '1' || origin(3) > '8'
             inputError = true;
             continue;
        end
        
        destination = input('Please enter the location of the square you wish to move to or Quit to quit: ','s');
        if strcmp(destination,'Quit') || strcmp(destination,'quit')
           break;
        %Making sure that the destination string is in the expected format
        %Includes additional check that the origin and destination are not
        %the same
        elseif length(destination) ~= 3 || destination(1) < 'A' || destination(1) > 'H' || (destination(2) ~= ',' && destination(2) ~= ' ') || destination(3) < '1' || destination(3) > '8' || strcmp(origin,destination)
             inputError = true;
             continue;
        end
        
        [board,invalidMove] = makeMove(board,origin,destination);
    end
end

function [board,invalidMove] = makeMove(board,origin,destination)
    %Assume a given move is valid until proven otherwise
    invalidMove = false;
    [originRow,originCol] = convertString(origin);
    [destinationRow,destinationCol] = convertString(destination);
    
    %If the board does not contain a piece at the origin space, set invalid
    %move to true and return to the main function
    if board(originRow,originCol) == 0
       invalidMove = true;
       return;
    elseif board(originRow,originCol) == 'P'
        [board,invalidMove] = pawnMove(board,originRow,originCol,destinationRow,destinationCol);
        
    elseif board(originRow,originCol) == 'R'
        [board,invalidMove] = rookMove(board,originRow,originCol,destinationRow,destinationCol);
    elseif board(originRow,originCol) == 'N'
        [board,invalidMove] = knightMove(board,originRow,originCol,destinationRow,destinationCol);
    elseif board(originRow,originCol) == 'B'
        [board,invalidMove] = bishopMove(board,originRow,originCol,destinationRow,destinationCol);
    elseif board(originRow,originCol) == 'Q'
        [board,invalidMove] = queenMove(board,originRow,originCol,destinationRow,destinationCol);
    elseif board(originRow,originCol) == 'K'
        [board,invalidMove] = kingMove(board,originRow,originCol,destinationRow,destinationCol);
        
    end
end

function [board,invalidMove] = pawnMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    %Pawns can move along a column one space at a time, unless the space
    %they are trying to move to is occupied
    
    if abs(originCol - destinationCol) == 1 && abs(originRow - destinationCol) == 0 && board(destinationRow,destinationCol) == 0
        %TODO: Check if it is being moved only one space, along a column, and
        %that the space it is moving to doesnt have a piece in it already. If
        %so, the piece can be moved
        board(originRow,originCol) = char(0);
        board(destinationRow,destinationCol) = 'P';
        
    %Pawns capture diagonally, and there must be a piece available to
    %capture in the destination space
    elseif  abs(originCol - destinationCol) == 1 && abs(originRow - destinationCol) == 1 && board(destinationRow,destinationCol) ~= 0
        %TODO: Check if it is being moved one space along a column and one
        %space along a row, and that the destination square has a piece on
        %it. If so, the piece can be moved. Move the
        board(originRow,originCol) = char(0);
        board(destinationRow,destinationCol) = 'P';
    else
        invalidMove = true;
        %TODO: The move is not possible. Make sure to change a variable to
        %let other functions know this
    end
end

function [board,invalidMove] = rookMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    %Rooks move either entirely vertically or entire horizontally, and
    %every space they pass through other than the final destination must be
    %unoccupied
    
    %The code is simpler to write if you break it down into separate
    %if/elseif blocks for moving right, left, down, and up
    
    if originCol < destinationCol && originRow == destinationRow 
        %TODO: check to see if piece is moving from a smaller column number to a larger one
        %AND that the pice is on the same row when it starts and ends
        
        %If only moving one space, don't check if there are pieces in the way
        if destinationCol - originCol == 1
            %TODO: Check if the piece is only moving one space away. If so,
            %move the piece and end this function
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'R';
            return;
        end
        %Check if the intervening spaces are unoccupied before moving
        %Return invalid move if not
        for i = (originCol + 1) : (destinationCol - 1)%TODO: Check if all squares in between the origin column and the destination column are unoccupied. 
            %TODO: *If* any of the spaces have a piece on them, the move is
            %invalid and the function should say so, before ending.
            if board(destinationRow,i) ~= 0
                invalidMove = true;
                return;
            end
        end
        
        %If the for loop did not return to the main function, spaces must
        %be clear
         board(originRow,originCol) = char(0);
         board(destinationRow,destinationCol) = 'R';
        %TODO: if the code gets to here, the move is valid, so move the
        %rook from its orignal place to its new place on the board.
         
        
    elseif originCol > destinationCol && originRow == destinationRow
        %TODO: check to see if piece is moving from a larger column number to a smaller one
        %AND that the pice is on the same row when it starts and ends
        
        %Similar steps will be taken here like for the if statement above.
        %You can copy/paste and change a bit of the logic to fit the new
        %direction 
        if destinationCol - originCol == -1
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'R';
        end
        for  i = (origin - 1) : (destinationCol + 1)
            %TODO: Check if all squares in between the origin column and the destination column are unoccupied. 
            %TODO: *If* any of the spaces have a piece on them, the move is
            %invalid and the function should say so, before ending.
            if board(destinationRow,i) ~= 0
                invalidMove = true;
                return;
            end
        end 
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'R';
    elseif originRow > destinationRow && originCol == destinationCol
        %TODO: check to see if piece is moving from a smaller row number to a larger one
        %AND that the pice is on the same column when it starts and ends
        
        %Similar steps will be taken here like for the if statement above.
        %You can copy/paste and change a bit of the logic to fit the new
        %direction 
        if originRow - destinationRow == 1
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'R';
            return;
        end
        for i = destinationRow +1 : originRow -1
            if board(i,destinationCol)~= 0
                invalidMove = true;
                return;
            end
        end
        
        elseif originRow < destinationRow && originCol == destinationCol
        %TODO: check to see if piece is moving from a smaller row number to a larger one
        %AND that the pice is on the same column when it starts and ends
        
        %Similar steps will be taken here like for the if statement above.
        %You can copy/paste and change a bit of the logic to fit the new
        %direction 
        if originRow - destinationRow ==-1
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'R';
            return;
        end
        for i = destinationRow + 1 : originRow -1
            if board(i,destinationCol)~= 0
                invalidMove = true;
            end
        end
        %Similar steps will be taken here like for the if statement above.
        %You can copy/paste and change a bit of the logic to fit the new
        %direction 
        
        
    else
        %TODO: The move is invalid. Set the appropriate variable(s).
    end
end

function [board,invalidMove] = knightMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    
    %Knights move in an L shape, the change along one axis must be equal to
    %spaces, and one space on the other axis
    
    %TODO: Check *IF* the knight is moving two spaces in either the row or column, and that the total spaces moved is three
    %If the above things are true, the move is valid and you can move the
    %piece. Else, the move is invalid. Set the appropriate variables.
    if (abs(originRow - destinationRow) == 2 || abs(originCol - destinationCol) == 2) && (abs(originRow - destinationRow) == 1 || abs(originCol - destinationCol) == 1)
            board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'N';
    else 
        invalidMove = true;
    end
        %HINT: remember, the letter 'K' refers to a king, not a knight. Don't
    %accidentally make more kings!

    
end
function [board,invalidMove] = bishopMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    
    %Bishops move diagonally in any direction, and every space they pass
    %through other than the final destination must be unoccupied
    %It is simpler to write this function by breaking it into if/elseif
    %blocks for each of the four directions the bishop can move
    
    %If only moving a single space in any direction, move unconditionally
    
    if abs(originRow - destinationRow) == 1 && abs(originCol - destinationCol) == 1 
        board(originRow,originCol) = char(0);
            board(destinationRow,destinationCol) = 'B';
        %TODO: Check if rook only moves one space diagnally, if so, then it 
        %automatically moves to that space.
    
    elseif abs(originRow - destinationRow) == abs(originCol - destinationCol)
        %TODO: check to make sure the distance being moved is the same on
    %both axes.
        
        %Four if/elseif blocks to check that there are no pieces between
        %the origin and destination
        if  (originRow - destinationRow) < 0 && (originCol - destinationCol) > 0
            for i = 1:abs(destinationCol - originCol) - 1
                if board(originRow + i, originCol - i) ~= 0
                    invalidMove = true;
                    return;
                end
            end
            %if moving up in row AND column numbers
            %TODO: Using a for loop, check to make sure there are no piecs
           
            %on any of the spaces between the original space and the
            %destination space. If any pieces lay in the way, the move is
            %invalid and the corressponding variables should be updated
        elseif originRow - destinationRow < 0 && originCol - destinationCol < 0
            for i = 1:abs(destinationCol - originCol) - 1
                if board(originRow + i, originCol + i) ~= 0
                    invalidMove = true;
                    return;
                end
            end
            %check if moving up in row number and down in column number
            %Model this part after the above if block, just changing some
            %of the logic
        elseif originRow - destinationRow > 0 && originCol - destinationCol < 0 
            for i = 1:abs(destinationCol - originCol) - 1
                if board(originRow - i, originCol - i) ~= 0
                    invalidMove = true;
                    return;
                end
            end
            %check if moving down in row number and up in column number
            %Model this part after the above if block, just changing some
            %of the logic
        elseif originRow - destinationRow < 0 && originCol - destinationCol < 0
            for i = 1:abs(destinationCol - originCol) - 1
                if board(originRow - i, originCol + i) ~= 0
                    invalidMove = true;
                    return;
                end
            end
            %check if moving down in row number and down in column number
            %Model this part after the above if block, just changing some
            %of the logic
        end
        
       % TODO: If invalidMove is still false, move the piece
        
    else 
        invalidMove = true;
            %the move is invalid. Update the corresponding variables
    end
end

function [board,invalidMove] = queenMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    %here, you can make use of other code you used. Call the bishop or rook
    %functions, depending on which direction the queen is moving. If the
    %move is valid, aka invalidMove is false when the function returns,
    %then you can place the queen in the end spot
    if originRow == destinationRow == 0  || originCol - destinationCol == 0 
        [board,invalidMove] = rookMove(board,originRow,originCol,destinationRow,destinationCol);
    else 
        [board,invalidMove] = bishopMove(board,originRow,originCol,destinationRow,destinationCol);
    end
    if ~invalidMove
        board(originRow,originCol) = char(0);
        board(destinationRow,destinationCol) = 'Q';
    end
end

function [board,invalidMove] = kingMove(board,originRow,originCol,destinationRow,destinationCol)
    invalidMove = false;
    
    %TODO: Check if king is moving only one square away from its original
    %space, horizontally, vertically, or diagnally. If so, the move is
    %valid, and the code should move the king. If not, the move is invalid
    %and the appropriate variable(s) should be updated.
    if abs(originCol - destinationCol) <= 1 && abs(originRow - destinationRow) <= 1
        board(originRow,originCol) = char(0);
        board(destinationRow, destinationCol) = 'K';
    else
        invalidMove = true;
    end
end

function [row,col] = convertString(str)
    %TODO -----------------------------------------------------------------
    %convert string from Char,Num into two variables, row and col,
    %so that for row, A = 1, B = 2, etc, and make sure theyre both
    %integers, not strings
    row = str(1) - 64;
    col = str2double(str(3));
    
end

function [] = displayBoard(board)
    fprintf('   1 2 3 4 5 6 7 8 \n');
    fprintf('  +-+-+-+-+-+-+-+-+\n');
    for i = 1:8
        newRow = true;
        for j = 1:8
            if newRow
                fprintf('%s ',char('A' + i - 1));
                newRow = false;
            end
            fprintf('|%c',board(i,j));
        end
        fprintf('|\n');
        fprintf('  +-+-+-+-+-+-+-+-+\n');
    end
end

function [board] = setUpBoard()
    board = char(zeros(8,8));
    board(1,:) = 'RNBQKBNR';
    board(2,:) = 'PPPPPPPP';
    board(7,:) = 'PPPPPPPP';
    board(8,:) = 'RNBKQBNR';
end