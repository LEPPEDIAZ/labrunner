using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;

public class Maze {

    Cell[,] mazeCells;

    /// obtiene un numero de la columna del laberinto
    public int Columns { get; private set; }
    /// pone un get rows del laberinto
    public int Rows { get; private set; }
    /// toma la escala donde se saca el laberinto
    public float Scale { get; private set; }

    public Maze(int rows, int columns, float scale)
    {
        Rows = rows;
        Columns = columns;
        mazeCells = new Cell[Rows, Columns];

        Scale = scale;

        drawing = new MazeDrawEventHandler(Maze_Drawing);
    }

    public void Draw(GameObject runner, GameObject wall)
    {
        drawing(this, new MazeDrawEventArgs(runner, wall, Scale));
    }
    /// <summary>
    /// Gets all the cells en una linea en una coneccion lineal
  
    IEnumerable<Cell> GetAllCells()
    {
        List<Cell> allCells = new List<Cell>(Rows * Columns);
        foreach (var cell in mazeCells)
        {
            allCells.Add(cell);
        }
     
        return allCells;
    }
    /// <summary>
    /// Gets the cell de una row o column
  
    public Cell GetCell(int row, int column)
    {
        return GetAllCells().FirstOrDefault(c => c.Row == row && c.Column == column);
    }
 
    Cell GetRandomCell(IEnumerable<Cell> cells = null)
    {
        if (cells == null)
            cells = GetAllCells();

        
        int randomIndex = UnityEngine.Random.Range(0, cells.Count());//random.Next(cells.Count());
        return cells.ToList()[randomIndex];
    }
 
    /// llena todo en el laberinto con cells
>
    void Init()
    {
        for (int i = 0; i < Rows; i++)
        {
            for (int j = 0; j < Columns; j++)
            {
                mazeCells[i, j] =
                    new Cell(this)
                    {
                        Column = j,
                        Row = i,
                    };
            }
        }        
        mazeCells[Rows - 1, Columns - 1].ExitCell = true;
    }
   //define el camino del laberinto
    public void Initialize()
    {
        Init();

        GetAllCells().ToList().ForEach(c => c.Visited = false);

        Stack<Cell> stack = new Stack<Cell>(Rows * Columns);
        Cell currentCell = GetRandomCell();

        stack.Push(currentCell);
        while (stack.Any())
        {
            currentCell.Visited = true;
            IEnumerable<Cell> unvisitedNeighbours = currentCell.GetNeighbours().Where(n => !n.Visited);
            if (unvisitedNeighbours.Any())
            {
                Cell temp = GetRandomCell(unvisitedNeighbours);
                currentCell.Connect(temp);
                currentCell = temp;
                stack.Push(temp);
            }
            else
            {
                currentCell = stack.Pop();
            }
        }
    }

    void Maze_Drawing(object sender, MazeDrawEventArgs e) { }
    event MazeDrawEventHandler drawing;
    public event MazeDrawEventHandler Drawing
    {
        add { drawing += value; }
        remove { drawing -= value; }
    }
}

public delegate void MazeDrawEventHandler(object sender, MazeDrawEventArgs e);

public class MazeDrawEventArgs : EventArgs
{
    public MazeDrawEventArgs(GameObject runner, GameObject wall, float scale)
    {
        Scale = scale;
        Runner = runner;
        Wall = wall;
    }

    public float Scale { get; private set; }
    public GameObject Runner { get; private set; }
    public GameObject Wall { get; private set; }
}


