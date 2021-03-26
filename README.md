# Enhanced-Poker-Game
An enhanced version of the Poker Game written in Python.

General program description  
The program will deal two 2-card poker hands and a shared five card pool (the flop/turn/river for those who know these poker terms) according to the rules of Texas Holdem poker. The program will determine the winning hand and return it. The rules of Texas Holdem and the various hand rankings can be found at the links below (ignore all talk of incremental betting/passing/folding, we aren’t considering that):
https://www.partypoker.com/en/how-to-play/texas-holdem  
https://www.fgbradleys.com/et_poker.asp  
When determining the strength of each player’s hand, we will consider the two cards that player was dealt, as well as the five cards present in the shared pool. The stronger hand will be returned as the winner.

Program Input  
The input to your program will be the first 9 values in a permutation of the integers 1-52. This represents a shuffling of a standard deck of cards. The order of suits in an unshuffled deck are Clubs, Diamonds, Hearts, Spades. Within each suit, the ranks are ordered from Ace, 2-10, Jack, Queen, King.

Tie Breaking  
According to the standard rules of poker, the ranks of the cards are used to decide the winner when both hands have the same strength. For example, if both hands are a flush, then the hand with the card of highest rank is declared the winner. If both hands have a pair, then the hand whose pair is higher wins. For example, a pair of Kings beats a pair of Sevens. If both hands have the same pair, i.e. each hand has a pair of threes, then the hand with the next highest card wins (called the kicker).
It is possible for two hands to remain tied even after all tie-breaking mechanisms based on rank are considered. An absurd example would be if the five cards in the shared pool formed a royal flush, in which case both players would have the exact same best hand (the royal flush). You may rest easy in the knowledge that your program will not be tested on such inputs. We assume that all inputs will produce a clear and unambiguous winner. To put it in poker terms, we don’t have to worry about any input that would result in the players splitting the pot.
