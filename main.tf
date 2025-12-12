terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

module "snake_game" {
  source = "./modules/s3-static-website"

  bucket_name  = "snake-game-demo-bucket"
  force_destroy = true

  tags = {
    Name    = "Snake Game Website"
    Purpose = "Demo"
  }

  website_content = <<-EOT
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Snake Game</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Arial', sans-serif;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        h1 {
            margin-bottom: 20px;
            font-size: 3em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        #gameCanvas {
            border: 4px solid white;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
            background-color: #1a1a2e;
        }
        #score {
            margin-top: 20px;
            font-size: 1.5em;
            font-weight: bold;
        }
        #gameOver {
            position: absolute;
            display: none;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: rgba(0,0,0,0.8);
            padding: 40px;
            border-radius: 10px;
        }
        #gameOver h2 {
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        button {
            padding: 15px 30px;
            font-size: 1.2em;
            background-color: #667eea;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #764ba2;
        }
        .instructions {
            margin-top: 20px;
            text-align: center;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <h1>🐍 Snake Game 🐍</h1>
    <canvas id="gameCanvas" width="400" height="400"></canvas>
    <div id="score">Score: 0</div>
    <div class="instructions">
        <p>Use Arrow Keys to move</p>
        <p>Eat the red food to grow!</p>
    </div>
    <div id="gameOver">
        <h2>Game Over!</h2>
        <p id="finalScore"></p>
        <button onclick="restartGame()">Play Again</button>
    </div>

    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const scoreElement = document.getElementById('score');
        const gameOverElement = document.getElementById('gameOver');
        const finalScoreElement = document.getElementById('finalScore');

        const gridSize = 20;
        const tileCount = canvas.width / gridSize;

        let snake = [{x: 10, y: 10}];
        let food = {x: 15, y: 15};
        let dx = 0;
        let dy = 0;
        let score = 0;
        let gameRunning = true;

        document.addEventListener('keydown', changeDirection);

        function changeDirection(event) {
            const key = event.key;

            if (key === 'ArrowLeft' && dx === 0) {
                dx = -1;
                dy = 0;
            } else if (key === 'ArrowUp' && dy === 0) {
                dx = 0;
                dy = -1;
            } else if (key === 'ArrowRight' && dx === 0) {
                dx = 1;
                dy = 0;
            } else if (key === 'ArrowDown' && dy === 0) {
                dx = 0;
                dy = 1;
            }
        }

        function gameLoop() {
            if (!gameRunning) return;

            update();
            draw();
            setTimeout(gameLoop, 100);
        }

        function update() {
            const head = {x: snake[0].x + dx, y: snake[0].y + dy};

            // Check wall collision
            if (head.x < 0 || head.x >= tileCount || head.y < 0 || head.y >= tileCount) {
                endGame();
                return;
            }

            // Check self collision
            for (let segment of snake) {
                if (head.x === segment.x && head.y === segment.y) {
                    endGame();
                    return;
                }
            }

            snake.unshift(head);

            // Check food collision
            if (head.x === food.x && head.y === food.y) {
                score++;
                scoreElement.textContent = 'Score: ' + score;
                generateFood();
            } else {
                snake.pop();
            }
        }

        function draw() {
            // Clear canvas
            ctx.fillStyle = '#1a1a2e';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Draw snake
            ctx.fillStyle = '#4ecca3';
            snake.forEach((segment, index) => {
                ctx.fillRect(
                    segment.x * gridSize,
                    segment.y * gridSize,
                    gridSize - 2,
                    gridSize - 2
                );
            });

            // Draw food
            ctx.fillStyle = '#ff6b6b';
            ctx.fillRect(
                food.x * gridSize,
                food.y * gridSize,
                gridSize - 2,
                gridSize - 2
            );
        }

        function generateFood() {
            food = {
                x: Math.floor(Math.random() * tileCount),
                y: Math.floor(Math.random() * tileCount)
            };

            // Make sure food doesn't spawn on snake
            for (let segment of snake) {
                if (food.x === segment.x && food.y === segment.y) {
                    generateFood();
                    return;
                }
            }
        }

        function endGame() {
            gameRunning = false;
            finalScoreElement.textContent = 'Final Score: ' + score;
            gameOverElement.style.display = 'flex';
        }

        function restartGame() {
            snake = [{x: 10, y: 10}];
            food = {x: 15, y: 15};
            dx = 0;
            dy = 0;
            score = 0;
            gameRunning = true;
            scoreElement.textContent = 'Score: 0';
            gameOverElement.style.display = 'none';
            gameLoop();
        }

        gameLoop();
    </script>
</body>
</html>
EOT
}

output "website_url" {
  description = "The URL where the snake game is hosted"
  value       = module.snake_game.website_url
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.snake_game.bucket_id
}
