# snake![image](https://github.com/r2010shadow/Cookbook/blob/master/python/img/snake.png)

import pygame
import time
import random

pygame.init()
white = (255,255,255)
black = (0,0,0)
red = (255,0,0)
green = (0,155,0)


display_width = 800
display_height = 600

gameDisplay = pygame.display.set_mode((display_width,display_height))
pygame.display.set_caption('Slither')

icon = pygame.image.load('apple.png')
pygame.display.set_icon(icon)


clock = pygame.time.Clock()

block_size = 10
FPS = 15

img = pygame.image.load('snake.png')
direction = "right"

appleimg = pygame.image.load('apple.png')

smallfont = pygame.font.SysFont("comicsansms", 25)
medfont = pygame.font.SysFont("comicsansms", 50)
largefont = pygame.font.SysFont("comicsansms", 80)


def game_intro():
    intro = True
    while intro:

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_c:
                    intro = False
                if event.key == pygame.K_q:
                    pygame.quit()
                    quit()

        gameDisplay.fill(white)
        message_to_screen("welcome to Slither", green, -100, "large")
        message_to_screen("The objective of the game is to eat red apples",black, -30)
        message_to_screen("The more apples you eat, the lenger you get", black , 10)
        message_to_screen("If you run into youself, or the edges, game over", black, 50)
        message_to_screen("Press C to play or Q to quit.", black , 180)
        pygame.display.update()
        clock.tick(5)

def snake(block_size,snakelist):
## let snake head towards to  right side
    if direction == "right":
        head = pygame.transform.rotate(img, 270)

    if direction == "left":
                head = pygame.transform.rotate(img, 90)

    if direction == "up":
                head = img

    if direction == "down":
                head = pygame.transform.rotate(img, 180)
## snake img at first size
    gameDisplay.blit(head, (snakelist[-1][0], snakelist[-1][1]))
## -1 always first after snake img
    for XnY in snakelist[:-1]:
        pygame.draw.rect(gameDisplay,green,[XnY[0],XnY[1],block_size,block_size])


## make text display center
def text_objects(text, color, size):
    if size == "small":
        textSurface = smallfont.render(text, True, color)
    elif size == "medium":
                textSurface = medfont.render(text, True, color)
    elif size == "large":
                textSurface = largefont.render(text, True, color)
    return textSurface, textSurface.get_rect()

## y_displace make  message two line wider
def message_to_screen(msg,color, y_displace=0, size = "small"):
    textSurf, textRect = text_objects(msg, color, size)
    textRect.center = (display_width / 2), (display_height / 2) + y_displace
    gameDisplay.blit(textSurf, textRect)

def gameLoop():
    global direction
    direction = 'right'

    lead_x = display_width/2
    lead_y = display_height/2
    lead_x_change = 0
    lead_y_change = 0
    gameExit = False
    gameOver = False

    snakeList = [ ]
    snakeLength = 1
## make apple and snake in the right place, same line. when use fat apple #10.0
    randAppleX = round(random.randrange(0, display_width-block_size))#/10.0)*10.0
    randAppleY = round(random.randrange(0, display_height-block_size))#/10.0)*10.0



    while not gameExit:
## choose
        while gameOver == True:
            gameDisplay.fill(white)
            message_to_screen("Game over",
                                red,
                                -50,
                                size = "large")
            message_to_screen("press C to AG, Q to quit",
                                black,
                                50,
                                size = "medium")
            pygame.display.update()

            for event in pygame.event.get():
## click windows exit
                    if event.type == pygame.QUIT:
                        gameOver = False
                        gameExit = True
## choose key exit
                    if event.type == pygame.KEYDOWN:
                        if event.key == pygame.K_q:
                            gameExit = True
                            gameOver = False
                        if event.key == pygame.K_c:
                            gameLoop()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                gameExit = True
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    direction = "left"
                    lead_x_change = -block_size
                    lead_y_change = 0
                elif event.key == pygame.K_RIGHT:
                    direction = "right"
                    lead_x_change = block_size
                    lead_y_change = 0
                elif event.key == pygame.K_UP:
                    direction = "up"
                    lead_y_change = -block_size
                    lead_x_change = 0
                elif event.key == pygame.K_DOWN:
                    direction = "down"
                    lead_y_change = block_size
                    lead_x_change = 0
## outoff windows then over
        if lead_x >= display_width or lead_x < 0 or lead_y >= display_height or lead_y < 0:
                    gameOver = True



        lead_x += lead_x_change
        lead_y += lead_y_change
        gameDisplay.fill(white)
## fat apple easy to eat
        AppleThickness = 30
        #pygame.draw.rect(gameDisplay,red,[randAppleX,randAppleY,AppleThickness,AppleThickness])

        gameDisplay.blit(appleimg, (randAppleX,randAppleY))

        snakeHead = [ ]
        snakeHead.append(lead_x)
        snakeHead.append(lead_y)
        snakeList.append(snakeHead)
## redraw snake on map, make snake like run on map.
        if len(snakeList) > snakeLength:
            del snakeList[0]
## snake eat himself
        for eachSegment in snakeList[:-1]:
            if eachSegment == snakeHead:
                gameOver = True



        snake(block_size, snakeList)
        pygame.display.update()

        if lead_x == randAppleX and lead_y == randAppleY:
            randAppleX = round(random.randrange(0, display_width-block_size)/10.0)*10.0
            randAppleY = round(random.randrange(0, display_height-block_size)/10.0)*10.0
            snakeLength += 1

## snake run into apple body
        if lead_x >= randAppleX and lead_x <= randAppleX + AppleThickness:
           if lead_y >= randAppleY and lead_y <= randAppleY + AppleThickness:
                randAppleX = round(random.randrange(0, display_width-block_size))#/10.0)*10.0
                randAppleY = round(random.randrange(0, display_height-block_size))#/10.0)*10.0
                snakeLength += 1


## cross apple more
        if lead_x > randAppleX and lead_x < randAppleX + AppleThickness or lead_x + block_size > randAppleX and lead_x + block_size  < randAppleX + AppleThickness:
            if lead_y > randAppleY and lead_y < randAppleY + AppleThickness:
                randAppleX = round(random.randrange(0, display_width-block_size))
                randAppleY = round(random.randrange(0, display_height-block_size))
                snakeLength += 1
            elif lead_y + block_size > randAppleY and lead_y + block_size < randAppleY + AppleThickness:
                randAppleX = round(random.randrange(0, display_width-block_size))
                randAppleY = round(random.randrange(0, display_height-block_size))
                snakeLength += 1

        clock.tick(FPS)

    pygame.quit()
    quit()

game_intro()
gameLoop()
