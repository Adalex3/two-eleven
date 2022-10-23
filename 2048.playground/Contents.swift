import UIKit

//var board: [[Int]] = [[0,0,0,2],[0,0,0,4],[0,0,0,16],[0,0,16,4]]
var board: [[Int]] = [[2,0,2,0],[2,0,0,0],[0,2,0,2],[0,0,0,0]]

func printBoard() {
    print()
    print(board[0])
    print(board[1])
    print(board[2])
    print(board[3])
}

// Swipe left
func swipeLeft(combine: Bool) {
    
    for i in 0...board.count-1 {
        var j = 1;
        while(j<board[i].count) {
            if(board[i][j] != 0) {
                if(board[i][j-1] == 0) {
                    // Switch
                    board[i][j-1] = board[i][j]
                    board[i][j] = 0
                    j = 0
                } else if (board[i][j-1] == board[i][j]) {
                    // Combine
                    if(combine) {
                        board[i][j-1] = board[i][j-1]*board[i][j]
                        board[i][j] = 0
                        j = 0
                    }
                }
            }
            
            j += 1
        }
    }
    
    if(combine) {
        for _ in 0...3 {
            swipeLeft(combine: false)
        }
    }
}

func swipeUp() {
    rotateLeft()
    swipeLeft(combine: true)
    rotateRight()
}

func swipeDown() {
    rotateRight()
    swipeLeft(combine: true)
    rotateLeft()
}

func swipeRight() {
    rotateLeft()
    rotateLeft()
    swipeLeft(combine: true)
    rotateLeft()
    rotateLeft()
}

func rotateLeft() {
    let w = board.count
    let h = board[0].count
    var ret: [[Int]] = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    for i in 0...h-1 {
        for j in 0...w-1 {
            ret[i][j] = board[j][h-i-1]
        }
    }
    
    board = ret
}

func rotateRight() {
    let w = board.count
    let h = board[0].count
    var ret: [[Int]] = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    for i in 0...h-1 {
        for j in 0...w-1 {
            ret[i][j] = board[w-j-1][i]
        }
    }
    
    board = ret
}

printBoard()

swipeLeft(combine: true)

printBoard()

swipeDown()

printBoard()

swipeRight()

printBoard()


//printBoard()
//
//swipeLeft(combine: true)
//
//printBoard()


