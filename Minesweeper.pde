import de.bezier.guido.*;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(1000, 1000);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }


  setMines();
}
public void setMines()
{
  //your code
  while (mines.size() < NUM_ROWS*3) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    MSButton newButton = new MSButton(r, c);
    if (!mines.contains(newButton)) {
      mines.add(newButton);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  for (int i = 0; i < mines.size(); i++) {
    int r = mines.get(i).myRow;
    int c = mines.get(i).myCol;
    if (!buttons[r][c].flagged) {
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  //your code here
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j].setLabel("LOSE");
    }
  }
  for (int i = 0; i < mines.size(); i++) {
     mines.get(i).clicked = true; 
     mines.get(i).flagged = false;
  }
}
public void displayWinningMessage()
{
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j].setLabel("WIN");
    }
  }
}
public boolean isValid(int r, int c)
{
  //your code here
  return(r > -1 && c > -1 && r < NUM_ROWS && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c <= col+1; c++) {
      if (r == row && c == col) {
        continue;
      }
      if (isValid(r, c)) {
        for (int i = 0; i < mines.size(); i++) {
          if (mines.get(i).myRow == r && mines.get(i).myCol == c) {
            numMines++;
          }
        }
      }
    }
  }

  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 1000/NUM_COLS;
    height = 1000/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (!flagged) {
        clicked = false;
      }
    } else {
      if (mines.contains(this)) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol) > 0) {
        setLabel(countMines(myRow, myCol));
      } else {
        for (int r = myRow-1; r <= myRow+1; r++) {
          for (int c = myCol-1; c <= myCol+1; c++) {
            if (r == myRow && c == myCol) {
              continue;
            }
            if (isValid(r, c) && (!buttons[r][c].clicked) && (countMines(r, c) == 0)) {
              buttons[r][c].mousePressed();
            }
          }
        }
      }
    }
  }

  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
