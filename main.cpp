// Sheema Masood (CS-012) 
// Wajiha Muzaffar Ali (CS-013)
// Aleesha Kanwal (CS-017)
// Date:  06/04/2015
// main.cpp (Written in C language to be converted in MIPS Assembly Language) 
// Description of Project:
// 		8 Queen Puzzle is the problem of placing 8 queens on an 8x8 chess board [N queens on NxN board; N=8]
// 		so that no queens can attack each other.
// 		Thus, it is necessary that no queens share same row, column and diagonal.

#include <iostream>
#include <iomanip>	//for setw
#include <string>
using namespace std;

const int N = 8;
int board[N][N];

int queens_Placed = 0;
int queens_RowNo[N];
int queens_ColNo[N];


void PrintBoard()
{
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			cout << setw(4) << board[i][j];
		}
		cout << endl << endl;
	}
}

bool Is_Safe(int row, int col)
{
	//check col
	for (int r = 0; r < N; r++)
	{
		if (board[r][col] == 1)
		{
			return false;
		}
	}
	//check row
	for (int c = 0; c < N; c++)
	{
		if (board[row][c] == 1)
		{
			return false;
		}
	}
	//check up diagonally '\'			
	for (int r = row, c=col; r >-1; r--,c--)
	{
		if (board[r][c] == 1)
		{
			return false;
		} 
	}
	//check down diagonally '/'
	for (int r = row, c=col; r < N; r++,c--)
	{
		if (board[r][c] == 1)
		{
			return false;
		} 
	}
	return true;
}

bool PlaceQueen(int r, int col) //returns true if queen is placed safely	//r diff passes and col fixed
{
	if(r == N) { return false;}
	
	for (int row = r; row < N; row++)
	{
		if (Is_Safe(row, col))
		{
			queens_RowNo[queens_Placed] = row;
			queens_ColNo[queens_Placed] = col;
			queens_Placed++;

			board[row][col] = 1;

			return true;
		}
		//else check next row
	}
	//row has no safe place to place queen
	return false;
}

void StartGame()
{
	//traversing board
	for (int col = 0; col < N; col++)
	{
		int row = 0;	//initially send row 0

		while (queens_Placed != col + 1)	//untill col has 1 queen keep on running this
		{
			if (PlaceQueen(row, col) == false)	//means no queen has placed in the sended col so need to cahnge previous col's queen
			{
				queens_Placed--;	//remove queen on previous col
				int r = queens_RowNo[queens_Placed];
				int c = queens_ColNo[queens_Placed];
				board[r][c] = 0;	//update queen on board that is's 0 now

				col--;	//changing queen pos in previos col now
				row = queens_RowNo[queens_Placed] + 1;		//in this case start checking from row next to the row in which queen was placed before
				continue;
			}
			else
			{
				row = 0;	//if in last step queen is placed successfully safe then search from place in next col's 1st place
			}
		}
	}
}

int main()
{
	//initialize board
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			board[i][j] = 0;
		}
	}

	//Run Game to solve puzzle
	StartGame();
	
	PrintBoard();
	cout << "TADA! xD   \nAll Queens Placed!" << endl;
}