from __future__ import division
import math
import pandas as pd
import pygame
import time
import numpy


black = (0,0,0)
white = (255,255,255)
red = (255, 0, 0)
green = (0, 255,0)
yellow = (255,255,0)
display_width = 800
display_height = 600

total_points = 0

pygame.init()
gameDisplay = pygame.display.set_mode((display_width,display_height))
clock = pygame.time.Clock()

def get_points(correct, hint):
    global total_points
    if hint:
        points = total_points*0.75 - total_points
        show_score(points)
        total_points = total_points*0.75
        return 
    if correct:
        show_score(50)
        total_points += 50
    else:
        show_score(0)
    return


def score_bar(score):
    '''display the score'''
    if score > 700:
        score_color = green
        score = 700
    elif score > 500:
        score_color = green
    elif score > 100:
        score_color = yellow
    else:
        score_color= red
    
    #pygame.draw.rect(display, kleur, (hoever van links, hoever van boven, breedte, hoogte))
    pygame.draw.rect(gameDisplay, black, (display_width-750, 5, 704, 24), 3)
    pygame.draw.rect(gameDisplay, score_color, (display_width-748, 7, score, 20))

    font = pygame.font.SysFont(None, 25)
    text = font.render("Score: "+ str(score), True, black)
    gameDisplay.blit(text,(display_width-198, 30))

def show_score(score):
    largeText = pygame.font.Font('freesansbold.ttf', 115)
    if score<=0:
        TextSurf = largeText.render(str(score), True, red)
    else:
        TextSurf = largeText.render('+ ' + str(score), True, green)
    TextRect = TextSurf.get_rect()
    TextRect.center = ((display_width/2), (display_height/2))
    gameDisplay.fill(black)
    gameDisplay.blit(TextSurf, TextRect)

    pygame.display.update()
    time.sleep(0.3)

def text_objects(text, font):
    textSurface = font.render(text, True, black)
    return textSurface, textSurface.get_rect()

def button(msg,x,y,w,h,ic,ac,correct,hint):
    mouse = pygame.mouse.get_pos()
    click = pygame.mouse.get_pressed()
    #print(click)
    if x+w > mouse[0] > x and y+h > mouse[1] > y:
        pygame.draw.rect(gameDisplay, ac,(x,y,w,h))
        if click[0] == 1:
            get_points(correct,hint)        
    else:
        pygame.draw.rect(gameDisplay, ic,(x,y,w,h))

    smallText = pygame.font.SysFont("freesans",12)
    textSurf, textRect = text_objects(msg, smallText)
    textRect.center = ( (x+(w/2)), (y+(h/2)) )
    gameDisplay.blit(textSurf, textRect)

def experiment():
    while True:
        for event in pygame.event.get():
            #print(event)
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()
        gameDisplay.fill(white)

        button('correct answer',50,450,100,50,green,green, 1,0)
        button('incorrect answer',350,450,100,50,red,red,0,0)
        button('hint',650,450,100,50,yellow,yellow, 0,1)

        score_bar(total_points)

        pygame.display.update()
        clock.tick(15)

experiment()