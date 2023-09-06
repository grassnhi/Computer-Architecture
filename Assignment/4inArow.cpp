#include <iostream>
#include <cstdlib>
#include <time.h>

using namespace std;

const int row = 6, column = 7;
char grid[row][column] = {};
char piece1, piece2;
const char x = 'X', o = 'O';
int undo1 = 3, undo2 = 3;
int block1 = 1, block2 = 1;
int remove1 = 1, remove2 = 1;
int violation1 = 3, violation2 = 3;
string player1, player2;
bool endGame = false;
bool block = false, remv = false;
int count1 = 0, count2 = 0;
int col = -1, rouu = -1, curPos = -1;
int piece = 0;

void printGrid(){
    cout << "    ";
    for (int i = 0; i < column; i++) {
        cout << i << " ";
    }
    cout << endl;
    cout << "   --------------" << endl;

    int k = 0;
    for (int i = 0; i < row; i++){
        cout << k << " | ";
        for (int j = 0; j < column; j++){
            if (grid[i][j]){
                cout << grid[i][j] << " ";
            }else 
                cout << ". ";
        }
        cout << endl;
        k++;
    }
    
    
}

void showTurn(string player, int& violation, int& undo){
    cout << player << "'s turn: " << endl;
    cout << "Violation: " << violation << endl;
    cout << "Undo: " << undo << endl;
}

bool checkFull() {
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            if (!grid[i][j]) return false;
        }
    }
    return true;
}

bool checkColumn(int col, char& piece) {
    if (col < 0 || col >= column)
        return false;
    for (int i = row - 1; i >= 0; i--) {
        if (!grid[i][col]){
            grid[i][col] = piece;
            curPos = i;
            return true;
        }
    }
    return false;
}

void checkViolation(int& col, char& piece, int& violate, string other) {
    while (!checkColumn(col, piece)) {
        if (violate == 0) {
            endGame = true;
            cout << "Player " << other << " win!" << endl;
            return;
        }
        cout << "Inappropriate column! Please choose a column again: " << endl;
        cin >> col;
        violate--;
    }
}

void checkWin(char& piece, string player) {
    for (int i = row - 1; i >= 0; i--) {
        for (int j = 0; j < column; j++) {
            //vertically
            if (i > 2 && grid[i][j] == piece && grid[i - 1][j] == piece && grid[i - 2][j] == piece && grid[i - 3][j] == piece) {
                cout << player << " win vertically!" << endl;
                endGame = true;
                return;
            }
            //horizontally
            else if (j < 4 && grid[i][j] == piece && grid[i][j + 1] == piece && grid[i][j + 2] == piece && grid[i][j + 3] == piece) {
                cout << player << " win horizontally!" << endl;
                endGame = true;
                return;
            }
            //up diagonally
            else if (i > 2 && j < 4 && grid[i][j] == piece && grid[i - 1][j + 1] == piece && grid[i - 2][j + 2] == piece && grid[i - 3][j + 3] == piece) {
                cout << player << " win up diagonally!" << endl;
                cout << i << " " << j << " " << i - 1 << " " << j + 1 << " " << i - 2 << " " << j + 2 << " " << i - 3 << " " << j + 3 << endl;
                endGame = true;
                return;
            }
            //down diagonally
            else if (i < 3 && j < 4 && grid[i][j] == piece && grid[i + 1][j + 1] == piece && grid[i + 2][j + 2] == piece && grid[i + 3][j + 3] == piece) {
                cout << player << " win down diagonally!" << endl;
                endGame = true;
                return;
            }
        }
    }
    if (checkFull() && !endGame) {
        cout << "Draw! No player wins!" << endl;
        endGame = true;
    }
}

void undoMove(int& violation, string other, char piece, string player, int& undo){
    char u;
    cout << "Do you want to undo your move? Y: yes, N: no. " << endl;
    cin >> u;
    while (u != 'Y' && u != 'y' && u != 'n' && u != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> u;
    }
    if (u == 'n' || u == 'N') return;
    grid[curPos][col] = '\0';
    undo--;
    printGrid();
    showTurn(player, violation, undo);
    cout << "Please choose a column: ";
    cin >> col;
    checkViolation(col, piece, violation, other); 
    if(!endGame){
        printGrid();
        checkWin(piece, player);
    }else return;
}

bool checkBlock(){
    for (int i = row - 1; i >= 0; i--) {
        for (int j = 0; j < column; j++) {
            //vertically
            if (i > 1 && grid[i][j] == piece && grid[i - 1][j] == piece && grid[i - 2][j] == piece) {
                return false;
            }
            //horizontally
            else if (j < 5 && grid[i][j] == piece && grid[i][j + 1] == piece && grid[i][j + 2] == piece) {
                return false;
            }
            //up diagonally
            else if (i > 1 && j < 4 && grid[i][j] == piece && grid[i - 1][j + 1] == piece && grid[i - 2][j + 2] == piece) {
                return false;
            }
            //down diagonally
            else if (i < 4 && j < 5 && grid[i][j] == piece && grid[i + 1][j + 1] == piece && grid[i + 2][j + 2] == piece) {
                return false;
            }
        }
    }
    return true;
}

void blockMove(int& block, char piece, int& violation, string other, string player, int& undo){
    cout << "Do you want to block the next opponent move? Y: yes, N: no. " << endl;
    char b;
    cin >> b;
    while (b != 'Y' && b != 'y' && b != 'n' && b != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> b;
    }
    if (b == 'n' || b == 'N') return;
    block--;
    cout << "Blocked. Now, it's your turn!" << endl;
    showTurn(player, violation, undo);
    cout << "Choose a column: " << endl;
    cin >> col;
    checkViolation(col, piece, violation, player);
    if(!endGame){
        printGrid();
        checkWin(piece, player);
    }
}

void removePiece(int& remove){
    cout << "Do you want to remove one arbitrary piece of the opponent? You cannot drop a piece if choosing this function.";
    cout << " Y: yes, N: no. " << endl;
    char r;
    cin >> r;
    while (r != 'Y' && r != 'y' && r != 'n' && r != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> r;
    }
    if (r == 'n' || r == 'N') return;
    remove = 0;
    remv = true;
    cout << "Please choose the one you want to remove." << endl;
    cout << "Which column? " << endl;
    cin >> col;
    cout << "Which row? " << endl;
    cin >> rouu;
    while (!grid[rouu][col])
    {
        cout << "Nothing to remove! Choose another position.";
        cout << "Which column? " << endl;
        cin >> col;
        cout << "Which row? " << endl;
        cin >> rouu;
    }
    
    grid[rouu][col] = '\0';
    for(int i = rouu; i > 0; i--){
        grid[i][col] = grid[i-1][col];    
    }
    printGrid();
}



void firstMove(){
    int turn = 0;
    while (turn != 2){
        if(piece == 1){ 
            showTurn(player1, violation1, undo1);
            cout << "Choose a column: " << endl;
            cin >> col;
            if(col != 3){
                cout << "You get a violation. You must place the piece at the centre column!";
                violation1--;
            }else{
                checkColumn(col, piece1);
                printGrid();
                piece = 2;
                turn++;
            }
        }else if(piece == 2){
            showTurn(player2, violation2, undo2);
            cout << "Choose a column: " << endl;
            cin >> col;
            if(col != 3){
                cout << "You get a violation. You must place the piece at the centre column!";
                violation2--;
            }else{
                checkColumn(col, piece2);
                printGrid();
                piece = 1;
                turn++;
            }
            
        }
    } 
}

void startGame(){
    cout << "===================" << endl;
    cout << "|| FOUR IN A ROW ||" << endl;
    cout << "===================" << endl;
    cout << "First, please choose your name and then, you will be assigned the piece randomly." << endl;
    cout << "Name of player 1: " << endl;
    cin >> player1;
    cout << "Name of player 2: " << endl;
    cin >> player2;

    srand(time(nullptr));
    piece = rand() % 2 + 1;  // Randomly assign piece
    if(piece == 1){
        piece1 = o;
        piece2 = x;
    }else{
        piece1 = x;
        piece2 = o;
    }

    cout << "Player 1 is " << piece1 << " and player 2 is " << piece2 << endl;
    cout << "Each of you have 3 times undo at the first move and 1 time block the next opponent's move unless it is a chance to win." << endl; 
    cout << "Besides, if you place your piece in an inapproriate position, the move will be restarting and it also counts as a violation." << endl;
    cout << "When your get violation over 3 times, you will lose this game." << endl;
    cout << "Now, let the one with the piece O go first." << endl;   
}

void playGame(){
    while (!endGame){
        block = false;
        remv = false;
        if(piece == 1){ 
            showTurn(player1, violation1, undo1);
            if(!endGame && remove1 != 0){
                removePiece(remove1);
            }
            if(remv == false){
                cout << "Choose a column: " << endl;
                cin >> col;
                checkViolation(col, piece1, violation1, player2);
                if(!endGame){
                    printGrid();
                    checkWin(piece1, player1);
                    if(!endGame && undo1 != 0){
                        undoMove(violation1, player2, piece1, player1, undo1);
                    }
                    if(!endGame && checkBlock() && block1 != 0){
                        blockMove(block1, piece1, violation1, player2, player1, undo1);
                    }
                } 
            }
            piece = 2;
        }else if(piece == 2){
            showTurn(player2, violation2, undo2);
            if(!endGame && remove1 != 0){
                removePiece(remove2);
            }
            if(remv == false){
                cout << "Choose a column: " << endl;
                cin >> col;
                checkViolation(col, piece2, violation2, player1);
                if(!endGame){
                    printGrid();
                    checkWin(piece2, player2);
                    if(!endGame && undo2 != 0){
                        undoMove(violation2, player1, piece2, player2, undo2);
                    }
                    if(!endGame && checkBlock() && block2 != 0){
                        blockMove(block2, piece2, violation2, player1, player2, undo2);
                    }
                }
            }
            piece = 1;
        }
    }
    
    
}

int main(){
    startGame();
    firstMove();
    playGame();

    return 0;
}