# Mastermind
One player becomes the codemaker, the other the codebreaker. The codemaker chooses a pattern of four code pegs. Duplicates are allowed, so the player could even choose four code pegs of the same color. The chosen pattern is placed in the four holes covered by the shield, visible to the codemaker but not to the codebreaker.

The codebreaker tries to guess the pattern, in both order and color, within twelve (or ten, or eight) turns. Each guess is made by placing a row of code pegs on the decoding board. Once placed, the codemaker provides feedback by placing from zero to four key pegs in the small holes of the row with the guess. A colored or black key peg is placed for each code peg from the guess which is correct in both color and position. A white key peg indicates the existence of a correct color code peg placed in the wrong position.

If there are duplicate colours in the guess, they cannot all be awarded a key peg unless they correspond to the same number of duplicate colours in the hidden code. For example, if the hidden code is white-white-black-black and the player guesses white-white-white-black, the codemaker will award two colored key pegs for the two correct whites, nothing for the third white as there is not a third white in the code, and a colored key peg for the black. No indication is given of the fact that the code also includes a second black.

Once feedback is provided, another guess is made; guesses and feedback continue to alternate until either the codebreaker guesses correctly, or twelve (or ten, or eight) incorrect guesses are made.

##Features
-You can play as CodeMaker or CodeBreaker

-Donald Knuth's algorhitm implemented, so computer breaks code in 5 or less guesses.

