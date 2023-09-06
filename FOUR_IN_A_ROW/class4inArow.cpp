#include <iostream>
#include <cstdlib>
#include <time.h>
#include <cstring>

using namespace std;

class Gamer{
    public:
        string name;
        char piece;
        int undo;
        int remove;
        int violation;
        int block;
        int count;
    public:
        Gamer(string name = "", char piece = 0, int undo = 3, int remove = 1, int violation = 3, int block = 1, int count = 0){
            this->name = name;
            this->piece = piece;
            this->undo = undo;
            this->remove = remove;
            this->violation = violation;
            this->block = block;
            this->count = count;
        }

        ~Gamer(){}

        void print(){
            cout << "Player: " << name << endl;
            cout << "Violation: " << violation << endl;
            cout << "Undo: " << undo << endl;
        }   
};

Gamer* player1 = new Gamer();
Gamer* player2 = new Gamer();

const int row = 6, column = 7;
char grid[row][column] = {};
const char x = 'X', o = 'O';
int piece = 0, col = 0, rouu = 0;
int curPos = -1;
bool endGame = false, remv = false, block = false;

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

bool checkFull() {
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            if (!grid[i][j]) return false;
        }
    }
    return true;
}

bool checkColumn(int col, Gamer* player) {
    if (col < 0 || col >= column)
        return false;
    for (int i = row - 1; i >= 0; i--) {
        if (!grid[i][col]){
            grid[i][col] = player->piece;
            curPos = i;
            player->count++;
            return true;
        }
    }
    return false;
}

void checkWin(Gamer* player, Gamer* other) {
    for (int i = row - 1; i >= 0; i--) {
        for (int j = 0; j < column; j++) {
            //vertically
            if (i > 2 && grid[i][j] == player->piece && grid[i - 1][j] == player->piece && grid[i - 2][j] == player->piece && grid[i - 3][j] == player->piece) {
                cout << player->name << " win vertically!" << endl;
                cout << "Total piece on the board: " << player->count << endl;
                endGame = true;
                return;
            }
            //horizontally
            else if (j < 4 && grid[i][j] == player->piece && grid[i][j + 1] == player->piece && grid[i][j + 2] == player->piece && grid[i][j + 3] == player->piece) {
                cout << player->name << " win horizontally!" << endl;
                cout << "Total piece on the board: " << player->count << endl;
                endGame = true;
                return;
            }
            //up diagonally
            else if (i > 2 && j < 4 && grid[i][j] == player->piece && grid[i - 1][j + 1] == player->piece && grid[i - 2][j + 2] == player->piece && grid[i - 3][j + 3] == player->piece) {
                cout << player->name << " win up diagonally!" << endl;
                cout << "Total piece on the board: " << player->count << endl;
                endGame = true;
                return;
            }
            //down diagonally
            else if (i < 3 && j < 4 && grid[i][j] == player->piece && grid[i + 1][j + 1] == player->piece && grid[i + 2][j + 2] == player->piece && grid[i + 3][j + 3] == player->piece) {
                cout << player->name << " win down diagonally!" << endl;
                cout << "Total piece on the board: " << player->count << endl;
                endGame = true;
                return;
            }
        }
    }
    if (checkFull() && !endGame) {
        cout << "Draw! No player wins!" << endl;
        cout << "Total piece of " << player->name << " on the board: " << player->count << endl;
        cout << "Total piece of " << other->name << " on the board: " << other->count << endl;
        endGame = true;
    }
}

void removePiece(Gamer*& player1, Gamer*& player2){
    cout << "Do you want to remove one arbitrary piece of the opponent? You cannot drop a piece if choosing this function.";
    cout << " Y: yes, N: no. " << endl;
    char r;
    cin >> r;
    while (r != 'Y' && r != 'y' && r != 'n' && r != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> r;
    }
    if (r == 'n' || r == 'N') return;
    player1->remove = 0;
    player2->count--;
    remv = true;
    cout << "Please choose the one you want to remove." << endl;
    cout << "Which column? " << endl;
    cin >> col;
    cout << "Which row? " << endl;
    cin >> rouu;
    while (!grid[rouu][col] || grid[rouu][col] != player1->piece)
    {
        cout << "There are not any your opponent's piece here! Choose another position.";
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
    checkWin(player1, player2);
    checkWin(player2, player1);
}

void checkViolation(Gamer*& player1, Gamer* player2) {
    while (!checkColumn(col, player1)) {
        if (player1->violation == 0) {
            endGame = true;
            cout << "Player " << player2->name << " win!" << endl;
            return;
        }
        cout << "Inappropriate column! Please choose a column again: " << endl;
        cin >> col;
        player1->violation--;
    }
}




void undoMove(Gamer*& player1, Gamer* player2){
    char u;
    cout << "Do you want to undo your move? Y: yes, N: no. " << endl;
    cin >> u;
    while (u != 'Y' && u != 'y' && u != 'n' && u != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> u;
    }
    if (u == 'n' || u == 'N') return;
    grid[curPos][col] = '\0';
    player1->undo--;
    player1->count--;
    printGrid();
    player1->print();
    cout << "Please choose a column: ";
    cin >> col;
    checkViolation(player1, player2); 
    if(!endGame){
        printGrid();
        checkWin(player1, player2);
    }else return;
}

bool checkBlock(Gamer* player){
    for (int i = row - 1; i >= 0; i--) {
        for (int j = 0; j < column; j++) {
            //vertically
            if (i > 1 && grid[i][j] == player->piece && grid[i - 1][j] == player->piece && grid[i - 2][j] == player->piece) {
                return false;
            }
            //horizontally
            else if (j < 5 && grid[i][j] == player->piece && grid[i][j + 1] == player->piece && grid[i][j + 2] == player->piece) {
                return false;
            }
            //up diagonally
            else if (i > 1 && j < 5 && grid[i][j] == player->piece && grid[i - 1][j + 1] == player->piece && grid[i - 2][j + 2] == player->piece) {
                return false;
            }
            //down diagonally
            else if (i < 4 && j < 5 && grid[i][j] == player->piece && grid[i + 1][j + 1] == player->piece && grid[i + 2][j + 2] == player->piece) {
                return false;
            }
        }
    }
    return true;
}

void blockMove(Gamer*& player1, Gamer* player2){
    cout << "Do you want to block the next opponent move? Y: yes, N: no. " << endl;
    char b;
    cin >> b;
    while (b != 'Y' && b != 'y' && b != 'n' && b != 'N') {
        cout << "Invalid character! Please enter Y: yes, N: no. ";
        cin >> b;
    }
    if (b == 'n' || b == 'N') return;
    player1->block--;
    cout << "Blocked. Now, it's your turn!" << endl;
    player1->print();
    cout << "Choose a column: " << endl;
    cin >> col;
    checkViolation(player1, player2);
    if(!endGame){
        printGrid();
        checkWin(player1, player2);
        
    }
    
}

void startGame(){
    cout << "===================" << endl;
    cout << "|| FOUR IN A ROW ||" << endl;
    cout << "===================" << endl;
    cout << "First, please choose your name and then, you will be assigned the piece randomly." << endl;
    cout << "Name of player 1: " << endl;
    cin >> player1->name;

    cout << "Name of player 2: " << endl;
    cin >> player2->name;

    srand(time(nullptr));
    piece = rand() % 2 + 1;  // Randomly assign piece
    if(piece == 1){
        player1->piece = x;
        player2->piece = o;
    }else{
        player1->piece = o;
        player2->piece = x;
    }
    cout << "Player 1 is " << player1->piece << " and player 2 is " << player2->piece << endl;
    cout << "Each of you have 3 times undo at the first move and 1 time block the next opponent's move unless it is a chance to win." << endl; 
    cout << "Besides, if you place your piece in an inapproriate position, the move will be restarting and it also counts as a violation." << endl;
    cout << "When your get violation over 3 times, you will lose this game." << endl;
    cout << "Now, let the one with the piece O go first." << endl;
}

void firstMove(){
    int turn = 0;
    while (turn != 2){
        if(piece == 1){ 
            player1->print(); 
            cout << "Choose a column: " << endl;
            cin >> col;
            if(col != 3){
                cout << "You get a violation. You must place the piece at the centre column!";
                player1->violation--;
            }else{
                checkColumn(col, player1);
                printGrid();
                piece = 2;
                turn++;
            }
        }else if(piece == 2){
            player2->print();
            cout << "Choose a column: " << endl;
            cin >> col;
            if(col != 3){
                cout << "You get a violation. You must place the piece at the centre column!";
                player2->violation--;
            }else{
                checkColumn(col, player2);
                printGrid();
                piece = 1;
                turn++;
            }
            
        }
    } 
}

void playGame(){
    while (!endGame){
        block = false;
        remv = false;
        if(piece == 1){ 
            player1->print();
            if(!endGame && player1->remove != 0){
                removePiece(player1, player2);
            }
            if(remv == false){
                cout << "Choose a column: " << endl;
                cin >> col;
                checkViolation(player1, player2);
                if(!endGame){
                    printGrid();
                    checkWin(player1, player2);
                    if(!endGame && player1->undo != 0){
                        undoMove(player1, player2);
                    }
                    if(!endGame && checkBlock(player2) && player1->block != 0){
                        blockMove(player1, player2);
                    }
                } 
            }
            piece = 2;
        }else if(piece == 2){
            player2->print();
            if(!endGame && player2->remove != 0){
                removePiece(player2, player1);
            }
            if(remv == false){
                cout << "Choose a column: " << endl;
                cin >> col;
                checkViolation(player2, player1);
                if(!endGame){
                    printGrid();
                    checkWin(player2, player1);
                    if(!endGame && player2->undo != 0){
                        undoMove(player2, player1);
                    }
                    if(!endGame && checkBlock(player1) && player2->block != 0){
                        blockMove(player2, player1);
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