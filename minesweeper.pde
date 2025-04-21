int BOMBS_RATIO = 20;


int w = 50;
int[][] grid;
int[][] activations;
int[][] bombs;
int[][] marks;

Boolean gameOver = false;

void setup()
{
  size(800, 800);
  
  grid = new int[width / w][];
  activations = new int[width / w][];
  bombs = new int[width / w][];
  marks = new int[width / w][]; 
  
  for (int x = 0; x < width / w; x++)
  {
    grid[x] = new int[height / w];
    activations[x] = new int[height / w];
    bombs[x] = new int[height / w];
    marks[x] = new int[height / w];
    
    for (int y = 0; y < height / w; y++)
    {
      grid[x][y] = floor(random(1, 11)) > BOMBS_RATIO / 10 ? 0 : 1;
      activations[x][y] = 0;
      bombs[x][y] = 0;
      marks[x][y] = 0;
    }
  }  
}
void draw()
{  
  for (int x = 0; x < width / w; x++)
  {
    for (int y = 0; y < height / w; y++)
    {
      stroke(0);
      
      switch (str(gameOver))
      {
        case "true":
          switch (grid[x][y])
          {   
            case 0:
              fill(175);
              square(x * w, y * w, w);
              if (bombs[x][y] == 0) break;
              textSize(28);
              fill(0);
              text(bombs[x][y], x * w + w / 2 - textWidth(str(bombs[x][y])) / 2, y * w + w / 2 + 10);
              break;
            case 1:
              fill(255);
              square(x * w, y * w, w);
              fill(255 - grid[x][y] * 255);
              circle(x * w + w / 2, y * w + w / 2, w / 2);
              break;
          }
          break; 
        case "false":
          switch (activations[x][y])
          {
            case 0:
              fill(255);
              square(x * w, y * w, w);
              break;
            case 1:
              fill(175);
              square(x * w, y * w, w);
              
              switch (grid[x][y])
              {   
                case 0:
                  if (bombs[x][y] == 0) break;
                  textSize(28);
                  fill(0);
                  text(bombs[x][y], x * w + w / 2 - textWidth(str(bombs[x][y])) / 2, y * w + w / 2 + 10);
                  break;
                case 1:
                  fill(255 - grid[x][y] * 255);
                  circle(x * w + w / 2, y * w + w / 2, w / 2);
                  break;
              }
              break;
            }
            break;
      }
    }
  }
  for (int x = 0; x < width / w; x++)
  {
    for (int y = 0; y < height / w; y++)
    {
      if (marks[x][y] == 0) continue;
      fill(255, 0, 0);
      circle(x * w + w / 2, y * w + w / 2, w / 2);
    }
  }
}
void mousePressed()
{   
  if (gameOver) return;

  switch (mouseButton)
  {
    case 37:
      if (grid[floor(mouseX / w)][floor(mouseY / w)] == 1)
      {
        gameOver = true;
        for (int x = 0; x < width / w; x++)
        {
          for (int y = 0; y < height / w; y++)
            CheckNeighborhood(x, y);
        }
        return;
      }
      CheckNeighborhood(floor(mouseX / w), floor(mouseY / w));
      break;
    case 39:
      marks[floor(mouseX / w)][floor(mouseY / w)] = marks[floor(mouseX / w)][floor(mouseY / w)] == 0 ? 1 : 0;
      break;
  }
}

void CheckNeighborhood(int column, int row)
{
  if (column < 0 || column > width / w - 1 || row < 0 || row > height / w - 1) return;
  if (activations[column][row] == 1) return;
  activations[column][row] = 1;

  int[] neighborhood = new int[]
  {
    column - 1 < 0 || row - 1 < 0 ? 0 : grid[column - 1][row - 1], 
    row - 1 < 0 ? 0 : grid[column][row - 1], 
    column + 1 > grid.length - 1 || row - 1 < 0 ? 0 : grid[column + 1][row - 1], 
      
    column - 1 < 0 ? 0 : grid[column - 1][row], 
    column + 1 > grid.length - 1 ? 0 : grid[column + 1][row], 
              
    column - 1 < 0 || row + 1 > grid[column].length - 1 ? 0 : grid[column - 1][row + 1], 
    row + 1 > grid[column].length - 1 ? 0 : grid[column][row + 1], 
    column + 1 > grid.length - 1 || row + 1 > grid[column].length - 1 ? 0 : grid[column + 1][row + 1]
  };
              
  for (int z = 0; z < neighborhood.length; z++)
  {
    if (neighborhood[z] == 0) continue;
    bombs[column][row]++;
  }
  
  if (bombs[column][row] != 0) return;
  CheckNeighborhood(column - 1, row - 1);
  CheckNeighborhood(column, row - 1);
  CheckNeighborhood(column + 1, row - 1);
  CheckNeighborhood(column - 1, row);
  CheckNeighborhood(column + 1, row);
  CheckNeighborhood(column - 1, row + 1);
  CheckNeighborhood(column, row - 1);
  CheckNeighborhood(column + 1, row + 1);
}
