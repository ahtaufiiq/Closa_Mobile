function vocalSeeker(board) {
    // create a new arr
    let arr = []
    let vocal = 0
    let kumpulanVocal = ''
  
    if (!board) {
      return null
    }
  
    for (let i = 0; i < board.length; i++) {
      for (let j = 0; j < board[i].length; j++) {
        if (board[i][j] == 'a' || board[i][j] == 'i' || board[i][j] == 'u' || board[i][j] == 'e' || board[i][j] == 'o' || board[i][j] == 'A' || board[i][j] == 'I' || board[i][j] == 'U' || board[i][j] == 'E' || board[i][j] == 'O') {
            vocal += 1
            kumpulanVocal += board[i][j]
            console.log(board[i][j]);
        }
      }
    }
  
    let str = `vokal ditemukan ${vocal} dan kumpulan vokal adalah ${kumpulanVocal}`
    //console.log(arr);
    return str
  }
  
  //DRIVER CODE
  
  let board = [
    ['*', '*', '*', 10],
    ['*', '*', -5, -10, '*', 100],
    ['a', 'A', 'o', 'b']
  ] 
  
//   let board = null
  
  console.log(vocalSeeker(board)); // vokal ditemukan 3 dan kumpulan vokal adalah aAo
  
  module.exports = vocalSeeker;